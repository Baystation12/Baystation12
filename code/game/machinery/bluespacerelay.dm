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


/obj/machinery/bluespacerelay/Initialize()
	. = ..()
	update_icon()


/obj/machinery/bluespacerelay/operable()
	return !inoperable(MACHINE_STAT_EMPED)


/obj/machinery/bluespacerelay/on_update_icon()
	ClearOverlays()
	if(operable())
		AddOverlays(list(
			"bspacerelay_on",
			emissive_appearance(icon, "bspacerelay_on")
		))
	if(panel_open)
		AddOverlays("bspacerelay_panel")


/obj/machinery/bluespacerelay/Process()
	update_icon()
