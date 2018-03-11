
/obj/machinery/vending/armory/attackby(var/atom/A,var/mob/user)
	if(A in products)
		products[A] = products[A] + 1
	return ..()

/obj/machinery/vending/armory/hybrid // Both ammo, and guns!
	name = "UNSC Weapon and Ammunition Rack"
	desc = "Storage for basic weapons and ammunition"
	icon = 'code/modules/halo/icons/machinery/gunvend.dmi'
	icon_state ="ironhammer" // SPRITES
	icon_deny = "ironhammer-deny"
	req_access = list(308)
	products = list(/obj/item/ammo_magazine/m127_saphe =20,/obj/item/ammo_magazine/m127_saphp =20,/obj/item/ammo_magazine/m762_ap/MA5B =20,/obj/item/ammo_magazine/m762_ap/M392,/obj/item/ammo_magazine/m762_ap =20
					,/obj/item/ammo_magazine/m95_sap = 20,/obj/item/ammo_magazine/m5 = 20,/obj/item/ammo_box/shotgun = 10,/obj/item/ammo_box/shotgun/slug = 10,/obj/item/weapon/melee/combat_knife =15
					,/obj/item/weapon/gun/projectile/m6d_magnum = 5,/obj/item/weapon/gun/projectile/ma5b_ar = 10,/obj/item/weapon/gun/projectile/br85 = 10
					,/obj/item/weapon/gun/projectile/shotgun/pump/m90_ts = 10,/obj/item/weapon/gun/projectile/m7_smg = 15,/obj/item/weapon/gun/projectile/m392_dmr = 10,/obj/item/weapon/grenade/frag/m9_hedp = 5,/obj/item/weapon/grenade/smokebomb = 5 )

/obj/machinery/vending/armory/heavy // HEAVY WEAPONS
	name = "UNSC Heavy Weapons Rack"
	desc = "Storage for advanced weapons and ammunition"
	icon = 'code/modules/halo/icons/machinery/gunvend.dmi'
	icon_state = "ironhammer" //SPRITES
	icon_deny = "ironhammer-deny"
	req_access = list(308)
	products = list(/obj/item/ammo_magazine/m145_ap = 2,/obj/item/ammo_magazine/a762_box_ap = 10,/obj/item/weapon/gun/projectile/m739_lmg = 2
	,/obj/item/weapon/gun/projectile/srs99_sniper = 1, /obj/item/weapon/gun/launcher/rocket/m41_ssr = 2, /obj/item/ammo_casing/rocket = 6)

/obj/machinery/vending/armory/police
	name = "Shell Vendor"
	desc = "A locker for different kinds of shotgun shells."
	icon = 'code/modules/halo/icons/machinery/gunvend.dmi'
	icon_state ="ironhammer" // SPRITES
	icon_deny = "ironhammer-deny"
	vend_delay = 6
	products = list(/obj/item/ammo_box/shotgun = 4, /obj/item/ammo_box/shotgun/slug = 4,/obj/item/ammo_box/shotgun/emp = 2
					,/obj/item/ammo_box/shotgun/beanbag = 6, /obj/item/ammo_box/shotgun/flash = 6, /obj/item/ammo_box/shotgun/practice = 4)