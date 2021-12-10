// "Useful" items - I'm guessing things that might be used at work?
/datum/gear/utility
	sort_category = "Utility"
	category = /datum/gear/utility

/datum/gear/utility/briefcase
	display_name = "briefcase"
	path = /obj/item/storage/briefcase

/datum/gear/utility/clipboard
	display_name = "clipboard"
	path = /obj/item/material/clipboard

/datum/gear/utility/folder
	display_name = "folders"
	path = /obj/item/folder

/datum/gear/utility/taperecorder
	display_name = "tape recorder"
	path = /obj/item/device/taperecorder

/datum/gear/utility/folder/New()
	..()
	var/folders = list()
	folders["blue folder"] = /obj/item/folder/blue
	folders["grey folder"] = /obj/item/folder
	folders["red folder"] = /obj/item/folder/red
	folders["white folder"] = /obj/item/folder/white
	folders["yellow folder"] = /obj/item/folder/yellow
	gear_tweaks += new/datum/gear_tweak/path(folders)

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
	display_name = "Multicolored Pen"
	path = /obj/item/pen/multi
	cost = 2

/datum/gear/utility/fancy
	display_name = "Fancy Pen"
	path = /obj/item/pen/fancy
	cost = 2

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

/datum/gear/utility/wrist_computer
	display_name = "Wrist computer selection"
	path = /obj/item/modular_computer/pda/wrist
	cost = 2

/datum/gear/utility/wrist_computer/New()
	..()
	var/wcomp = list()
	slot = slot_wear_id
	wcomp["black"]                   = /obj/item/modular_computer/pda/wrist/
	wcomp["lightgrey"]               = /obj/item/modular_computer/pda/wrist/grey
	wcomp["black-red (sec)"]         = /obj/item/modular_computer/pda/wrist/security
	wcomp["brown (sup)"]             = /obj/item/modular_computer/pda/wrist/cargo
	wcomp["yellow (eng)"]            = /obj/item/modular_computer/pda/wrist/engineering
	wcomp["navy (heads)"]            = /obj/item/modular_computer/pda/wrist/heads
	wcomp["navy-red (hos)"]          = /obj/item/modular_computer/pda/wrist/heads/hos
	wcomp["navy-gold (capt)"]        = /obj/item/modular_computer/pda/wrist/captain
	wcomp["navy-blue (cmo)"]         = /obj/item/modular_computer/pda/wrist/heads/cmo
	wcomp["navy-white (hop)"]        = /obj/item/modular_computer/pda/wrist/heads/hop
	wcomp["navy-yellow (ce)"]        = /obj/item/modular_computer/pda/wrist/heads/ce
	wcomp["navy-darkgreen (rd)"]     = /obj/item/modular_computer/pda/wrist/heads/rd
	wcomp["blue (med)"]              = /obj/item/modular_computer/pda/wrist/medical
	wcomp["purple (exp)"]            = /obj/item/modular_computer/pda/wrist/explorer
	wcomp["lightgrey-darkgreen (sci)"]   = /obj/item/modular_computer/pda/wrist/science
	wcomp["lightgrey-yellowblue (robot)"]= /obj/item/modular_computer/pda/wrist/roboticist
	wcomp["black (mercs)"]           = /obj/item/modular_computer/pda/wrist/syndicate
	wcomp["short (lightgrey)"]       = /obj/item/modular_computer/pda/wrist/lila
	wcomp["short (black)"]           = /obj/item/modular_computer/pda/wrist/lila/black
	gear_tweaks += new/datum/gear_tweak/path(wcomp)

/datum/gear/utility/wrist_computer/spawn_on_mob(var/mob/living/carbon/human/H, var/metadata)
	var/obj/item/modular_computer/pda/wrist/item = spawn_item(H, H, metadata)
	var/obj/item/card/id = H.GetIdCard()
	if(id)
		item.attackby(id, H)
	if(item.tesla_link && !istype(H, /mob/living/carbon/human/dummy))	//PDA in loadout shouldn't work
		var/datum/extension/interactive/ntos/os = get_extension(item, /datum/extension/interactive/ntos)
		if(os && os.active_program && os.active_program.NM && istype(os.active_program, /datum/computer_file/program/email_client))
			var/datum/nano_module/email_client/NME = os.active_program.NM
			NME.log_in()
	if(H.equip_to_slot_if_possible(item, slot, del_on_fail = 1))
		. = item

/****************
Pouches and kits
****************/

/datum/gear/utility/pencilcase
	display_name = "Pencil case"
	path = /obj/item/storage/fancy/pencilcase
	cost = 2
