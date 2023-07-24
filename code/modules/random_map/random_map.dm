// Generates cave systems for the asteroid, and places ore tiles.
var/global/list/random_maps = list()
var/global/list/map_count = list()

/datum/random_map

	// Strings.
	var/name                        // Set in New()
	var/descriptor = "random map"   // Display name.

	// Locator/value vars.
	var/initial_cell_char = FLOOR_CHAR
	var/initial_wall_cell = 100     // % Chance that a cell will be seeded as a wall.
	var/max_attempts = 5            // Fail if a sane map isn't generated by this point.
	var/origin_x = 1                // Origin point, left.
	var/origin_y = 1                // Origin point, bottom.
	var/origin_z = 1                // Target Z-level.
	var/limit_x = 128               // Default x size.
	var/limit_y = 128               // Default y size.
	var/auto_apply = 1
	var/preserve_map = 1

	// Turf paths.
	var/wall_type =  /turf/simulated/wall
	var/floor_type = /turf/simulated/floor
	var/target_turf_type

	var/area/use_area // If set, turfs will be put in this area. If set to type, new instance will be spawned for the map

	// Storage for the final iteration of the map.
	var/list/map = list()           // Actual map.

	// If set, all sleep(-1) calls will be skipped.
	// Test to see if rand_seed() can be used reliably.
	var/priority_process

/datum/random_map/New(seed, tx, ty, tz, tlx, tly, do_not_apply, do_not_announce, never_be_priority = 0, used_area)

	// Store this for debugging.
	if (!map_count[descriptor])
		map_count[descriptor] = 1
	else
		map_count[descriptor]++
	name = "[descriptor] #[map_count[descriptor]]"
	if (preserve_map) random_maps[name] = src

	// Get origins for applying the map later.
	set_origins(tx, ty, tz)
	if (tlx) limit_x = tlx
	if (tly) limit_y = tly

	if (used_area)
		if (ispath(used_area))
			use_area = new(used_area)
		else
			use_area = used_area

	if (do_not_apply)
		auto_apply = null

	// Initialize map.
	set_map_size()

	var/start_time = world.timeofday
	if (!do_not_announce) admin_notice(SPAN_DANGER("Generating [name]."), R_DEBUG)
	CHECK_TICK

	// Testing needed to see how reliable this is (asynchronous calls, called during worldgen), DM ref is not optimistic
	if (seed)
		rand_seed(seed)
		priority_process = !never_be_priority

	for (var/i = 0;i<max_attempts;i++)
		if (generate())
			if (!do_not_announce) admin_notice(SPAN_DANGER("[capitalize(name)] generation completed in [round(0.1*(world.timeofday-start_time),0.1)] seconds."), R_DEBUG)
			return
	if (!do_not_announce) admin_notice(SPAN_DANGER("[capitalize(name)] failed to generate ([round(0.1*(world.timeofday-start_time),0.1)] seconds): could not produce sane map."), R_DEBUG)

/datum/random_map/proc/get_map_cell(x,y)
	if (!map)
		set_map_size()
	. = ((y-1)*limit_x)+x
	if ((. < 1) || (. > length(map)))
		return null

/datum/random_map/proc/get_map_char(value)
	switch (value)
		if (WALL_CHAR)
			return "#"
		if (FLOOR_CHAR)
			return "."
		if (DOOR_CHAR)
			return "D"
		if (ROOM_TEMP_CHAR)
			return "+"
		if (MONSTER_CHAR)
			return "M"
		if (ARTIFACT_TURF_CHAR)
			return "_"
		if (ARTIFACT_CHAR)
			return "A"
		else
			return " "

/datum/random_map/proc/display_map(atom/user)

	if (!user)
		user = world

	var/dat = "<code>+------+<br>"
	for (var/x = 1, x <= limit_x, x++)
		for (var/y = 1, y <= limit_y, y++)
			var/current_cell = get_map_cell(x,y)
			if (current_cell)
				dat += get_map_char(map[current_cell])
		dat += "<br>"
	to_chat(user, "[dat]+------+</code>")

/datum/random_map/proc/set_map_size()
	map = new (limit_x * limit_y)

/datum/random_map/proc/seed_map()
	for (var/x = 1, x <= limit_x, x++)
		for (var/y = 1, y <= limit_y, y++)
			var/current_cell = get_map_cell(x,y)
			if (prob(initial_wall_cell))
				map[current_cell] = WALL_CHAR
			else
				map[current_cell] = initial_cell_char

/datum/random_map/proc/clear_map()
	for (var/x = 1, x <= limit_x, x++)
		for (var/y = 1, y <= limit_y, y++)
			map[get_map_cell(x,y)] = 0

/datum/random_map/proc/generate()
	seed_map()
	generate_map()
	if (check_map_sanity())
		cleanup()
		if (auto_apply)
			apply_to_map()
		return 1
	return 0

// Unused for basic map.
/datum/random_map/proc/generate_map()
	return 1

/datum/random_map/proc/check_map_sanity()
	return 1

/datum/random_map/proc/set_origins(tx, ty, tz)
	origin_x = tx ? tx : 1
	origin_y = ty ? ty : 1
	origin_z = tz ? tz : 1

/datum/random_map/proc/apply_to_map()
	if (!origin_x) origin_x = 1
	if (!origin_y) origin_y = 1
	if (!origin_z) origin_z = 1

	for (var/x = 1, x <= limit_x, x++)
		for (var/y = 1, y <= limit_y, y++)
			if (!priority_process)
				CHECK_TICK
			apply_to_turf(x,y)

/datum/random_map/proc/apply_to_turf(x,y)
	var/current_cell = get_map_cell(x,y)
	if (!current_cell)
		return 0
	var/turf/T = locate((origin_x-1)+x,(origin_y-1)+y,origin_z)
	if (!T || (target_turf_type && !istype(T,target_turf_type)))
		return 0
	var/newpath = get_appropriate_path(map[current_cell])
	if (newpath)
		T.ChangeTurf(newpath)
	get_additional_spawns(map[current_cell],T,get_spawn_dir(x, y))
	if (use_area)
		ChangeArea(T, use_area)
	return T

/datum/random_map/proc/get_spawn_dir()
	return 0

/datum/random_map/proc/get_appropriate_path(value)
	switch (value)
		if (FLOOR_CHAR)
			return floor_type
		if (WALL_CHAR)
			return wall_type

/datum/random_map/proc/get_additional_spawns(value, turf/T)
	if (value == DOOR_CHAR)
		new /obj/machinery/door/airlock(T)

/datum/random_map/proc/cleanup()
	return

/datum/random_map/proc/overlay_with(datum/random_map/target_map, tx, ty)
	if (!length(map) || !istype(target_map))
		return
	tx-- // Update origin so that x/y index
	ty-- // doesn't push it off-kilter by one.
	for (var/x = 1, x <= limit_x, x++)
		for (var/y = 1, y <= limit_y, y++)
			var/current_cell = get_map_cell(x,y)
			if (!current_cell)
				continue
			if (tx+x > target_map.limit_x)
				continue
			if (ty+y > target_map.limit_y)
				continue
			target_map.map[target_map.get_map_cell(tx+x,ty+y)] = map[current_cell]
	handle_post_overlay_on(target_map,tx,ty)


/datum/random_map/proc/handle_post_overlay_on(datum/random_map/target_map, tx, ty)
	return
