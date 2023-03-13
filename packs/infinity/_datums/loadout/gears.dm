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

/datum/gear/utility/wrist_computer/spawn_on_mob(mob/living/carbon/human/H, metadata)
	var/obj/item/modular_computer/pda/wrist/item = spawn_item(H, H, metadata)
	var/obj/item/card/id = H.GetIdCard()
	if(id)
		item.attackby(id, H)
	if(item.tesla_link && !istype(H, /mob/living/carbon/human/dummy))	//PDA in loadout shouldn't work
		var/datum/extension/interactive/ntos/os = get_extension(item, /datum/extension/interactive/ntos)
		if(os && os.active_program && os.active_program.NM && istype(os.active_program, /datum/computer_file/program/email_client))
			var/datum/nano_module/email_client/NME = os.active_program.NM
			NME.log_in()
	if(H.equip_to_slot_if_possible(item, slot, equip_flags = TRYEQUIP_DESTROY))
		. = item
