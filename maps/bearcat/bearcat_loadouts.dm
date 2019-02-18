/datum/gear/utility/guns
	display_name = "guns"
	flags = GEAR_HAS_COLOR_SELECTION
	cost = 4
	sort_category = "Utility"
	path = /obj/item/weapon/gun/projectile/

/datum/gear/utility/guns/New()
	..()
	var/guns = list()
	guns["holdout reolver"] = /obj/item/weapon/gun/projectile/revolver/holdout
	guns["holdout pistol"] = /obj/item/weapon/gun/projectile/pistol/holdout
	guns["pistol"] = /obj/item/weapon/gun/projectile/pistol/sec
	gear_tweaks += new/datum/gear_tweak/path(guns)