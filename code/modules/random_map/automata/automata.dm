#define CELL_ALIVE(VAL) (VAL == cell_live_value)
#define KILL_CELL(CELL, NEXT_MAP) NEXT_MAP[CELL] = cell_dead_value;
#define REVIVE_CELL(CELL, NEXT_MAP) NEXT_MAP[CELL] = cell_live_value;

/datum/random_map/automata
	descriptor = "generic caves"
	initial_wall_cell = 55
	var/iterations = 0               // Number of times to apply the automata rule.
	var/cell_live_value = WALL_CHAR  // Cell is alive if it has this value.
	var/cell_dead_value = FLOOR_CHAR // As above for death.
	var/cell_threshold = 5           // Cell becomes alive with this many live neighbors.

// Automata-specific procs and processing.
/datum/random_map/automata/generate_map()
	for(var/iter = 1 to iterations)
		var/list/next_map[limit_x*limit_y]
		var/count
		var/is_not_border_left
		var/is_not_border_right
		var/ilim_u
		var/ilim_d
		var/bottom_lim = ((limit_y - 1) * limit_x)

		if (!islist(map))
			set_map_size()

		for (var/i in 1 to (limit_x * limit_y))
			count = 0

			is_not_border_left = i != 1 && ((i - 1) % limit_x)
			is_not_border_right = i % limit_x

			if (CELL_ALIVE(map[i])) // Center row.
				++count
			if (is_not_border_left && CELL_ALIVE(map[i - 1]))
				++count
			if (is_not_border_right && CELL_ALIVE(map[i + 1]))
				++count

			if (i > limit_x) // top row
				ilim_u = i - limit_x
				if (CELL_ALIVE(map[ilim_u]))
					++count
				if (is_not_border_left && CELL_ALIVE(map[ilim_u - 1]))
					++count
				if (is_not_border_right && CELL_ALIVE(map[ilim_u + 1]))
					++count

			if (i <= bottom_lim) // bottom row
				ilim_d = i + limit_x
				if (CELL_ALIVE(map[ilim_d]))
					++count
				if (is_not_border_left && CELL_ALIVE(map[ilim_d - 1]))
					++count
				if (is_not_border_right && CELL_ALIVE(map[ilim_d + 1]))
					++count

			if(count >= cell_threshold)
				REVIVE_CELL(i, next_map)
			else	// Nope. Can't be alive. Kill it.
				KILL_CELL(i, next_map)

			CHECK_TICK

		map = next_map

/datum/random_map/automata/get_additional_spawns(value, turf/T)
	return

#undef KILL_CELL
#undef REVIVE_CELL