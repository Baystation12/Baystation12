/obj/item/organ/external/stump
	name = "limb stump"
	icon_name = ""
	dislocated = -1

/obj/item/organ/external/stump/New(var/mob/living/carbon/holder, var/internal, var/obj/item/organ/external/limb)
	if(istype(limb))
		limb_name = limb.limb_name
		body_part = limb.body_part
		amputation_point = limb.amputation_point
		joint = limb.joint
		parent_organ = limb.parent_organ
		wounds = limb.wounds
	..(holder, internal)
	if(istype(limb))
		max_damage = limb.max_damage

/obj/item/organ/external/stump/is_stump()
	return 1

/obj/item/organ/external/stump/removed()
	..()
	qdel(src)

/obj/item/organ/external/stump/is_usable()
	return 0
