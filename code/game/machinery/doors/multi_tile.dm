//Terribly sorry for the code doubling, but things go derpy otherwise.
/obj/machinery/door/airlock/multi_tile
	width = 2
	appearance_flags = 0
	var/list/sight_blockers = list()

/obj/machinery/door/airlock/multi_tile/New()
	..()
	SetBounds()

/obj/machinery/door/airlock/multi_tile/Initialize()
	. = ..()
	for(var/turf/T in locs)
		var/atom/movable/A = new(T)
		A.opacity = 1
		A.name = "sight blocker"
		A.invisibility  = 101
		sight_blockers.Add(A)

/obj/machinery/door/airlock/multi_tile/set_opacity(new_opacity)
	for(var/atom/movable/A in sight_blockers)
		A.opacity = new_opacity
	. = ..()


/obj/machinery/door/airlock/multi_tile/Move()
	. = ..()
	SetBounds()

/obj/machinery/door/airlock/multi_tile/Destroy()
	for(var/atom/movable/A in sight_blockers)
		qdel(A)

	. = ..()

/obj/machinery/door/airlock/multi_tile/proc/SetBounds()
	if(dir in list(NORTH, SOUTH))
		bound_width = width * world.icon_size
		bound_height = world.icon_size
	else
		bound_width = world.icon_size
		bound_height = width * world.icon_size

/obj/machinery/door/airlock/multi_tile/glass
	name = "Glass Airlock"
	icon = 'icons/obj/doors/Door2x1glass.dmi'
	opacity = 0
	glass = 1
	assembly_type = /obj/structure/door_assembly/multi_tile
