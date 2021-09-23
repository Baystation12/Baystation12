
/obj/machinery/computer/station_alert
	name = "alert console"
	desc = "Used to access the automated alert system."
	icon_keyboard = "tech_key"
	icon_screen = "alert:0"
	light_color = "#e6ffff"
	base_type = /obj/machinery/computer/station_alert
	machine_name = "alert console"
	machine_desc = "A compact monitoring system that displays a readout of all active atmosphere, camera, and fire alarms on the network."
	var/datum/nano_module/alarm_monitor/alarm_monitor
	var/monitor_type = /datum/nano_module/alarm_monitor

/obj/machinery/computer/station_alert/engineering
	monitor_type = /datum/nano_module/alarm_monitor/engineering

/obj/machinery/computer/station_alert/security
	monitor_type = /datum/nano_module/alarm_monitor/security

/obj/machinery/computer/station_alert/all
	monitor_type = /datum/nano_module/alarm_monitor/all

/obj/machinery/computer/station_alert/Initialize()
	alarm_monitor = new monitor_type(src)
	alarm_monitor.register_alarm(src, /atom/proc/update_icon)
	. = ..()
	if(monitor_type)
		register_monitor(new monitor_type(src))

/obj/machinery/computer/station_alert/Destroy()
	. = ..()
	unregister_monitor()

/obj/machinery/computer/station_alert/proc/register_monitor(var/datum/nano_module/alarm_monitor/monitor)
	if(monitor.host != src)
		return

	alarm_monitor = monitor
	alarm_monitor.register_alarm(src, /atom/proc/update_icon)

/obj/machinery/computer/station_alert/proc/unregister_monitor()
	if(alarm_monitor)
		alarm_monitor.unregister_alarm(src)
		qdel(alarm_monitor)
		alarm_monitor = null

/obj/machinery/computer/station_alert/interface_interact(user)
	ui_interact(user)
	return TRUE

/obj/machinery/computer/station_alert/ui_interact(mob/user)
	if(alarm_monitor)
		alarm_monitor.ui_interact(user)

/obj/machinery/computer/station_alert/nano_container()
	return alarm_monitor

/obj/machinery/computer/station_alert/on_update_icon()
	icon_screen = initial(icon_screen)
	if(!(stat & (BROKEN|NOPOWER)))
		if(alarm_monitor)
			if(alarm_monitor.has_major_alarms(get_z(src)))
				icon_screen = "alert:2"
	..()
