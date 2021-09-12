/**
* Augments
* Extra organs that can be embedded to provide behaviors and flavor
*/
/obj/item/organ/internal/augment
	name = "embedded augment"
	icon = 'icons/obj/augment.dmi'
	status = ORGAN_ROBOTIC
	var/augment_flags = AUGMENT_MECHANICAL | AUGMENT_BIOLOGICAL | AUGMENT_SCANNABLE
	var/list/allowed_organs = list(BP_AUGMENT_R_ARM, BP_AUGMENT_L_ARM)
	default_action_type = /datum/action/item_action/organ/augment
	var/descriptor = ""


/obj/item/organ/internal/augment/Initialize()
	. = ..()
	organ_tag = pick(allowed_organs)
	update_parent_organ()


//General expectation is onInstall and onRemoved are overwritten to add effects to augmentee
/obj/item/organ/internal/augment/replaced(mob/living/carbon/human/target)
	if (..() && istype(owner))
		onInstall()


/obj/item/organ/internal/augment/removed(mob/living/user, drop_organ = TRUE)
	onRemove()
	..()


/obj/item/organ/internal/augment/proc/onRoundstart()
	return


/obj/item/organ/internal/augment/proc/onInstall()
	return


/obj/item/organ/internal/augment/proc/onRemove()
	return


/obj/item/organ/internal/augment/attackby(obj/item/I, mob/user)
	if (isScrewdriver(I) && allowed_organs.len > 1) //Adjusting the install organ for augments with multiple targets
		organ_tag = input(user, "Adjust installation parameters") as null | anything in allowed_organs
		update_parent_organ()
		playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
		return
	..()


/// Attempts to match a parent organ to an augment slot
/obj/item/organ/internal/augment/proc/update_parent_organ()
	switch (organ_tag)
		if (BP_AUGMENT_L_LEG)
			parent_organ = BP_L_LEG
			descriptor = "left leg"
		if (BP_AUGMENT_R_LEG)
			parent_organ = BP_R_LEG
			descriptor = "right leg"
		if (BP_AUGMENT_L_HAND)
			parent_organ = BP_L_HAND
			descriptor = "left hand"
		if (BP_AUGMENT_R_HAND)
			parent_organ = BP_R_HAND
			descriptor = "right hand"
		if (BP_AUGMENT_L_ARM)
			parent_organ = BP_L_ARM
			descriptor = "left arm"
		if (BP_AUGMENT_R_ARM)
			parent_organ = BP_R_ARM
			descriptor = "right arm"
		if (BP_AUGMENT_HEAD)
			parent_organ = BP_HEAD
			descriptor = "head"
		if (BP_AUGMENT_CHEST_ACTIVE, BP_AUGMENT_CHEST_ARMOUR)
			parent_organ = BP_CHEST
			descriptor = "chest"


/obj/item/organ/internal/augment/examine(mob/user, distance)
	. = ..()
	if (distance <= 1)
		var/list/attachable = list()
		if (augment_flags & AUGMENT_MECHANICAL)
			attachable += "mechanical"
		if (augment_flags & AUGMENT_BIOLOGICAL)
			attachable += "biological"
		if (augment_flags & AUGMENT_CRYSTALINE)
			attachable += "crystaline"
		to_chat(user, "It is configured to be attached to the [descriptor]." +\
		"\nIt can interface with [english_list(attachable) || "no"] organs.")
