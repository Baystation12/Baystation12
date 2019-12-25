// "Useful" items - I'm guessing things that might be used at work?
/datum/gear/utility
	sort_category = "Utility"
	category = /datum/gear/utility

/datum/gear/utility/briefcase
	display_name = "briefcase"
	path = /obj/item/weapon/storage/briefcase

/datum/gear/utility/clipboard
	display_name = "clipboard"
	path = /obj/item/weapon/material/clipboard

/datum/gear/utility/folder
	display_name = "folders"
	path = /obj/item/weapon/folder

/datum/gear/utility/taperecorder
	display_name = "tape recorder"
	path = /obj/item/device/taperecorder

/datum/gear/utility/folder/New()
	..()
	var/folders = list()
	folders["blue folder"] = /obj/item/weapon/folder/blue
	folders["grey folder"] = /obj/item/weapon/folder
	folders["red folder"] = /obj/item/weapon/folder/red
	folders["white folder"] = /obj/item/weapon/folder/white
	folders["yellow folder"] = /obj/item/weapon/folder/yellow
	gear_tweaks += new/datum/gear_tweak/path(folders)

/datum/gear/utility/paicard
	display_name = "personal AI device"
	path = /obj/item/device/paicard

/datum/gear/utility/camera
	display_name = "camera"
	path = /obj/item/device/camera

/datum/gear/utility/photo_album
	display_name = "photo album"
	path = /obj/item/weapon/storage/photo_album

/datum/gear/utility/film_roll
	display_name = "film roll"
	path = /obj/item/device/camera_film

/datum/gear/accessory/stethoscope
	display_name = "stethoscope (medical)"
	path = /obj/item/clothing/accessory/stethoscope
	cost = 2

/datum/gear/utility/pen
	display_name = "Multicolored Pen"
	path = /obj/item/weapon/pen/multi
	cost = 2

/datum/gear/utility/fancy
	display_name = "Fancy Pen"
	path = /obj/item/weapon/pen/fancy
	cost = 2

/datum/gear/utility/hand_labeler
	display_name = "hand labeler"
	path = /obj/item/weapon/hand_labeler
	cost = 3

/****************
modular computers
****************/

/datum/gear/utility/cheaptablet
	display_name = "tablet computer, cheap"
	path = /obj/item/modular_computer/tablet/preset/custom_loadout/cheap
	cost = 3

/datum/gear/utility/normaltablet
	display_name = "tablet computer, advanced"
	path = /obj/item/modular_computer/tablet/preset/custom_loadout/advanced
	cost = 4

/datum/gear/utility/customtablet
	display_name = "tablet computer, custom"
	path = /obj/item/modular_computer/tablet
	cost = 4

/datum/gear/utility/customtablet/New()
	..()
	gear_tweaks += new /datum/gear_tweak/tablet()

/datum/gear/utility/cheaplaptop
	display_name = "laptop computer, cheap"
	path = /obj/item/modular_computer/laptop/preset/custom_loadout/cheap
	cost = 5

/datum/gear/utility/normallaptop
	display_name = "laptop computer, advanced"
	path = /obj/item/modular_computer/laptop/preset/custom_loadout/advanced
	cost = 6
