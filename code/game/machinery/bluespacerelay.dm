/obj/machinery/bluespacerelay
	name = "emergency bluespace relay"
	desc = "This sends messages through bluespace! Wow!"
	icon = 'icons/obj/machines/telecomms.dmi'
	icon_state = "bspacerelay"
	anchored = TRUE
	density = TRUE
	idle_power_usage = 15000
	construct_state = /singleton/machine_construction/default/panel_closed
	uncreated_component_parts = null
	machine_name = "emergency bluespace relay"
	machine_desc = "Used to instantly send messages across vast distances. An emergency relay is required to directly contact Expeditionary Command through crisis channels."

/obj/machinery/bluespacerelay/on_update_icon()
	overlays.Cut()
	if(panel_open)
		overlays += "[icon_state]_panel"
	if(!inoperable())
		overlays += "[icon_state]_lights_working"
		overlays += emissive_appearance(icon, "[icon_state]_lights_working")