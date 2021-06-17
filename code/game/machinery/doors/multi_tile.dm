//Terribly sorry for the code doubling, but things go derpy otherwise.
/obj/machinery/door/airlock/multi_tile
	airlock_type = "double"
	name = "\improper Airlock"
	icon = 'icons/obj/doors/double/door.dmi'
	fill_file = 'icons/obj/doors/double/fill_steel.dmi'
	color_file = 'icons/obj/doors/double/color.dmi'
	color_fill_file = 'icons/obj/doors/double/fill_color.dmi'
	stripe_file = 'icons/obj/doors/double/stripe.dmi'
	stripe_fill_file = 'icons/obj/doors/double/fill_stripe.dmi'
	glass_file = 'icons/obj/doors/double/fill_glass.dmi'
	bolts_file = 'icons/obj/doors/double/lights_bolts.dmi'
	deny_file = 'icons/obj/doors/double/lights_deny.dmi'
	lights_file = 'icons/obj/doors/double/lights_green.dmi'
	panel_file = 'icons/obj/doors/double/panel.dmi'
	welded_file = 'icons/obj/doors/double/welded.dmi'
	emag_file = 'icons/obj/doors/double/emag.dmi'
	width = 2
	appearance_flags = 0
	opacity = 1
	assembly_type = /obj/structure/door_assembly/multi_tile

/obj/machinery/door/airlock/multi_tile/New()
	..()
	SetBounds()

/obj/machinery/door/airlock/multi_tile/Move()
	. = ..()
	SetBounds()

/obj/machinery/door/airlock/multi_tile/proc/SetBounds()
	if(dir in list(NORTH, SOUTH))
		bound_width = width * world.icon_size
		bound_height = world.icon_size
	else
		bound_width = world.icon_size
		bound_height = width * world.icon_size


/obj/machinery/door/airlock/multi_tile/on_update_icon(state=0, override=0)
	..()
	if(connections in list(NORTH, SOUTH, NORTH|SOUTH))
		if(connections in list(WEST, EAST, EAST|WEST))
			set_dir(SOUTH)
		else
			set_dir(WEST)
	else
		set_dir(SOUTH)

/obj/machinery/door/airlock/multi_tile/update_connections(var/propagate = 0)
	var/dirs = 0

	for(var/direction in GLOB.cardinal)
		var/turf/T = get_step(src, direction)
		var/success = 0

		if(direction in list(NORTH, EAST))
			T = get_step(T, direction)

		if( istype(T, /turf/simulated/wall))
			success = 1
			if(propagate)
				var/turf/simulated/wall/W = T
				W.update_connections()
				W.update_icon()

		else if( istype(T, /turf/simulated/shuttle/wall))
			success = 1
		else
			for(var/obj/O in T)
				for(var/b_type in blend_objects)
					if( istype(O, b_type))
						success = 1

					if(success)
						break
				if(success)
					break

		if(success)
			dirs |= direction
	connections = dirs

/obj/machinery/door/airlock/multi_tile/command
	door_color = COLOR_COMMAND_BLUE

/obj/machinery/door/airlock/multi_tile/security
	door_color = COLOR_NT_RED

/obj/machinery/door/airlock/multi_tile/engineering
	name = "Maintenance Hatch"
	door_color = COLOR_AMBER

/obj/machinery/door/airlock/multi_tile/medical
	door_color = COLOR_WHITE
	stripe_color = COLOR_DEEP_SKY_BLUE

/obj/machinery/door/airlock/multi_tile/virology
	door_color = COLOR_WHITE
	stripe_color = COLOR_GREEN

/obj/machinery/door/airlock/multi_tile/mining
	name = "Mining Airlock"
	door_color = COLOR_PALE_ORANGE
	stripe_color = COLOR_BEASTY_BROWN

/obj/machinery/door/airlock/multi_tile/atmos
	door_color = COLOR_AMBER
	stripe_color = COLOR_CYAN

/obj/machinery/door/airlock/multi_tile/research
	door_color = COLOR_WHITE
	stripe_color = COLOR_RESEARCH

/obj/machinery/door/airlock/multi_tile/science
	door_color = COLOR_WHITE
	stripe_color = COLOR_VIOLET

/obj/machinery/door/airlock/multi_tile/sol
	door_color = COLOR_BLUE_GRAY

/obj/machinery/door/airlock/multi_tile/maintenance
	name = "Maintenance Access"
	stripe_color = COLOR_AMBER

/obj/machinery/door/airlock/multi_tile/civilian
	stripe_color = COLOR_CIVIE_GREEN

/obj/machinery/door/airlock/multi_tile/freezer
	name = "Freezer Airlock"
	door_color = COLOR_WHITE

/obj/machinery/door/airlock/multi_tile/glass
	name = "Glass Airlock"
	hitsound = 'sound/effects/Glasshit.ogg'
	glass = 1

/obj/machinery/door/airlock/multi_tile/glass/command
	door_color = COLOR_COMMAND_BLUE
	stripe_color = COLOR_SKY_BLUE

/obj/machinery/door/airlock/multi_tile/glass/security
	door_color = COLOR_NT_RED
	stripe_color = COLOR_ORANGE

/obj/machinery/door/airlock/multi_tile/glass/engineering
	door_color = COLOR_AMBER
	stripe_color = COLOR_RED

/obj/machinery/door/airlock/multi_tile/glass/medical
	door_color = COLOR_WHITE
	stripe_color = COLOR_DEEP_SKY_BLUE

/obj/machinery/door/airlock/multi_tile/glass/virology
	door_color = COLOR_WHITE
	stripe_color = COLOR_GREEN

/obj/machinery/door/airlock/multi_tile/glass/mining
	door_color = COLOR_PALE_ORANGE
	stripe_color = COLOR_BEASTY_BROWN

/obj/machinery/door/airlock/multi_tile/glass/atmos
	door_color = COLOR_AMBER
	stripe_color = COLOR_CYAN

/obj/machinery/door/airlock/multi_tile/glass/research
	door_color = COLOR_WHITE
	stripe_color = COLOR_RESEARCH

/obj/machinery/door/airlock/multi_tile/glass/science
	door_color = COLOR_WHITE
	stripe_color = COLOR_VIOLET

/obj/machinery/door/airlock/multi_tile/glass/sol
	door_color = COLOR_BLUE_GRAY
	stripe_color = COLOR_AMBER

/obj/machinery/door/airlock/multi_tile/glass/freezer
	door_color = COLOR_WHITE

/obj/machinery/door/airlock/multi_tile/glass/maintenance
	name = "Maintenance Access"
	stripe_color = COLOR_AMBER

/obj/machinery/door/airlock/multi_tile/glass/civilian
	stripe_color = COLOR_CIVIE_GREEN