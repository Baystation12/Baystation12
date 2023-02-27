/obj/item/clothing/accessory/storage/bandolier/armory/Initialize()
	. = ..()

	for(var/i = 0, i < slots, i++)
		new /obj/item/ammo_casing/shotgun/pellet(src)

//Sprites from tgstation, specially for Parasoul's custom-item
/obj/item/clothing/accessory/necklace/talisman
	name = "bone talisman"
	desc = "A hunter's talisman, some say the old gods smile on those who wear it."
	icon = CUSTOM_ITEM_OBJ
	accessory_icons = list(slot_w_uniform_str = CUSTOM_ITEM_MOB, slot_wear_suit_str = CUSTOM_ITEM_MOB)
	item_icons = list(slot_wear_mask_str = 'packs/infinity/icons/mob/onmob/onmob_accessories.dmi')
	icon_state = "talisman-4"

/obj/item/clothing/accessory/scarf/inf
	name = "red striped scarf"
	icon = 'packs/infinity/icons/obj/clothing/obj_accessories.dmi'
	icon_state = "stripedredscarf"
	accessory_icons = list(slot_w_uniform_str = 'packs/infinity/icons/mob/onmob/onmob_accessories.dmi', slot_wear_suit_str = 'packs/infinity/icons/mob/onmob/onmob_accessories.dmi')
	item_icons = list(slot_wear_mask_str = 'packs/infinity/icons/mob/onmob/onmob_accessories.dmi')

/obj/item/clothing/accessory/scarf/inf/green
	name = "green striped scarf"
	icon_state = "stripedgreenscarf"

/obj/item/clothing/accessory/scarf/inf/blue
	name = "blue striped scarf"
	icon_state = "stripedbluescarf"

/obj/item/clothing/accessory/scarf/inf/zebra
	name = "zebra scarf"
	icon_state = "zebrascarf"

/obj/item/clothing/accessory/scarf/inf/christmas
	name = "christmas scarf"
	icon_state = "christmasscarf"
