
/obj/machinery/vending/armory/hybrid // Both ammo, and guns!
	name = "UNSC Weapon and Ammunition Rack"
	desc = "Storage for basic weapons and ammunition"
	icon = 'code/modules/halo/gunvend.dmi'
	icon_state ="ironhammer" // SPRITES
	icon_deny = "ironhammer-deny"
	req_access = list(access_unsc_marine)
	products = list(/obj/item/ammo_magazine/m127_saphe =20,/obj/item/ammo_magazine/m127_saphp =20,/obj/item/ammo_magazine/m762_ap =20
					,/obj/item/ammo_magazine/m95_sap = 20,/obj/item/ammo_magazine/m5 = 20,/obj/item/weapon/melee/combat_knife =15
					,/obj/item/weapon/gun/projectile/m6d_magnum = 5,/obj/item/weapon/gun/projectile/ma5b_ar =10,/obj/item/weapon/gun/projectile/br55 = 10
					,/obj/item/weapon/gun/projectile/shotgun/pump/m90_ts = 10,/obj/item/weapon/gun/projectile/m7_smg = 15,/obj/item/weapon/gun/projectile/m392_dmr = 10 )

/obj/machinery/vending/armory/heavy // HEAVY WEAPONS
	name = "UNSC Heavy Weapons Rack"
	desc = "Storage for advanced weapons and ammunition"
	icon = 'code/modules/halo/gunvend.dmi'
	icon_state = "ironhammer" //SPRITES
	icon_deny = "ironhammer-deny"
	req_access = list(access_unsc_armoury)
	products = list(/obj/item/ammo_magazine/m145_ap = 10,/obj/item/ammo_magazine/a762_box_ap = 10,/obj/item/weapon/gun/projectile/m739_lmg = 5
	,/obj/item/weapon/gun/projectile/srs99_sniper = 5)
