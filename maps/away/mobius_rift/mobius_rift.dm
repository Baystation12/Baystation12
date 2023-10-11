#include "mobius_rift_areas.dm"

/obj/overmap/visitable/sector/mobius_rift
	name = "unusual asteroid"
	desc = "Sensors error: ERROR #E0x003141592: recursive stack overflow for CALCULATE_APPROXIMATE_SIZE()."
	icon_state = "object"


/datum/map_template/ruin/away_site/mobius_rift
	name = "Mobius rift"
	id = "awaysite_mobius_rift"
	description = "Non-euclidian mess."
	suffixes = list("mobius_rift/mobius_rift.dmm")
	spawn_cost = 1
	area_usage_test_exempted_root_areas = list(/area/mobius_rift)
	apc_test_exempt_areas = list(
		/area/mobius_rift = NO_SCRUBBER|NO_VENT|NO_APC
	)

/obj/step_trigger/mobius_rift/seamless_portal
	var/obj/step_trigger/mobius_rift/seamless_portal/dest
	//NORTH or EAST cases
	//var/obj/step_trigger/mobius_rift/seamless_portal/dest2//SOUTH or WEST cases
	var/directed//NS or WE
	var/x_shift = 0
	var/y_shift = 0

/obj/step_trigger/mobius_rift/seamless_portal/Initialize(mapload, towards)
	. = ..()
	if (towards == NORTH)
		y_shift = 1
	if (towards == SOUTH)
		y_shift = -1
	if (towards == EAST)
		x_shift = 1
	if (towards == WEST)
		x_shift = -1

/obj/step_trigger/mobius_rift/seamless_portal/proc/set_destination(D)
	dest = D

/obj/step_trigger/mobius_rift/seamless_portal/Trigger(atom/movable/AM)
	if(!istype(AM))
		return
	//moving player one tile past portal to avoid portal spamming
	var/turf/T = locate(dest.x + x_shift, dest.y + y_shift, dest.z)
	AM.forceMove(T)

//spawns and presets portals to their destinations, must be in left lower chamber center
/obj/mobius_rift/portals_setup
	var/grid_number = 4//amount of rooms in a square pattern grid
	var/grid_size = 31//lenfth from center of one room to another, or size of a chamber(room length, 12?) + corridor length. Corridor length is (view-range * 2) (16?)

/obj/mobius_rift/portals_setup/Initialize()
	..()
	var/list/rooms = list()

	for (var/y_iter = 1 to grid_number)//spawning chamber abstract objects
		for (var/x_iter = 1 to grid_number)
			var/turf/T = locate(src.x + (x_iter-1)*grid_size, src.y + (y_iter-1)*grid_size, src.z)
			var/CH = new /obj/mobius_rift/chamber(T, grid_size)
			rooms["[y_iter]_[x_iter]"] = CH
	//creating lists of teleporting consequences for each direction
	var/list/north_jumps = shuffle(rooms)
	var/list/south_jumps = shuffle(rooms)
	var/list/east_jumps = shuffle(rooms)
	var/list/west_jumps = shuffle(rooms)

	var/list/routes = list("SOUTH" = south_jumps, "NORTH" = north_jumps, "WEST" = west_jumps, "EAST" = east_jumps)//North exit is linked to south exit of another room etc.
	for (var/ch_iter = 1 to length(rooms))//get destinations in SNWE order
		var/list/destinations = list()//4 exit portals for linking
		var/chamber_tag = rooms[ch_iter]
		var/obj/mobius_rift/chamber/chamber = rooms[chamber_tag]
		for (var/dir_iter =1 to length(routes))
			var/list/route = routes[routes[dir_iter]]
			var/ch_pos = route.Find(chamber_tag) + 1
			if (ch_pos > (grid_number * grid_number))//if that's the last one
				ch_pos = 1
			var/obj/mobius_rift/chamber/dest_chamber = route[route[ch_pos]]//getting destination chamber for direction
			var/P = dest_chamber.get_portal(routes[dir_iter])
			destinations.Add(P)
		chamber.set_portals(destinations)
	//cleaning up
	for (var/ch_iter = 1 to length(rooms))
		qdel(rooms[rooms[ch_iter]])
	return INITIALIZE_HINT_QDEL

/obj/mobius_rift/chamber
	var/list/portals = list()

/obj/mobius_rift/chamber/Initialize(mapload, grid_size)//NORTH, SOUTH, EAST, WEST
	. = ..()
	var/turf/T
	T = locate(src.x, src.y + round(grid_size/2), src.z)
	var/N = new /obj/step_trigger/mobius_rift/seamless_portal(T, NORTH)
	portals["NORTH"] = N
	T = locate(src.x, src.y - round(grid_size/2), src.z)
	var/S = new /obj/step_trigger/mobius_rift/seamless_portal(T, SOUTH)
	portals["SOUTH"] = S
	T = locate(src.x + round(grid_size/2), src.y, src.z)
	var/E = new /obj/step_trigger/mobius_rift/seamless_portal(T, EAST)
	portals["EAST"] = E
	T = locate(src.x - round(grid_size/2), src.y, src.z)
	var/W = new /obj/step_trigger/mobius_rift/seamless_portal(T, WEST)
	portals["WEST"] = W

/obj/mobius_rift/chamber/proc/set_portals(list/destinations)
	for (var/iter = 1 to length(portals))
		var/obj/step_trigger/mobius_rift/seamless_portal/P = portals[portals[iter]]
		P.set_destination(destinations[iter])

/obj/mobius_rift/chamber/proc/get_portal(towards)
	return portals[towards]
