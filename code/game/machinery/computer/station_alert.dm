
/obj/machinery/computer/station_alert
	name = "station alert console"
	desc = "Used to access the station's automated alert system."
	icon_keyboard = "tech_key"
	icon_screen = "alert:0"
	light_color = "#e6ffff"
	circuit = /obj/item/weapon/circuitboard/stationalert
	var/datum/nano_module/alarm_monitor/alarm_monitor
	var/monitor_type

/obj/machinery/computer/station_alert/engineering
	monitor_type = /datum/nano_module/alarm_monitor/engineering

/obj/machinery/computer/station_alert/security
	monitor_type = /datum/nano_module/alarm_monitor/security

/obj/machinery/computer/station_alert/all
	monitor_type = /datum/nano_module/alarm_monitor/all

/obj/machinery/computer/station_alert/initialize()
	..()
	if(monitor_type)
		register(new monitor_type(src))

/obj/machinery/computer/station_alert/Destroy()
	. = ..()
	unregister()

/obj/machinery/computer/station_alert/proc/register_monitor(var/datum/nano_module/alarm_monitor/monitor)
	if(monitor.host != src)
		return

	alarm_monitor = monitor
	alarm_monitor.register(src, /obj/machinery/computer/station_alert/update_icon)

/obj/machinery/computer/station_alert/proc/unregister_monitor()
	if(alarm_monitor)
		alarm_monitor.unregister(src)
		qdel(alarm_monitor)
		alarm_monitor = null

/obj/machinery/computer/station_alert/attack_ai(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)
	return

/obj/machinery/computer/station_alert/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)
	return

/obj/machinery/computer/station_alert/interact(mob/user)
	if(alarm_monitor)
		alarm_monitor.ui_interact(user)

/obj/machinery/computer/station_alert/update_icon()
	icon_screen = initial(icon_screen)
	if(!(stat & (BROKEN|NOPOWER)))
		if(alarm_monitor)
			var/list/alarms = alarm_monitor.major_alarms()
			if(alarms.len)
				icon_screen = "alert:2"
	..()
