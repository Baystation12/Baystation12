
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
		/obj/item/weapon/melee/blamite,\
		/obj/item/weapon/melee/energy/elite_sword,\
		/obj/item/clothing/gloves/shield_gauntlet,\
		/obj/item/weapon/armor_patch,\
		/obj/item/weapon/plastique,\
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
	storage_slots = 5

	can_hold = list(/obj/item/weapon/storage/firstaid/unsc,\
	/obj/item/weapon/storage/firstaid/erk,\
	/obj/item/weapon/storage/firstaid/combat/unsc,\
	/obj/item/projectile/bullet/covenant/needles,
	/obj/item/device/healthanalyzer,
	/obj/item/weapon/reagent_containers/dropper,
	/obj/item/weapon/reagent_containers/glass/beaker,
	/obj/item/weapon/reagent_containers/glass/bottle,
	/obj/item/weapon/reagent_containers/syringe,
	/obj/item/weapon/flame/lighter/zippo,
	/obj/item/weapon/storage/fancy/cigarettes,
	/obj/item/weapon/storage/pill_bottle,
	/obj/item/stack/medical,
	/obj/item/device/flashlight/pen,
	/obj/item/clothing/mask/surgical,
	/obj/item/clothing/head/surgery,
	/obj/item/clothing/gloves/latex,
	/obj/item/weapon/reagent_containers/hypospray,
	/obj/item/clothing/glasses/hud/health
	)

/obj/item/clothing/accessory/storage/bandolier/covenant
	name = "Covenant Bandolier"
	desc = "A lightweight synthetic bandolier made by the covenant to carry small items"
	icon = 'tools.dmi'
	icon_state = "covbandolier"
//Exactly the same as the human variant, but cannont hold Grenades. This may be changed once plasma grenades are less insta-kill.