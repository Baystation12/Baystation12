/obj/item/organ/internal
	name = "organ"
	desc = "It looks like it probably just plopped out."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "appendix"

	var/list/transplant_data = list()         // Stores info when removed.
	var/organ_type = /obj/item/organ/internal    // Used to spawn the relevant organ data when produced via a machine or spawn().
	var/prosthetic_icon                       // Icon for robotic organ.
	var/dead_icon                             // Icon used when the organ dies.

	var/rejecting = 0

/obj/item/organ/internal/attack_self(mob/user as mob)

	// Convert it to an edible form, yum yum.
	if(!robotic && user.a_intent == "help" && user.zone_sel.selecting == "mouth")
		bitten(user)
		return

/obj/item/organ/internal/New()
	..()
	if(owner)
		var/obj/item/organ/external/E = owner.organs_by_name[src.parent_organ]
		if(E.internal_organs == null)
			E.internal_organs = list()
		E.internal_organs |= src

// Brain is defined in brain_item.dm.
/obj/item/organ/internal/heart
	name = "heart"
	icon_state = "heart-on"
	prosthetic_name = "circulatory pump"
	prosthetic_icon = "heart-prosthetic"
	body_part = "heart"
	fresh = 6 // Juicy.
	dead_icon = "heart-off"
	parent_organ = "chest"

/obj/item/organ/internal/heart/process_internal()
	..()
	if (germ_level > INFECTION_LEVEL_ONE)
		if(prob(5))
			owner.emote("cough")		//respitory tract infection

	if(is_bruised())
		if(prob(2))
			spawn owner.emote("me", 1, "coughs up blood!")
			owner.drip(10)
		if(prob(4))
			spawn owner.emote("me", 1, "gasps for air!")
			owner.losebreath += 15

/obj/item/organ/internal/lungs
	name = "lungs"
	icon_state = "lungs"
	gender = PLURAL
	prosthetic_name = "gas exchange system"
	prosthetic_icon = "lungs-prosthetic"
	body_part = "lungs"
	parent_organ = "chest"

/obj/item/organ/internal/kidneys
	name = "kidneys"
	icon_state = "kidneys"
	gender = PLURAL
	prosthetic_name = "prosthetic kidneys"
	prosthetic_icon = "kidneys-prosthetic"
	body_part = "kidneys"
	parent_organ = "groin"

/obj/item/organ/internal/kidneys/process_internal()

	..()

	// Coffee is really bad for you with busted kidneys.
	// This should probably be expanded in some way, but fucked if I know
	// what else kidneys can process in our reagent list.
	var/datum/reagent/coffee = locate(/datum/reagent/drink/coffee) in owner.reagents.reagent_list
	if(coffee)
		if(is_bruised())
			owner.adjustToxLoss(0.1 * PROCESS_ACCURACY)
		else if(is_broken())
			owner.adjustToxLoss(0.3 * PROCESS_ACCURACY)

/obj/item/organ/internal/eyes
	name = "eyeballs"
	icon_state = "eyes"
	gender = PLURAL
	prosthetic_name = "visual prosthesis"
	prosthetic_icon = "eyes-prosthetic"
	body_part = "eyes"
	parent_organ = "head"

	var/eye_colour

/obj/item/organ/internal/eyes/process_internal() //Eye damage replaces the old eye_stat var.
	..()
	if(is_bruised())
		owner.eye_blurry = 20
	if(is_broken())
		owner.eye_blind = 20

/obj/item/organ/internal/liver
	name = "liver"
	icon_state = "liver"
	prosthetic_name = "toxin filter"
	prosthetic_icon = "liver-prosthetic"
	body_part = "liver"
	parent_organ = "groin"

/obj/item/organ/internal/liver/process_internal()

	..()

	if (germ_level > INFECTION_LEVEL_ONE)
		if(prob(1))
			owner << "\red Your skin itches."
	if (germ_level > INFECTION_LEVEL_TWO)
		if(prob(1))
			spawn owner.vomit()

	if(owner.life_tick % PROCESS_ACCURACY == 0)

		//High toxins levels are dangerous
		if(owner.getToxLoss() >= 60 && !owner.reagents.has_reagent("anti_toxin"))
			//Healthy liver suffers on its own
			if (src.damage < min_broken_damage)
				src.damage += 0.2 * PROCESS_ACCURACY
			//Damaged one shares the fun
			else
				var/obj/item/organ/internal/O = pick(owner.internal_organs)
				if(O)
					O.damage += 0.2  * PROCESS_ACCURACY

		//Detox can heal small amounts of damage
		if (src.damage && src.damage < src.min_bruised_damage && owner.reagents.has_reagent("anti_toxin"))
			src.damage -= 0.2 * PROCESS_ACCURACY

		if(src.damage < 0)
			src.damage = 0

		// Get the effectiveness of the liver.
		var/filter_effect = 3
		if(is_bruised())
			filter_effect -= 1
		if(is_broken())
			filter_effect -= 2

		// Do some reagent filtering/processing.
		for(var/datum/reagent/R in owner.reagents.reagent_list)
			// Damaged liver means some chemicals are very dangerous
			// The liver is also responsible for clearing out alcohol and toxins.
			// Ethanol and all drinks are bad.K
			if(istype(R, /datum/reagent/ethanol))
				if(filter_effect < 3)
					owner.adjustToxLoss(0.1 * PROCESS_ACCURACY)
				owner.reagents.remove_reagent(R.id, R.custom_metabolism*filter_effect)
			// Can't cope with toxins at all
			else if(istype(R, /datum/reagent/toxin))
				if(filter_effect < 3)
					owner.adjustToxLoss(0.3 * PROCESS_ACCURACY)
				owner.reagents.remove_reagent(R.id, ALCOHOL_METABOLISM*filter_effect)

/obj/item/organ/internal/appendix
	name = "appendix"
	icon_state = "appendix"
	body_part = "appendix"
	parent_organ = "groin"

/obj/item/organ/internal/proc/removed(var/mob/living/carbon/human/target,var/mob/living/user)

	var/turf/target_loc
	if(user)
		target_loc = get_turf(user)
	else
		target_loc = get_turf(owner)
	loc = target_loc
	if(!robotic)
		processing_objects |= src

	if(!istype(target))
		return

	target.internal_organs_by_name[body_part] = null
	target.internal_organs_by_name -= body_part
	target.internal_organs -= src

	var/obj/item/organ/external/affected = target.get_organ(src.parent_organ)
	affected.internal_organs -= src

	loc = target.loc
	rejecting = null
	var/datum/reagent/blood/organ_blood = locate(/datum/reagent/blood) in reagents.reagent_list
	if(!organ_blood || !transplant_data["blood_DNA"])
		target.vessel.trans_to(src, 5, 1, 1)

	if(target && user && vital)
		user.attack_log += "\[[time_stamp()]\]<font color='red'> removed a vital organ ([src]) from [target.name] ([target.ckey]) (INTENT: [uppertext(user.a_intent)])</font>"
		target.attack_log += "\[[time_stamp()]\]<font color='orange'> had a vital organ ([src]) removed by [user.name] ([user.ckey]) (INTENT: [uppertext(user.a_intent)])</font>"
		msg_admin_attack("[user.name] ([user.ckey]) removed a vital organ ([src]) from [target.name] ([target.ckey]) (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")
		target.death()

/obj/item/organ/internal/appendix/removed(var/mob/living/target,var/mob/living/user)

	..()

	var/inflamed = 0
	for(var/datum/disease/appendicitis/appendicitis in target.viruses)
		inflamed = 1
		appendicitis.cure()
		target.resistances += appendicitis

	if(inflamed)
		icon_state = "appendixinflamed"
		name = "inflamed appendix"

/obj/item/organ/internal/die()
	..()
	if(dead_icon) icon_state = dead_icon

/obj/item/organ/internal/eyes/removed(var/mob/living/target,var/mob/living/user)

	if(!eye_colour)
		eye_colour = list(0,0,0)

	..() //Make sure target is set so we can steal their eye colour for later.
	var/mob/living/carbon/human/H = target
	if(istype(H))
		eye_colour = list(
			H.r_eyes ? H.r_eyes : 0,
			H.g_eyes ? H.g_eyes : 0,
			H.b_eyes ? H.b_eyes : 0
			)

		// Leave bloody red pits behind!
		H.r_eyes = 128
		H.g_eyes = 0
		H.b_eyes = 0
		H.update_body()

/obj/item/organ/internal/proc/replaced(var/mob/living/carbon/human/target,var/obj/item/organ/external/affected)

	if(!istype(target)) return

	var/datum/reagent/blood/transplant_blood = locate(/datum/reagent/blood) in reagents.reagent_list
	if(!transplant_blood)
		transplant_data = list()
		transplant_data["species"] =    target.species.name
		transplant_data["blood_type"] = target.dna.b_type
		transplant_data["blood_DNA"] =  target.dna.unique_enzymes
	else
		transplant_data = list()
		transplant_data["species"] =    transplant_blood.data["species"]
		transplant_data["blood_type"] = transplant_blood.data["blood_type"]
		transplant_data["blood_DNA"] =  transplant_blood.data["blood_DNA"]

	owner = target
	src.loc = owner
	if(!robotic)
		processing_objects -= src
	target.internal_organs |= src
	affected.internal_organs |= src
	target.internal_organs_by_name[body_part] = src
	status |= ORGAN_CUT_AWAY

/obj/item/organ/internal/eyes/replaced(var/mob/living/carbon/human/target)

	// Apply our eye colour to the target.
	if(istype(target) && eye_colour)
		target.r_eyes = eye_colour[1]
		target.g_eyes = eye_colour[2]
		target.b_eyes = eye_colour[3]
		target.update_body()
	..()

/obj/item/organ/internal/proc/bitten(mob/user)

	if(robotic)
		return

	user << "\blue You take an experimental bite out of \the [src]."
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in reagents.reagent_list
	blood_splatter(src,B,1)


	user.drop_from_inventory(src)
	var/obj/item/weapon/reagent_containers/food/snacks/organ/O = new(get_turf(src))
	O.name = name
	O.icon_state = dead_icon ? dead_icon : icon_state

	// Pass over the blood.
	reagents.trans_to(O, reagents.total_volume)

	if(fingerprints) O.fingerprints = fingerprints.Copy()
	if(fingerprintshidden) O.fingerprintshidden = fingerprintshidden.Copy()
	if(fingerprintslast) O.fingerprintslast = fingerprintslast

	user.put_in_active_hand(O)
	del(src)

/obj/item/organ/internal/proc/rejuvenate()
	damage=0

/obj/item/organ/internal/proc/is_bruised()
	return damage >= min_bruised_damage

/obj/item/organ/internal/proc/is_broken()
	return damage >= min_broken_damage || status & ORGAN_CUT_AWAY

/obj/item/organ/internal/process_internal()

	//Process infections
	if (robotic >= 2 )	//TODO make robotic internal and external organs separate types of organ instead of a flag
		germ_level = 0
		return

	if(owner.bodytemperature >= 170)	//cryo stops germs from moving and doing their bad stuffs
		//** Handle antibiotics and curing infections
		handle_antibiotics()

		//** Handle the effects of infections
		var/antibiotics = owner.reagents.get_reagent_amount("spaceacillin")

		if (germ_level > 0 && germ_level < INFECTION_LEVEL_ONE/2 && prob(30))
			germ_level--

		if (germ_level >= INFECTION_LEVEL_ONE/2)
			//aiming for germ level to go from ambient to INFECTION_LEVEL_TWO in an average of 15 minutes
			if(antibiotics < 5 && prob(round(germ_level/6)))
				germ_level++

		if (germ_level >= INFECTION_LEVEL_TWO)
			var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
			//spread germs
			if (antibiotics < 5 && parent.germ_level < germ_level && ( parent.germ_level < INFECTION_LEVEL_ONE*2 || prob(30) ))
				parent.germ_level++

			if (prob(3))	//about once every 30 seconds
				take_damage(1,silent=prob(30))

		// Process unsuitable transplants. TODO: consider some kind of
		// immunosuppressant that changes transplant data to make it match.
		if(transplant_data)
			if(!rejecting && prob(20) && owner.dna && blood_incompatible(transplant_data["blood_type"],owner.dna.b_type,owner.species,transplant_data["species"]))
				rejecting = 1
			else
				rejecting++ //Rejection severity increases over time.
				if(rejecting % 10 == 0) //Only fire every ten rejection ticks.
					switch(rejecting)
						if(1 to 50)
							take_damage(1)
						if(51 to 200)
							owner.reagents.add_reagent("toxin", 1)
							take_damage(1)
						if(201 to 500)
							take_damage(rand(2,3))
							owner.reagents.add_reagent("toxin", 2)
						if(501 to INFINITY)
							take_damage(4)
							owner.reagents.add_reagent("toxin", rand(3,5))

/obj/item/organ/internal/take_damage(amount, var/silent=0)
	if(src.robotic == 2)
		src.damage += (amount * 0.8)
	else
		src.damage += amount

	var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
	if (!silent)
		owner.custom_pain("Something inside your [parent.display_name] hurts a lot.", 1)

/obj/item/organ/internal/proc/mechanize() //Being used to make robutt hearts, etc
	robotic = 2

/obj/item/organ/internal/proc/mechassist() //Used to add things like pacemakers, etc
	robotic = 1
	min_bruised_damage = 15
	min_broken_damage = 35