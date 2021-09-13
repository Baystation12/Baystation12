/**
* Augments
* Extra organs that can be embedded to provide behaviors and flavor
*/
/obj/item/organ/internal/augment
	name = "embedded augment"
	icon = 'icons/obj/augment.dmi'
	status = ORGAN_ROBOTIC | ORGAN_CONFIGURE
	default_action_type = /datum/action/item_action/organ/augment
	var/augment_flags = AUGMENT_MECHANICAL | AUGMENT_BIOLOGICAL | AUGMENT_SCANNABLE
	var/augment_slots = EMPTY_BITFIELD


/obj/item/organ/internal/augment/surgery_configure(mob/living/user, mob/living/carbon/human/target, obj/item/organ/parent, obj/item/tool, decl/surgery_step/action)
	var/found
	switch (parent?.organ_tag)
		if (null)
			found = FALSE
		if (BP_L_ARM, BP_R_ARM)
			found = augment_slots & AUGMENT_ARM
		if (BP_L_HAND, BP_R_HAND)
			found = augment_slots & AUGMENT_HAND
		if (BP_L_LEG, BP_R_LEG)
			found = augment_slots & AUGMENT_LEG
		if (BP_L_FOOT, BP_R_FOOT)
			found = augment_slots & AUGMENT_FOOT
		if (BP_CHEST)
			found = augment_slots & (AUGMENT_CHEST | AUGMENT_ARMOR)
		if (BP_GROIN)
			found = augment_slots & AUGMENT_GROIN
		if (BP_HEAD)
			found = augment_slots & AUGMENT_HEAD
	if (!found)
		to_chat(user, SPAN_WARNING("The augment can't be installed in \the [parent]."))
		parent_organ = null
		organ_tag = null
		return 1
	parent_organ = parent.organ_tag
	if (found == AUGMENT_ARMOR)
		organ_tag = "[parent_organ]_aug_armor"
	else
		organ_tag = "[parent_organ]_aug"


/obj/item/organ/internal/augment/replaced(mob/living/carbon/human/target)
	if (..() && istype(owner))
		onInstall()


/obj/item/organ/internal/augment/removed(mob/living/user, drop_organ = TRUE)
	onRemove()
	..()


/// Virtual for removing augment effects from owner
/obj/item/organ/internal/augment/proc/onRemove()
	return


/// Virtual for adding augment effects to owner when surgically added
/obj/item/organ/internal/augment/proc/onInstall()
	return


/// Virtual for adding additional behavior when augment is already present at owner instantiation
/obj/item/organ/internal/augment/proc/onRoundstart()
	return


/obj/item/organ/internal/augment/examine(mob/user, distance)
	. = ..()
	if (distance <= 1)
		var/list/attach_types = list()
		if (augment_flags & AUGMENT_MECHANICAL)
			attach_types += "mechanical"
		if (augment_flags & AUGMENT_BIOLOGICAL)
			attach_types += "biological"
		if (augment_flags & AUGMENT_CRYSTALINE)
			attach_types += "crystaline"
		var/list/attach_parts = list()
		if (augment_slots & (AUGMENT_CHEST|AUGMENT_ARMOR))
			attach_parts += "chests"
		if (augment_slots & AUGMENT_GROIN)
			attach_parts += "lower bodies"
		if (augment_slots & AUGMENT_HEAD)
			attach_parts += "heads"
		if (augment_slots & AUGMENT_ARM)
			attach_parts += "arms"
		if (augment_slots & AUGMENT_HAND)
			attach_parts += "hands"
		if (augment_slots & AUGMENT_LEG)
			attach_parts += "legs"
		if (augment_slots & AUGMENT_FOOT)
			attach_parts += "feet"
		to_chat(user, "It can be installed in [english_list(attach_parts)] that are [english_list(attach_types)].")
