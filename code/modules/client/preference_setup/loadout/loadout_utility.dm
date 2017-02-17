// "Useful" items - I'm guessing things that might be used at work?
/datum/gear/utility
	display_name = "briefcase"
	path = /obj/item/weapon/storage/briefcase
	sort_category = "Utility"

/datum/gear/utility/waistpack
	display_name = "waist pack"
	path = /obj/item/weapon/storage/belt/waistpack
	slot = slot_belt
	cost = 2
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/utility/waistpack/big
	display_name = "large waist pack"
	path = /obj/item/weapon/storage/belt/waistpack/big
	cost = 4

/datum/gear/utility/clipboard
	display_name = "clipboard"
	path = /obj/item/weapon/clipboard

/datum/gear/utility/folder
	display_name = "folders"
	path = /obj/item/weapon/folder

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

/****************
modular computers
****************/

/datum/gear/utility/cheaptablet
	display_name = "tablet computer: cheap"
	path = /obj/item/modular_computer/tablet/preset/custom_loadout/cheap
	cost = 3

/datum/gear/utility/normaltablet
	display_name = "tablet computer: advanced"
	path = /obj/item/modular_computer/tablet/preset/custom_loadout/advanced
	cost = 4

/datum/gear/utility/customtablet
	display_name = "tablet computer: custom"
	path = /obj/item/modular_computer/tablet
	cost = 4

/datum/gear/utility/customtablet/New()
	..()
	gear_tweaks += new /datum/gear_tweak/modular_computer/tablet()


/datum/gear/utility/customlaptop
	display_name = "laptop computer: custom"
	path = /obj/item/modular_computer/laptop/
	cost = 6

/datum/gear/utility/customlaptop/New()
	..()
	gear_tweaks += new /datum/gear_tweak/modular_computer/laptop()
