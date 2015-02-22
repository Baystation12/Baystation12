#define PROCESS_ACCURACY 1

/****************************************************
			   ORGAN DEFINES
****************************************************/

// EXTERNAL

/obj/item/organ/external/chest
	name = "upper body"
	limb_name = "chest"
	icon_name = "torso"
	health = 75
	min_broken_damage = 35
	body_part = UPPER_TORSO
	vital = 1
	amputation_point = "spine"
	joint = "neck"
	dislocated = -1
	min_sever_area = 25
	gendered_icon = 1

/obj/item/organ/external/groin
	name = "lower body"
	limb_name = "groin"
	icon_name = "groin"
	health = 50
	min_broken_damage = 20
	body_part = LOWER_TORSO
	vital = 1
	parent_organ = "chest"
	amputation_point = "lumbar"
	joint = "hip"
	dislocated = -1
	min_sever_area = 25
	gendered_icon = 1

/obj/item/organ/external/arm
	limb_name = "l_arm"
	name = "left arm"
	icon_name = "l_arm"
	health = 50
	min_broken_damage = 30
	body_part = ARM_LEFT
	parent_organ = "chest"
	joint = "left elbow"
	amputation_point = "left shoulder"
	min_sever_area = 10

/obj/item/organ/external/arm/process_internal()
	..()
	process_grasp(owner.l_hand, "left hand")

/obj/item/organ/external/arm/right
	limb_name = "r_arm"
	name = "right arm"
	icon_name = "r_arm"
	health = 50
	min_broken_damage = 30
	body_part = ARM_RIGHT
	parent_organ = "chest"
	joint = "right elbow"
	amputation_point = "right shoulder"

/obj/item/organ/external/arm/right/process_internal()
	..()
	process_grasp(owner.r_hand, "right hand")

/obj/item/organ/external/leg
	limb_name = "l_leg"
	name = "left leg"
	icon_name = "l_leg"
	health = 50
	min_broken_damage = 30
	body_part = LEG_LEFT
	icon_position = LEFT
	parent_organ = "groin"
	joint = "left knee"
	amputation_point = "left hip"
	min_sever_area = 10

/obj/item/organ/external/leg/right
	limb_name = "r_leg"
	name = "right leg"
	icon_name = "r_leg"
	body_part = LEG_RIGHT
	icon_position = RIGHT
	parent_organ = "groin"
	joint = "right knee"
	amputation_point = "right hip"

/obj/item/organ/external/foot
	limb_name = "l_foot"
	name = "left foot"
	icon_name = "l_foot"
	health = 30
	min_broken_damage = 15
	body_part = FOOT_LEFT
	icon_position = LEFT
	parent_organ = "l_leg"
	joint = "left ankle"
	amputation_point = "left ankle"

/obj/item/organ/external/foot/removed()
	if(owner) owner.u_equip(owner.shoes)
	..()

/obj/item/organ/external/foot/right
	limb_name = "r_foot"
	name = "right foot"
	icon_name = "r_foot"
	body_part = FOOT_RIGHT
	icon_position = RIGHT
	parent_organ = "r_leg"
	joint = "right ankle"
	amputation_point = "right ankle"

/obj/item/organ/external/hand
	limb_name = "l_hand"
	name = "left hand"
	icon_name = "l_hand"
	health = 30
	min_broken_damage = 15
	body_part = HAND_LEFT
	parent_organ = "l_arm"
	joint = "left wrist"
	amputation_point = "left wrist"

/obj/item/organ/external/hand/process_internal()
	..()
	process_grasp(owner.l_hand, "left hand")

/obj/item/organ/external/hand/removed()
	owner.u_equip(owner.gloves)
	..()

/obj/item/organ/external/hand/right
	limb_name = "r_hand"
	name = "right hand"
	icon_name = "r_hand"
	body_part = HAND_RIGHT
	parent_organ = "r_arm"
	joint = "right wrist"
	amputation_point = "right wrist"

/obj/item/organ/external/hand/right/process_internal()
	..()
	process_grasp(owner.r_hand, "right hand")

/obj/item/organ/external/head
	limb_name = "head"
	icon_name = "head"
	name = "head"
	health = 75
	min_broken_damage = 35
	body_part = HEAD
	vital = 1
	parent_organ = "chest"
	joint = "jaw"
	amputation_point = "neck"
	min_sever_area = 15
	gendered_icon = 1

/obj/item/organ/external/head/removed()
	if(owner)
		owner.u_equip(owner.glasses)
		owner.u_equip(owner.head)
		owner.u_equip(owner.l_ear)
		owner.u_equip(owner.r_ear)
		owner.u_equip(owner.wear_mask)
	..()

// Prosthetics.
/obj/item/organ/external/leg/robot
	status = ORGAN_ROBOT
	dislocated = -1

/obj/item/organ/external/leg/right/robot
	status = ORGAN_ROBOT
	dislocated = -1

/obj/item/organ/external/foot/robot
	status = ORGAN_ROBOT
	dislocated = -1

/obj/item/organ/external/foot/right/robot
	status = ORGAN_ROBOT
	dislocated = -1

/obj/item/organ/external/arm/robot
	status = ORGAN_ROBOT
	dislocated = -1

/obj/item/organ/external/arm/right/robot
	status = ORGAN_ROBOT
	dislocated = -1

/obj/item/organ/external/hand/robot
	status = ORGAN_ROBOT
	dislocated = -1

/obj/item/organ/external/hand/right/robot
	status = ORGAN_ROBOT
	dislocated = -1

/obj/item/organ/external/head/robot
	status = ORGAN_ROBOT
	dislocated = -1

/obj/item/organ/external/chest/robot
	status = ORGAN_ROBOT
	dislocated = -1

//INTERNAL

// Brain is defined in brain_item.dm.
/obj/item/organ/internal/heart
	name = "heart"
	icon_state = "heart-on"
	body_part = "heart"
	dead_icon = "heart-off"
	parent_organ = "chest"

// Takes care blood loss and regeneration
/obj/item/organ/internal/heart/process_internal()
	..()

	var/blood_volume = round(owner.vessel.get_reagent_amount("blood"))

	//Blood regeneration if there is some space
	if(blood_volume < 560)
		var/datum/reagent/blood/B = locate() in owner.vessel.reagent_list //Grab some blood
		if(B) // Make sure there's some blood at all
			if(B.data["donor"] != src) //If it's not theirs, then we look for theirs
				for(var/datum/reagent/blood/D in owner.vessel.reagent_list)
					if(D.data["donor"] == src)
						B = D
						break

			B.volume += 0.1 // regenerate blood VERY slowly
			//TODO: move this to stomach organ.
			if (owner.reagents.has_reagent("nutriment"))	//Getting food speeds it up
				B.volume += 0.4
				owner.reagents.remove_reagent("nutriment", 0.1)

			if (owner.reagents.has_reagent("iron"))	//Hematogen candy anyone?
				B.volume += 0.8
				owner.reagents.remove_reagent("iron", 0.1)

	// Damaged heart virtually reduces the blood volume, as the blood isn't
	// being pumped properly anymore.
	if(is_damaged()>0)
		if(is_bruised())
			if(is_broken())
				blood_volume *= 0.3
			else
				blood_volume *= 0.6
		else
			blood_volume *= 0.8

	// Mob can handle everything else since it uses only mob vars, not organ vars.
	owner.blood_volume = blood_volume

/obj/item/organ/internal/heart/removed()
	owner.blood_volume = 0
	..()

/obj/item/organ/internal/heart/die()
	owner.blood_volume = 0
	..()

/obj/item/organ/internal/lungs
	name = "lungs"
	icon_state = "lungs"
	gender = PLURAL
	body_part = "lungs"
	parent_organ = "chest"

/obj/item/organ/internal/lungs/process_internal()
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

/obj/item/organ/internal/kidneys
	name = "kidneys"
	icon_state = "kidneys"
	gender = PLURAL
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
	body_part = "eyes"
	parent_organ = "head"

	var/eye_colour

/obj/item/organ/internal/eyes/process_internal() //Eye damage replaces the old eye_stat var.
	..()
	if(is_bruised())
		owner.eye_blurry = 20
	if(is_broken())
		owner.eye_blind = 20

/obj/item/organ/internal/eyes/removed(var/mob/living/user)

	if(!eye_colour)
		eye_colour = list(0,0,0)

	..() //Make sure target is set so we can steal their eye colour for later.

	if(istype(owner))
		eye_colour = list(
			owner.r_eyes ? owner.r_eyes : 0,
			owner.g_eyes ? owner.g_eyes : 0,
			owner.b_eyes ? owner.b_eyes : 0
			)

		// Leave bloody red pits behind!
		owner.r_eyes = 128
		owner.g_eyes = 0
		owner.b_eyes = 0
		owner.update_body()

/obj/item/organ/internal/eyes/replaced(var/mob/living/carbon/human/target)

	// Apply our eye colour to the target.
	if(istype(target) && eye_colour)
		target.r_eyes = eye_colour[1]
		target.g_eyes = eye_colour[2]
		target.b_eyes = eye_colour[3]
		target.update_body()
	..()

/obj/item/organ/internal/liver
	name = "liver"
	icon_state = "liver"
	body_part = "liver"
	parent_organ = "groin"

/obj/item/organ/internal/liver/process_internal()

	..()

	if (germ_level > INFECTION_LEVEL_ONE)
		if(prob(1))
			owner << "<span class='danger'>Your skin itches.</span>"
	if (germ_level > INFECTION_LEVEL_TWO)
		if(prob(1))
			spawn owner.vomit()

	if(owner.life_tick % PROCESS_ACCURACY == 0)

		//High toxins levels are dangerous
		if(owner.getToxLoss() >= 60 && !owner.reagents.has_reagent("anti_toxin"))
			//Healthy liver suffers on its own
			if (!is_broken())
				src.take_damage(0.2*PROCESS_ACCURACY,0)
			//Damaged one shares the fun
			else
				var/obj/item/organ/internal/O = pick(owner.internal_organs)
				if(O)
					O.take_damage(0.2*PROCESS_ACCURACY,0)

		//Detox can heal small amounts of damage
		if (!is_bruised() && owner.reagents.has_reagent("anti_toxin"))
			src.heal_damage(0.2*PROCESS_ACCURACY,0)

		if(src.is_damaged() < 0)
			src.set_damage(0,0)

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

/obj/item/organ/internal/appendix/removed(var/mob/living/user)

	..()
	if(!istype(owner))
		return
	var/inflamed = 0
	for(var/datum/disease/appendicitis/appendicitis in owner.viruses)
		inflamed = 1
		appendicitis.cure()
		owner.resistances += appendicitis

	if(inflamed)
		icon_state = "appendixinflamed"
		name = "inflamed appendix"

//DIONA ORGANS.
/obj/item/organ/internal/diona
	name = "diona nymph"
	icon = 'icons/obj/objects.dmi'
	icon_state = "nymph"
	body_part = "special" // Turns into a nymph instantly, no transplanting possible.

/obj/item/organ/internal/diona/removed(var/mob/living/user)

	..()
	if(!istype(owner))
		del(src)

	if(!owner.internal_organs.len)
		owner.death()

	//This is a terrible hack and I should be ashamed.
	var/datum/seed/diona = seed_types["diona"]
	if(!diona)
		del(src)

	spawn(1) // So it has time to be thrown about by the gib() proc.
		var/mob/living/carbon/alien/diona/D = new(get_turf(src))
		diona.request_player(D)
		del(src)

/obj/item/organ/internal/diona/process_internal()
	return

/obj/item/organ/internal/diona/strata
	name = "neural strata"
	parent_organ = "chest"

/obj/item/organ/internal/diona/bladder
	name = "gas bladder"
	parent_organ = "head"

/obj/item/organ/internal/diona/polyp
	name = "polyp segment"
	parent_organ = "groin"

/obj/item/organ/internal/diona/ligament
	name = "anchoring ligament"
	parent_organ = "groin"

// These are different to the standard diona organs as they have a purpose in other
// species (absorbing radiation and light respectively)
/obj/item/organ/internal/diona/nutrients
	name = "nutrient vessel"
	body_part = "nutrient vessel"
	icon = 'icons/mob/alien.dmi'
	icon_state = "claw"

/obj/item/organ/internal/diona/nutrients/removed()
	return

/obj/item/organ/internal/diona/node
	name = "receptor node"
	body_part = "receptor node"
	icon = 'icons/mob/alien.dmi'
	icon_state = "claw"

/obj/item/organ/internal/diona/node/removed()
	return

//CORTICAL BORER ORGANS.
/obj/item/organ/internal/borer
	name = "cortical borer"
	parent_organ = "head"
	vital = 1

/obj/item/organ/internal/borer/process_internal()

	// Borer husks regenerate health, feel no pain, and are resistant to stuns and brainloss.
	for(var/chem in list("tricordrazine","tramadol","hyperzine","alkysine"))
		if(owner.reagents.get_reagent_amount(chem) < 3)
			owner.reagents.add_reagent(chem, 5)

	// They're also super gross and ooze ichor.
	if(prob(5))
		var/mob/living/carbon/human/H = owner
		if(!istype(H))
			return

		var/datum/reagent/blood/B = locate(/datum/reagent/blood) in H.vessel.reagent_list
		blood_splatter(H,B,1)
		var/obj/effect/decal/cleanable/blood/splatter/goo = locate() in get_turf(owner)
		if(goo)
			goo.name = "husk ichor"
			goo.desc = "It's thick and stinks of decay."
			goo.basecolor = "#412464"
			goo.update_icon()

/obj/item/organ/internal/borer
	name = "cortical borer"
	icon = 'icons/obj/objects.dmi'
	icon_state = "borer"
	body_part = "brain"
	desc = "A disgusting space slug."
	vital = 1

/obj/item/organ/internal/borer/removed(var/mob/living/user)

	..()
	if(!istype(owner))
		return
	var/mob/living/simple_animal/borer/B = owner.has_brain_worms()
	if(B)
		B.leave_host()
		B.ckey = owner.ckey

	spawn(0)
		del(src)

//XENOMORPH ORGANS
/obj/item/organ/internal/xenos
	name = "xeno organ"
	icon = 'icons/effects/blood.dmi'
	desc = "It smells like an accident in a chemical factory."

/obj/item/organ/internal/xenos/plasmavessel
	name = "plasma vessel"
	icon_state = "xgibdown1"
	body_part = "plasma vessel"
	var/stored_plasma = 0
	var/max_plasma = 500

/obj/item/organ/internal/xenos/plasmavessel/queen
	name = "bloated plasma vessel"
	stored_plasma = 200
	max_plasma = 500

/obj/item/organ/internal/xenos/plasmavessel/sentinel
	stored_plasma = 100
	max_plasma = 250

/obj/item/organ/internal/xenos/plasmavessel/hunter
	name = "tiny plasma vessel"
	stored_plasma = 100
	max_plasma = 150

/obj/item/organ/internal/xenos/eggsac
	name = "egg sac"
	icon_state = "xgibmid1"
	body_part = "egg sac"

/obj/item/organ/internal/xenos/acidgland
	name = "acid gland"
	icon_state = "xgibtorso"
	body_part = "acid gland"

/obj/item/organ/internal/xenos/hivenode
	name = "hive node"
	icon_state = "xgibmid2"
	body_part = "hive node"

/obj/item/organ/internal/xenos/resinspinner
	name = "hive node"
	icon_state = "xgibmid2"
	body_part = "resin spinner"

//VOX ORGANS.

/obj/item/organ/internal/stack
	name = "cortical stack"
	icon_state = "brain-prosthetic"
	body_part = "stack"
	status = ORGAN_ROBOT
	vital = 1
	var/backup_time = 0
	var/datum/mind/backup

/obj/item/organ/internal/stack/process_internal()
	if(owner && owner.stat != 2 && !is_broken())
		backup_time = world.time
		if(owner.mind) backup = owner.mind

/obj/item/organ/internal/stack/vox
	name = "vox cortical stack"

#undef PROCESS_ACCURACY