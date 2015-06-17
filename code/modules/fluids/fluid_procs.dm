// Called to add all nearby fluids to the fluid controller.
/proc/update_fluids(var/atom/A)
	for(var/obj/effect/fluid/F in range(1,A))
		F.refresh()

// Checking if a given object blocks flow (shield walls, windows, etc). flow_from is a dir.
/obj/proc/can_liquid_pass(var/flow_from)
	return 1

/obj/effect/energy_field/can_liquid_pass()
	return 0

/obj/machinery/door/can_liquid_pass()
	return density == 0

/obj/machinery/door/window/can_liquid_pass(var/flow_from)
	if(dir in list(5,6,9,10))
		return 0
	if(dir & flow_from)
		return 0
	return 1

/obj/structure/window/can_liquid_pass(var/flow_from)
	if(dir in list(5,6,9,10))
		return 0
	if(dir & flow_from)
		return 0
	return 1

// Jamming a fluid update into the existing update proc (windows, doors)
/obj/update_nearby_tiles(need_rebuild)
	. = ..(need_rebuild)
	update_fluids(get_turf(src))
