/proc/spawn_diona_nymph_from_organ(var/obj/item/organ/organ)
	if(!istype(organ))
		return
	spawn(1) // So it has time to be thrown about by the gib() proc.
		var/mob/living/carbon/alien/diona/D = new(get_turf(organ))
		var/datum/ghosttrap/plant/P = get_ghost_trap("living plant")
		P.request_player(D, "A diona nymph has split off from its gestalt. ")
		qdel(organ)

/obj/item/organ/external/diona
	name = "tendril"
	cannot_break = 1
	amputation_point = "branch"
	joint = "structural ligament"
	dislocated = -1

/obj/item/organ/external/diona/chest
	name = "core trunk"
	limb_name = "chest"
	icon_name = "torso"
	health = 200
	min_broken_damage = 50
	body_part = UPPER_TORSO
	vital = 1
	cannot_amputate = 1
	parent_organ = null

/obj/item/organ/external/diona/groin
	name = "fork"
	limb_name = "groin"
	icon_name = "groin"
	health = 100
	min_broken_damage = 50
	body_part = LOWER_TORSO
	parent_organ = "chest"

/obj/item/organ/external/diona/arm
	name = "left upper tendril"
	limb_name = "l_arm"
	icon_name = "l_arm"
	health = 35
	min_broken_damage = 20
	body_part = ARM_LEFT
	parent_organ = "chest"
	can_grasp = 1

/obj/item/organ/external/diona/arm/right
	name = "right upper tendril"
	limb_name = "r_arm"
	icon_name = "r_arm"
	body_part = ARM_RIGHT

/obj/item/organ/external/diona/leg
	name = "left lower tendril"
	limb_name = "l_leg"
	icon_name = "l_leg"
	health = 35
	min_broken_damage = 20
	body_part = LEG_LEFT
	icon_position = LEFT
	parent_organ = "groin"
	can_stand = 1

/obj/item/organ/external/diona/leg/right
	name = "right lower tendril"
	limb_name = "r_leg"
	icon_name = "r_leg"
	body_part = LEG_RIGHT
	icon_position = RIGHT

/obj/item/organ/external/diona/foot
	name = "left foot"
	limb_name = "l_foot"
	icon_name = "l_foot"
	health = 20
	min_broken_damage = 10
	body_part = FOOT_LEFT
	icon_position = LEFT
	parent_organ = "l_leg"
	can_stand = 1

/obj/item/organ/external/diona/foot/right
	name = "right foot"
	limb_name = "r_foot"
	icon_name = "r_foot"
	body_part = FOOT_RIGHT
	icon_position = RIGHT
	parent_organ = "r_leg"
	joint = "right ankle"
	amputation_point = "right ankle"

/obj/item/organ/external/diona/hand
	name = "left grasper"
	limb_name = "l_hand"
	icon_name = "l_hand"
	health = 30
	min_broken_damage = 15
	body_part = HAND_LEFT
	parent_organ = "l_arm"
	can_grasp = 1

/obj/item/organ/external/diona/hand/right
	name = "right grasper"
	limb_name = "r_hand"
	icon_name = "r_hand"
	body_part = HAND_RIGHT
	parent_organ = "r_arm"

/obj/item/organ/external/diona/head
	limb_name = "head"
	icon_name = "head"
	name = "head"
	health = 50
	min_broken_damage = 25
	body_part = HEAD
	parent_organ = "chest"

/obj/item/organ/external/diona/head/removed()
	if(owner)
		owner.u_equip(owner.head)
		owner.u_equip(owner.l_ear)
	..()

//DIONA ORGANS.
/obj/item/organ/external/diona/removed()
	..()
	if(!istype(owner))
		qdel(src)

	if(!owner.organs.len)
		owner.death()

	if(prob(50))
		spawn_diona_nymph_from_organ(src)

/obj/item/organ/diona/process()
	return

/obj/item/organ/diona/strata
	name = "neural strata"
	parent_organ = "chest"

/obj/item/organ/diona/bladder
	name = "gas bladder"
	parent_organ = "head"

/obj/item/organ/diona/polyp
	name = "polyp segment"
	parent_organ = "groin"

/obj/item/organ/diona/ligament
	name = "anchoring ligament"
	parent_organ = "groin"

/obj/item/organ/diona/node
	name = "receptor node"
	parent_organ = "head"

/obj/item/organ/diona/nutrients
	name = "nutrient vessel"
	parent_organ = "chest"

/obj/item/organ/diona
	name = "diona nymph"
	icon = 'icons/obj/objects.dmi'
	icon_state = "nymph"
	organ_tag = "special" // Turns into a nymph instantly, no transplanting possible.

/obj/item/organ/diona/removed(var/mob/living/user)

	..()
	if(!istype(owner))
		qdel(src)

	if(!owner.internal_organs.len)
		owner.death()

	spawn_diona_nymph_from_organ(src)

// These are different to the standard diona organs as they have a purpose in other
// species (absorbing radiation and light respectively)
/obj/item/organ/diona/nutrients
	name = "nutrient vessel"
	organ_tag = "nutrient vessel"
	icon = 'icons/mob/alien.dmi'
	icon_state = "claw"

/obj/item/organ/diona/nutrients/removed()
	return

/obj/item/organ/diona/node
	name = "receptor node"
	organ_tag = "receptor node"
	icon = 'icons/mob/alien.dmi'
	icon_state = "claw"

/obj/item/organ/diona/node/removed()
	return
