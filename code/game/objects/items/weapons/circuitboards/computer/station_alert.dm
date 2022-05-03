/obj/item/stock_parts/circuitboard/stationalert
	name = T_BOARD("alert console")
	build_path = /obj/machinery/computer/station_alert
	var/list/alarm_handlers

/obj/item/stock_parts/circuitboard/stationalert/New()
	alarm_handlers = new()
	set_extension(src, /datum/extension/interactive/multitool/circuitboards/stationalert)
	..()

/obj/item/stock_parts/circuitboard/stationalert/construct(var/obj/machinery/computer/station_alert/SA)
	if(..(SA))
		SA.unregister_monitor()

		var/datum/nano_module/alarm_monitor/monitor = new(SA)
		monitor.alarm_handlers.Cut()
		for(var/alarm_handler in alarm_handlers)
			monitor.alarm_handlers += alarm_handler

		SA.register_monitor(monitor)
		return 1

/obj/item/stock_parts/circuitboard/stationalert/deconstruct(var/obj/machinery/computer/station_alert/SA)
	if(..(SA))
		alarm_handlers.Cut()
		if(SA.alarm_monitor)
			for(var/alarm_handler in SA.alarm_monitor.alarm_handlers)
				alarm_handlers += alarm_handler
		return 1
