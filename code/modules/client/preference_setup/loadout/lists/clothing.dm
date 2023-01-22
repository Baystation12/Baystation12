
/datum/gear/clothing
	sort_category = "Clothing Pieces"
	category = /datum/gear/clothing
	slot = slot_tie

/datum/gear/clothing/flannel
	display_name = "flannel (colorable)"
	path = /obj/item/clothing/accessory/flannel
	slot = slot_tie
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/clothing/scarf
	display_name = "scarf"
	path = /obj/item/clothing/accessory/scarf
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/clothing/hawaii
	display_name = "hawaii shirt"
	path = /obj/item/clothing/accessory/toggleable/hawaii

/datum/gear/clothing/hawaii/New()
	..()
	var/list/shirts = list()
	shirts["blue hawaii shirt"] = /obj/item/clothing/accessory/toggleable/hawaii
	shirts["red hawaii shirt"] = /obj/item/clothing/accessory/toggleable/hawaii/red
	shirts["random colored hawaii shirt"] = /obj/item/clothing/accessory/toggleable/hawaii/random
	gear_tweaks += new/datum/gear_tweak/path(shirts)

/datum/gear/clothing/vest
	display_name = "suit vest, colour select"
	path = /obj/item/clothing/accessory/toggleable/suit_vest
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/clothing/suspenders
	display_name = "suspenders"
	path = /obj/item/clothing/accessory/suspenders

/datum/gear/clothing/suspenders/colorable
	display_name = "suspenders, colour select"
	path = /obj/item/clothing/accessory/suspenders/colorable
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/clothing/wcoat
	display_name = "waistcoat, colour select"
	path = /obj/item/clothing/accessory/waistcoat
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/clothing/zhongshan
	display_name = "zhongshan jacket, colour select"
	path = /obj/item/clothing/accessory/toggleable/zhongshan
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/clothing/dashiki
	display_name = "dashiki selection"
	path = /obj/item/clothing/accessory/dashiki
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/clothing/thawb
	display_name = "thawb"
	path = /obj/item/clothing/accessory/thawb

/datum/gear/clothing/sherwani
	display_name = "sherwani, colour select"
	path = /obj/item/clothing/accessory/sherwani
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/clothing/qipao
	display_name = "qipao blouse, colour select"
	path = /obj/item/clothing/accessory/qipao
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/clothing/sweater
	display_name = "turtleneck sweater, colour select"
	path = /obj/item/clothing/accessory/sweater
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/clothing/tangzhuang
	display_name = "tangzhuang jacket, colour select"
	path = /obj/item/clothing/accessory/tangzhuang
	flags = GEAR_HAS_COLOR_SELECTION
