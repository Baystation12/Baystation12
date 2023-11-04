/mob/living/carbon/human/proc/MachineChangeScreen()
	set category = "Abilities"
	set name = "Change Screen"
	if (stat)
		to_chat(src, SPAN_WARNING("You're in no condition to do that."))
		return
	var/obj/item/organ/external/head/head = get_organ(BP_HEAD)
	var/datum/robolimb/robohead = all_robolimbs[head.model]
	if (!head || head.is_stump())
		to_chat(src, SPAN_WARNING("You have no head!"))
		return
	if (head.is_broken())
		to_chat(src, SPAN_WARNING("Your head is broken!"))
		return
	if (!robohead.has_screen)
		to_chat(src, SPAN_WARNING("Your head has no screen!"))
		return
	var/list/options = list()
	for (var/datum/sprite_accessory/facial_hair/ipc/entry as anything in subtypesof(/datum/sprite_accessory/facial_hair/ipc))
		options += initial(entry.name)
	var/choice = input(src, null, "Select Screen") as null | anything in options
	if (!choice || !(choice in options))
		return
	facial_hair_style = choice
	update_hair()


/mob/living/carbon/human/proc/MachineDisableScreen()
	set category = "Abilities"
	set name = "Disable Screen"
	if (stat)
		to_chat(src, SPAN_WARNING("You're in no condition to do that."))
		return
	var/obj/item/organ/external/head/head = get_organ(BP_HEAD)
	var/datum/robolimb/robohead = all_robolimbs[head.model]
	if (!head || head.is_stump())
		to_chat(src, SPAN_WARNING("You have no head!"))
		return
	if (head.is_broken())
		to_chat(src, SPAN_WARNING("Your head is broken!"))
		return
	if (!robohead.has_screen)
		to_chat(src, SPAN_WARNING("Your head has no screen!"))
		return
	facial_hair_style = "Off"
	update_hair()


/mob/living/carbon/human/proc/MachineShowText()
	set category = "Abilities"
	set name = "Set Screen Text"
	if (stat)
		to_chat(src, SPAN_WARNING("You're in no condition to do that."))
		return
	var/obj/item/organ/external/head/head = get_organ(BP_HEAD)
	var/datum/robolimb/robohead = all_robolimbs[head.model]
	if (!head || head.is_stump())
		to_chat(src, SPAN_WARNING("You have no head!"))
		return
	if (head.is_broken())
		to_chat(src, SPAN_WARNING("Your head is broken!"))
		return
	if (!robohead.has_screen)
		to_chat(src, SPAN_WARNING("Your head has no screen!"))
		return
	var/text = input(src, null, "Display Text") as null | text
	if (isnull(text))
		return
	text = sanitize(text, MAX_DESC_LEN)
	robohead.display_text = text
	facial_hair_style = "Text"
	if (!length(text))
		facial_hair_style = "Off"
	update_hair()
	if (HAS_FLAGS(head?.flags_inv, HIDEFACE) || HAS_FLAGS(wear_mask?.flags_inv, HIDEFACE))
		return
	if (!length(text))
		return
	visible_message(
		"\The [src] displays \"[text]\" on their screen.",
		"You display \"[text]\" on your screen."
	)
