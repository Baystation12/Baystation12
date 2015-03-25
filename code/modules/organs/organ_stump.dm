/obj/item/organ/external/stump
	name = "limb stump"
	icon_name = ""
	dislocated = -1
	cannot_amputate = 1

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

/obj/item/organ/external/stump/process()
	damage = max_damage

/obj/item/organ/external/stump/handle_rejection()
	return

/obj/item/organ/external/stump/rejuvenate()
	return

/obj/item/organ/external/stump/is_damaged()
	return 1

/obj/item/organ/external/stump/is_bruised()
	return 1

/obj/item/organ/external/stump/is_broken()
	return 1
