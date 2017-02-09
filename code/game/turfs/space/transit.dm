/turf/space/transit
	var/pushdirection // push things that get caught in the transit tile this direction

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

/turf/space/transit/north // moving to the north
	pushdirection = SOUTH  // south because the space tile is scrolling south
	var/static/list/phase_shift_by_x

/turf/space/transit/north/New()
	..()
	if(!phase_shift_by_x)
		phase_shift_by_x = get_cross_shift_list(15)

	var/x_shift = phase_shift_by_x[src.x % (phase_shift_by_x.len - 1) + 1]
	var/transit_state = (world.maxy - src.y + x_shift)%15 + 1

	icon_state = "speedspace_ns_[transit_state]"

/turf/space/transit/east // moving to the east
	pushdirection = WEST
	var/static/list/phase_shift_by_y

/turf/space/transit/east/New()
	..()
	if(!phase_shift_by_y)
		phase_shift_by_y = get_cross_shift_list(15)

	var/y_shift = phase_shift_by_y[src.y % (phase_shift_by_y.len - 1) + 1]
	var/transit_state = (world.maxx - src.x + y_shift)%15 + 1

	icon_state = "speedspace_ew_[transit_state]"
