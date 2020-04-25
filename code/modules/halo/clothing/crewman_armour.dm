
/obj/item/clothing/head/helmet/crewman
	name = "Crewman Helmet"
	desc = "A helmet worn by crewmen when comfort is required over protection"
	armor = list(melee = 30, bullet = 30, laser = 30,energy = 20, bomb = 25, bio = 0, rad = 0)
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "helmet"
	item_icons = list("slot_l_hand"='icons/mob/items/lefthand_hats.dmi',"slot_r_hand"='icons/mob/items/righthand_hats.dmi')
	item_state_slots = list("slot_l_hand" = "helmet","slot_r_hand" = "helmet")

/obj/item/clothing/suit/storage/marine/crewman
	name = "Crewman Armour"
	desc = "Light armour worn by crewmen for protection against a variety of damage sources."
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 30, bullet = 40, laser = 40, energy = 40, bomb = 40, bio = 20, rad = 20)
	armor_thickness = 20
	icon = 'icons/obj/clothing/suits.dmi'
	icon_state = "bulletproofvest"
	item_state = null
	icon_override = null

/obj/item/clothing/shoes/marine/crewman
	name = "Crewman Shoes"
	desc = "Armored jackboots worn by crewmen when comfort is required over protection"
	body_parts_covered = FEET
	armor = list(melee = 35, bullet = 35, laser = 5, energy = 25, bomb = 15, bio = 0, rad = 0)
	armor_thickness = 20
	icon = 'icons/obj/clothing/shoes.dmi'
	icon_state = "jackboots"
	item_state = "jackboots"
	icon_override = null

/obj/item/clothing/gloves/thick/unsc/crewman
	name = "Crewman's Armoured Gloves"
	desc = "Gloves used by crewmen when comfort is required over protection."
	body_parts_covered = HANDS
