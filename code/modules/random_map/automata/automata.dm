/datum/random_map/automata
	descriptor = "generic caves"
	initial_wall_cell = 55
	var/iterations = 0               // Number of times to apply the automata rule.
	var/cell_live_value = WALL_CHAR  // Cell is alive if it has this value.
	var/cell_dead_value = FLOOR_CHAR // As above for death.
	var/cell_threshold = 5           // Cell becomes alive with this many live neighbors.

// Automata-specific procs and processing.
/datum/random_map/automata/generate_map()
	for(var/i=1;i<=iterations;i++)
		iterate(i)

/datum/random_map/automata/get_additional_spawns(var/value, var/turf/T)
	return

/datum/random_map/automata/proc/iterate(var/iteration)
	var/list/next_map[limit_x*limit_y]
	for(var/x = 1, x <= limit_x, x++)
		for(var/y = 1, y <= limit_y, y++)
			var/current_cell = get_map_cell(x,y)
			next_map[current_cell] = map[current_cell]
			var/count = 0

			// Every attempt to place this in a proc or a list has resulted in
			// the generator being totally bricked and useless. Fuck it. We're
			// hardcoding this shit. Feel free to rewrite and PR a fix. ~ Z
			var/tmp_cell = get_map_cell(x,y)
			if(tmp_cell && cell_is_alive(map[tmp_cell])) count++
			tmp_cell = get_map_cell(x+1,y+1)
			if(tmp_cell && cell_is_alive(map[tmp_cell])) count++
			tmp_cell = get_map_cell(x-1,y-1)
			if(tmp_cell && cell_is_alive(map[tmp_cell])) count++
			tmp_cell = get_map_cell(x+1,y-1)
			if(tmp_cell && cell_is_alive(map[tmp_cell])) count++
			tmp_cell = get_map_cell(x-1,y+1)
			if(tmp_cell && cell_is_alive(map[tmp_cell])) count++
			tmp_cell = get_map_cell(x-1,y)
			if(tmp_cell && cell_is_alive(map[tmp_cell])) count++
			tmp_cell = get_map_cell(x,y-1)
			if(tmp_cell && cell_is_alive(map[tmp_cell])) count++
			tmp_cell = get_map_cell(x+1,y)
			if(tmp_cell && cell_is_alive(map[tmp_cell])) count++
			tmp_cell = get_map_cell(x,y+1)
			if(tmp_cell && cell_is_alive(map[tmp_cell])) count++

			if(count >= cell_threshold)
				revive_cell(current_cell, next_map, (iteration == iterations))
			else
				kill_cell(current_cell, next_map, (iteration == iterations))
	map = next_map

// Check if a given tile counts as alive for the automata generations.
/datum/random_map/automata/proc/cell_is_alive(var/value)
	return (value == cell_live_value) && (value != cell_dead_value)

/datum/random_map/automata/proc/revive_cell(var/target_cell, var/list/use_next_map, var/final_iter)
	if(!use_next_map)
		use_next_map = map
	use_next_map[target_cell] = cell_live_value

/datum/random_map/automata/proc/kill_cell(var/target_cell, var/list/use_next_map, var/final_iter)
	if(!use_next_map)
		use_next_map = map
	use_next_map[target_cell] = cell_dead_value