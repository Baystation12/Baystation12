
/obj/item/weapon/storage/belt/covenant_ammo
	name = "Covenant martial belt"
	desc = "A belt with many various pouches to hold ammunition and weaponry"
	icon = 'tools.dmi'
	item_state = "securitybelt"
	color = "#ff99ff"
	sprite_sheets = list(
		"Tvaoan Kig-Yar" = null,\
		"Sangheili" = null\
		)

	can_hold = list(/obj/item/ammo_magazine,\
		/obj/item/ammo_box,\
		/obj/item/ammo_casing,\
		/obj/item/weapon/grenade,\
		/obj/item/weapon/melee/energy/elite_sword,\
		/obj/item/clothing/gloves/shield_gauntlet)
