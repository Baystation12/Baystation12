// Unathi garnmaents

/obj/item/clothing/head/cap/sec
	name = "big security cap"
	desc = "A security cap. This one pretty big."
	icon = 'mods/loadout_items/icons/obj_head.dmi'
	item_icons = list(slot_wear_suit_str = 'mods/loadout_items/icons/onmob_head.dmi')
	sprite_sheets = list(
		SPECIES_UNATHI = 'mods/loadout_items/icons/onmob_head.dmi'
	)
	icon_state = "unathi_seccap"
	item_state = "unathi_seccap"
	species_restricted = list(SPECIES_UNATHI)
	flags_inv = BLOCKHEADHAIR

/obj/item/clothing/head/cap/desert
	name = "Suncap"
	desc = "A big suncap designed for use in the desert. Unathi use it to withstand scorhing heat rays when \"Burning Mother\" at it's zenith, something that their heads cannot handle. This one features foldable flaps to keep back of the neck protected. It's too big to fit anyone, but unathi."
	icon = 'mods/loadout_items/icons/obj_head.dmi'
	item_icons = list(slot_wear_suit_str = 'mods/loadout_items/icons/onmob_head.dmi')
	sprite_sheets = list(
		SPECIES_UNATHI = 'mods/loadout_items/icons/onmob_head.dmi'
	)
	icon_state = "unathi_suncap"
	item_state = "unathi_suncap"
	flags_inv = HIDEEARS|BLOCKHEADHAIR
	var/icon_state_up = "unathi_suncap_u"
	species_restricted  = list(SPECIES_UNATHI)
	body_parts_covered = HEAD

/obj/item/clothing/head/cap/desert/attack_self(mob/user as mob)
	if(icon_state == initial(icon_state))
		icon_state = icon_state_up
		item_state = icon_state_up
		to_chat(user, "You raise the ear flaps on the Suncap.")
	else
		icon_state = initial(icon_state)
		item_state = initial(icon_state)
		to_chat(user, "You lower the ear flaps on the Suncap.")
