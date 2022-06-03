/// Operates NanoUI
/datum/extension/interactive/ntos/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)
	if(!on || !host_status())
		if(ui)
			ui.close()
		return 0
	// If we have an active program switch to it now.
	if(active_program)
		if(ui) // This is the main laptop screen. Since we are switching to program's UI close it for now.
			ui.close()
		active_program.ui_interact(user)
		return

	// We are still here, that means there is no program loaded. Load the BIOS/ROM/OS/whatever you want to call it.
	// This screen simply lists available programs and user may select them.
	var/obj/item/stock_parts/computer/hard_drive/hard_drive = get_component(PART_HDD)
	if(!hard_drive)
		show_error(user, "DISK ERROR")
		return // No HDD, Something is very broken.

	var/list/data = get_header_data()

	var/datum/computer_file/data/autorun = get_file("autorun")
	var/list/programs = list()
	for(var/datum/computer_file/program/P in get_all_files())
		var/list/program = list()
		program["name"] = P.filename
		program["desc"] = P.filedesc
		program["icon"] = P.program_menu_icon
		program["autorun"] = (istype(autorun) && (autorun.stored_data == P.filename)) ? 1 : 0
		if(P in running_programs)
			program["running"] = 1
		programs.Add(list(program))

	data["programs"] = programs

	data["updating"] = updating
	data["update_progress"] = update_progress
	data["updates"] = updates

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "laptop_mainscreen.tmpl", "NTOS Main Menu ", 400, 500)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/extension/interactive/ntos/extension_status(mob/user)
	. = ..()
	if(!on || !host_status())
		return STATUS_CLOSE
	//There is no bypassing the update, mwhahaha
	if(updating)
		. = min(STATUS_UPDATE, .)

/datum/extension/interactive/ntos/CanUseTopic(mob/user, state)
	. = holder.CanUseTopic(user, state)
	. = min(., extension_status(user))

/// Handles user's GUI input
/datum/extension/interactive/ntos/extension_act(href, href_list, user)
	if( href_list["PC_exit"] )
		kill_program(active_program)
		return TOPIC_HANDLED
	if(href_list["PC_enable_component"] )
		var/obj/item/stock_parts/computer/H = locate(href_list["PC_enable_component"]) in holder
		if(H && istype(H) && !H.enabled)
			H.enabled = TRUE
			H.on_enable(src)
		return TOPIC_REFRESH
	if(href_list["PC_disable_component"] )
		var/obj/item/stock_parts/computer/H = locate(href_list["PC_disable_component"]) in holder
		if(H && istype(H) && H.enabled)
			H.enabled = FALSE
			H.on_disable()
		return TOPIC_REFRESH
	if( href_list["PC_enable_update"] )
		receives_updates = TRUE
		return TOPIC_REFRESH
	if( href_list["PC_disable_update"] )
		receives_updates = FALSE
		return TOPIC_REFRESH
	if( href_list["PC_shutdown"] )
		system_shutdown()
		return TOPIC_HANDLED
	if( href_list["PC_minimize"] )
		minimize_program(usr)
		return TOPIC_HANDLED

	if( href_list["PC_killprogram"] )
		var/datum/computer_file/program/P = get_file(href_list["PC_killprogram"])

		if(!istype(P) || P.program_state == PROGRAM_STATE_KILLED)
			return TOPIC_HANDLED

		kill_program(P)
		update_uis()
		to_chat(usr, "<span class='notice'>Program [P.filename].[P.filetype] with PID [rand(100,999)] has been killed.</span>")
		return TOPIC_HANDLED

	if( href_list["PC_runprogram"] )
		run_program(href_list["PC_runprogram"])
		return TOPIC_HANDLED

	if( href_list["PC_setautorun"] )
		var/datum/computer_file/data/autorun = get_file("autorun")
		if(istype(autorun) && autorun.stored_data == href_list["PC_setautorun"])
			set_autorun()
		else
			set_autorun(href_list["PC_setautorun"])
		return TOPIC_REFRESH

	if( href_list["PC_terminal"] )
		open_terminal(usr)
		return TOPIC_HANDLED

/datum/extension/interactive/ntos/proc/regular_ui_update()
	var/ui_update_needed = FALSE
	var/obj/item/stock_parts/computer/battery_module/battery_module = get_component(PART_BATTERY)
	if(battery_module)
		var/batery_percent = battery_module.battery.percent()
		if(last_battery_percent != batery_percent) //Let's update UI on percent change
			ui_update_needed = TRUE
			last_battery_percent = batery_percent

	if(stationtime2text() != last_world_time)
		last_world_time = stationtime2text()
		ui_update_needed = TRUE

	var/list/current_header_icons = list()
	for(var/datum/computer_file/program/P in running_programs)
		if(!P.ui_header)
			continue
		current_header_icons[P.type] = P.ui_header

	if(!last_header_icons)
		last_header_icons = current_header_icons

	else if(!listequal(last_header_icons, current_header_icons))
		last_header_icons = current_header_icons
		ui_update_needed = TRUE
	else
		for(var/x in last_header_icons|current_header_icons)
			if(last_header_icons[x]!=current_header_icons[x])
				last_header_icons = current_header_icons
				ui_update_needed = TRUE
				break

	if(ui_update_needed)
		update_uis()

/datum/extension/interactive/ntos/proc/update_uis()
	if(active_program) //Should we update program ui or computer ui?
		SSnano.update_uis(active_program)
		if(active_program.NM)
			SSnano.update_uis(active_program.NM)

/// Function used by NanoUI's to obtain data for header. All relevant entries begin with "PC_"
/datum/extension/interactive/ntos/proc/get_header_data()
	var/list/data = list()

	var/obj/item/stock_parts/computer/battery_module/battery_module = get_component(PART_BATTERY)
	if(battery_module)
		switch(battery_module.battery.percent())
			if(80 to 200) // 100 should be maximal but just in case..
				data["PC_batteryicon"] = "batt_100.gif"
			if(60 to 80)
				data["PC_batteryicon"] = "batt_80.gif"
			if(40 to 60)
				data["PC_batteryicon"] = "batt_60.gif"
			if(20 to 40)
				data["PC_batteryicon"] = "batt_40.gif"
			if(5 to 20)
				data["PC_batteryicon"] = "batt_20.gif"
			else
				data["PC_batteryicon"] = "batt_5.gif"
		data["PC_batterypercent"] = "[round(battery_module.battery.percent())] %"
		data["PC_showbatteryicon"] = TRUE
	else
		data["PC_batteryicon"] = "batt_5.gif"
		data["PC_batterypercent"] = "N/C"
		data["PC_showbatteryicon"] = battery_module ? TRUE : FALSE

	var/obj/item/stock_parts/computer/tesla_link/tesla_link = get_component(PART_TESLA)
	if(tesla_link && tesla_link.enabled)
		data["PC_apclinkicon"] = "charging.gif"

	var/obj/item/stock_parts/computer/network_card/network_card = get_component(PART_NETWORK)
	if(network_card && network_card.is_banned())
		data["PC_ntneticon"] = "sig_warning.gif"
	else
		switch(get_ntnet_status())
			if(0)
				data["PC_ntneticon"] = "sig_none.gif"
			if(1)
				data["PC_ntneticon"] = "sig_low.gif"
			if(2)
				data["PC_ntneticon"] = "sig_high.gif"
			if(3)
				data["PC_ntneticon"] = "sig_lan.gif"

	var/list/program_headers = list()
	for(var/datum/computer_file/program/P in running_programs)
		if(!P.ui_header)
			continue
		program_headers.Add(list(list(
			"icon" = P.ui_header
		)))
	data["PC_programheaders"] = program_headers

	data["PC_stationtime"] = stationtime2text()
	data["PC_hasheader"] = !updating
	data["PC_showexitprogram"] = active_program ? TRUE : FALSE // Hides "Exit Program" button on mainscreen
	return data

/datum/extension/interactive/ntos/initial_data()
	return get_header_data()

/datum/extension/interactive/ntos/update_layout()
	return TRUE

/datum/extension/interactive/ntos/nano_host()
	return holder.nano_host()
