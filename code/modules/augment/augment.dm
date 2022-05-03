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


#define ORGAN_STYLE ( \
  (organ.status & ORGAN_ROBOTIC) ? 1 \
: (organ.status & ORGAN_CRYSTAL) ? 2 \
: 0 \
)

#define ORGAN_STYLE_OK ( \
   style == 0 && (augment_flags & AUGMENT_BIOLOGICAL) \
|| style == 1 && (augment_flags & AUGMENT_MECHANICAL) \
|| style == 2 && (augment_flags & AUGMENT_CRYSTALINE) \
)

/obj/item/organ/internal/augment/proc/get_valid_parent_organ(mob/living/carbon/subject)
	if (!istype(subject))
		return
	var/style
	var/obj/item/organ/external/organ
	var/list/organs = subject.organs_by_name
	if ((augment_slots & AUGMENT_CHEST) && !organs["[BP_CHEST]_aug"] && (organ = organs[BP_CHEST]))
		style = ORGAN_STYLE
		if (ORGAN_STYLE_OK)
			return organ
	if ((augment_slots & AUGMENT_ARMOR) && !organs["[BP_CHEST]_aug_armor"] && (organ = organs[BP_CHEST]))
		style = ORGAN_STYLE
		if (ORGAN_STYLE_OK)
			return organ
	if ((augment_slots & AUGMENT_GROIN) && !organs["[BP_GROIN]_aug"] && (organ = organs[BP_GROIN]))
		style = ORGAN_STYLE
		if (ORGAN_STYLE_OK)
			return organ
	if ((augment_slots & AUGMENT_HEAD) && !organs["[BP_HEAD]_aug"] && (organ = organs[BP_HEAD]))
		style = ORGAN_STYLE
		if (ORGAN_STYLE_OK)
			return organ
	if ((augment_slots & AUGMENT_FLUFF) && !organs["[BP_HEAD]_aug_fluff"] && (organ = organs[BP_HEAD]))
		style = ORGAN_STYLE
		if (ORGAN_STYLE_OK)
			return organ
	if (augment_slots & AUGMENT_ARM)
		if (!organs["[BP_L_ARM]_aug"] && (organ = organs[BP_L_ARM]))
			style = ORGAN_STYLE
		if (ORGAN_STYLE_OK)
			return organ
		if (!organs["[BP_R_ARM]_aug"] && (organ = organs[BP_R_ARM]))
			style = ORGAN_STYLE
			if (ORGAN_STYLE_OK)
				return organ
	if (augment_slots & AUGMENT_HAND)
		if (!organs["[BP_L_HAND]_aug"] && (organ = organs[BP_L_HAND]))
			style = ORGAN_STYLE
			if (ORGAN_STYLE_OK)
				return organ
		if (!organs["[BP_R_HAND]_aug"] && (organ = organs[BP_R_HAND]))
			style = ORGAN_STYLE
			if (ORGAN_STYLE_OK)
				return organ
	if (augment_slots & AUGMENT_LEG)
		if (!organs["[BP_L_LEG]_aug"] && (organ = organs[BP_L_LEG]))
			style = ORGAN_STYLE
			if (ORGAN_STYLE_OK)
				return organ
		if (!organs["[BP_R_LEG]_aug"] && (organ = organs[BP_R_LEG]))
			style = ORGAN_STYLE
			if (ORGAN_STYLE_OK)
				return organ
	if (augment_slots & AUGMENT_FOOT)
		if (!organs["[BP_L_FOOT]_aug"] && (organ = organs[BP_L_FOOT]))
			style = ORGAN_STYLE
			if (ORGAN_STYLE_OK)
				return organ
		if (!organs["[BP_R_FOOT]_aug"] && (organ = organs[BP_R_FOOT]))
			style = ORGAN_STYLE
			if (ORGAN_STYLE_OK)
				return organ

#undef ORGAN_STYLE_OK
#undef ORGAN_STYLE


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
			found = augment_slots & (AUGMENT_HEAD | AUGMENT_FLUFF)
	if (!found)
		to_chat(user, SPAN_WARNING("\The [src] can't be installed in \the [parent]."))
		parent_organ = null
		organ_tag = null
		return 1
	parent_organ = parent.organ_tag
	if (found == AUGMENT_ARMOR)
		organ_tag = "[parent_organ]_aug_armor"
	if (found == AUGMENT_FLUFF)
		organ_tag = "[parent_organ]_aug_fluff"
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
	var/level
	if (isobserver(user))
		level = 2
	else if (distance > 1)
		return
	else if (user.mind?.special_role)
		level = 2
	else if (user.skill_check(SKILL_DEVICES, SKILL_PROF))
		level = 2
	else if (user.skill_check(SKILL_DEVICES, SKILL_ADEPT))
		level = 1
	if (!level)
		return
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
	if (augment_slots & (AUGMENT_HEAD|AUGMENT_FLUFF))
		attach_parts += "heads"
	if (augment_slots & AUGMENT_ARM)
		attach_parts += "arms"
	if (augment_slots & AUGMENT_HAND)
		attach_parts += "hands"
	if (augment_slots & AUGMENT_LEG)
		attach_parts += "legs"
	if (augment_slots & AUGMENT_FOOT)
		attach_parts += "feet"
	var/message = "It can be installed in [english_list(attach_parts)] that are [english_list(attach_types)]."
	if (level > 1)
		var/list/discovery = list()
		if (augment_flags & AUGMENT_SCANNABLE)
			discovery += "scanners"
		if (augment_flags & AUGMENT_INSPECTABLE)
			discovery += "manual inspection"
		if (discovery.len)
			message += " It can be discovered by [english_list(discovery)]."
		else
			message += " It is undetectable."
	to_chat(user, message)


/datum/codex_entry/augment
	display_name = "Implantable Augmentation"
	associated_paths = list(/obj/item/organ/internal/augment)
	lore_text = {"\
		<p>Augmentations are a broad category of devices that are added to the bodies of biological and \
		mechanical individuals in order to provide some function or benefit to the user. The most common \
		augmentations in humans are medical or otherwise corrective, but everything from weapons to reward \
		stimulators can be wired into the body one way or another, making many modern humans classic cyborgs.</p>\
		<p>In non-biological entities "augmentations" are often simply normal body components that are not \
		already installed - but many of the same non-medical tools, utilities, and entertainment devices \
		are available.</p>\
	"}
	mechanics_text = {"\
		<p>Augmentations provide various (or no) functionality and are either <b>passive</b> or <b>active</b>. \
		A passive augmentation, so long as it is not too damaged, Just Works. An active augmentation can be \
		toggled on or off via its associated UI button, which appears on its owners screen once it has been \
		implanted.</p>\
		<p>Some active augmentations, like tools and weapons, will try to place an item into (or take it from) \
		a hand or other inventory slot. You will need to <b>keep those slots free</b> in order to turn those \
		active augmentations on.</p>\
		<p>
	"}
