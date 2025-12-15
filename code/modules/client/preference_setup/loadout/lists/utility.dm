// "Useful" items - I'm guessing things that might be used at work?
/datum/gear/utility
	sort_category = "Utility"
	category = /datum/gear/utility

/datum/gear/utility/briefcase
	display_name = "briefcase"
	path = /obj/item/storage/briefcase

/datum/gear/utility/clipboard
	display_name = "clipboards"
	path = /obj/item/material/folder/clipboard

/datum/gear/utility/clipboard/New()
	..()
	var/clipboards = list()
	clipboards["wooden clipboard"] = /obj/item/material/folder/clipboard
	clipboards["plastic clipboard"] = /obj/item/material/folder/clipboard/plastic
	clipboards["aluminium clipboard"] = /obj/item/material/folder/clipboard/aluminium
	clipboards["glass clipboard"] = /obj/item/material/folder/clipboard/glass
	clipboards["ebony clipboard"] = /obj/item/material/folder/clipboard/ebony
	gear_tweaks += new/datum/gear_tweak/path(clipboards)

/datum/gear/utility/folder
	display_name = "folders"
	path = /obj/item/material/folder

/datum/gear/utility/folder/New()
	..()
	var/folders = list()
	folders["blue folder"] = /obj/item/material/folder/blue
	folders["grey folder"] = /obj/item/material/folder
	folders["red folder"] = /obj/item/material/folder/red
	folders["white folder"] = /obj/item/material/folder/white
	folders["yellow folder"] = /obj/item/material/folder/yellow
	gear_tweaks += new/datum/gear_tweak/path(folders)

/datum/gear/utility/taperecorder
	display_name = "tape recorder"
	path = /obj/item/device/taperecorder

/datum/gear/utility/paicard
	display_name = "personal AI device"
	path = /obj/item/device/paicard

/datum/gear/utility/camera
	display_name = "camera"
	path = /obj/item/device/camera

/datum/gear/utility/photo_album
	display_name = "photo album"
	path = /obj/item/storage/photo_album

/datum/gear/utility/film_roll
	display_name = "film roll"
	path = /obj/item/device/camera_film

/datum/gear/accessory/stethoscope
	display_name = "stethoscope (medical)"
	path = /obj/item/clothing/accessory/stethoscope
	cost = 2

/datum/gear/utility/pen
	display_name = "pens"
	path = /obj/item/pen

/datum/gear/utility/pen/New()
	..()
	var/pens = list()
	pens["black pen"] = /obj/item/pen
	pens["red pen"] = /obj/item/pen/red
	pens["blue pen"] = /obj/item/pen/blue
	pens["green pen"] = /obj/item/pen/green
	pens["fancy pen"] = /obj/item/pen/fancy
	pens["multicolored pen"] = /obj/item/pen/multi
	gear_tweaks += new/datum/gear_tweak/path(pens)

/datum/gear/utility/hand_labeler
	display_name = "hand labeler"
	path = /obj/item/hand_labeler
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

/****************
Pouches and kits
****************/

/datum/gear/utility/pencilcase
	display_name = "pencil case"
	path = /obj/item/storage/fancy/pencilcase
	cost = 2

/datum/gear/utility/pyx
	display_name = "pyx"
	path = /obj/item/storage/fancy/pyx
	cost = 2
	allowed_roles = list(/datum/job/chaplain)

/****************
Instruments
****************/

/datum/gear/utility/musical_instruments
	display_name = "musical instruments"
	path = /obj/item/device/synthesized_instrument
	cost = 6

/datum/gear/utility/musical_instruments/New()
	..()
	var/musical_instruments = list()
	musical_instruments["acoustic guitar"] = /obj/item/device/synthesized_instrument/guitar
	musical_instruments["polyguitar flying V"] = /obj/item/device/synthesized_instrument/guitar/multi_v
	musical_instruments["polyguitar strato black"] = /obj/item/device/synthesized_instrument/guitar/multi_strato_black
	musical_instruments["polyguitar strato gradient"] = /obj/item/device/synthesized_instrument/guitar/multi_strato_gradient
	musical_instruments["polyguitar strato red"] = /obj/item/device/synthesized_instrument/guitar/multi_strato_red
	musical_instruments["polyguitar strato purple"] = /obj/item/device/synthesized_instrument/guitar/multi_strato_purple
	musical_instruments["synthesizer"] = /obj/item/device/synthesized_instrument/synthesizer
	musical_instruments["trumpet"] = /obj/item/device/synthesized_instrument/trumpet
	musical_instruments["violin"] = /obj/item/device/synthesized_instrument/violin
	gear_tweaks += new/datum/gear_tweak/path(musical_instruments)

/datum/gear/utility/stellascope
	display_name = "stellascope"
	path = /obj/item/holosign_creator/stellascope
	cost = 4
