/obj/machinery/computer/crew
	name = "crew monitoring computer"
	desc = "Used to monitor active health sensors built into most of the crew's uniforms."
	icon_keyboard = "med_key"
	icon_screen = "crew"
	light_color = "#315ab4"
	idle_power_usage = 250
	active_power_usage = 500
	machine_name = "crew monitoring console"
	machine_desc = "Vital for medical personnel, crew monitors display a list of all crew members, and a vital sign readout based on their suit sensors."
	var/datum/nano_module/crew_monitor/crew_monitor

/obj/machinery/computer/crew/New()
	crew_monitor = new(src)
	..()

/obj/machinery/computer/crew/Destroy()
	qdel(crew_monitor)
	crew_monitor = null
	..()

/obj/machinery/computer/crew/interface_interact(user)
	ui_interact(user)
	return TRUE

/obj/machinery/computer/crew/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	crew_monitor.ui_interact(user, ui_key, ui, force_open, state)

/obj/machinery/computer/crew/nano_container()
	return crew_monitor

/obj/machinery/computer/crew/interact(mob/user)
	crew_monitor.ui_interact(user)
