/obj/item/weapon/circuitboard/rcon_console
	name = "\improper RCON Remote Control Console circuit board"
	build_path = /obj/machinery/computer/rcon
	origin_tech = "programming=4;engineering=3;powerstorage=5"

/obj/machinery/computer/rcon
	name = "RCON Console"
	desc = "Console used to remotely control machinery on the station."
	icon = 'icons/obj/computer.dmi'
	icon_state = "ai-fixer"
	circuit = /obj/item/weapon/circuitboard/rcon_console
	req_one_access = list(access_engine)
	var/current_tag = null
	var/list/known_SMESs = null
	var/list/known_breakers = null

/obj/machinery/computer/rcon/attack_ai(var/mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/rcon/attack_hand(var/mob/user as mob)
	..()
	ui_interact(user)

/obj/machinery/computer/rcon/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	FindDevices() // Update our devices list
	var/data[0]

	// SMES DATA (simplified view)
	var/list/smeslist[0]
	for(var/obj/machinery/power/smes/buildable/SMES in known_SMESs)
		smeslist.Add(list(list(
		"charge" = round(SMES.Percentage()),
		"input_set" = SMES.input_attempt,
		"input_val" = round(SMES.input_level),
		"output_set" = SMES.output_attempt,
		"output_val" = round(SMES.output_level),
		"output_load" = round(SMES.output_used),
		"RCON_tag" = SMES.RCon_tag
		)))
	data["smes_info"] = smeslist

	// BREAKER DATA (simplified view)
	var/list/breakerlist[0]
	for(var/obj/machinery/power/breakerbox/BR in known_breakers)
		breakerlist.Add(list(list(
		"RCON_tag" = BR.RCon_tag,
		"enabled" = BR.on
		)))
	data["breaker_info"] = breakerlist





	// update the ui if it exists, returns null if no ui is passed/found
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "rcon.tmpl", "RCON Control Console", 600, 400)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/machinery/computer/rcon/Topic(href, href_list)
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
			var/inputset = input(usr, "Enter new input level (0-[SMES.input_level_max])", "SMES Input Power Control") as num
			SMES.set_input(inputset)
	if(href_list["smes_out_set"])
		var/obj/machinery/power/smes/buildable/SMES = GetSMESByTag(href_list["smes_out_set"])
		if(SMES)
			var/outputset = input(usr, "Enter new output level (0-[SMES.output_level_max])", "SMES Input Power Control") as num
			SMES.set_output(outputset)

	if(href_list["toggle_breaker"])
		var/obj/machinery/power/breakerbox/toggle = null
		for(var/obj/machinery/power/breakerbox/breaker in known_breakers)
			if(breaker.RCon_tag == href_list["toggle_breaker"])
				toggle = breaker
		if(toggle)
			if(toggle.update_locked)
				usr << "The breaker box was recently toggled. Please wait before toggling it again."
			else
				toggle.auto_toggle()

/obj/machinery/computer/rcon/proc/GetSMESByTag(var/tag)
	if(!tag)
		return

	for(var/obj/machinery/power/smes/buildable/S in known_SMESs)
		if(S.RCon_tag == tag)
			return S

/obj/machinery/computer/rcon/proc/FindDevices()
	known_SMESs = new /list()
	for(var/obj/machinery/power/smes/buildable/SMES in machines)
		if(SMES.RCon_tag && (SMES.RCon_tag != "NO_TAG") && SMES.RCon)
			known_SMESs.Add(SMES)

	known_breakers = new /list()
	for(var/obj/machinery/power/breakerbox/breaker in machines)
		if(breaker.RCon_tag != "NO_TAG")
			known_breakers.Add(breaker)