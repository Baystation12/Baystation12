#define PRINT_SCAN 0
#define SAVE_SCAN 1
#define PRINT_SAVE_SCAN 2
#define PRINT_MODE_ROLLOVER PRINT_SAVE_SCAN
#define FROM_MAIN_STORAGE 1
#define FROM_PORTABLE_STORAGE 2

/obj/machinery/body_scanconsole
	var/obj/machinery/bodyscanner/connected	
	var/stored_scan_subject
	name = "Body Scanner Console"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "body_scannerconsole"
	density = 0
	anchored = 1
	var/list/display_tags = list()
	var/list/connected_displays = list()
	var/list/data = list()
	var/scan_data
	var/print_mode = PRINT_SCAN
	var/show_files = FALSE
	var/pending_file_list_regeneration = TRUE
	var/spawn_with_hard_drive = null
	var/obj/item/weapon/computer_hardware/hard_drive/main_file_storage
	var/obj/item/weapon/computer_hardware/hard_drive/portable/portable_file_storage

/obj/machinery/body_scanconsole/Initialize()
	. = ..()
	component_parts = list(
		new /obj/item/weapon/circuitboard/body_scanconsole(src),
		new /obj/item/weapon/stock_parts/console_screen(src))
		
	if(spawn_with_hard_drive)
		main_file_storage = new spawn_with_hard_drive(src)
		install_file_storage(main_file_storage)
	
	RefreshParts()
	FindScanner()

/obj/machinery/body_scanconsole/advanced_hard_drive
	spawn_with_hard_drive = /obj/item/weapon/computer_hardware/hard_drive/advanced

/obj/machinery/body_scanconsole/proc/update_verbs()
	verbs.Cut()
	if(portable_file_storage)
		verbs |= /obj/machinery/body_scanconsole/verb/eject_usb

/obj/machinery/body_scanconsole/on_update_icon()
	if(stat & (BROKEN | NOPOWER))
		icon_state = "body_scannerconsole-p"	
	else
		icon_state = initial(icon_state)

/obj/machinery/body_scanconsole/ex_act(severity)

	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if (prob(50))
				qdel(src)				

/obj/machinery/body_scanconsole/proc/FindScanner()
	for(var/D in GLOB.cardinal)
		src.connected = locate(/obj/machinery/bodyscanner, get_step(src, D))
		if(src.connected)
			break
		GLOB.destroyed_event.register(connected, src, .proc/unlink_scanner)

/obj/machinery/body_scanconsole/proc/unlink_scanner(var/obj/machinery/bodyscanner/scanner)	
	GLOB.destroyed_event.unregister(scanner, src, .proc/unlink_scanner)
	connected = null

/obj/machinery/body_scanconsole/proc/FindDisplays()
	for(var/obj/machinery/body_scan_display/D in SSmachines.machinery)
		if(D.tag in display_tags)
			connected_displays += D
			GLOB.destroyed_event.register(D, src, .proc/remove_display)
	return !!connected_displays.len

/obj/machinery/body_scanconsole/attack_ai(user as mob)
	return src.attack_hand(user)

/obj/machinery/body_scanconsole/attack_hand(mob/user)
	if(..())
		return
	if(stat & (NOPOWER|BROKEN))
		return
	if(!connected || (connected.stat & (NOPOWER|BROKEN)))
		to_chat(user, "<span class='warning'>This console is not connected to a functioning body scanner.</span>")
		return
	ui_interact(user)

/obj/machinery/body_scanconsole/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	data["file_storage_present"] = file_storage_present()
	data["main_file_storage_present"] = ( main_file_storage ? TRUE : FALSE)
	if(main_file_storage)
		data["main_file_storage_used"] = file_storage_percent_used(main_file_storage)
	else
		data["main_file_storage_used"] = 100

	data["portable_file_storage_present"] = ( portable_file_storage ? TRUE : FALSE)
	if(portable_file_storage)
		data["portable_file_storage_used"] = file_storage_percent_used(portable_file_storage)
	else
		data["portable_file_storage_used"] = 100
	
	data["show_files"] = show_files
	data["main_file_storage_files"] = list()
	data["portable_file_storage_files"] = list()
	if(show_files && pending_file_list_regeneration)
		regenerate_file_listing()

	switch(print_mode)
		if(PRINT_SCAN)
			data["print_mode"] = "Print"
		if(SAVE_SCAN)
			data["print_mode"] = "Save"
		if(PRINT_SAVE_SCAN)
			data["print_mode"] = "Print & Save"
	
	if(connected.occupant)
		data["scanEnabled"] = TRUE
		if(ishuman(connected.occupant))
			data["isCompatible"] = TRUE
		else
			data["isCompatible"] = FALSE
	else
		data["scanEnabled"] = FALSE

	if(!data["scan"])
		data["html_scan_header"] = "<center>No scan loaded.</center>"
		data["html_scan_health"] = "&nbsp;"
		data["html_scan_body"] = "&nbsp;"
	else
		data["html_scan_header"] = display_medical_data_header(data["scan"], user.get_skill_value(SKILL_MEDICAL))
		data["html_scan_health"] = display_medical_data_health(data["scan"], user.get_skill_value(SKILL_MEDICAL))
		data["html_scan_body"] = display_medical_data_body(data["scan"], user.get_skill_value(SKILL_MEDICAL))

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "body_scanner.tmpl", "Body Scanner", 600, 800)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/body_scanconsole/OnTopic(mob/user, href_list)
	if(href_list["scan"])
		if (!connected.occupant)
			to_chat(user, "\icon[src]<span class='warning'>The body scanner is empty.</span>")
			return TOPIC_REFRESH
		if (!istype(connected.occupant))
			to_chat(user, "\icon[src]<span class='warning'>The body scanner cannot scan that lifeform.</span>")
			return TOPIC_REFRESH
		data["scan"] = connected.occupant.get_raw_medical_data(TRUE)
		regenerate_scan_information(user, href_list)
		
		stored_scan_subject = connected.occupant
		user.visible_message("<span class='notice'>\The [user] performs a scan of \the [connected.occupant] using \the [connected].</span>")
		return TOPIC_REFRESH

	if (href_list["print"])
		if (!data["scan"])
			to_chat(user, "\icon[src]<span class='warning'>Error: No scan stored.</span>")
			return TOPIC_REFRESH
		var/list/scan = data["scan"]
		if(print_mode == PRINT_SCAN || print_mode == PRINT_SAVE_SCAN)
			new /obj/item/weapon/paper/bodyscan(loc, "Printout error.", "Body scan report - [stored_scan_subject]", scan.Copy())
		
		if(print_mode == SAVE_SCAN || print_mode == PRINT_SAVE_SCAN)
			var/obj/item/weapon/computer_hardware/hard_drive/file_storage = save_scan_to_file_storage(scan, user)
			if(file_storage)
				to_chat(user, "\icon[src] \icon[file_storage]<span class='notice'>Saved scan to [file_storage_name(file_storage)].</span>")
			else
				to_chat(user, "\icon[src]<span class='warning'>Could not save scan.</span>")

		return TOPIC_REFRESH

	if(href_list["push"])		
		if(!connected_displays.len && !FindDisplays())
			to_chat(user, "\icon[src]<span class='warning'>Error: No configured displays detected.</span>")
			return TOPIC_REFRESH
		for(var/obj/machinery/body_scan_display/D in connected_displays)
			D.add_new_scan(data["scan"])
		to_chat(user, "<span class='notice'>The console beeps, confirming it has successfully sent the scan to the connected displays.</span>")
		return TOPIC_REFRESH

	if(href_list["erase"])
		data["scan"] = null
		data["html_scan"] = null
		stored_scan_subject = null
		data["eraseEnabled"] = FALSE
		data["printEnabled"] = FALSE
		data["pushEnabled"] = FALSE
		return TOPIC_REFRESH
	
	if(href_list["switch_print_mode"])
		if(!file_storage_present()) // Someone had an out of date view.
			print_mode = PRINT_SCAN
			return TOPIC_REFRESH
		
		print_mode++
		if(print_mode > PRINT_MODE_ROLLOVER)
			print_mode = PRINT_SCAN
		return TOPIC_REFRESH
	
	if(href_list["copy_scan"])
		var/obj/item/weapon/computer_hardware/hard_drive/copy_file_storage_from
		var/obj/item/weapon/computer_hardware/hard_drive/copy_file_storage_to
		switch(text2num(href_list["copy_scan"]))
			if(FROM_MAIN_STORAGE)
				copy_file_storage_from = main_file_storage
				copy_file_storage_to = portable_file_storage
			if(FROM_PORTABLE_STORAGE)
				copy_file_storage_from = portable_file_storage
				copy_file_storage_to = main_file_storage
		if(copy_from_to_file_storage(copy_file_storage_from, copy_file_storage_to, href_list["file_reference"]))
			to_chat(user, "\icon[src] \icon[copy_file_storage_from] => \icon[copy_file_storage_to]<span class='notice'>Copied scan from [file_storage_name(copy_file_storage_from)] to [file_storage_name(copy_file_storage_to)].</span>")
		else
			to_chat(user, "\icon[src] \icon[copy_file_storage_from] !=> \icon[copy_file_storage_to]<span class='warning'>Could not copy scan from [file_storage_name(copy_file_storage_from)] to [file_storage_name(copy_file_storage_to)].</span>")
		return TOPIC_REFRESH

	if(href_list["delete_scan"])
		var/obj/item/weapon/computer_hardware/hard_drive/delete_file_storage_from
		switch(text2num(href_list["delete_scan"]))
			if(FROM_MAIN_STORAGE)
				delete_file_storage_from = main_file_storage
			if(FROM_PORTABLE_STORAGE)
				delete_file_storage_from = portable_file_storage
		if(delete_from_file_storage(delete_file_storage_from, href_list["file_reference"]))
			to_chat(user, "\icon[src] \icon[delete_file_storage_from]<span class='notice'>Deleted scan from [file_storage_name(delete_file_storage_from)].</span>")
		else
			to_chat(user, "\icon[src] \icon[delete_file_storage_from]<span class='warning'>Could not delete scan from [file_storage_name(delete_file_storage_from)].</span>")
		return TOPIC_REFRESH

	if(href_list["recall_scan"])
		var/obj/item/weapon/computer_hardware/hard_drive/recall_file_storage_from
		switch(text2num(href_list["recall_scan"]))
			if(FROM_MAIN_STORAGE)
				recall_file_storage_from = main_file_storage
			if(FROM_PORTABLE_STORAGE)
				recall_file_storage_from = portable_file_storage
		if(recall_from_file_storage(recall_file_storage_from, href_list["file_reference"]))
			to_chat(user, "\icon[src] \icon[recall_file_storage_from]<span class='notice'>Recalled scan from [file_storage_name(recall_file_storage_from)].</span>")
			regenerate_scan_information(user, href_list)
		else
			to_chat(user, "\icon[src] \icon[recall_file_storage_from]<span class='warning'>Could not recall scan from [file_storage_name(recall_file_storage_from)].</span>")
		return TOPIC_REFRESH
	
	if(href_list["move_scan"]) // Why not? I'm feeling charitable today.
		var/obj/item/weapon/computer_hardware/hard_drive/move_file_storage_from
		var/obj/item/weapon/computer_hardware/hard_drive/move_file_storage_to
		switch(text2num(href_list["move_scan"]))
			if(FROM_MAIN_STORAGE)
				move_file_storage_from = main_file_storage
				move_file_storage_to = portable_file_storage
			if(FROM_PORTABLE_STORAGE)
				move_file_storage_from = portable_file_storage
				move_file_storage_to = main_file_storage
		if(copy_from_to_file_storage(move_file_storage_from, move_file_storage_to, href_list["file_reference"]) && delete_from_file_storage(move_file_storage_from, href_list["file_reference"]))
			to_chat(user, "\icon[src] \icon[move_file_storage_from] *=> \icon[move_file_storage_to]<span class='notice'>Moved scan from [file_storage_name(move_file_storage_from)] to [file_storage_name(move_file_storage_to)].</span>")
		else
			to_chat(user, "\icon[src] \icon[move_file_storage_from] !*=> \icon[move_file_storage_to]<span class='warning'>Could not move scan from [file_storage_name(move_file_storage_from)] to [file_storage_name(move_file_storage_to)].</span>")
		return TOPIC_REFRESH

	if(href_list["eject_portable_storage"])
		remove_file_storage(portable_file_storage, user)
		return TOPIC_REFRESH
	if(href_list["show_files"])
		if(!file_storage_present()) // Someone had an out of date view.
			show_files = FALSE
			return TOPIC_REFRESH
		show_files = !show_files
		return TOPIC_REFRESH

/obj/machinery/body_scanconsole/proc/regenerate_scan_information(mob/user, href_list)
	data["printEnabled"] = TRUE
	data["eraseEnabled"] = TRUE
	data["pushEnabled"] = TRUE
	data["html_scan_header"] = display_medical_data_header(data["scan"], user.get_skill_value(SKILL_MEDICAL))
	data["html_scan_health"] = display_medical_data_health(data["scan"], user.get_skill_value(SKILL_MEDICAL))
	data["html_scan_body"] = display_medical_data_body(data["scan"], user.get_skill_value(SKILL_MEDICAL))
	return

/obj/machinery/body_scanconsole/proc/file_storage_present()
	return (main_file_storage || portable_file_storage ? TRUE : FALSE)

/obj/machinery/body_scanconsole/proc/save_scan_to_file_storage(var/list/scan, mob/user)
	var/datum/computer_file/data/bodyscan/file = new /datum/computer_file/data/bodyscan(scan)
	var/obj/item/weapon/computer_hardware/hard_drive/file_storage = (main_file_storage ? main_file_storage : portable_file_storage)
	if(file_storage && file_storage.store_file(file))
		regenerate_file_listing()
		return file_storage
	else
		return null

/obj/machinery/body_scanconsole/proc/file_storage_name(var/obj/item/weapon/computer_hardware/hard_drive/file_storage)
	if(file_storage == main_file_storage)
		return "internal storage"
	if(file_storage == portable_file_storage)
		return "portable storage"
	return "unknown"

/obj/machinery/body_scanconsole/proc/copy_from_to_file_storage(var/obj/item/weapon/computer_hardware/hard_drive/from_storage, var/obj/item/weapon/computer_hardware/hard_drive/to_storage, var/reference)
	if(!to_storage || !from_storage)
		return FALSE
	var/datum/computer_file/c_file = locate(reference) in from_storage.stored_files
	if(!c_file)
		return FALSE
	var/result = to_storage.store_file(c_file.clone())
	regenerate_file_listing()
	return result

/obj/machinery/body_scanconsole/proc/delete_from_file_storage(var/obj/item/weapon/computer_hardware/hard_drive/from, var/reference)
	if(!from)
		return FALSE
	var/datum/computer_file/c_file = locate(reference) in from.stored_files
	if(!c_file)
		return FALSE
	var/result = from.remove_file(c_file)
	regenerate_file_listing()
	return result

/obj/machinery/body_scanconsole/proc/recall_from_file_storage(var/obj/item/weapon/computer_hardware/hard_drive/from, var/reference)
	if(!from)
		return FALSE
	var/datum/computer_file/c_file = locate(reference) in from.stored_files
	if(!c_file)
		return FALSE
	if(c_file.papertype == /obj/item/weapon/paper/bodyscan)
		data["scan"] = c_file.metadata
		return TRUE
	else
		return FALSE

/obj/machinery/body_scanconsole/proc/regenerate_file_listing()
	if(show_files)
		if(main_file_storage)
			for(var/datum/computer_file/file in main_file_storage.stored_files)
				if(file.papertype == /obj/item/weapon/paper/bodyscan)
					data["main_file_storage_files"].Add(list(list(
						"scan_name" = file.metadata["name"],
						"scan_time" = file.metadata["time"],
						"ref" 		= "\ref[file]"
					)))
		if(portable_file_storage)
			for(var/datum/computer_file/file in portable_file_storage.stored_files)
				if(file.papertype == /obj/item/weapon/paper/bodyscan)
					data["portable_file_storage_files"].Add(list(list(
						"scan_name" = file.metadata["name"],
						"scan_time" = file.metadata["time"],
						"ref" 		= "\ref[file]"
					)))
	else
		pending_file_list_regeneration = TRUE


/obj/machinery/body_scanconsole/attackby(var/obj/item/O, user as mob)
	if(istype(O, /obj/item/weapon/computer_hardware/hard_drive) && install_file_storage(O, user)) // Installing hard drives
		return
	
	if(panel_open && main_file_storage && istype(O, /obj/item/weapon/screwdriver))
		if(alert(user, "A hard drive is present. Remove \the [main_file_storage] or close panel?", "Hard drive removal", "Remove \the [main_file_storage]", "Close Panel") != "Close Panel")
			remove_file_storage(main_file_storage)
			return
	
	if(default_deconstruction_screwdriver(user, O))
		updateUsrDialog()
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return

/obj/machinery/body_scanconsole/dismantle()
	remove_file_storage(main_file_storage)
	remove_file_storage(portable_file_storage)
	..()

/obj/machinery/body_scanconsole/proc/install_file_storage(var/obj/item/weapon/computer_hardware/O, var/mob/user as mob)
	var/found = FALSE
	if(!portable_file_storage && istype(O, /obj/item/weapon/computer_hardware/hard_drive/portable))
		portable_file_storage = O
		found = TRUE
	else if(!main_file_storage && istype(O, /obj/item/weapon/computer_hardware/hard_drive))
		main_file_storage = O
		found = TRUE
	
	if(found && user.unEquip(O, src))
		if(user)
			to_chat(user, "You install \the [O] into \the [src]")
		regenerate_file_listing()
		update_verbs()
		return TRUE

/obj/machinery/body_scanconsole/proc/remove_file_storage(var/obj/item/weapon/computer_hardware/hard_drive/file_storage, var/mob/user as mob)
	if(!istype(file_storage))
		return
	
	var/found = FALSE
	if(portable_file_storage == file_storage)
		portable_file_storage = null
		found = TRUE
	if(main_file_storage == file_storage)
		main_file_storage = null
		found = TRUE
	
	if(found)
		to_chat(user, "You remove \the [file_storage] from the \the [src].")
		if(user && Adjacent(user))
			user.put_in_hands(file_storage)
		else
			file_storage.dropInto(loc)
		regenerate_file_listing()
		update_verbs()
		if(!file_storage_present())
			print_mode = PRINT_SCAN
			show_files = FALSE
		return TRUE


/obj/machinery/body_scanconsole/verb/eject_usb()
	set name = "Eject Portable Storage"
	set category = "Object"
	set src in view(1)

	if(usr.incapacitated() || !istype(usr, /mob/living))
		to_chat(usr, "<span class='warning'>You can't do that.</span>")
		return

	if(!Adjacent(usr))
		to_chat(usr, "<span class='warning'>You can't reach it.</span>")
		return
	
	remove_file_storage(portable_file_storage, usr)

/obj/machinery/body_scanconsole/proc/file_storage_percent_used(var/obj/item/weapon/computer_hardware/hard_drive/file_storage)
	return Floor( (file_storage.used_capacity / file_storage.max_capacity) * 100 )

/obj/machinery/body_scanconsole/proc/remove_display(var/obj/machinery/body_scan_display/display)
	connected_displays -= display
	GLOB.destroyed_event.unregister(display, src, .proc/remove_display)

/obj/machinery/body_scanconsole/Destroy()
	. = ..()
	for(var/D in connected_displays)
		remove_display(D)
	unlink_scanner(connected)

#undef PRINT_SCAN
#undef SAVE_SCAN
#undef PRINT_SAVE_SCAN
#undef PRINT_MODE_ROLLOVER
#undef FROM_PORTABLE_STORAGE