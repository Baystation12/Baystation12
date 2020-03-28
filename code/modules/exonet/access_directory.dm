/obj/machinery/exonet/access_directory
	name = "EXONET Relay"
	desc = "A very complex machine that manages the security for an EXONET system. Looks fragile."
	use_power = POWER_USE_ACTIVE
	active_power_usage = 4000 //4kW
	idle_power_usage = 100
	icon_state = "bus"
	anchored = 1
	density = 1
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0

/obj/machinery/exonet/access_directory/on_update_icon()
	if(operable())
		icon_state = "bus"
	else
		icon_state = "bus_off"