/obj/machinery/bluespacerelay
	name = "Emergency Bluespace Relay"
	desc = "This sends messages through bluespace! Wow!"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "bspacerelay"
	anchored = 1
	density = 1
	idle_power_usage = 15000
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null

/obj/machinery/bluespacerelay/on_update_icon()
	if(stat & (BROKEN|NOPOWER))
		icon_state = "[initial(icon_state)]_off"
	else
		icon_state = initial(icon_state)