/datum/computer_file/program/reactor_control
	filename = "Reactor montior"
	filedesc = "Reactor monitoring software"
	nanomodule_path = /datum/nano_module/rmon
	program_icon_state = "generic"
	program_key_state = "rd_key"
	program_menu_icon = "power"  // Can somebody draw a radiation icon?
	extended_desc = "A quite outdated reactor monitoring software"
	requires_ntnet = 1
	network_destination = "reactor monitoring system"
	requires_ntnet_feature = NTNET_SYSTEMCONTROL
	usage_flags = PROGRAM_LAPTOP | PROGRAM_CONSOLE
	size = 23
	category = PROG_ENG




/obj/machinery/computer/reactor_control  // Just regular NanoUI based console
	name = "Reactor monitor computer"
	icon_keyboard = "rd_key"
	icon_screen = "power"
	light_color = COLOR_BLUE
	idle_power_usage = 250
	active_power_usage = 500
	var/datum/nano_module/rmon/mon
	var/overterm = 360
	var/overrad = 120
	var/overraddec = 121
	var/overtdec = 10


/obj/machinery/computer/reactor_control/Process()  // I made this just to configure coefficients directly while in the game. If reactor is working correctly, you're free to delete it
	for(var/obj/machinery/power/nuclear_rod/R in GLOB.nrods)
		R.thermaldecaycoeff = overtdec
		R.raddeccoeff = overraddec
		R.radkoeff = overrad
		R.thermalkoeff = overterm


/obj/machinery/computer/reactor_control/Initialize()
	. = ..()
	mon = new(src)
	mon.id_tag = id_tag



/obj/machinery/computer/reactor_control/Destroy()
	QDEL_NULL(mon)
	return ..()

/obj/machinery/computer/reactor_control/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/computer/reactor_control/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	mon.ui_interact(user, ui_key, ui, force_open, state)

/obj/machinery/computer/reactor_control/attackby(var/obj/item/W, var/mob/user)
	if(isMultitool(W))
		var/new_ident = input("Enter a new ID.", "Rod Control", id_tag) as null|text
		if(new_ident && user.Adjacent(src))
			id_tag = new_ident
			mon.id_tag = new_ident
		return
	return ..()

/datum/nano_module/rmon
	name = "Reactor monitor"
	var/list/known_rods = list()
	var/id_tag

/datum/nano_module/rmon/ui_interact(mob/user, ui_key = "rcon", datum/nanoui/ui=null, force_open=1, var/datum/topic_state/state = GLOB.default_state)
	FindDevices() // Update our devices list
	var/overtemp = 0
	var/list/data = host.initial_data()
	var/list/rodlist = new /list()
	for(var/obj/machinery/power/nuclear_rod/R in known_rods)
		overtemp += R.rodtemp
		rodlist.Add(list(list(
		"name" = R.name,
		"temp" = R.rodtemp,
		"rads" = R.own_rads,
		"broken" = R.broken
		)))

	data["rods"] = sortByKey(rodlist, "name")
	data["id"] = id_tag
	if(known_rods.len)
		data["summarytemp"] = overtemp/(known_rods.len)
	else
		data["summarytemp"] = 0
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "rmonitor.tmpl", "Reactor monitoring Console", 600, 400, state = state)
		if(host.update_layout()) // This is necessary to ensure the status bar remains updated along with rest of the UI.
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/datum/nano_module/rmon/proc/FindDevices()
	known_rods = list()
	for(var/obj/machinery/power/nuclear_rod/I in GLOB.nrods)
		if(I.id_tag && (I.id_tag == id_tag)) //&& (get_dist(src, I) < 50))
			known_rods += I

/obj/item/weapon/stock_parts/circuitboard/reactor_montor_console
	name = T_BOARD("Reactor monitor")
	build_path = /obj/machinery/computer/reactor_control
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_POWER = 5)
