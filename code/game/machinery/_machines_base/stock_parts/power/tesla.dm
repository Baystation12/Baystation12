// Basic power handler.
/obj/item/stock_parts/power/apc
	name = "tesla link receptor"
	desc = "Standard area-based power receptor, connecting the machine to a nearby area power controller through a tesla link."
	priority = 1

// Very simple; checks for area power and that's it.
/obj/item/stock_parts/power/apc/can_provide_power(var/obj/machinery/machine)
	return machine.powered()

// Doesn't actually do it.
/obj/item/stock_parts/power/apc/can_use_power_oneoff(var/obj/machinery/machine, var/amount, var/channel)
	var/area/A = get_area(machine)		// make sure it's in an area
	. = 0
	if(!A)
		return
	if(A.powered(channel))
		return amount

/obj/item/stock_parts/power/apc/use_power_oneoff(var/obj/machinery/machine, var/amount, var/channel)
	var/area/A = get_area(machine)
	. = 0
	if(!A)
		return
	if(A.powered(channel))
		A.use_power_oneoff(amount, channel)
		return amount

/obj/item/stock_parts/power/apc/buildable
	part_flags = PART_FLAG_HAND_REMOVE
	matter = list(MATERIAL_STEEL = 200)