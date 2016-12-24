// ----- BookHAP RIG MODULE
/obj/item/weapon/rig/ert/assetprotection/book_hap
	name = "advanced heavy asset protection suit control module"
	desc = "A heavier, more modified version of a common asset protection hardsuit. Has blood red highlights. Built like a tank and could go toe to toe with one too."
	suit_type = "advanced heavy asset protection"
	icon_state = "asset_protection_rig"
	armor = list(melee = 65, bullet = 55, laser = 55,energy = 45, bomb = 45, bio = 100, rad = 100)
	cell_type = /obj/item/weapon/cell/hyper

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/mounted/egun,
		/obj/item/rig_module/chem_dispenser/injector,
		/obj/item/rig_module/device/plasmacutter,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/device/healthscanner
		)

// -----BookHAP bandoliers
/obj/item/clothing/accessory/storage/bandolier/book_hap/New()
	..()
	new /obj/item/weapon/plastique(hold)
	new /obj/item/weapon/plastique(hold)
	new /obj/item/weapon/plastique(hold)
	new /obj/item/weapon/grenade/chem_grenade/metalfoam(hold)
	new /obj/item/weapon/grenade/frag/shell(hold)
	new /obj/item/weapon/grenade/chem_grenade/teargas(hold)
	new /obj/item/weapon/grenade/anti_photon(hold)

/obj/item/clothing/accessory/storage/bandolier/book_hap_sniper/New()
	..()
	new /obj/item/ammo_casing/a145(hold)
	new /obj/item/ammo_casing/a145(hold)
	new /obj/item/ammo_casing/a145(hold)
	new /obj/item/ammo_casing/a145(hold)
	new /obj/item/ammo_casing/a145(hold)
	new /obj/item/ammo_casing/a145(hold)
	new /obj/item/ammo_casing/a145(hold)

// -----BookHAP belts
/obj/item/weapon/storage/belt/book_hap_sniper/New()
	..()
	new /obj/item/weapon/gun/projectile/silenced(src)
	new /obj/item/ammo_magazine/c45m(src)
	new /obj/item/ammo_magazine/c45m(src)
	new /obj/item/weapon/storage/box/sniperammo(src)
	new /obj/item/weapon/storage/box/sniperammo(src)
	new /obj/item/weapon/storage/box/sniperammo(src)
	new /obj/item/weapon/storage/box/sniperammo(src)

/obj/item/weapon/storage/belt/book_hap_gunner/New()
	..()
	new /obj/item/weapon/gun/projectile/silenced(src)
	new /obj/item/ammo_magazine/c45m(src)
	new /obj/item/ammo_magazine/c45m(src)
	new /obj/item/ammo_magazine/box/a762(src)
	new /obj/item/ammo_magazine/box/a762(src)
	new /obj/item/ammo_magazine/box/a762(src)
	new /obj/item/ammo_magazine/box/a762(src)

/obj/item/weapon/storage/belt/book_hap_grenadier/New()
	..()
	new /obj/item/weapon/gun/projectile/silenced(src)
	new /obj/item/ammo_magazine/c45m(src)
	new /obj/item/ammo_magazine/c45m(src)
	new /obj/item/ammo_magazine/a556(src)
	new /obj/item/ammo_magazine/a556(src)
	new /obj/item/ammo_magazine/a556(src)
	new /obj/item/ammo_magazine/a556(src)

/obj/item/weapon/storage/belt/book_hap_rifleman/New()
	..()
	new /obj/item/weapon/gun/projectile/silenced(src)
	new /obj/item/ammo_magazine/c45m(src)
	new /obj/item/ammo_magazine/c45m(src)
	new /obj/item/ammo_magazine/c762(src)
	new /obj/item/ammo_magazine/c762(src)
	new /obj/item/ammo_magazine/c762(src)
	new /obj/item/ammo_magazine/c762(src)
