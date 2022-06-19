// "Useful" items - I'm guessing things that might be used at work?
/datum/gear/utility
	sort_category = "Utilidad"
	category = /datum/gear/utility

/datum/gear/utility/briefcase
	display_name = "maletin"
	path = /obj/item/storage/briefcase

/datum/gear/utility/clipboard
	display_name = "portapapeles"
	path = /obj/item/material/clipboard

/datum/gear/utility/folder
	display_name = "carpetas"
	path = /obj/item/folder

/datum/gear/utility/taperecorder
	display_name = "grabadora"
	path = /obj/item/device/taperecorder

/datum/gear/utility/folder/New()
	..()
	var/folders = list()
	folders["carpeta azul"] = /obj/item/folder/blue
	folders["carpeta gris"] = /obj/item/folder
	folders["carpeta roja"] = /obj/item/folder/red
	folders["carpeta blanca"] = /obj/item/folder/white
	folders["carpeta amarilla"] = /obj/item/folder/yellow
	gear_tweaks += new/datum/gear_tweak/path(folders)

/datum/gear/utility/paicard
	display_name = "dispositivo personal de IA"
	path = /obj/item/device/paicard

/datum/gear/utility/camera
	display_name = "camara"
	path = /obj/item/device/camera

/datum/gear/utility/photo_album
	display_name = "album de fotos"
	path = /obj/item/storage/photo_album

/datum/gear/utility/film_roll
	display_name = "rollo de pelicula"
	path = /obj/item/device/camera_film

/datum/gear/accessory/stethoscope
	display_name = "Estetoscopio (medico)"
	path = /obj/item/clothing/accessory/stethoscope
	cost = 2

/datum/gear/utility/pen
	display_name = "Boligrafo multicolor"
	path = /obj/item/pen/multi
	cost = 2

/datum/gear/utility/fancy
	display_name = "Boligrafo elegante"
	path = /obj/item/pen/fancy
	cost = 2

/datum/gear/utility/hand_labeler
	display_name = "etiquetadora manual"
	path = /obj/item/hand_labeler
	cost = 3

/****************
modular computers
****************/

/datum/gear/utility/cheaptablet
	display_name = "Tablet, barata"
	path = /obj/item/modular_computer/tablet/preset/custom_loadout/cheap
	cost = 3

/datum/gear/utility/normaltablet
	display_name = "tablet, avanzada"
	path = /obj/item/modular_computer/tablet/preset/custom_loadout/advanced
	cost = 4

/datum/gear/utility/customtablet
	display_name = "tablet, custom"
	path = /obj/item/modular_computer/tablet
	cost = 4

/datum/gear/utility/customtablet/New()
	..()
	gear_tweaks += new /datum/gear_tweak/tablet()

/datum/gear/utility/cheaplaptop
	display_name = "laptop, barata"
	path = /obj/item/modular_computer/laptop/preset/custom_loadout/cheap
	cost = 5

/datum/gear/utility/normallaptop
	display_name = "laptop, avanzada"
	path = /obj/item/modular_computer/laptop/preset/custom_loadout/advanced
	cost = 6

/****************
Pouches and kits
****************/

/datum/gear/utility/pencilcase
	display_name = "Estuche"
	path = /obj/item/storage/fancy/pencilcase
	cost = 2
