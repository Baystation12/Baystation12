/obj/item/weapon/circuitboard/stationalert
	name = T_BOARD("station alert console")
	build_path = /obj/machinery/computer/station_alert
	var/list/alarm_handlers

/obj/item/weapon/circuitboard/stationalert/New()
	alarm_handlers = new()
	expansions[/datum/expansion/multitool] = new /datum/expansion/multitool/circuitboards/stationalert(src)
	..()

/obj/item/weapon/circuitboard/stationalert/construct(var/obj/machinery/computer/station_alert/SA)
	if(..(SA))
		SA.unregister()

		var/datum/nano_module/alarm_monitor/monitor = new(SA)
		monitor.alarm_handlers.Cut()
		for(var/alarm_handler in alarm_handlers)
			monitor.alarm_handlers += alarm_handler

		SA.register(monitor)
		return 1

/obj/item/weapon/circuitboard/stationalert/deconstruct(var/obj/machinery/computer/station_alert/SA)
	if(..(SA))
		alarm_handlers.Cut()
		if(SA.alarm_monitor)
			for(var/alarm_handler in SA.alarm_monitor.alarm_handlers)
				alarm_handlers += alarm_handler
		return 1
