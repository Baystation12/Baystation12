/obj/item/organ/external/stump
	name = "limb stump"
	icon_name = ""
	dislocated = -1

/obj/item/organ/external/stump/New(var/mob/living/carbon/holder, var/internal, var/obj/item/organ/external/limb)
	if(istype(limb))
		organ_tag = limb.organ_tag
		body_part = limb.body_part
		amputation_point = limb.amputation_point
		joint = limb.joint
		parent_organ = limb.parent_organ
	..(holder, internal)
	if(istype(limb))
		max_damage = limb.max_damage
		if((limb.robotic >= ORGAN_ROBOT) && (!parent || (parent.robotic >= ORGAN_ROBOT)))
			robotize() //if both limb and the parent are robotic, the stump is robotic too

/obj/item/organ/external/stump/is_stump()
	return 1

/obj/item/organ/external/stump/removed()
	..()
	qdel(src)

/obj/item/organ/external/stump/is_usable()
	return 0
