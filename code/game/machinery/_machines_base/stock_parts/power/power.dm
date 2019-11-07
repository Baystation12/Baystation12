// Power component for machines. Handles power interactions.

/obj/machinery
	var/list/power_components = list() // this is an optimization, as power code is expensive.

/obj/item/weapon/stock_parts/power
	part_flags = PART_FLAG_QDEL // For integrated components, which are built from uncreated_component_parts. Use subtypes with this off for buildable ones.
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "teslalink"
	var/priority = 0            // Higher priority is used first
	var/cached_channel

/obj/item/weapon/stock_parts/power/on_install(var/obj/machinery/machine)
	..()
	ADD_SORTED(machine.power_components, src, /proc/cmp_power_component_priority)
	machine.power_change() // Makes the machine recompute its power status.
	cached_channel = initial(machine.power_channel)

/obj/item/weapon/stock_parts/power/on_uninstall(var/obj/machinery/machine)
	machine.power_components -= src
	..()
	machine.power_change()

// By returning true here, the part promises that it will provide the machine with power until it calls power_change on the machine.
/obj/item/weapon/stock_parts/power/proc/can_provide_power(var/obj/machinery/machine)
	return FALSE

// Doesn't actually do it.
/obj/item/weapon/stock_parts/power/proc/can_use_power_oneoff(var/obj/machinery/machine, var/amount, var/channel)
	return 0

// A request for the amount of power on the given channel. Returns the amount of power which could be provided.
/obj/item/weapon/stock_parts/power/proc/use_power_oneoff(var/obj/machinery/machine, var/amount, var/channel)
	return 0

// This alerts the part that it does not need to provide power anymore.
/obj/item/weapon/stock_parts/power/proc/not_needed(var/obj/machinery/machine)