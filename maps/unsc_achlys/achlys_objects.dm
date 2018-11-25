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

/obj/structure/closet/marine/marine_medic
	name = "combat medic equipment"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/marine/marine_medic/New()
	..()
	new /obj/item/weapon/storage/box/MRE/Chicken(src)
	new /obj/item/weapon/material/knife/combat_knife(src)
	new /obj/item/ammo_magazine/m127_saphp(src)
	new /obj/item/ammo_magazine/m127_saphe(src)
	new /obj/item/weapon/gun/projectile/m6d_magnum(src)
	new /obj/item/ammo_magazine/m5(src)
	new /obj/item/weapon/gun/projectile/m7_smg(src)
	new /obj/item/clothing/head/helmet/marine/medic(src)
	new /obj/item/clothing/mask/marine(src)
	new /obj/item/clothing/glasses/hud/tactical(src)
	new /obj/item/clothing/suit/storage/marine/medic(src)
	new /obj/item/clothing/gloves/thick/unsc(src)
	new /obj/item/clothing/shoes/marine(src)
	new /obj/item/weapon/storage/firstaid/unsc(src)
	new /obj/item/weapon/storage/firstaid/unsc(src)
	new /obj/item/device/flashlight/unsc(src)
	new /obj/item/weapon/storage/belt/marine_medic(src)
	return

/obj/structure/closet/marine/cqc
	name = "CQB equipment"
	icon_state = "red"
	icon_closed = "red"

/obj/structure/closet/marine/cqc/New()
	..()
	new /obj/item/weapon/storage/box/MRE/Pizza(src)
	new /obj/item/weapon/storage/box/flares(src)
	new /obj/item/weapon/material/knife/combat_knife(src)
	new /obj/item/ammo_magazine/m5(src)
	new /obj/item/weapon/gun/projectile/m7_smg(src)
	new /obj/item/weapon/grenade/frag/m9_hedp(src)
	new /obj/item/ammo_box/shotgun/slug(src)
	new /obj/item/ammo_box/shotgun(src)
	new /obj/item/weapon/gun/projectile/shotgun/pump/m90_ts(src)
	new /obj/item/clothing/head/helmet/marine/visor(src)
	new /obj/item/clothing/mask/marine(src)
	new /obj/item/clothing/glasses/hud/tactical(src)
	new /obj/item/clothing/suit/storage/marine(src)
	new /obj/item/clothing/gloves/thick/unsc(src)
	new /obj/item/clothing/shoes/marine(src)
	new /obj/item/weapon/storage/belt/marine_ammo(src)
	return

/obj/structure/closet/marine/engineer
	name = "combat engineer equipment"
	icon_state = "orange"
	icon_closed = "orange"

/obj/structure/closet/marine/engineer/New()
	..()
	new /obj/item/weapon/storage/box/MRE/Chicken(src)
	new /obj/item/weapon/material/knife/combat_knife(src)
	new /obj/item/ammo_magazine/m127_saphp(src)
	new /obj/item/ammo_magazine/m127_saphe(src)
	new /obj/item/weapon/gun/projectile/m6d_magnum(src)
	new /obj/item/ammo_magazine/m762_ap/MA5B(src)
	new /obj/item/weapon/gun/projectile/ma5b_ar(src)
	new /obj/item/clothing/head/helmet/marine/visor(src)
	new /obj/item/clothing/mask/marine(src)
	new /obj/item/clothing/glasses/welding(src)
	new /obj/item/clothing/glasses/hud/tactical(src)
	new /obj/item/clothing/suit/storage/marine(src)
	new /obj/item/clothing/gloves/thick/unsc(src)
	new /obj/item/clothing/shoes/marine(src)
	new /obj/item/weapon/storage/belt/utility/marine_engineer(src)
	return

/obj/structure/closet/marine/rifleman
	name = "standard rifleman equipment"
	icon_state = "green"
	icon_closed = "green"

/obj/structure/closet/marine/rifleman/New()
	..()
	new /obj/item/weapon/storage/box/MRE/Spaghetti(src)
	new /obj/item/weapon/storage/box/flares(src)
	new /obj/item/weapon/storage/box/flares(src)
	new /obj/item/weapon/material/knife/combat_knife(src)
	new /obj/item/ammo_magazine/m127_saphe(src)
	new /obj/item/weapon/gun/projectile/m6d_magnum(src)
	new /obj/item/ammo_magazine/m762_ap/MA5B(src)
	new /obj/item/ammo_magazine/m762_ap/MA5B(src)
	new /obj/item/weapon/gun/projectile/ma5b_ar(src)
	new /obj/item/weapon/grenade/frag/m9_hedp(src)
	new /obj/item/clothing/head/helmet/marine(src)
	new /obj/item/clothing/mask/marine(src)
	new /obj/item/clothing/glasses/hud/tactical(src)
	new /obj/item/clothing/suit/storage/marine(src)
	new /obj/item/clothing/gloves/thick/unsc(src)
	new /obj/item/clothing/shoes/marine(src)
	new /obj/item/weapon/storage/belt/marine_ammo(src)
	return

/obj/structure/closet/secure_closet/marine_squad_leader
	name = "squad leader equipment"
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_broken = "secbroken"
	icon_off = "secoff"
	req_access = list(103)

/obj/structure/closet/secure_closet/marine_squad_leader/New()
	..()
	new /obj/item/weapon/storage/box/MRE/Spaghetti(src)
	new /obj/item/weapon/storage/box/flares(src)
	new /obj/item/weapon/material/knife/combat_knife(src)
	new /obj/item/ammo_magazine/m127_saphe(src)
	new /obj/item/weapon/gun/projectile/m6d_magnum(src)
	new /obj/item/ammo_magazine/m762_ap/MA5B(src)
	new /obj/item/weapon/gun/projectile/ma5b_ar(src)
	new /obj/item/device/taperecorder(src)
	new /obj/item/squad_manager(src)
	new /obj/item/clothing/head/helmet/marine(src)
	new /obj/item/clothing/mask/marine(src)
	new /obj/item/clothing/glasses/hud/tactical(src)
	new /obj/item/clothing/suit/storage/marine(src)
	new /obj/item/clothing/gloves/thick/unsc(src)
	new /obj/item/clothing/shoes/marine(src)
	new /obj/item/weapon/storage/belt/marine_ammo(src)
	return