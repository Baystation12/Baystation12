/datum/gear/utility/guns
	display_name = "guns"
	flags = GEAR_HAS_COLOR_SELECTION
	cost = 4
	sort_category = "Utility"
	path = /obj/item/weapon/gun/projectile/

/datum/gear/utility/guns/New()
	..()
	var/guns = list()
	guns["holdout"] = /obj/item/weapon/gun/projectile/pistol
	guns[".45 gun"] = /obj/item/weapon/gun/projectile/sec
	gear_tweaks += new/datum/gear_tweak/path(guns)