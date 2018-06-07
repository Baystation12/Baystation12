/turf/space/transit
	// pushdirection is now dir // push things that get caught in the transit tile this direction
	var/static/list/phase_shift

//Overwrite because we dont want people building rods in space.
/turf/space/transit/attackby(obj/O as obj, mob/user as mob)
	return

//generates a list used to randomize transit animations so they aren't in lockstep
/turf/space/transit/proc/get_cross_shift_list(var/size)
	var/list/result = list()

	result += rand(0, 14)
	for(var/i in 2 to size)
		var/shifts = list(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14)
		shifts -= result[i - 1] //consecutive shifts should not be equal
		if(i == size)
			shifts -= result[1] //because shift list is a ring buffer
		result += pick(shifts)

	return result

/turf/space/transit/Initialize()
	. = ..()
	if(!phase_shift)
		phase_shift = get_cross_shift_list(15)

	var/shift = phase_shift[(dir & (NORTH|SOUTH) ? src.x : src.y) % (phase_shift.len - 1) + 1]
	var/transit_state = ((dir & (NORTH|SOUTH) ? world.maxy - src.y : world.maxx - src.x) + shift)%15 + 1

	icon_state = "speedspace_[dir & (SOUTH|WEST) ? 16 - transit_state : transit_state]"

/turf/space/transit/north // moving to the north
	dir = SOUTH // south because the space tile is scrolling south

/turf/space/transit/south
	dir = NORTH

/turf/space/transit/east
	dir = WEST

/turf/space/transit/west
	dir = EAST
