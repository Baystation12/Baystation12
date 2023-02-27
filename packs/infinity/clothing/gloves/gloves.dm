/obj/item/clothing/gloves/daft_punk
	name = "Daft Punk gloves"
	desc = "DJs' most comfortable gloves."
	icon = 'packs/infinity/icons/obj/clothing/obj_hands.dmi'
	icon_override = 'packs/infinity/icons/mob/onmob/onmob_hands.dmi'
	icon_state = "daft_gloves"
	item_state = null

/obj/item/clothing/gloves/wristwatch
	name = "watch"
	desc = "A wristwatch. This one is silver and EMP-resistance."
	icon = 'packs/infinity/icons/obj/clothing/obj_hands.dmi'
	item_icons = list(slot_gloves_str = 'packs/infinity/icons/mob/onmob/onmob_hands.dmi')
	icon_state = "watch_black"
	item_state = "watch_black"

/obj/item/clothing/gloves/wristwatch/gold
	name = "gold watch"
	desc = "A wristwatch. This one is golden and in makes you feel like a boss."
	icon_state = "watch_gold"
	item_state = "watch_gold"

/obj/item/clothing/gloves/wristwatch/examine(mob/user)
	. = ..()
	to_chat(user, "It displays " + stationtime2text())
