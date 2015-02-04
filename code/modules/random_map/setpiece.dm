/datum/setpiece
	var/descriptor
	var/base_x
	var/base_y
	var/origin_x
	var/origin_y
	var/origin_z
	var/x_bound
	var/y_bound
	var/list/map
	var/min_x = 32
	var/min_y = 32

/datum/setpiece/New(var/x, var/y, var/x_size, var/y_size)

	// Get operating paramaters.
	if(x_size)
		x_bound = x_size
	else
		x_bound = base_x
	if(y_size)
		y_bound = y_size
	else
		y_bound = base_y

	origin_x = x
	origin_y = y

	// Initialize map.
	map = list()
	map.len = x_bound * y_bound

	// Build.
	if(is_buildable())
		generate()
		apply_to_map()
		return 1
	return 0

/datum/setpiece/proc/is_buildable()
	return 1

/datum/setpiece/proc/apply_to_map()
	return 1

/datum/setpiece/proc/generate()
	return 1

/datum/setpiece/asteroid_secret
	descriptor = "secret room"
	base_x = 5
	base_y = 5
	min_x = 5
	min_y = 5

/datum/setpiece/asteroid_secret/is_buildable()

	var/valid = 0
	var/turf/T = null
	var/sanity = 0
	var/list/room = null
	var/list/turfs = null

	turfs = get_area_turfs(/area/mine/unexplored)

	if(!turfs.len)
		return 0

	while(!valid)
		valid = 1
		sanity++
		if(sanity > 100)
			return 0

		T=pick(turfs)
		if(!T)
			return 0

		var/list/surroundings = list()

		surroundings += range(7, locate(T.x,T.y,T.z))
		surroundings += range(7, locate(T.x+size,T.y,T.z))
		surroundings += range(7, locate(T.x,T.y+size,T.z))
		surroundings += range(7, locate(T.x+size,T.y+size,T.z))

		if(locate(/area/mine/explored) in surroundings)			// +5s are for view range
			valid = 0
			continue

		if(locate(/turf/space) in surroundings)
			valid = 0
			continue

		if(locate(/area/asteroid/artifactroom) in surroundings)
			valid = 0
			continue

		if(locate(/turf/simulated/floor/plating/airless/asteroid) in surroundings)
			valid = 0
			continue

	if(!T)
		return 0

	room = spawn_room(T,size,size,,,1)

	if(room)
		T = pick(room["floors"])
		if(T)
			var/surprise = null
			valid = 0
			while(!valid)
				surprise = pickweight(space_surprises)
				if(surprise in spawned_surprises)
					if(prob(20))
						valid++
					else
						continue
				else
					valid++

			spawned_surprises.Add(surprise)
			new surprise(T)

	return 1