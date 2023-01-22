/*************
* Ammunition *
*************/
/datum/uplink_item/item/ammo
	item_cost = 4
	category = /datum/uplink_category/ammunition

/datum/uplink_item/item/ammo/holdout
	name = "Small Magazine"
	desc = "A magazine for small pistols. Contains 8 rounds."
	item_cost = 3
	path = /obj/item/ammo_magazine/pistol/small

/datum/uplink_item/item/ammo/empslug
	name = "Haywire Slug"
	desc = "Single 12-gauge shotgun slug fitted with a single-use ion pulse generator."
	item_cost = 1
	path = /obj/item/ammo_casing/shotgun/emp

/datum/uplink_item/item/ammo/holdout_speedloader
	name = "Small Speedloader"
	desc = "A speedloader for small revolvers. Contains 6 rounds."
	item_cost = 3
	path = /obj/item/ammo_magazine/speedloader/small

/datum/uplink_item/item/ammo/darts
	name = "Dart Cartridge"
	desc = "A small cartridge for a gas-powered dart gun. Contains 5 hollow darts."
	path = /obj/item/ammo_magazine/chemdart

/datum/uplink_item/item/ammo/speedloader
	name = "Standard Speedloader"
	desc = "A speedloader for standard revolvers. Contains 6 rounds."
	item_cost = 6
	path = /obj/item/ammo_magazine/speedloader

/datum/uplink_item/item/ammo/rifle
	name = "Rifle Magazine"
	desc = "A magazine for assault rifles. Contains 20 rounds."
	item_cost = 8
	path = /obj/item/ammo_magazine/rifle

/datum/uplink_item/item/ammo/bullpup //for zipguns
	name = "Bullpup Rifle Magazine"
	desc = "A magazine for bullpup assault rifles. Contains 15 rounds."
	item_cost = 8
	path = /obj/item/ammo_magazine/mil_rifle

/datum/uplink_item/item/ammo/sniperammo
	name = "Ammobox of Sniper Rounds"
	desc = "A container of rounds for the anti-materiel rifle. Contains 7 rounds."
	item_cost = 8
	path = /obj/item/storage/box/ammo/sniperammo
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/item/ammo/sniperammo/apds
	name = "Ammobox of APDS Sniper Rounds"
	desc = "A container of armor piercing rounds for the anti-materiel rifle. Contains 3 rounds."
	item_cost = 12
	path = /obj/item/storage/box/ammo/sniperammo/apds
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/item/ammo/shotgun_shells
	name = "Ammobox of Shotgun Shells"
	desc = "An ammobox with 2 sets of shell holders. Contains 8 buckshot shells total."
	item_cost = 8
	path = /obj/item/storage/box/ammo/shotgunshells

/datum/uplink_item/item/ammo/flechette_shells
	name = "Ammobox of Flechette Shells"
	desc = "An ammobox with 2 sets of shell holders. Contains 8 extra accurate flechette shells."
	item_cost = 12
	path = /obj/item/storage/box/ammo/flechetteshells
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/item/ammo/shotgun_slugs
	name = "Ammobox of Shotgun Slugs"
	desc = "An ammobox with 2 sets of shell holders. Contains 8 slugs total."
	item_cost = 8
	path = /obj/item/storage/box/ammo/shotgunammo

/datum/uplink_item/item/ammo/machine_pistol
	name = "Standard Stick Magazine"
	desc = "A magazine for standard machine pistols. Contains 16 rounds."
	item_cost = 8
	path = /obj/item/ammo_magazine/machine_pistol

/datum/uplink_item/item/ammo/smg
	name = "Standard Box Magazine"
	desc = "A magazine for standard SMGs. Contains 20 rounds."
	item_cost = 8
	path = /obj/item/ammo_magazine/smg
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/item/ammo/pistol
	name = "Standard Doublestack Magazine"
	desc = "A magazine for standard military pistols. Contains 15 rounds."
	item_cost = 9
	path = /obj/item/ammo_magazine/pistol/double

/datum/uplink_item/item/ammo/magnum
	name = "Magnum Magazine"
	desc = "A magazine for magnum pistols. Contains 7 rounds."
	item_cost = 8
	path = /obj/item/ammo_magazine/magnum

/datum/uplink_item/item/ammo/speedloader_magnum
	name = "Magnum Speedloader"
	desc = "A speedloader for magnum revolvers. Contains 6 rounds."
	item_cost = 8
	path = /obj/item/ammo_magazine/speedloader/magnum

/datum/uplink_item/item/ammo/flechette
	name = "Flechette Rifle Magazine"
	desc = "A  rifle magazine loaded with flechette rounds. Contains 9 rounds."
	item_cost = 8
	path = /obj/item/magnetic_ammo
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/item/ammo/pistol_emp
	name = "Standard EMP Ammo Box"
	desc = "A box of EMP ammo for standard pistols. Contains 15 rounds."
	item_cost = 8
	path = /obj/item/ammo_magazine/box/emp/pistol

/datum/uplink_item/item/ammo/holdout_emp
	name = "Small EMP Ammo Box"
	desc = "A box of EMP ammo for small pistols and revolvers. Contains 8 rounds."
	item_cost = 6
	path = /obj/item/ammo_magazine/box/emp/smallpistol

/datum/uplink_item/item/ammo/stripperclip
	name = "Stripper Clip"
	desc = "A stripper clip used to load bolt action rifles. Contains just 5 rounds."
	item_cost = 2
	path = /obj/item/ammo_magazine/speedloader/clip
