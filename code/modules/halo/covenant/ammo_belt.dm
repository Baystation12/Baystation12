
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
		/obj/item/weapon/melee/energy/elite_sword,\
		/obj/item/clothing/gloves/shield_gauntlet,\
		/obj/item/weapon/armor_patch/cov,\
		/obj/item/weapon/plastique/covenant,\
		/obj/item/weapon/tank/emergency/oxygen/covenant)

/obj/item/weapon/storage/belt/covenant_medic
	name = "Covenant Medical Belt"

	desc = "A belt with many holders for medical kits, with a few small ammunition pouches"
	icon = 'tools.dmi'
	item_state = "securitybelt"
	color = "#ff99ff"
	w_class = ITEM_SIZE_HUGE
	sprite_sheets = list(
		"Tvaoan Kig-Yar" = null,\
		"Sangheili" = null\
		)

	can_hold = list(/obj/item/weapon/storage/firstaid/unsc,\
	/obj/item/weapon/storage/firstaid/erk,\
	/obj/item/weapon/storage/firstaid/combat/unsc,\
	/obj/item/projectile/bullet/covenant/needles)

/obj/item/clothing/accessory/storage/bandolier/covenant
	name = "Covenant Bandolier"
	desc = "A lightweight synthetic bandolier made by the covenant to carry small items"
	icon = 'tools.dmi'
	icon_state = "covbandolier"

/obj/item/clothing/accessory/storage/bandolier/covenant/New()
	. = ..()
	hold.can_hold = list(
		/obj/item/ammo_casing,
		/obj/item/weapon/material/hatchet/tacknife,
		/obj/item/weapon/material/kitchen/utensil/knife,
		/obj/item/weapon/material/knife,
		/obj/item/weapon/material/star,
		/obj/item/weapon/rcd_ammo,
		/obj/item/weapon/reagent_containers/syringe,
		/obj/item/weapon/reagent_containers/hypospray,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector,
		/obj/item/weapon/syringe_cartridge,
		/obj/item/weapon/plastique,
		/obj/item/clothing/mask/smokable,
		/obj/item/weapon/screwdriver,
		/obj/item/device/multitool,
		/obj/item/weapon/magnetic_ammo,
		/obj/item/ammo_magazine
	)

//Exactly the same as the human variant, but cannont hold Grenades. This may be changed once plasma grenades are less insta-kill.