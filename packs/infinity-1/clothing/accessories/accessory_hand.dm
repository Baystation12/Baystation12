/obj/item/clothing/accessory_hand
	name = "ring"
	desc = "This is just a ring. Nothing more."
	icon = 'icons/obj/clothing/obj_hands_ring.dmi'
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_GLOVES
	gender = NEUTER

	var/undergloves = TRUE 					// If TRUE, the item will be hidden under the gloves.

// Wristwacth
/obj/item/clothing/accessory_hand/wristwatch
	name = "black watch"
	desc = "A wristwatch. This one is silver and EMP-resistance."
	icon = 'packs/infinity/icons/obj/clothing/obj_accessory_hand.dmi'
	item_icons = list(slot_gloves_str = 'infinity/icons/mob/onmob/onmob_wristwatch.dmi')
	icon_state = "watch_black"
	item_state = "watch_black"
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_GLOVES
	species_restricted = list("exclude", SPECIES_NABBER)
	gender = NEUTER

	var/origin_sprite = "watch_black"		// We use this variable to store the original name of the sprite
	var/can_wear_on_both_hands = TRUE		// If TRUE, we can use "switch hand" verb

/obj/item/clothing/accessory_hand/wristwatch/Initialize()
	. = ..()
	if(!can_wear_on_both_hands)
		src.verbs -= /obj/item/clothing/accessory_hand/wristwatch/verb/switch_hand
	origin_sprite = item_state

/obj/item/clothing/accessory_hand/wristwatch/examine(mob/user)
	. = ..()
	to_chat(user, "\the [src] displays [stationtime2text()].")


/obj/item/clothing/accessory_hand/wristwatch/verb/switch_hand()
	set name = "Switch hand"
	set category = "Object"

	if(item_state == origin_sprite)
		item_state = "[item_state]_righthand"
	else
		item_state = origin_sprite

/obj/item/clothing/accessory_hand/wristwatch/gold
	name = "gold watch"
	desc = "A wristwatch. This one is golden and in makes you feel like a boss."
	icon_state = "watch_gold"
	item_state = "watch_gold"

/obj/item/clothing/accessory_hand/wristwatch/saare
	name = "SAARE \"Casio\" watch"
	desc = "A wristwatch. This one has label \"Casio\" and \"For real operatives\"."
	icon_state = "watch_saare"
	item_state = "watch_saare"
