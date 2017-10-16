/datum/gear/accessory/dashiki
	display_name = "dashiki selection"
	path = /obj/item/clothing/accessory/dashiki

/datum/gear/accessory/dashiki/New()
	..()
	gear_tweaks += new/datum/gear_tweak/path(/obj/item/clothing/accessory/dashiki)

/datum/gear/accessory/thawb
	display_name = "thawb"
	path = /obj/item/clothing/accessory/thawb

/datum/gear/accessory
	display_name = "scarf"
	path = /obj/item/clothing/accessory/scarf
	slot = slot_tie
	sort_category = "Accessories"

/datum/gear/accessory/hawaii
	display_name = "hawaii shirt"
	path = /obj/item/clothing/accessory/toggleable/hawaii

/datum/gear/accessory/hawaii/New()
	..()
	var/list/shirts = list()
	shirts["blue hawaii shirt"] = /obj/item/clothing/accessory/toggleable/hawaii
	shirts["red hawaii shirt"] = /obj/item/clothing/accessory/toggleable/hawaii/red
	shirts["random colored hawaii shirt"] = /obj/item/clothing/accessory/toggleable/hawaii/random
	gear_tweaks += new/datum/gear_tweak/path(shirts)

/datum/gear/accessory/ethnic
	display_name = "clothing tops (colorable)"
	flags = GEAR_HAS_COLOR_SELECTION
	path = /obj/item/clothing/accessory

/datum/gear/accessory/ethnic/New()
	..()
	var/stuff = list()
	stuff["zhongshan jacket"] = /obj/item/clothing/accessory/toggleable/zhongshan
	stuff["sherwani"] = /obj/item/clothing/accessory/sherwani
	stuff["qipao blouse"] = /obj/item/clothing/accessory/qipao
	stuff["turtleneck sweater"] = /obj/item/clothing/accessory/sweater
	stuff["tangzhuang jacket"] = /obj/item/clothing/accessory/tangzhuang
	gear_tweaks += new/datum/gear_tweak/path(stuff)

/datum/gear/accessory/holster
	display_name = "holster selection"
	path = /obj/item/clothing/accessory/holster
	cost = 1

/datum/gear/accessory/holster/New()
	..()
	gear_tweaks += new/datum/gear_tweak/path(/obj/item/clothing/accessory/holster)

/datum/gear/accessory/guns
	display_name = "guns"
	flags = GEAR_HAS_COLOR_SELECTION
	cost = 4
	sort_category = "Utility"
	path = /obj/item/weapon/gun/projectile/

/datum/gear/accessory/guns/New()
	..()
	var/guns = list()
	guns["holdout"] = /obj/item/weapon/gun/projectile/pistol
	guns[".45 gun"] = /obj/item/weapon/gun/projectile/sec
	gear_tweaks += new/datum/gear_tweak/path(guns)