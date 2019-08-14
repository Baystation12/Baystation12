/obj/machinery/computer/rod_control
	name = "Reactor control computer"
	icon_keyboard = "rd_key"
	icon_screen = "power"
	light_color = COLOR_BLUE
	idle_power_usage = 250
	active_power_usage = 500
	var/datum/nano_module/rcontrol/C


/obj/machinery/computer/rod_control/Initialize()
	. = ..()
	C =  new(src)
	C.id_tag = id_tag


/obj/machinery/computer/rod_control/Destroy()
	QDEL_NULL(C)
	return ..()

/obj/machinery/computer/rod_control/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/computer/rod_control/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	C.ui_interact(user, ui_key, ui, force_open, state)

/datum/nano_module/rcontrol
	name = "Reactor control"
	var/list/known_c_rods = list()
	var/id_tag

/datum/nano_module/rcontrol/ui_interact(mob/user, ui_key = "rcon", datum/nanoui/ui=null, force_open=1, var/datum/topic_state/state = GLOB.default_state)
	FindDevices() // Update our devices list
	var/list/data = host.initial_data()
	var/list/rodlist = new /list()
	for(var/obj/machinery/control_rod/R in known_c_rods)
		rodlist.Add(list(list(
		"name" = R.name,
		"len" = R.rod_length,
		"targ" = R.target,
		"broken" = R.nocontrol,
		"tag" = "\ref[R]"
		)))

	data["rods"] = sortByKey(rodlist, "name")
	data["id"] = id_tag

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "rcontrol.tmpl", "Reactor control Console", 600, 400, state = state)
		if(host.update_layout()) // This is necessary to ensure the status bar remains updated along with rest of the UI.
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/datum/nano_module/rcontrol/proc/FindDevices()
	known_c_rods = list()
	for(var/obj/machinery/control_rod/I in GLOB.control_rods)
		if(I.id_tag && (I.id_tag == id_tag)) //&& (get_dist(src, I) < 50))
			known_c_rods += I

/datum/nano_module/rcontrol/Topic(href, href_list)
	if(href_list["settarg"])
		var/obj/machinery/control_rod/Rd = locate((href_list["settarg"]))
		var/new_val = (input("Enter new target length", "Setting new length", Rd.target) as num)
		Rd.target = Clamp(new_val, 0, 4)

	if( href_list["setall"] )
		var/new_overall = (input("Enter new overall length", "Setting new length", 0) as num)
		for(var/obj/machinery/control_rod/C in known_c_rods)
			if(C.target != new_overall)
				C.target = Clamp(new_overall, 0, 4)



/obj/machinery/computer/rod_control/attackby(var/obj/item/W, var/mob/user)
	if(isMultitool(W))
		var/new_ident = input("Enter a new ID.", "Rod Control", id_tag) as null|text
		if(new_ident && user.Adjacent(src))
			id_tag = new_ident
			C.id_tag = new_ident
		return
	return ..()



/obj/item/weapon/stock_parts/circuitboard/reactor_control_console
	name = T_BOARD("Reactor control")
	build_path = /obj/machinery/computer/rod_control
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_POWER = 5)
