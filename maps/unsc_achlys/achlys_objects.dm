/obj/item/weapon/storage/box/flares
	name = "box of flares"
	icon_state = "flashbang"
	max_storage_space = 4
	w_class = 1
	startswith = list(/obj/item/device/flashlight/flare/unsc = 4)

/obj/item/device/flashlight/flare/unsc
	brightness_on = 4 //halved normal flare light

/obj/item/weapon/storage/belt/utility/marine_engineer
	can_hold = list(/obj/item/weapon/weldingtool,/obj/item/weapon/crowbar,/obj/item/device/analyzer,/obj/item/ammo_magazine,/obj/item/ammo_box,/obj/item/weapon/grenade/frag/m9_hedp,/obj/item/weapon/grenade/smokebomb,/obj/item/weapon/grenade/chem_grenade/incendiary,/obj/item/weapon/armor_patch)

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
	/obj/item/weapon/armor_patch = 3,
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

/obj/structure/navconsole
	name = "Navagation Console"
	desc = "A robust system with it's own power supply that holds nav data on it's hard drive. This includes the location of the planet Earth."
	icon = 'code/modules/halo/overmap/nav_computer.dmi'
	icon_state = "nav_computer"
	light_range = 1
	light_color = "#ebf7fe"
	density = 1
	anchored = 1

/obj/item/weapon/reference
	name = "gold coin"
	desc = "This coin isn't as soft as normal gold, and seems to be an improper size. Clearly a fraud."
	icon = 'icons/obj/items.dmi'
	icon_state = "coin_gold"

/obj/item/weapon/research //the red herring
	name = "research documents"
	desc = "Random useless papers documenting some kind of nerd experiments."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "envelope_sealed"

/obj/item/weapon/research/sekrits //the mcguffin
	name = "strange documents"
	desc = "This folder is sealed shut and coated in way too many warnings. Definitely not safe to open."

/obj/item/weapon/card/id/the_gold
	name = "Gold Keycard"
	desc = "This keycard appears to belong to the captain. How it got here and where it's owner is remains unknown."
	access = list(777)
	icon_state = "gold"
	item_state = "gold_id"

/obj/item/weapon/card/id/the_silver
	name = "Silver Keycard"
	desc = "This silver keycard seems to belong to someone important. How it got here and who it belongs to is a mystery."
	access = list(666)
	icon_state = "silver"
	item_state = "silver_id"