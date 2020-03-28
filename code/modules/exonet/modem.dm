/obj/machinery/exonet/modem
	name = "EXONET Modem"
	desc = "A very complex modem capable of transmitting information to PLEXUS, the space internet. Looks fragile."
	use_power = POWER_USE_ACTIVE
	active_power_usage = 20000 //20kW
	idle_power_usage = 100
	icon_state = "bus"
	anchored = 1
	density = 1
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0

/obj/machinery/exonet/modem/on_update_icon()
	if(operable())
		icon_state = "bus"
	else
		icon_state = "bus_off"