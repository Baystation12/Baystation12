/obj/item/organ/external/stump
	name = "limb stump"
	icon_name = ""
	dislocated = -1

/obj/item/organ/external/stump/New(var/mob/living/carbon/holder, var/internal, var/obj/item/organ/external/limb)
	if(istype(limb))
		SetName("stump of \a [limb.name]")
		organ_tag = limb.organ_tag
		body_part = limb.body_part
		amputation_point = limb.amputation_point
		joint = limb.joint
		parent_organ = limb.parent_organ
		artery_name = "mangled [limb.artery_name]"
		arterial_bleed_severity = limb.arterial_bleed_severity
	..(holder, internal)
	if(istype(limb))
		max_damage = limb.max_damage
		if(BP_IS_ROBOTIC(limb) && (!parent || BP_IS_ROBOTIC(parent)))
			robotize() //if both limb and the parent are robotic, the stump is robotic too
		if(BP_IS_CRYSTAL(limb) && (!parent || BP_IS_CRYSTAL(parent)))
			status |= ORGAN_CRYSTAL // Likewise with crystalline limbs.

/obj/item/organ/external/stump/is_stump()
	return 1
