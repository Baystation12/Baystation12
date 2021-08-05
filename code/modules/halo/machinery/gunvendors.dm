
/obj/machinery/vending/armory
	icon = 'code/modules/halo/icons/machinery/gunvend.dmi'
	icon_state ="ironhammer"
	icon_deny = "ironhammer-deny"
	ai_access_level = 3
	nohack = 1

/obj/machinery/pointbased_vending/armory/hybrid // Both ammo, and guns!
	name = "UNSC Equipment Rack"
	desc = "Storage for basic weapons and ammunition, alongside some equipment."
	req_access = list(access_unsc_armoury)
	products = list(
					"Melee" = -1,
					/obj/item/weapon/material/knife/combat_knife = 0,
					/obj/item/weapon/material/machete = 0,
					"Guns" = -1,
					/obj/item/weapon/gun/projectile/m6d_magnum = 0,
					/obj/item/weapon/gun/projectile/m7_smg = 0,
					/obj/item/weapon/gun/projectile/shotgun/pump/m90_ts = 0,
					/obj/item/weapon/gun/projectile/m392_dmr = 0,
					/obj/item/weapon/gun/projectile/ma5b_ar = 0,
					/obj/item/weapon/gun/projectile/br55 = 0,
					"Ammunition" = -1,
					/obj/item/ammo_magazine/m6d/m225 = 0,
					/obj/item/ammo_magazine/ma5b/m118 = 0,
					/obj/item/ammo_magazine/m392/m120 = 0,
					/obj/item/ammo_magazine/br55/m634 = 0,
					/obj/item/ammo_magazine/m7/m443 = 0,
					/obj/item/ammo_magazine/m7/rubber = 0,
					/obj/item/ammo_box/shotgun = 0,
					/obj/item/ammo_box/shotgun/slug = 0,
					/obj/item/ammo_box/shotgun/beanbag = 0,
					"Specialised Ammunition" = -1,
					/obj/item/ammo_magazine/na4_tank = 0,
					"Explosives" = -1,
					/obj/item/weapon/grenade/frag/m9_hedp = 0,
					/obj/item/weapon/grenade/smokebomb = 0,
					/obj/item/weapon/plastique = 0,
					/obj/item/weapon/plastique/breaching = 0,
					/obj/item/weapon/plastique/breaching/longrange = 0,
					"Miscellaneous" = -1,
					/obj/item/weapon/armor_patch = 0,
					/obj/item/weapon/armor_patch/mini = 0,
					/obj/item/drop_pod_beacon = 0
					)
	amounts = list(\
		/obj/item/weapon/grenade/frag/m9_hedp = 15,
		/obj/item/weapon/grenade/smokebomb = 15,
		/obj/item/weapon/plastique = 2,
		/obj/item/weapon/plastique/breaching = 2,
		/obj/item/weapon/plastique/breaching/longrange = 2,
	)

/obj/machinery/pointbased_vending/armory/hybrid/innie
	name = "Insurrectionist Equipment Rack"
	desc = "An equipment rack, obviously stolen from the UNSC or their suppliers."
	req_access = list(access_innie)

/obj/machinery/pointbased_vending/armory/heavy // HEAVY WEAPONS
	name = "UNSC Heavy Weapons Rack"
	desc = "Storage for advanced weapons and ammunition"
	req_access = list(access_unsc_armoury, access_unsc_specialist)
	products = list(
					"Guns" = -1,
					/obj/item/weapon/gun/projectile/m739_lmg = 0,
					/obj/item/weapon/gun/projectile/srs99_sniper = 0,
					/obj/item/weapon/gun/projectile/m41 = 0,
					"Ammunition" = -1,
					/obj/item/ammo_magazine/spnkr = 0,
					/obj/item/ammo_magazine/srs99/m232 = 0,
					/obj/item/ammo_magazine/m739/m118 = 0,
					"Turrets" = -1,
					/obj/item/turret_deploy_kit/HMG = 0,
					"Explosives" = -1,
					/obj/item/weapon/plastique = 0,
					/obj/item/weapon/plastique/breaching = 0,
					/obj/item/weapon/plastique/breaching/longrange = 0
					)
	amounts = list(\
		/obj/item/weapon/gun/projectile/m739_lmg = 3,
		/obj/item/weapon/gun/projectile/srs99_sniper = 3,
		/obj/item/weapon/gun/projectile/m41 = 3,
		/obj/item/turret_deploy_kit/HMG = 2,
		/obj/item/weapon/plastique = 2,
		/obj/item/weapon/plastique/breaching = 2,
		/obj/item/weapon/plastique/breaching/longrange = 2,
	)

/obj/machinery/pointbased_vending/armory/heavy/innie // HEAVY WEAPONS
	name = "Insurrectionist Heavy Weapons Rack"
	desc = "Storage for advanced weapons and ammunition"
	req_access = list(access_innie)
	products = list(
					"Guns" = -1,
					/obj/item/weapon/gun/projectile/m545_lmg  = 0,
					/obj/item/weapon/gun/projectile/heavysniper = 0,
					/obj/item/weapon/gun/projectile/m41 = 0,
					"Ammunition" = -1,
					/obj/item/ammo_magazine/spnkr = 0,
					/obj/item/ammo_box/heavysniper = 0,
					/obj/item/ammo_magazine/m545/m118 = 0,
					"Turrets" = -1,
					/obj/item/turret_deploy_kit/HMG = 0,
					"Explosives" = -1,
					/obj/item/weapon/plastique = 0,
					/obj/item/weapon/plastique/breaching = 0,
					/obj/item/weapon/plastique/breaching/longrange = 0
					)
	amounts = list(\
		/obj/item/weapon/gun/projectile/m545_lmg  = 1,
		/obj/item/weapon/gun/projectile/heavysniper = 1,
		/obj/item/weapon/gun/projectile/m41 = 1,
		/obj/item/turret_deploy_kit/HMG = 2,
		/obj/item/weapon/plastique = 8,
		/obj/item/weapon/plastique/breaching = 2,
		/obj/item/weapon/plastique/breaching/longrange = 2,
	)

/obj/machinery/vending/armory/police
	name = "Shell Vendor"
	desc = "A locker for different kinds of shotgun shells."
	vend_delay = 6
	products = list(/obj/item/ammo_box/shotgun = 4,
					/obj/item/ammo_box/shotgun/slug = 4,
					/obj/item/ammo_box/shotgun/beanbag = 6,
					/obj/item/ammo_box/shotgun/flash = 6,
					/obj/item/ammo_box/shotgun/practice = 4)

/obj/machinery/pointbased_vending/armory/armor
	name = "UNSC Misc Equipment Vendor"
	desc = "A machine full of spare UNSC armor and equipment"
	req_access = list(access_unsc_marine)
	products = list(
					"Undersuits" = -1,
					/obj/item/clothing/under/unsc/marine_fatigues = 0,
					"Armor" = -1,
					/obj/item/weapon/storage/box/large/armorset/green/novisor = 0,
					/obj/item/weapon/storage/box/large/armorset/green/visor = 0,
					/obj/item/weapon/storage/box/large/armorset/brown/novisor = 0,
					/obj/item/weapon/storage/box/large/armorset/brown/visor = 0,
					/obj/item/weapon/storage/box/large/armorset/white = 0,
					/obj/item/weapon/storage/box/large/armorset/medic/green/novisor = 0,
					/obj/item/weapon/storage/box/large/armorset/medic/green/visor = 0,
					/obj/item/weapon/storage/box/large/armorset/medic/brown/novisor = 0,
					/obj/item/weapon/storage/box/large/armorset/medic/brown/visor = 0,
					/obj/item/weapon/storage/box/large/armorset/medic/white = 0,
					/obj/item/weapon/storage/box/large/armorset/eva = 0,
					"Storage" = -1,
					/obj/item/weapon/storage/belt/marine_ammo = 2,
					/obj/item/weapon/storage/belt/marine_medic = 1,
					/obj/item/weapon/storage/belt/utility/full = 0,
					/obj/item/clothing/accessory/storage/IFAK/UNSC = 1,
					/obj/item/clothing/accessory/storage/bandolier = 2,
					/obj/item/weapon/storage/backpack/marine = 3,
					/obj/item/weapon/storage/backpack/marine/brown = 3,
					"Storage - Holsters" = -1,
					/obj/item/clothing/accessory/holster = 1,
					/obj/item/clothing/accessory/holster/armpit = 1,
					/obj/item/clothing/accessory/holster/waist = 1,
					/obj/item/clothing/accessory/holster/hip = 1,
					/obj/item/clothing/accessory/holster/thigh = 1,
					"Storage - Hardcases" = -1,
					/obj/item/weapon/storage/pocketstore/hardcase/magazine = 0,
					/obj/item/weapon/storage/pocketstore/hardcase/bullets = 0,
					/obj/item/weapon/storage/pocketstore/hardcase/grenade = 1,
					/obj/item/weapon/storage/pocketstore/hardcase/armorkits = 0,
					/obj/item/weapon/storage/pocketstore/hardcase/rockets = 1,
					/obj/item/weapon/storage/pocketstore/hardcase/medbottles = 0,
					/obj/item/weapon/storage/pocketstore/hardcase/hypos = 0,
					/obj/item/weapon/storage/pocketstore/hardcase/materials = 0,
					/obj/item/weapon/storage/pocketstore/hardcase/tools = 0,
					"Miscellaneous" = -1,
					/obj/item/flight_item/bullfrog_pack = 0,
					/obj/item/stack/barbedwire/fifteen = 0,
					/obj/item/weapon/armor_patch = 0,
					/obj/item/weapon/storage/firstaid/unsc = 0,
					/obj/item/device/binoculars = 0,
					/obj/item/weapon/armor_patch = 0,
					/obj/item/weapon/armor_patch/mini = 0,
					/obj/item/drop_pod_beacon = 0
					)
	amounts = list(\
		/obj/item/weapon/storage/box/large/armorset/eva = 3,
		/obj/item/clothing/accessory/storage/IFAK/UNSC = 20,
		/obj/item/weapon/storage/firstaid/unsc = 6,
		/obj/item/stack/barbedwire/fifteen = 15,
		/obj/item/flight_item/bullfrog_pack = 1
		)

/obj/machinery/vending/armory/oni
	name = "ONI Vendor"
	desc = "A machine full of spare ONI guard equipment."
	req_access = list(access_unsc_oni)
	products = list(/obj/item/clothing/under/unsc/marine_fatigues/oni_uniform = 12,
					/obj/item/clothing/head/helmet/oni_guard = 8,
					/obj/item/clothing/head/helmet/oni_guard/visor = 8,
					/obj/item/clothing/suit/storage/oni_guard = 5,
					/obj/item/clothing/shoes/oni_guard = 8,
					/obj/item/clothing/mask/marine = 5,
					/obj/item/weapon/storage/belt/marine_ammo/oni = 8,
					/obj/item/clothing/gloves/thick/oni_guard = 8,
					/obj/item/weapon/armor_patch = 10)

/obj/machinery/vending/armory/attachment
	name = "UNSC Attachment Vendor"
	desc = "A vendor full of attachments for the MA5B."
	req_access = list(access_unsc_armoury)
	products = list(/obj/item/weapon_attachment/ma5_stock_butt/extended = 5,
					/obj/item/weapon_attachment/ma5_upper_railed =5,
					/obj/item/weapon_attachment/barrel/suppressor = 5,
					/obj/item/weapon_attachment/sight/acog = 5,
					/obj/item/weapon_attachment/light/flashlight = 5,
					/obj/item/weapon_attachment/secondary_weapon/underslung_shotgun = 2,
					/obj/item/weapon_attachment/barrel/suppressor = 3,
					/obj/item/weapon_attachment/vertical_grip = 5,
					/obj/item/weapon_attachment/secondary_weapon/underslung_grenadelauncher = 2,
					/obj/item/ammo_casing/g40mm = 12,
					/obj/item/ammo_casing/g40mm/he = 8,
					/obj/item/ammo_casing/g40mm/frag = 8,
					/obj/item/ammo_casing/g40mm/smoke = 8,
					/obj/item/ammo_casing/g40mm/illumination = 8)
	//products = list(/obj/item/weapon_attachment/sight/acog = 2, /obj/item/weapon_attachment/sight/rds = 6)

/obj/machinery/vending/armory/attachment/innie
	name = "Insurrectionist Attachment Vendor"
	req_access = list(access_innie)
	products = list(/obj/item/weapon_attachment/ma5_stock_butt/extended = 2,
					/obj/item/weapon_attachment/ma5_upper_railed =2,
					/obj/item/weapon_attachment/barrel/suppressor = 2,
					/obj/item/weapon_attachment/sight/acog = 2,
					/obj/item/weapon_attachment/light/flashlight = 2,
					/obj/item/weapon_attachment/barrel/suppressor = 1,
					/obj/item/weapon_attachment/vertical_grip = 2,
					)

/obj/machinery/vending/armory/attachment/soe
	name = "SOE Attachments Vendor"
	desc = "A vendor full? of attachments *the rest is scratched off*."
	req_access = list(access_soe)
	products = list(/obj/item/weapon_attachment/barrel/suppressor = 5,
					/obj/item/weapon_attachment/light/flashlight = 5,
					/obj/item/weapon_attachment/vertical_grip = 5,
					/obj/item/weapon_attachment/sight/rds = 5,
					/obj/item/weapon_attachment/secondary_weapon/underslung_shotgun_soe = 5,
					/obj/item/weapon_attachment/sight/acog = 5,
					/obj/item/weapon_attachment/secondary_weapon/underslung_grenadelauncher = 1,
					/obj/item/ammo_casing/g40mm = 6,
					/obj/item/ammo_casing/g40mm/he = 4,
					/obj/item/ammo_casing/g40mm/frag = 4,
					/obj/item/ammo_casing/g40mm/smoke = 4,
					/obj/item/ammo_casing/g40mm/illumination = 4)

/obj/machinery/pointbased_vending/armory/odstvend
	name = "Armtech 5530 Weaponry"
	desc = "Cold, dark, and slightly depressed. Basically an ODST in vending machine form."
	color = COLOR_DARK_GRAY
	req_access = list(access_unsc_odst)
	products = list(
					"Melee" = -1,
					/obj/item/weapon/material/knife/combat_knife = 0,
					/obj/item/weapon/material/machete = 0,
					"Guns" = -1,
					/obj/item/weapon/gun/projectile/m6c_magnum_s = 0,
					/obj/item/weapon/gun/projectile/m7_smg/silenced = 0,
					/obj/item/weapon/gun/projectile/shotgun/pump/m90_ts = 0,
					/obj/item/weapon/gun/projectile/m392_dmr = 0,
					/obj/item/weapon/gun/projectile/ma5b_ar = 0,
					/obj/item/weapon/gun/projectile/br55 = 0,
					"Ammunition" = -1,
					/obj/item/ammo_magazine/m6s/m224 = 0,
					/obj/item/ammo_magazine/m6s/m225 = 0,
					/obj/item/ammo_magazine/ma5b/m118 = 0,
					/obj/item/ammo_magazine/m392/m120 = 0,
					/obj/item/ammo_magazine/br55/m634 = 0,
					/obj/item/ammo_magazine/m7/m443/rnd48,
					/obj/item/ammo_box/shotgun = 0,
					/obj/item/ammo_box/shotgun/slug = 0,
					/obj/item/ammo_box/shotgun/beanbag = 0,
					"Explosives" = -1,
					/obj/item/weapon/grenade/frag/m9_hedp = 0,
					/obj/item/weapon/grenade/smokebomb = 0,
					/obj/item/weapon/plastique = 0,
					/obj/item/weapon/plastique/breaching = 0,
					/obj/item/weapon/plastique/breaching/longrange = 0,
					)
	amounts = list(\
	/obj/item/weapon/grenade/frag/m9_hedp = 15,
	/obj/item/weapon/grenade/smokebomb = 15,
	/obj/item/weapon/plastique = 4,
	/obj/item/weapon/plastique/breaching = 2,
	/obj/item/weapon/plastique/breaching/longrange= 2,
	)

/obj/machinery/pointbased_vending/armory/odstvend/armour
	name = "Armtech 5530 Gear"
	products = list(
					"Armor" = -1,
					/obj/item/weapon/storage/box/large/armorset/odst/rifleman = 0,
					/obj/item/weapon/storage/box/large/armorset/odst/cqb = 0,
					/obj/item/weapon/storage/box/large/armorset/odst/sharpshooter = 0,
					/obj/item/weapon/storage/box/large/armorset/odst/medic = 0,
					/obj/item/weapon/storage/box/large/armorset/odst/engineer = 0,
					/obj/item/weapon/storage/box/large/armorset/odst/squadleader = 0,
					"Storage" = -1,
					/obj/item/weapon/storage/belt/marine_ammo = 2,
					/obj/item/weapon/storage/belt/marine_medic = 1,
					/obj/item/weapon/storage/belt/utility/full = 0,
					/obj/item/clothing/accessory/storage/IFAK/UNSC = 1,
					/obj/item/clothing/accessory/storage/bandolier = 2,
					/obj/item/weapon/storage/backpack/odst/regular = 3,
					/obj/item/weapon/storage/backpack/odst/cqb = 3,
					/obj/item/weapon/storage/backpack/odst/sharpshooter = 3,
					/obj/item/weapon/storage/backpack/odst/medic = 3,
					/obj/item/weapon/storage/backpack/odst/engineer = 3,
					/obj/item/weapon/storage/backpack/odst/squadlead = 3,
					"Storage - Holsters" = -1,
					/obj/item/clothing/accessory/holster = 1,
					/obj/item/clothing/accessory/holster/armpit = 1,
					/obj/item/clothing/accessory/holster/waist = 1,
					/obj/item/clothing/accessory/holster/hip = 1,
					/obj/item/clothing/accessory/holster/thigh = 1,
					"Storage - Hardcases" = -1,
					/obj/item/weapon/storage/pocketstore/hardcase/magazine = 0,
					/obj/item/weapon/storage/pocketstore/hardcase/bullets = 0,
					/obj/item/weapon/storage/pocketstore/hardcase/grenade = 1,
					/obj/item/weapon/storage/pocketstore/hardcase/armorkits = 0,
					/obj/item/weapon/storage/pocketstore/hardcase/medbottles = 0,
					/obj/item/weapon/storage/pocketstore/hardcase/hypos = 0,
					/obj/item/weapon/storage/pocketstore/hardcase/materials = 0,
					/obj/item/weapon/storage/pocketstore/hardcase/tools = 0,
					"Miscellaneous" = -1,
					/obj/item/weapon/storage/firstaid/unsc = 0,
					/obj/item/device/binoculars = 0,
					/obj/item/stack/barbedwire/fifteen = 0,
					/obj/item/weapon/armor_patch = 0,
					/obj/item/weapon/armor_patch/mini = 0,
					/obj/item/drop_pod_beacon = 0
					)
	amounts = list(\
					/obj/item/weapon/storage/box/large/armorset/odst/rifleman = 4,
					/obj/item/weapon/storage/box/large/armorset/odst/cqb = 2,
					/obj/item/weapon/storage/box/large/armorset/odst/sharpshooter = 2,
					/obj/item/weapon/storage/box/large/armorset/odst/medic = 2,
					/obj/item/weapon/storage/box/large/armorset/odst/engineer = 2,
					/obj/item/weapon/storage/box/large/armorset/odst/squadleader = 2,
					/obj/item/stack/barbedwire/fifteen = 5,
					/obj/item/clothing/accessory/storage/IFAK/UNSC = 20,
					/obj/item/weapon/storage/firstaid/unsc = 6,
					)

//Don't actually use this. Spartans should be using normal vendors unless being debugged in for admin use.//
/obj/machinery/vending/armory/spartanvend
	name = "Armtech 6500"
	desc  = "A prototype Armtech vendor filled with things... that stop certain super-soldiers from dying.."
	req_access = list(access_spartan)
	color = COLOR_DARK_GRAY
	products = list(/obj/item/clothing/under/spartan_internal = 1,
					/obj/item/clothing/head/helmet/spartan = 1,
					/obj/item/clothing/suit/armor/special/spartan = 1,
					/obj/item/clothing/gloves/spartan = 1,
					/obj/item/clothing/shoes/magboots/spartan = 1,
					/obj/item/clothing/glasses/hud/tactical/odst_hud/medic = 1,
					/obj/item/weapon/storage/backpack/odst/regular = 2,
					/obj/item/weapon/storage/belt/marine_ammo = 2,
					/obj/item/weapon/storage/belt/marine_medic = 2,
					/obj/item/clothing/accessory/storage/odst = 2,
					/obj/item/clothing/accessory/storage/bandolier = 2,
					/obj/item/weapon/material/knife/combat_knife = 1,
					/obj/item/weapon/material/machete = 1,
					/obj/item/weapon/gun/projectile/m739_lmg = 1,
					/obj/item/weapon/gun/projectile/m7_smg/silenced = 4,
					/obj/item/weapon/gun/projectile/shotgun/pump/m90_ts = 4,
					/obj/item/weapon/gun/projectile/m392_dmr = 4,
					/obj/item/weapon/gun/projectile/srs99_sniper = 1,
					/obj/item/weapon/gun/projectile/m41 = 1,
					/obj/item/weapon/gun/projectile/m6d_magnum = 15,
					/obj/item/weapon/gun/projectile/ma5b_ar = 4,
					/obj/item/weapon/gun/projectile/br55 = 4,
					/obj/item/weapon/gun/projectile/m7_smg = 4,
					/obj/item/weapon/plastique = 9,
					/obj/item/weapon/storage/firstaid/unsc = 6,
					/obj/item/device/binoculars = 4,
					/obj/item/ammo_magazine/m6d/m225 =20,
					/obj/item/ammo_magazine/ma5b/m118 = 40,
					/obj/item/ammo_box/shotgun = 10,
					/obj/item/ammo_box/shotgun/slug = 10,
					/obj/item/ammo_magazine/m739/m118 = 16,
					/obj/item/ammo_magazine/spnkr = 10,
					/obj/item/ammo_magazine/m6d/m225 = 16,
					/obj/item/ammo_magazine/m7/m443 = 16,
					/obj/item/ammo_magazine/m392/m120 = 16,
					/obj/item/ammo_magazine/srs99/m232 = 16,
					/obj/item/ammo_magazine/br55/m634 = 16,
					/obj/item/weapon/grenade/smokebomb = 16,
					/obj/item/weapon/grenade/frag/m9_hedp = 16,
					/obj/item/weapon/armor_patch = 8,
					/obj/item/drop_pod_beacon = 3)

/obj/machinery/pointbased_vending/armory/commandovend
	name = "Stolen Armtech 5530"
	desc = "An Armtech vendor with damaged fastenings. Many products appear to be missing and have makeshift product names taped over them."
	req_access = list(access_soe)
	products = list(
					"Melee" = -1,
					/obj/item/weapon/material/knife/combat_knife = 0,
					/obj/item/weapon/material/machete = 0,
					"Guns" = -1,
					/obj/item/weapon/gun/projectile/heavysniper = 0,
					/obj/item/weapon/gun/projectile/br55 = 0,
					/obj/item/weapon/gun/projectile/m6d_magnum = 0,
					/obj/item/weapon/gun/projectile/m7_smg = 0,
					/obj/item/weapon/gun/projectile/m392_dmr/innie = 0,
					/obj/item/weapon/gun/projectile/shotgun/soe = 0,
					/obj/item/weapon/gun/projectile/m545_lmg = 0,
					/obj/item/weapon/gun/projectile/ma3_ar = 0,
					"Ammunition" = -1,
					/obj/item/ammo_box/heavysniper = 0,
					/obj/item/ammo_magazine/ma3/m118 = 0,
					/obj/item/ammo_magazine/m392/m120 = 0,
					/obj/item/ammo_magazine/br55/m634 = 0,
					/obj/item/ammo_magazine/m7/m443 = 0,
					/obj/item/ammo_magazine/kv32 = 0,
					/obj/item/ammo_box/shotgun = 0,
					/obj/item/ammo_box/shotgun/slug = 0,
					/obj/item/ammo_magazine/m545/m118 = 0,
					/obj/item/ammo_magazine/m6d/m225 = 0,
					"Storage" = -1,
					/obj/item/weapon/storage/belt/marine_ammo = 2,
					/obj/item/weapon/storage/belt/marine_medic = 1,
					/obj/item/weapon/storage/belt/utility/full = 0,
					/obj/item/clothing/accessory/storage/IFAK/UNSC = 1,
					/obj/item/clothing/accessory/storage/bandolier = 2,
					/obj/item/weapon/storage/backpack/marine = 3,
					"Storage - Holsters" = -1,
					/obj/item/clothing/accessory/holster = 1,
					/obj/item/clothing/accessory/holster/armpit = 1,
					/obj/item/clothing/accessory/holster/waist = 1,
					/obj/item/clothing/accessory/holster/hip = 1,
					/obj/item/clothing/accessory/holster/thigh = 1,
					"Storage - Hardcases" = -1,
					/obj/item/weapon/storage/pocketstore/hardcase/magazine = 0,
					/obj/item/weapon/storage/pocketstore/hardcase/bullets = 0,
					/obj/item/weapon/storage/pocketstore/hardcase/grenade = 1,
					/obj/item/weapon/storage/pocketstore/hardcase/armorkits = 0,
					/obj/item/weapon/storage/pocketstore/hardcase/medbottles = 0,
					/obj/item/weapon/storage/pocketstore/hardcase/hypos = 0,
					/obj/item/weapon/storage/pocketstore/hardcase/materials = 0,
					/obj/item/weapon/storage/pocketstore/hardcase/tools = 0,
					"Explosives" = -1,
					/obj/item/weapon/plastique = 0,
					/obj/item/weapon/grenade/frag/m9_hedp = 0,
					/obj/item/weapon/storage/firstaid/unsc = 0,
					/obj/item/weapon/grenade/smokebomb = 0,
					/obj/item/device/landmine = 0,
					"Miscellaneous" = -1,
					/obj/item/device/binoculars = 0,
					/obj/item/weapon/handcuffs = 0,
					/obj/item/weapon/armor_patch = 0,
					/obj/item/drop_pod_beacon = 0)
	amounts = list(\
		/obj/item/weapon/gun/projectile/heavysniper = 1,
		/obj/item/weapon/gun/projectile/m545_lmg = 1,
		/obj/item/weapon/plastique = 12,
		/obj/item/weapon/grenade/frag/m9_hedp = 15,
		/obj/item/weapon/grenade/smokebomb = 15,
		/obj/item/weapon/storage/firstaid/unsc = 6,
		/obj/item/device/landmine = 4
		)

/obj/machinery/vending/armory/commandovend/armour
	name = "Stolen Armtech 5530 Armor Variant"
	desc = "An Armtech vendor with damaged fastenings. Many products appear to be missing and have makeshift product names taped over them."
	req_access = list(access_soe)
	products = list(
					"Armor" = -1,
					/obj/item/weapon/storage/box/large/armorset/soe = 4,
					/obj/item/weapon/storage/box/large/armorset/soe/cqb = 2,
					/obj/item/weapon/storage/box/large/armorset/soe/sniper = 2,
					/obj/item/weapon/storage/box/large/armorset/soe/medic = 2,
					/obj/item/weapon/storage/box/large/armorset/soe/engineer = 2,
					/obj/item/weapon/storage/box/large/armorset/soe/squadleader = 1,
					/obj/item/weapon/storage/box/large/armorset/soe/eva = 10,
					/obj/item/weapon/storage/backpack/cmdo/eng = 2,
					/obj/item/weapon/storage/backpack/cmdo/med = 2,
					/obj/item/weapon/storage/backpack/cmdo = 5,
					/obj/item/weapon/storage/backpack/cmdo/cqc = 2,
					"Jumpsuits" = -1,
					/obj/item/clothing/under/urfc_jumpsuit = 8,
					/obj/item/clothing/under/urfc_jumpsuit/tanktop = 8,
					/obj/item/clothing/under/urfc_jumpsuit/jumpsuit = 8,
					"Accessories" = -1,
					/obj/item/clothing/head/helmet/urfccommander/beretmerc = 7,
					/obj/item/clothing/head/helmet/urfccommander/beretofficer = 7,
					/obj/item/clothing/mask/gas/soebalaclava = 7,
					/obj/item/clothing/mask/gas/soebalaclava/open = 7,
					"Miscellaneous" = -1,
					/obj/item/weapon/armor_patch = 4,
					 )

/obj/machinery/pointbased_vending/armory/innie_armor
	name = "Insurrectionist Misc Equipment Vendor"
	desc = "A machine full of spare stolen and cobbled together innie armor and equipment"
	req_access = list(access_innie)
	products = list(
					"Armor" = -1,
					/obj/item/weapon/storage/box/large/armorset/inniearmor = 0,
					/obj/item/weapon/storage/box/large/armorset/inniearmor/black = 0,
					/obj/item/weapon/storage/box/large/armorset/inniearmor/blue = 0,
					/obj/item/weapon/storage/box/large/armorset/inniearmor/white = 0,
					/obj/item/weapon/storage/box/large/armorset/inniearmor/green = 0,
					"Storage" = -1,
					/obj/item/weapon/storage/belt/marine_ammo = 2,
					/obj/item/weapon/storage/belt/marine_medic = 1,
					/obj/item/weapon/storage/belt/utility/full = 0,
					/obj/item/clothing/accessory/storage/IFAK/UNSC = 1,
					/obj/item/clothing/accessory/storage/bandolier = 2,
					/obj/item/weapon/storage/backpack/marine = 3,
					/obj/item/weapon/storage/backpack/marine/brown = 3,
					"Storage - Holsters" = -1,
					/obj/item/clothing/accessory/holster = 1,
					/obj/item/clothing/accessory/holster/armpit = 1,
					/obj/item/clothing/accessory/holster/waist = 1,
					/obj/item/clothing/accessory/holster/hip = 1,
					/obj/item/clothing/accessory/holster/thigh = 1,
					"Storage - Hardcases" = -1,
					/obj/item/weapon/storage/pocketstore/hardcase/magazine = 0,
					/obj/item/weapon/storage/pocketstore/hardcase/bullets = 0,
					/obj/item/weapon/storage/pocketstore/hardcase/grenade = 1,
					/obj/item/weapon/storage/pocketstore/hardcase/armorkits = 0,
					/obj/item/weapon/storage/pocketstore/hardcase/medbottles = 0,
					/obj/item/weapon/storage/pocketstore/hardcase/hypos = 0,
					/obj/item/weapon/storage/pocketstore/hardcase/materials = 0,
					/obj/item/weapon/storage/pocketstore/hardcase/tools = 0,
					"Miscellaneous" = -1,
					/obj/item/flight_item/bullfrog_pack = 0,
					/obj/item/weapon/armor_patch = 0,
					/obj/item/weapon/armor_patch/mini = 0,
					/obj/item/stack/barbedwire/fifteen = 0,
					)
	amounts = list(\
		/obj/item/clothing/accessory/storage/IFAK/UNSC = 20,
		/obj/item/stack/barbedwire/fifteen = 15,
		/obj/item/flight_item/bullfrog_pack = 1,
		)

/obj/machinery/vending/armory/medical
	name = "UNSC Medical Vendor"
	desc = "A vendor that supplies medical equipment"
	req_access = list(access_unsc)
	products = list(
					"Utility" = -1,
					/obj/item/bodybag/cryobag = 3,
					/obj/item/device/healthanalyzer = 10,
					"Medkits" = -1,
					/obj/item/weapon/storage/firstaid/unsc = 10,
					/obj/item/weapon/storage/firstaid/fire = 2,
					/obj/item/weapon/storage/firstaid/o2 = 4,
					/obj/item/weapon/storage/firstaid/toxin = 4,
					/obj/item/weapon/storage/firstaid/erk = 4,
					/obj/item/weapon/storage/firstaid/combat/unsc = 7,
					/obj/item/weapon/storage/firstaid/adv = 7,
					"Pill Bottles" = -1,
					/obj/item/weapon/storage/pill_bottle/bicaridine = 6,
					/obj/item/weapon/storage/pill_bottle/dermaline = 6,
					/obj/item/weapon/storage/pill_bottle/tramadol = 6,
					/obj/item/weapon/storage/pill_bottle/polypseudomorphine = 6,
					/obj/item/weapon/storage/pill_bottle/hyronalin = 6,
					/obj/item/weapon/storage/pill_bottle/iron = 6,
					/obj/item/weapon/storage/pill_bottle/dexalin_plus = 6,
					/obj/item/weapon/storage/pill_bottle/inaprovaline = 6,
					"Injectors" = -1,
					/obj/item/weapon/reagent_containers/hypospray = 3,
					/obj/item/weapon/reagent_containers/syringe/ld50_syringe/triadrenaline = 10,
					/obj/item/weapon/storage/box/syringes = 2,
					)

/obj/machinery/vending/armory/medical/innie
	name = "Insurrectionist Medical Vendor"
	req_access = list(access_innie)
