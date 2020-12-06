/datum/computer_file/program/rcon_console
	filename = "rconconsole"
	filedesc = "RCON Remote Control"
	nanomodule_path = /datum/nano_module/rcon
	program_icon_state = "generic"
	program_key_state = "rd_key"
	program_menu_icon = "power"
	extended_desc = "This program allows remote control of power distribution systems. This program can not be run on tablet computers."
	required_access = access_engine
	requires_ntnet = 1
	network_destination = "RCON remote control system"
	requires_ntnet_feature = NTNET_SYSTEMCONTROL
	usage_flags = PROGRAM_LAPTOP | PROGRAM_CONSOLE
	size = 19
	category = PROG_ENG

/datum/nano_module/rcon
	name = "Power RCON"
	var/list/known_SMESs = null
	var/list/known_breakers = null
	// Allows you to hide specific parts of the UI
	var/hide_SMES = 0
	var/hide_SMES_details = 0
	var/hide_breakers = 0

/datum/nano_module/rcon/ui_interact(mob/user, ui_key = "rcon", datum/nanoui/ui=null, force_open=1, var/datum/topic_state/state = GLOB.default_state)
	FindDevices() // Update our devices list
	var/list/data = host.initial_data()

	// SMES DATA (simplified view)
	var/list/smeslist[0]
	for(var/obj/machinery/power/smes/buildable/SMES in known_SMESs)
		smeslist.Add(list(list(
		"charge" = round(SMES.Percentage()),
		"input_set" = SMES.input_attempt,
		"input_val" = round(SMES.input_level/1000, 0.1),
		"input_load" = round(SMES.input_available/1000, 0.1),
		"output_set" = SMES.output_attempt,
		"output_val" = round(SMES.output_level/1000, 0.1),
		"output_load" = round(SMES.output_used/1000, 0.1),
		"RCON_tag" = SMES.RCon_tag
		)))

	data["smes_info"] = sortByKey(smeslist, "RCON_tag")

	// BREAKER DATA (simplified view)
	var/list/breakerlist[0]
	for(var/obj/machinery/power/breakerbox/BR in known_breakers)
		breakerlist.Add(list(list(
		"RCON_tag" = BR.RCon_tag,
		"enabled" = BR.on
		)))
	data["breaker_info"] = breakerlist
	data["hide_smes"] = hide_SMES
	data["hide_smes_details"] = hide_SMES_details
	data["hide_breakers"] = hide_breakers

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "rcon.tmpl", "RCON Console", 600, 400, state = state)
		if(host.update_layout()) // This is necessary to ensure the status bar remains updated along with rest of the UI.
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

// Proc: Topic()
// Parameters: 2 (href, href_list - allows us to process UI clicks)
// Description: Allows us to process UI clicks, which are relayed in form of hrefs.
/datum/nano_module/rcon/Topic(href, href_list)
	if(..())
		return

	if(href_list["smes_in_toggle"])
		var/obj/machinery/power/smes/buildable/SMES = GetSMESByTag(href_list["smes_in_toggle"])
		if(SMES)
			SMES.toggle_input()
	if(href_list["smes_out_toggle"])
		var/obj/machinery/power/smes/buildable/SMES = GetSMESByTag(href_list["smes_out_toggle"])
		if(SMES)
			SMES.toggle_output()
	if(href_list["smes_in_set"])
		var/obj/machinery/power/smes/buildable/SMES = GetSMESByTag(href_list["smes_in_set"])
		if(SMES)
			var/inputset = (input(usr, "Enter new input level (0-[SMES.input_level_max/1000] kW)", "SMES Input Power Control", SMES.input_level/1000) as num) * 1000
			SMES.set_input(inputset)
	if(href_list["smes_out_set"])
		var/obj/machinery/power/smes/buildable/SMES = GetSMESByTag(href_list["smes_out_set"])
		if(SMES)
			var/outputset = (input(usr, "Enter new output level (0-[SMES.output_level_max/1000] kW)", "SMES Input Power Control", SMES.output_level/1000) as num) * 1000
			SMES.set_output(outputset)

	if(href_list["toggle_breaker"])
		var/obj/machinery/power/breakerbox/toggle = null
		for(var/obj/machinery/power/breakerbox/breaker in known_breakers)
			if(breaker.RCon_tag == href_list["toggle_breaker"])
				toggle = breaker
		if(toggle)
			if(toggle.update_locked)
				to_chat(usr, "The breaker box was recently toggled. Please wait before toggling it again.")
			else
				toggle.auto_toggle()
	if(href_list["hide_smes"])
		hide_SMES = !hide_SMES
	if(href_list["hide_smes_details"])
		hide_SMES_details = !hide_SMES_details
	if(href_list["hide_breakers"])
		hide_breakers = !hide_breakers


// Proc: GetSMESByTag()
// Parameters: 1 (tag - RCON tag of SMES we want to look up)
// Description: Looks up and returns SMES which has matching RCON tag
/datum/nano_module/rcon/proc/GetSMESByTag(var/tag)
	if(!tag)
		return

	for(var/obj/machinery/power/smes/buildable/S in known_SMESs)
		if(S.RCon_tag == tag)
			return S

// Proc: FindDevices()
// Parameters: None
// Description: Refreshes local list of known devices.
/datum/nano_module/rcon/proc/FindDevices()
	known_SMESs = new /list()
	for(var/obj/machinery/power/smes/buildable/SMES in SSmachines.machinery)
		if(AreConnectedZLevels(get_host_z(), get_z(SMES)) && SMES.RCon_tag && (SMES.RCon_tag != "NO_TAG") && SMES.RCon)
			known_SMESs.Add(SMES)

	known_breakers = new /list()
	for(var/obj/machinery/power/breakerbox/breaker in SSmachines.machinery)
		if(AreConnectedZLevels(get_host_z(), get_z(breaker)) && breaker.RCon_tag != "NO_TAG")
			known_breakers.Add(breaker)
