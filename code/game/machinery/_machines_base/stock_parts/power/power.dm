// Power component for machines. Handles power interactions.

/// List of all machine components that are of the `power` subtype. This is an optimization, as power code is expensive.
/obj/machinery/var/list/power_components = list()

/obj/item/stock_parts/power
	part_flags = PART_FLAG_QDEL // For integrated components, which are built from uncreated_component_parts. Use subtypes with this off for buildable ones.
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "teslalink"
	var/priority = 0            // Higher priority is used first
	var/cached_channel

/obj/item/stock_parts/power/on_install(obj/machinery/machine)
	..()
	ADD_SORTED(machine.power_components, src, GLOBAL_PROC_REF(cmp_power_component_priority))
	machine.power_change() // Makes the machine recompute its power status.
	cached_channel = initial(machine.power_channel)

/obj/item/stock_parts/power/on_uninstall(obj/machinery/machine)
	machine.power_components -= src
	..()
	machine.power_change()

// By returning true here, the part promises that it will provide the machine with power until it calls power_change on the machine.
/obj/item/stock_parts/power/proc/can_provide_power(obj/machinery/machine)
	return FALSE

// Doesn't actually do it.
/obj/item/stock_parts/power/proc/can_use_power_oneoff(obj/machinery/machine, amount, channel)
	return 0

// A request for the amount of power on the given channel. Returns the amount of power which could be provided.
/obj/item/stock_parts/power/proc/use_power_oneoff(obj/machinery/machine, amount, channel)
	return 0

// This alerts the part that it does not need to provide power anymore.
/obj/item/stock_parts/power/proc/not_needed(obj/machinery/machine)
