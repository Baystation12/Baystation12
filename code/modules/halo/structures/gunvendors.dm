
/obj/machinery/vending/armory
	icon = 'code/modules/halo/icons/machinery/gunvend.dmi'
	icon_state ="ironhammer"
	icon_deny = "ironhammer-deny"
	ai_access_level = 3
	nohack = 1

/obj/machinery/vending/armory/attackby(var/atom/A,var/mob/user)
	if(A in products)
		products[A] = products[A] + 1
	else
		return ..()

/obj/machinery/vending/armory/hybrid // Both ammo, and guns!
	name = "UNSC Weapon and Ammunition Rack"
	desc = "Storage for basic weapons and ammunition"
	req_access = list(access_unsc_armoury)
	products = list(/obj/item/ammo_magazine/m127_saphe =20,
					/obj/item/ammo_magazine/m127_saphp =20,
					/obj/item/ammo_magazine/m762_ap/MA5B = 40,
					/obj/item/ammo_magazine/m762_ap/MA5B/TTR = 15,
					/obj/item/ammo_magazine/m762_ap/M392 = 30,
					/obj/item/ammo_magazine/m95_sap/br55 = 20,
					/obj/item/ammo_magazine/m5 = 20,
					/obj/item/ammo_magazine/m5/rubber = 10,
					/obj/item/ammo_box/shotgun = 10,
					/obj/item/ammo_box/shotgun/slug = 10,
					/obj/item/ammo_box/shotgun/beanbag = 10,
					/obj/item/weapon/material/knife/combat_knife =15,
					/obj/item/weapon/material/machete = 2,
					/obj/item/weapon/gun/projectile/m6d_magnum = 15,
					/obj/item/weapon/gun/projectile/ma5b_ar = 15,
					/obj/item/weapon/gun/projectile/br55 = 2,
					/obj/item/weapon/gun/projectile/shotgun/pump/m90_ts = 8,
					/obj/item/weapon/gun/projectile/m7_smg = 8,
					/obj/item/weapon/gun/projectile/m392_dmr = 5,
					/obj/item/weapon/grenade/frag/m9_hedp = 5,
					/obj/item/weapon/grenade/smokebomb = 5,
					/obj/item/weapon/armor_patch = 5,
					/obj/item/drop_pod_beacon = 1)

/obj/machinery/vending/armory/heavy // HEAVY WEAPONS
	name = "UNSC Heavy Weapons Rack"
	desc = "Storage for advanced weapons and ammunition"
	req_access = list(access_unsc_armoury, access_unsc_specialist)
	products = list(/obj/item/ammo_magazine/m145_ap = 4,
					/obj/item/ammo_magazine/a762_box_ap = 6,
					/obj/item/weapon/gun/projectile/m739_lmg = 1,
					/obj/item/weapon/gun/projectile/srs99_sniper = 1,
					/obj/item/weapon/gun/projectile/m41 = 1,
					/obj/item/weapon/storage/box/spnkr = 2,
					/obj/item/turret_deploy_kit/HMG = 1,
					/obj/item/turret_deploy_kit/chaingun = 1,
					/obj/item/weapon/plastique = 6,
					/obj/item/weapon/armor_patch = 2)

/obj/machinery/vending/armory/police
	name = "Shell Vendor"
	desc = "A locker for different kinds of shotgun shells."
	vend_delay = 6
	products = list(/obj/item/ammo_box/shotgun = 4,
					/obj/item/ammo_box/shotgun/slug = 4,
					/obj/item/ammo_box/shotgun/beanbag = 6,
					/obj/item/ammo_box/shotgun/flash = 6,
					/obj/item/ammo_box/shotgun/practice = 4)

/obj/machinery/vending/armory/armor
	name = "UNSC Armor Vendor"
	desc = "A machine full of spare UNSC armor and equipment"
	req_access = list(access_unsc_marine)
	products = list(/obj/item/clothing/under/unsc/marine_fatigues = 12,
					/obj/item/clothing/head/helmet/marine = 8,
					/obj/item/clothing/head/helmet/marine/brown = 8,
					/obj/item/clothing/head/helmet/marine/medic = 6,
					/obj/item/clothing/head/helmet/marine/medic/brown = 6,
					/obj/item/clothing/head/helmet/marine/medic/visor = 6,
					/obj/item/clothing/head/helmet/marine/medic/brownvisor = 6,
					/obj/item/clothing/head/helmet/marine/visor = 8,
					/obj/item/clothing/head/helmet/marine/brownvisor = 8,
					/obj/item/clothing/suit/storage/marine = 5,
					/obj/item/clothing/suit/storage/marine/brown = 5,
					/obj/item/clothing/suit/storage/marine/medic = 3,
					/obj/item/clothing/suit/storage/marine/medic/brown = 3,
					/obj/item/clothing/shoes/marine = 8,
					/obj/item/clothing/shoes/marine/brown = 8,
					/obj/item/clothing/mask/marine = 5,
					/obj/item/clothing/suit/spaceeva/eva = 3,
					/obj/item/clothing/head/helmet/eva/marine = 3,
					/obj/item/clothing/shoes/magboots/eva/marine = 3,
					/obj/item/weapon/storage/belt/marine_ammo = 8,
					/obj/item/weapon/storage/belt/marine_medic = 8,
					/obj/item/weapon/storage/belt/utility/full = 8,
					/obj/item/clothing/gloves/thick/unsc = 8,
					/obj/item/clothing/gloves/thick/unsc/brown = 8,
					/obj/item/weapon/armor_patch = 10,
					/obj/item/clothing/accessory/storage/bandolier = 15,
					/obj/item/weapon/storage/backpack/marine = 6,
					/obj/item/weapon/storage/backpack/marine/brown = 6,
					/obj/item/flight_item/bullfrog_pack = 1)

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

/obj/machinery/vending/armory/attachment/soe
	name = "SOE Attachments Vendor"
	desc = "A vendor full? of attachments *the rest is scratched off*."
	product_ads = "ME WANT ATTACHMENTS!"
	req_access = list(access_soe)
	products = list(/obj/item/weapon_attachment/barrel/suppressor = 5,
					/obj/item/weapon_attachment/light/flashlight = 5,
					/obj/item/weapon_attachment/vertical_grip = 5,
					/obj/item/weapon_attachment/sight/rds = 5,
					/obj/item/weapon_attachment/secondary_weapon/underslung_shotgun_soe = 5,
					/obj/item/weapon_attachment/sight/acog = 5,
					/obj/item/weapon_attachment/secondary_weapon/underslung_grenadelauncher = 2,
					/obj/item/ammo_casing/g40mm = 12,
					/obj/item/ammo_casing/g40mm/he = 8,
					/obj/item/ammo_casing/g40mm/frag = 8,
					/obj/item/ammo_casing/g40mm/smoke = 8,
					/obj/item/ammo_casing/g40mm/illumination = 8)

/obj/machinery/vending/armory/odstvend
	name = "Armtech 5530 Weaponry"
	desc = "Cold, dark, and slightly depressed. Basically an ODST in vending machine form."
	product_ads = "Life is woe;Suspect, Investigate, Terminate;CAUTION SHIP SELF DESTRUCT ACTIVATED! Just kidding."
	color = COLOR_DARK_GRAY
	req_access = list(access_unsc_odst)
	products = list(/obj/item/weapon/material/knife/combat_knife = 4,
					/obj/item/weapon/material/machete = 2,
					/obj/item/weapon/gun/projectile/ma5b_ar = 10,
					/obj/item/weapon/gun/projectile/m7_smg/silenced = 5,
					/obj/item/weapon/gun/projectile/shotgun/pump/m90_ts = 4,
					/obj/item/weapon/gun/projectile/m6c_magnum_s = 6,
					/obj/item/weapon/gun/projectile/ma5b_ar = 10,
					/obj/item/weapon/gun/projectile/m392_dmr = 2,
					/obj/item/weapon/gun/projectile/br55 = 2,
					/obj/item/ammo_magazine/m762_ap/MA5B = 40,
					/obj/item/ammo_magazine/m127_saphe = 16,
					/obj/item/ammo_magazine/m127_saphp = 16,
					/obj/item/ammo_magazine/m5 = 24,
					/obj/item/ammo_magazine/m95_sap/br55 = 10,
					/obj/item/ammo_magazine/m762_ap/M392 = 16,
					/obj/item/ammo_box/shotgun = 10,
					/obj/item/ammo_box/shotgun/slug = 10,
					/obj/item/weapon/grenade/smokebomb = 8,
					/obj/item/weapon/grenade/frag/m9_hedp = 8)

/obj/machinery/vending/armory/odstvend/armour
	name = "Armtech 5530 Gear"
	products = list(/obj/item/clothing/head/helmet/odst/rifleman = 2,
					/obj/item/clothing/suit/armor/special/odst = 2,
					/obj/item/weapon/storage/backpack/odst/regular = 1,
					/obj/item/clothing/head/helmet/odst/engineer = 1,
					/obj/item/clothing/suit/armor/special/odst/engineer = 1,
					/obj/item/weapon/storage/backpack/odst/engineer = 1,
					/obj/item/clothing/head/helmet/odst/cqb = 1,
					/obj/item/clothing/suit/armor/special/odst/cqb = 1,
					/obj/item/weapon/storage/backpack/odst/cqb = 1,
					/obj/item/clothing/head/helmet/odst/medic = 1,
					/obj/item/clothing/suit/armor/special/odst/medic = 1,
					/obj/item/weapon/storage/backpack/odst/medic = 1,
					/obj/item/clothing/head/helmet/odst/squadleader = 1,
					/obj/item/clothing/suit/armor/special/odst/squadleader = 1,
					/obj/item/weapon/storage/backpack/odst/squadlead = 1,
					/obj/item/clothing/head/helmet/odst/sharpshooter = 1,
					/obj/item/clothing/suit/armor/special/odst/sharpshooter = 1,
					/obj/item/weapon/storage/backpack/odst/sharpshooter = 1,
					/obj/item/clothing/gloves/thick/combat = 4,
					/obj/item/weapon/storage/belt/marine_ammo = 4,
					/obj/item/weapon/storage/belt/marine_medic = 4,
					/obj/item/clothing/accessory/storage/odst = 4,
					/obj/item/clothing/shoes/magboots/odst = 8,
					/obj/item/weapon/plastique = 9,
					/obj/item/weapon/storage/firstaid/unsc = 6,
					/obj/item/device/binoculars = 4,
					/obj/item/weapon/armor_patch = 8,
					/obj/item/drop_pod_beacon = 3)

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
					/obj/item/ammo_magazine/m127_saphe =20,
					/obj/item/ammo_magazine/m127_saphp =20,
					/obj/item/ammo_magazine/m762_ap/MA5B = 40,
					/obj/item/ammo_box/shotgun = 10,
					/obj/item/ammo_box/shotgun/slug = 10,
					/obj/item/ammo_magazine/a762_box_ap = 16,
					/obj/item/weapon/storage/box/spnkr = 5,
					/obj/item/ammo_magazine/m127_saphe = 16,
					/obj/item/ammo_magazine/m5 = 16,
					/obj/item/ammo_magazine/m762_ap/M392 = 16,
					/obj/item/ammo_magazine/m145_ap = 16,
					/obj/item/ammo_magazine/m95_sap/br55 = 16,
					/obj/item/weapon/grenade/smokebomb = 16,
					/obj/item/weapon/grenade/frag/m9_hedp = 16,
					/obj/item/weapon/armor_patch = 8,
					/obj/item/drop_pod_beacon = 3)

/obj/machinery/vending/armory/commandovend
	name = "Stolen Armtech 5530"
	desc = "An Armtech vendor with damaged fastenings. Many products appear to be missing and have makeshift product names taped over them."
	product_ads = "URF! URF!"
	req_access = list(access_soe)
	products = list(/obj/item/weapon/gun/projectile/heavysniper = 1,
					/obj/item/weapon/gun/projectile/br55 = 2,
					/obj/item/weapon/gun/projectile/m6d_magnum = 2,
					/obj/item/weapon/gun/projectile/m7_smg = 2,
					/obj/item/weapon/gun/projectile/m392_dmr/innie = 2,
					/obj/item/weapon/gun/projectile/shotgun/soe = 2,
					/obj/item/weapon/gun/projectile/m739_lmg/lmg30cal = 1,
					/obj/item/weapon/gun/projectile/ma5b_ar/MA3 = 8,
					/obj/item/ammo_box/heavysniper = 3,
					/obj/item/ammo_magazine/m762_ap/MA3 = 16,
					/obj/item/ammo_magazine/m762_ap/M392/innie = 12,
					/obj/item/ammo_magazine/m95_sap = 10,
					/obj/item/ammo_magazine/m5 = 24,
					/obj/item/ammo_magazine/kv32 = 10,
					/obj/item/ammo_box/shotgun = 10,
					/obj/item/ammo_box/shotgun/slug = 10,
					/obj/item/ammo_magazine/lmg_30cal_box_ap = 6,
					/obj/item/ammo_magazine/m127_saphe =10,
					/obj/item/ammo_magazine/m127_saphp =10,
					/obj/item/weapon/storage/belt/marine_ammo = 4,
					/obj/item/weapon/storage/belt/marine_medic = 4,
					/obj/item/weapon/material/knife/combat_knife = 4,
					/obj/item/weapon/material/machete = 2,
					/obj/item/weapon/plastique = 12,
					/obj/item/weapon/storage/firstaid/unsc = 6,
					/obj/item/device/binoculars = 4,
					/obj/item/weapon/handcuffs/ = 5,
					/obj/item/weapon/grenade/smokebomb = 8,
					/obj/item/device/landmine = 4,
					/obj/item/weapon/grenade/frag/m9_hedp = 4,
					/obj/item/weapon/armor_patch = 4,
					/obj/item/drop_pod_beacon = 1 )

/obj/machinery/vending/armory/commandovend/armour
	products = list(/obj/item/clothing/head/helmet/urfc/engineer = 2,
					/obj/item/weapon/storage/backpack/cmdo/eng = 2,
					/obj/item/clothing/head/helmet/urfc/medic = 2,
					/obj/item/weapon/storage/backpack/cmdo/med = 2,
					/obj/item/clothing/head/helmet/urfc/sniper = 2,
					/obj/item/weapon/storage/backpack/cmdo = 2,
					/obj/item/clothing/head/helmet/urfc/cqb = 2,
					/obj/item/weapon/storage/backpack/cmdo/cqc = 2,
					/obj/item/clothing/head/helmet/urfc/squadleader = 1,
					/obj/item/clothing/suit/armor/special/urfc/squadleader = 1,
					/obj/item/clothing/suit/armor/special/urfc = 8,
					/obj/item/clothing/under/urfc_jumpsuit = 8,
					/obj/item/clothing/under/urfc_jumpsuit/tanktop = 8,
					/obj/item/clothing/under/urfc_jumpsuit/jumpsuit = 8,
					/obj/item/clothing/head/helmet/urfccommander/beretmerc = 7,
					/obj/item/clothing/head/helmet/urfccommander/beretofficer = 7,
					/obj/item/clothing/mask/gas/soebalaclava = 7,
					/obj/item/clothing/mask/gas/soebalaclava/open = 7,
					/obj/item/clothing/gloves/soegloves/urfc = 8,
					/obj/item/clothing/shoes/magboots/urfc = 8,
					/obj/item/weapon/armor_patch = 4,
					/obj/item/clothing/head/helmet/soe = 6,
					/obj/item/clothing/suit/armor/special/soe = 6,
					/obj/item/weapon/tank/jetpack/void/urfc = 6 )

/obj/machinery/vending/armory/medical
	name = "UNSC Medical Vendor"
	desc = "A vendor that supplies medical equipment"
	req_access = list(access_unsc)
	products = list(/obj/item/bodybag/cryobag = 3,
					/obj/item/weapon/storage/firstaid/unsc = 10,
					/obj/item/weapon/reagent_containers/syringe/ld50_syringe/triadrenaline = 10,
					/obj/item/weapon/storage/firstaid/fire = 2,
					/obj/item/weapon/storage/firstaid/o2 = 4,
					/obj/item/weapon/storage/firstaid/toxin = 4,
					/obj/item/weapon/storage/firstaid/erk = 4,
					/obj/item/weapon/storage/firstaid/combat/unsc = 7,
					/obj/item/weapon/storage/firstaid/adv = 7,
					/obj/item/weapon/storage/pill_bottle/bicaridine = 6,
					/obj/item/weapon/storage/pill_bottle/dermaline = 6,
					/obj/item/weapon/storage/pill_bottle/tramadol = 6,
					/obj/item/weapon/storage/pill_bottle/hyronalin = 6,
					/obj/item/weapon/storage/pill_bottle/iron = 6,
					/obj/item/weapon/storage/pill_bottle/dexalin_plus = 6,
					/obj/item/weapon/storage/pill_bottle/inaprovaline = 6,
					/obj/item/weapon/reagent_containers/hypospray = 3)
