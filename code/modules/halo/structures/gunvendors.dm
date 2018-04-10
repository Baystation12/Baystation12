
/obj/machinery/vending/armory
	icon = 'code/modules/halo/icons/machinery/gunvend.dmi'

/obj/machinery/vending/armory/attackby(var/atom/A,var/mob/user)
	if(A in products)
		products[A] = products[A] + 1
	return ..()

/obj/machinery/vending/armory/hybrid // Both ammo, and guns!
	name = "UNSC Weapon and Ammunition Rack"
	desc = "Storage for basic weapons and ammunition"
	icon_state ="ironhammer" // SPRITES
	icon_deny = "ironhammer-deny"
	req_access = list(308)
	products = list(/obj/item/ammo_magazine/m127_saphe =20,/obj/item/ammo_magazine/m127_saphp =20,/obj/item/ammo_magazine/m762_ap/MA5B = 40,/obj/item/ammo_magazine/m762_ap/MA5B/TTR = 15,/obj/item/ammo_magazine/m762_ap/M392 = 30
					,/obj/item/ammo_magazine/m95_sap = 20,/obj/item/ammo_magazine/m5 = 20,/obj/item/ammo_box/shotgun = 10,/obj/item/ammo_box/shotgun/slug = 10,/obj/item/weapon/material/knife/combat_knife =15
					,/obj/item/weapon/gun/projectile/m6d_magnum = 15,/obj/item/weapon/gun/projectile/ma5b_ar = 15,/obj/item/weapon/gun/projectile/br85 = 2
					,/obj/item/weapon/gun/projectile/shotgun/pump/m90_ts = 8,/obj/item/weapon/gun/projectile/m7_smg = 8,/obj/item/weapon/gun/projectile/m392_dmr = 5,/obj/item/weapon/grenade/frag/m9_hedp = 5,/obj/item/weapon/grenade/smokebomb = 5 )

/obj/machinery/vending/armory/heavy // HEAVY WEAPONS
	name = "UNSC Heavy Weapons Rack"
	desc = "Storage for advanced weapons and ammunition"
	icon_state = "ironhammer" //SPRITES
	icon_deny = "ironhammer-deny"
	req_access = list(308)
	products = list(/obj/item/ammo_magazine/m145_ap = 2,/obj/item/ammo_magazine/a762_box_ap = 5,/obj/item/weapon/gun/projectile/m739_lmg = 2
	,/obj/item/weapon/gun/projectile/srs99_sniper = 1, /obj/item/weapon/gun/launcher/rocket/m41_ssr = 1, /obj/item/ammo_casing/rocket = 4,/obj/item/weapon/plastique = 2)

/obj/machinery/vending/armory/police
	name = "Shell Vendor"
	desc = "A locker for different kinds of shotgun shells."
	icon_state ="ironhammer" // SPRITES
	icon_deny = "ironhammer-deny"
	vend_delay = 6
	products = list(/obj/item/ammo_box/shotgun = 4, /obj/item/ammo_box/shotgun/slug = 4,/obj/item/ammo_box/shotgun/emp = 2
					,/obj/item/ammo_box/shotgun/beanbag = 6, /obj/item/ammo_box/shotgun/flash = 6, /obj/item/ammo_box/shotgun/practice = 4)

/obj/machinery/vending/armory/armor
	name = "Armor Vendor"
	desc = "A machine full of spare UNSC armor."
	icon_state ="ironhammer"
	icon_deny = "ironhammer-deny"
	products = list(/obj/item/clothing/under/unsc/marine_fatigues = 12,/obj/item/clothing/head/helmet/marine = 8,/obj/item/clothing/head/helmet/marine/visor = 8,/obj/item/clothing/suit/storage/marine = 5,/obj/item/clothing/shoes/marine = 8,/obj/item/clothing/mask/marine = 5, /obj/item/weapon/storage/belt/marine_ammo = 8)

/obj/machinery/vending/armory/attachment
	name = "Attachment Vendor"
	desc = "A vendor full of attachments for the MA5B."
	icon_state ="ironhammer"
	icon_deny = "ironhammer-deny"
	req_access = list(308)
	products = list(/obj/item/weapon_attachment/sight/acog = 2, /obj/item/weapon_attachment/sight/rds = 6, /obj/item/weapon_attachment/stock/ma5b = 10, /obj/item/weapon_attachment/stock/skeletal = 8)