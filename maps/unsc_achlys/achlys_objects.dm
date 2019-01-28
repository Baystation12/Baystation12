/obj/item/weapon/storage/box/flares
	name = "box of flares"
	icon_state = "flashbang"
	max_storage_space = 4
	w_class = 1
	startswith = list(/obj/item/device/flashlight/flare/unsc = 4)

/obj/item/device/flashlight/flare/unsc
	brightness_on = 4 //halved normal flare light

/obj/item/weapon/storage/belt/utility/marine_engineer
	can_hold = list(/obj/item/weapon/weldingtool,/obj/item/weapon/crowbar,/obj/item/device/analyzer,/obj/item/ammo_magazine,/obj/item/ammo_box,/obj/item/weapon/grenade/frag/m9_hedp,/obj/item/weapon/grenade/smokebomb,/obj/item/weapon/grenade/chem_grenade/incendiary)

/obj/item/weapon/storage/belt/utility/marine_engineer/New()
	..()
	new /obj/item/weapon/weldingtool(src)
	new /obj/item/weapon/crowbar/red(src)
	new /obj/item/device/analyzer(src)
	return

/obj/structure/closet/crate/marine/marine_medic
	name = "combat medic equipment"
	desc = "Has everything but spare blood bags."
	icon_state = "o2crate"
	icon_opened = "o2crateopen"
	icon_closed = "o2crate"

/obj/structure/closet/crate/marine/marine_medic/WillContain()
	return list(
	/obj/item/weapon/storage/box/MRE/Chicken = 1,
	/obj/item/weapon/material/knife/combat_knife = 1,
	/obj/item/ammo_magazine/m127_saphp = 2,
	/obj/item/weapon/gun/projectile/m6d_magnum = 1,
	/obj/item/ammo_magazine/m5 = 1,
	/obj/item/weapon/gun/projectile/m7_smg = 1,
	/obj/item/clothing/head/helmet/marine/medic = 1,
	/obj/item/clothing/mask/marine = 1,
	/obj/item/clothing/glasses/hud/tactical = 1,
	/obj/item/clothing/suit/storage/marine/medic = 1,
	/obj/item/clothing/gloves/thick/unsc = 1,
	/obj/item/clothing/shoes/marine = 1,
	/obj/item/weapon/storage/firstaid/unsc = 2,
	/obj/item/device/flashlight/unsc = 1,
	/obj/item/weapon/storage/belt/marine_medic = 1)

/obj/structure/closet/crate/marine/cqc
	name = "CQB equipment"
	desc = "Perfect for being up close and personal."
	icon_state = "secgearcrate"
	icon_opened = "secgearcrateopen"
	icon_closed = "secgearcrate"

/obj/structure/closet/crate/marine/cqc/WillContain()
	return list(
	/obj/item/weapon/storage/box/MRE/Pizza = 1,
	/obj/item/weapon/storage/box/flares = 1,
	/obj/item/weapon/material/knife/combat_knife = 1,
	/obj/item/ammo_magazine/m5 = 1,
	/obj/item/weapon/gun/projectile/m7_smg = 1,
	/obj/item/weapon/grenade/frag/m9_hedp = 1,
	/obj/item/ammo_box/shotgun/slug = 1,
	/obj/item/ammo_box/shotgun = 1,
	/obj/item/weapon/gun/projectile/shotgun/pump/m90_ts = 1,
	/obj/item/clothing/head/helmet/marine/visor = 1,
	/obj/item/clothing/mask/marine = 1,
	/obj/item/clothing/glasses/hud/tactical = 1,
	/obj/item/clothing/suit/storage/marine = 1,
	/obj/item/clothing/gloves/thick/unsc = 1,
	/obj/item/clothing/shoes/marine = 1,
	/obj/item/weapon/storage/belt/marine_ammo = 1)

/obj/structure/closet/crate/marine/engineer
	name = "combat engineer equipment"
	desc = "Engineer gear."
	icon_state = "secgearcrate"
	icon_opened = "secgearcrateopen"
	icon_closed = "secgearcrate"

/obj/structure/closet/crate/marine/engineer/WillContain()
	return list(
	/obj/item/weapon/storage/box/MRE/Chicken = 1,
	/obj/item/weapon/material/knife/combat_knife = 1,
	/obj/item/ammo_magazine/m127_saphe = 2,
	/obj/item/weapon/gun/projectile/m6d_magnum = 1,
	/obj/item/ammo_magazine/m762_ap/MA5B = 1,
	/obj/item/weapon/gun/projectile/ma5b_ar = 1,
	/obj/item/clothing/head/helmet/marine/visor = 1,
	/obj/item/clothing/mask/marine = 1,
	/obj/item/clothing/glasses/welding = 1,
	/obj/item/clothing/glasses/hud/tactical = 1,
	/obj/item/clothing/suit/storage/marine = 1,
	/obj/item/clothing/gloves/thick/unsc = 1,
	/obj/item/clothing/shoes/marine = 1,
	/obj/item/weapon/storage/belt/utility/marine_engineer = 1)

/obj/structure/closet/crate/marine/rifleman
	name = "standard rifleman equipment"
	desc = "Standard groundpounder gear."
	icon_state = "secgearcrate"
	icon_opened = "secgearcrateopen"
	icon_closed = "secgearcrate"

/obj/structure/closet/crate/marine/rifleman/WillContain()
	return list(
	/obj/item/weapon/storage/box/MRE/Spaghetti = 1,
	/obj/item/weapon/storage/box/flares = 2,
	/obj/item/weapon/material/knife/combat_knife = 1,
	/obj/item/ammo_magazine/m127_saphe = 1,
	/obj/item/weapon/gun/projectile/m6d_magnum = 1,
	/obj/item/ammo_magazine/m762_ap/MA5B = 2,
	/obj/item/weapon/gun/projectile/ma5b_ar = 1,
	/obj/item/weapon/grenade/frag/m9_hedp = 1,
	/obj/item/clothing/head/helmet/marine = 1,
	/obj/item/clothing/mask/marine = 1,
	/obj/item/clothing/glasses/hud/tactical = 1,
	/obj/item/clothing/suit/storage/marine = 1,
	/obj/item/clothing/gloves/thick/unsc = 1,
	/obj/item/clothing/shoes/marine = 1,
	/obj/item/weapon/storage/belt/marine_ammo = 1)

/obj/structure/closet/crate/secure/marine_squad_leader
	name = "squad leader equipment"
	desc = "Will only open to a Squad Leader."
	icon_state = "weaponcrate"
	icon_opened = "weaponcrateopen"
	icon_closed = "weaponcrate"
	req_access = list(143)

/obj/structure/closet/crate/secure/marine_squad_leader/WillContain()
	return list(
	/obj/item/weapon/storage/box/MRE/Spaghetti = 1,
	/obj/item/weapon/storage/box/flares = 1,
	/obj/item/weapon/material/knife/combat_knife = 1,
	/obj/item/ammo_magazine/m127_saphe = 1,
	/obj/item/weapon/gun/projectile/m6d_magnum = 1,
	/obj/item/ammo_magazine/m762_ap/MA5B = 1,
	/obj/item/weapon/gun/projectile/ma5b_ar = 1,
	/obj/item/device/taperecorder = 1,
	/obj/item/squad_manager = 1,
	/obj/item/clothing/head/helmet/marine = 1,
	/obj/item/clothing/mask/marine = 1,
	/obj/item/clothing/glasses/hud/tactical = 1,
	/obj/item/clothing/suit/storage/marine = 1,
	/obj/item/clothing/gloves/thick/unsc = 1,
	/obj/item/clothing/shoes/marine = 1,
	/obj/item/weapon/storage/belt/marine_ammo = 1)

/obj/machinery/vending/armory/achlys
	name = "Gear Vendor"
	desc = "A hastily stocked machine that takes a special card to access the inventory of."
	icon_state ="ironhammer"
	icon_deny = "ironhammer-deny"
	premium = list(/obj/structure/closet/crate/marine/rifleman = 10,
					/obj/structure/closet/crate/marine/cqc = 3,
					/obj/structure/closet/crate/marine/engineer = 1,
					/obj/structure/closet/crate/marine/marine_medic = 2,
					/obj/structure/closet/crate/secure/marine_squad_leader = 1) //there should only be 2 of these on the map so do multiplication

/obj/item/weapon/coin/gear_req
	name = "Requisition Card"
	desc = "Inserted into the Gear Vendor to get a loadout."
	icon = 'code/modules/halo/icons/objs/(Placeholder)card.dmi'
	icon_state = "id"
	item_state = "card-id"
	sides = 0

/obj/item/weapon/coin/gear_req/attack_self(mob/user as mob)
	return 0

/obj/machinery/vending/armory/attachment/achlys
	req_access = list(143)