GLOBAL_LIST_INIT(weighted_minerals_sparse, \
	list(                   \
		"pitchblende" =  8, \
		"platinum" =     8, \
		"hematite" =    35, \
		"graphene" =    35, \
		"diamond" =      5, \
		"gold" =         8, \
		"silver" =       8, \
		"phoron" =      10, \
		"quartz" =       3, \
		"pyrite" =       3, \
		"spodumene" =    3, \
		"cinnabar" =     3, \
		"phosphorite" =  3, \
		"rock salt" =    3, \
		"potash" =       3, \
		"bauxite" =      3  \
	))

GLOBAL_LIST_INIT(weighted_minerals_rich, \
	list(                   \
		"pitchblende" = 10, \
		"platinum" =    10, \
		"hematite" =    20, \
		"graphene" =    20, \
		"diamond" =      5, \
		"gold" =        10, \
		"silver" =      10, \
		"phoron" =      20, \
		"quartz" =       1, \
		"pyrite" =       1, \
		"spodumene" =    1, \
		"cinnabar" =     1, \
		"phosphorite" =  1, \
		"rock salt" =    1, \
		"potash" =       1, \
		"bauxite" =      1  \
	))

/datum/random_map/automata/cave_system
	iterations = 5
	descriptor = "moon caves"
	wall_type =  /turf/simulated/mineral
	floor_type = /turf/simulated/floor/asteroid
	target_turf_type = /turf/unsimulated/mask

	var/mineral_turf = /turf/simulated/mineral/random
	var/list/ore_turfs = list()
	var/list/minerals_sparse
	var/list/minerals_rich

/datum/random_map/automata/cave_system/New()
	if(!minerals_sparse) minerals_sparse = GLOB.weighted_minerals_sparse
	if(!minerals_rich)   minerals_rich =   GLOB.weighted_minerals_rich
	..()

/datum/random_map/automata/cave_system/get_appropriate_path(var/value)
	switch(value)
		if(DOOR_CHAR, EMPTY_CHAR)
			return mineral_turf
		if(FLOOR_CHAR)
			return floor_type
		if(WALL_CHAR)
			return wall_type

/datum/random_map/automata/cave_system/get_map_char(var/value)
	switch(value)
		if(DOOR_CHAR)
			return "x"
		if(EMPTY_CHAR)
			return "X"
	return ..(value)

// Create ore turfs.
/datum/random_map/automata/cave_system/cleanup()
	var/tmp_cell
	for (var/x = 1 to limit_x)
		for (var/y = 1 to limit_y)
			tmp_cell = TRANSLATE_COORD(x, y)
			if (CELL_ALIVE(map[tmp_cell]))
				ore_turfs += tmp_cell

	game_log("ASGEN", "Found [ore_turfs.len] ore turfs.")
	var/ore_count = round(map.len/20)
	var/door_count = 0
	var/empty_count = 0
	while((ore_count>0) && (ore_turfs.len>0))

		if(!priority_process)
			CHECK_TICK

		var/check_cell = pick(ore_turfs)
		ore_turfs -= check_cell
		if(prob(75))
			map[check_cell] = DOOR_CHAR  // Mineral block
			door_count += 1
		else
			map[check_cell] = EMPTY_CHAR // Rare mineral block.
			empty_count += 1
		ore_count--

	game_log("ASGEN", "Set [door_count] turfs to random minerals.")
	game_log("ASGEN", "Set [empty_count] turfs to high-chance random minerals.")
	return 1

/datum/random_map/automata/cave_system/apply_to_map()
	if(!origin_x) origin_x = 1
	if(!origin_y) origin_y = 1
	if(!origin_z) origin_z = 1

	var/tmp_cell
	var/new_path
	var/num_applied = 0
	for (var/thing in block(locate(origin_x, origin_y, origin_z), locate(limit_x, limit_y, origin_z)))
		var/turf/T = thing
		new_path = null
		if (!T || (target_turf_type && !istype(T, target_turf_type)))
			continue

		tmp_cell = TRANSLATE_COORD(T.x, T.y)

		var/minerals
		switch (map[tmp_cell])
			if(DOOR_CHAR)
				new_path = mineral_turf
				minerals = pickweight(minerals_sparse)
			if(EMPTY_CHAR)
				new_path = mineral_turf
				minerals = pickweight(minerals_rich)
			if(FLOOR_CHAR)
				new_path = floor_type
			if(WALL_CHAR)
				new_path = wall_type

		if (!new_path)
			continue

		num_applied += 1
		T.ChangeTurf(new_path, minerals)

		CHECK_TICK

	game_log("ASGEN", "Applied [num_applied] turfs.")