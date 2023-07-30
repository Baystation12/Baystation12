/datum/keybinding/human
	category = CATEGORY_HUMAN


/datum/keybinding/human/can_use(client/user)
	return ishuman(user.mob)


/datum/keybinding/human/quick_equip
	hotkey_keys = list("E")
	name = "quick_equip"
	full_name = "Quick Equip"
	description = "Quickly puts an item in the best slot available"


/datum/keybinding/human/quick_equip/down(client/user)
	var/mob/living/carbon/human/H = user.mob
	H.quick_equip()
	return TRUE


/datum/keybinding/human/holster
	hotkey_keys = list("H")
	name = "holster"
	full_name = "Holster"
	description = "Draw or holster weapon"


/datum/keybinding/human/holster/down(client/user)
	var/mob/living/carbon/human/H = user.mob
	if(H.incapacitated())
		return

	var/obj/item/clothing/under/U = H.w_uniform
	for(var/obj/S in U.accessories)
		if(istype(S, /obj/item/clothing/accessory/storage/holster))
			var/datum/extension/holster/E = get_extension(S, /datum/extension/holster)
			if(!E.holstered)
				if(!H.get_active_hand())
					to_chat(H, SPAN_WARNING("You're not holding anything to holster."))
					return
				E.holster(H.get_active_hand(), H)
				return
			else
				E.unholster(H, TRUE)
				return

	if(istype(H.belt, /obj/item/storage/belt/holster))
		var/obj/item/storage/belt/holster/B = H.belt
		var/datum/extension/holster/E = get_extension(B, /datum/extension/holster)
		if(!E.holstered)
			if(!H.get_active_hand())
				to_chat(H, SPAN_WARNING("You're not holding anything to holster."))
				return
			E.holster(H.get_active_hand(), H)
			return
		else
			E.unholster(H, TRUE)
			return

	return TRUE


/datum/keybinding/human/give
	hotkey_keys = list("None")
	name = "give_item"
	full_name = "Give Item"
	description = "Give the item you're currently holding"


/datum/keybinding/human/give/down(client/user)
	var/mob/living/carbon/human/H = user.mob
	H.give()
	return TRUE


/datum/keybinding/human/stop_pulling
	hotkey_keys = list("C", "Delete")
	name = "stop_pulling"
	full_name = "Stop Pulling"
	description = "Let go of the object and stop pulling"


/datum/keybinding/human/stop_pulling/down(client/user)
	var/mob/living/carbon/human/H = user.mob
	H.stop_pulling()
	return TRUE
