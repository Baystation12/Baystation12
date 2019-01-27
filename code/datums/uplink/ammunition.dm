/*************
* Ammunition *
*************/
/datum/uplink_item/item/ammo
	item_cost = 4
	category = /datum/uplink_category/ammunition

/datum/uplink_item/item/ammo/holdout
	name = "Holdout Pistol Magazine"
	item_cost = 3
	path = /obj/item/ammo_magazine/pistol/small

/datum/uplink_item/item/ammo/darts
	name = "Darts"
	path = /obj/item/ammo_magazine/chemdart

/datum/uplink_item/item/ammo/speedloader
	name = "Revolver Speedloader"
	item_cost = 8
	path = /obj/item/ammo_magazine/speedloader

/datum/uplink_item/item/ammo/rifle
	name = "Assault Rifle Magazine"
	item_cost = 8
	path = /obj/item/ammo_magazine/rifle

/datum/uplink_item/item/ammo/sniperammo
	name = "Sniper Shells"
	item_cost = 8
	path = /obj/item/weapon/storage/box/sniperammo

/datum/uplink_item/item/ammo/sniperammo/apds
	name = "Sniper APDS Shells"
	item_cost = 12
	path = /obj/item/weapon/storage/box/sniperammo/apds

/datum/uplink_item/item/ammo/shotgun_shells
	name = "Shotgun Shells box"
	item_cost = 8
	path = /obj/item/weapon/storage/box/shotgunshells

/datum/uplink_item/item/ammo/shotgun_slugs
	name = "Shotgun Slugs box"
	item_cost = 8
	path = /obj/item/weapon/storage/box/shotgunammo

/datum/uplink_item/item/ammo/machine_pistol
	name = "Machine Pistol Magazine"
	item_cost = 8
	path = /obj/item/ammo_magazine/machine_pistol

/datum/uplink_item/item/ammo/smg
	name = "SMG Magazine"
	item_cost = 8
	path = /obj/item/ammo_magazine/smg

/datum/uplink_item/item/ammo/pistol
	name = "Pistol Magazine"
	item_cost = 6
	path = /obj/item/ammo_magazine/pistol

/datum/uplink_item/item/ammo/magnum
	name = "Magnum Magazine"
	item_cost = 8
	path = /obj/item/ammo_magazine/magnum

/datum/uplink_item/item/ammo/speedloader_magnum
	name = "Magnum Speedloader"
	item_cost = 8
	path = /obj/item/ammo_magazine/speedloader/magnum

/datum/uplink_item/item/ammo/flechette
	name = "Flechette Rifle Magazine"
	item_cost = 8
	path = /obj/item/weapon/magnetic_ammo

/datum/uplink_item/item/ammo/pistol_emp
	name = "Pistol EMP Ammmo Box (10 rounds)"
	item_cost = 6
	path = /obj/item/ammo_magazine/box/emp/pistol

/datum/uplink_item/item/ammo/holdout_emp
	name = "Small Pistol EMP Ammmo Box (10 rounds)"
	desc = "EMP ammo for holdout pistols and revolvers."
	item_cost = 6
	path = /obj/item/ammo_magazine/box/emp/smallpistol