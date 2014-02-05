/datum/organ
	var/name = "organ"
	var/mob/living/carbon/human/owner = null

	var/list/datum/autopsy_data/autopsy_data = list()
	var/list/trace_chemicals = list() // traces of chemicals in the organ,
									  // links chemical IDs to number of ticks for which they'll stay in the blood
	proc/process()
		return 0

	proc/receive_chem(chemical as obj)
		return 0

/datum/organ/proc/get_icon()
	return icon('icons/mob/human.dmi',"blank")

//Handles chem traces
/mob/living/carbon/human/proc/handle_trace_chems()
	//New are added for reagents to random organs.
	for(var/datum/reagent/A in reagents.reagent_list)
		var/datum/organ/O = pick(organs)
		O.trace_chemicals[A.name] = 100

//Adds autopsy data for used_weapon.
/datum/organ/proc/add_autopsy_data(var/used_weapon, var/damage)
	var/datum/autopsy_data/W = autopsy_data[used_weapon]
	if(!W)
		W = new()
		W.weapon = used_weapon
		autopsy_data[used_weapon] = W

	W.hits += 1
	W.damage += damage
	W.time_inflicted = world.time

/mob/living/carbon/human/var/list/organs = list()
/mob/living/carbon/human/var/list/organs_by_name = list() // map organ names to organs
/mob/living/carbon/human/var/list/internal_organs_by_name = list() // so internal organs have less ickiness too

//Creates and initializes and connects external and internal organs
/mob/living/carbon/human/proc/make_organs()
	organs = list()
	organs_by_name["chest"] = new/datum/organ/external/chest()
	organs_by_name["groin"] = new/datum/organ/external/groin(organs_by_name["chest"])
	organs_by_name["head"] = new/datum/organ/external/head(organs_by_name["chest"])
	organs_by_name["l_arm"] = new/datum/organ/external/l_arm(organs_by_name["chest"])
	organs_by_name["r_arm"] = new/datum/organ/external/r_arm(organs_by_name["chest"])
	organs_by_name["r_leg"] = new/datum/organ/external/r_leg(organs_by_name["groin"])
	organs_by_name["l_leg"] = new/datum/organ/external/l_leg(organs_by_name["groin"])
	organs_by_name["l_hand"] = new/datum/organ/external/l_hand(organs_by_name["l_arm"])
	organs_by_name["r_hand"] = new/datum/organ/external/r_hand(organs_by_name["r_arm"])
	organs_by_name["l_foot"] = new/datum/organ/external/l_foot(organs_by_name["l_leg"])
	organs_by_name["r_foot"] = new/datum/organ/external/r_foot(organs_by_name["r_leg"])

	internal_organs_by_name["heart"] = new/datum/organ/internal/heart(src)
	internal_organs_by_name["lungs"] = new/datum/organ/internal/lungs(src)
	internal_organs_by_name["liver"] = new/datum/organ/internal/liver(src)
	internal_organs_by_name["kidney"] = new/datum/organ/internal/kidney(src)
	internal_organs_by_name["brain"] = new/datum/organ/internal/brain(src)
	internal_organs_by_name["eyes"] = new/datum/organ/internal/eyes(src)

	for(var/name in organs_by_name)
		organs += organs_by_name[name]

	for(var/datum/organ/external/O in organs)
		O.owner = src

// Takes care of organ related updates, such as broken and missing limbs
/mob/living/carbon/human/proc/handle_organs()
	number_wounds = 0
	var/leg_tally = 2
	for(var/datum/organ/external/E in organs)
		if(!E)
			continue
		E.process()
		number_wounds += E.number_wounds

		//Robotic limb malfunctions
		var/malfunction = 0
		if (E.status & ORGAN_ROBOT && prob(E.brute_dam + E.burn_dam))
			malfunction = 1

		//Broken limbs hurt too
		var/broken = 0
		if(E.status & ORGAN_BROKEN && !(E.status & ORGAN_SPLINTED) )
			broken = 1

		//Moving around with fractured ribs won't do you any good
		if (broken && E.internal_organs && prob(15))
			if (!lying && world.timeofday - l_move_time < 15)
				var/datum/organ/internal/I = pick(E.internal_organs)
				custom_pain("You feel broken bones moving in your [E.display_name]!", 1)
				I.take_damage(rand(3,5))

		//Special effects for limbs.
		if(E.name in list("l_hand","l_arm","r_hand","r_arm") && (broken||malfunction))
			var/obj/item/c_hand		//Getting what's in this hand
			if(E.name == "l_hand" || E.name == "l_arm")
				c_hand = l_hand
			if(E.name == "r_hand" || E.name == "r_arm")
				c_hand = r_hand

			if (c_hand)
				u_equip(c_hand)

				if(broken)
					emote("me", 1, "[(species && species.flags & NO_PAIN) ? "" : "screams in pain and"] drops what they were holding in their [E.display_name?"[E.display_name]":"[E]"]!")
				if(malfunction)
					emote("me", 1, "drops what they were holding, their [E.display_name?"[E.display_name]":"[E]"] malfunctioning!")
					var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
					spark_system.set_up(5, 0, src)
					spark_system.attach(src)
					spark_system.start()
					spawn(10)
						del(spark_system)

		else if(E.name in list("l_leg","l_foot","r_leg","r_foot") && !lying)
			if (!E.is_usable() || malfunction || (broken && !(E.status & ORGAN_SPLINTED)))
				leg_tally--			// let it fail even if just foot&leg

	// standing is poor
	if(leg_tally <= 0 && !paralysis && !(lying || resting) && prob(5))
		if(species && species.flags & NO_PAIN)
			emote("scream")
		emote("collapse")
		paralysis = 10

	//Check arms and legs for existence
	can_stand = 2 //can stand on both legs
	var/datum/organ/external/E = organs_by_name["l_foot"]
	if(E.status & ORGAN_DESTROYED)
		can_stand--

	E = organs_by_name["r_foot"]
	if(E.status & ORGAN_DESTROYED)
		can_stand--
