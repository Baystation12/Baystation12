/datum/maze_coor // why is this necessary ugh
	var/x
	var/y

/datum/maze_coor/New(var/nx,var/ny)
	x = nx
	y = ny

/datum/random_map/maze
	descriptor = "maze"
	real_size = 128
	iterations = 3

	var/list/marked = list()

/datum/random_map/maze/seed_map()
	for(var/x = 1, x <= real_size, x++)
		for(var/y = 1, y <= real_size, y++)
			map[get_map_cell(x,y)] = 2

	// Add a random cell to start the loop with.
	var/datum/maze_coor/tcoor = new(2*rand(1,round(real_size/2)),2*rand(1,round(real_size/2)))
	var/last_x = tcoor.x
	var/last_y = tcoor.y
	marked |= tcoor

	// If we make this recursive BYOND freaks out, so it'll have to work as a big fat loop.
	var/iter_sanity = 0
	while(marked.len && iter_sanity < 5000) //Should cap out at 4096 or so, ideally.
		iter_sanity++
		sleep(-1)

		// Grab a wall entry.
		var/datum/maze_coor/coor = pick(marked)
		marked -= coor
		var/x = coor.x
		var/y = coor.y

		// Mark target tile and intermediary wall as floor.
		if(last_x && last_y)
			var/tx = (last_x < x) ? x-1 : x+1
			var/ty = (last_y < y) ? y-1 : y+1
			last_x = x
			last_y = y
			if(within_bounds(get_map_cell(tx,ty)))
				map[get_map_cell(tx,ty)] = 1
		if(within_bounds(get_map_cell(x,y)))
			map[get_map_cell(x,y)] = 1

		// Iterate over neighbors.
		if(within_bounds(get_map_cell(x,y+2)) && map[get_map_cell(x,y+2)] == 2)
			marked |= new /datum/maze_coor(x,y+2)
		if(within_bounds(get_map_cell(x,y-2)) && map[get_map_cell(x,y-2)] == 2)
			marked |= new /datum/maze_coor(x,y-2)
		if(within_bounds(get_map_cell(x+2,y)) && map[get_map_cell(x+2,y)] == 2)
			marked |= new /datum/maze_coor(x+2,y)
		if(within_bounds(get_map_cell(x-2,y)) && map[get_map_cell(x-2,y)] == 2)
			marked |= new /datum/maze_coor(x-2,y)

/datum/random_map/maze/iterate()
	var/list/next_map[raw_map_size]
	for(var/x = 1, x <= real_size, x++)
		for(var/y = 1, y <= real_size, y++)
			var/current_cell = get_map_cell(x,y)
			// Sanity check.
			if(!within_bounds(current_cell))
				continue
			// Copy over original value.
			next_map[current_cell] = map[current_cell]
			// Check all neighbors.
			var/count = 0
			if(next_map[current_cell] == 2)
				for(var/cell in list(get_map_cell(x+1,y+1),get_map_cell(x-1,y-1),get_map_cell(x+1,y-1),get_map_cell(x-1,y+1),get_map_cell(x-1,y),get_map_cell(x,y-1),get_map_cell(x+1,y),get_map_cell(x,y+1)))
					if(within_bounds(cell) && map[cell] == 1)
						count++
					if(count>= 7)
						next_map[current_cell] = 1 // becomes a floor
						break
	map = next_map


/datum/random_map/maze/apply_to_turf(var/x,var/y)
	var/current_cell = get_map_cell(x,y)
	if(!within_bounds(current_cell))
		return
	var/turf/T = locate(x,y,origin_z)
	if(map[current_cell] == 2)
		T.ChangeTurf(/turf/simulated/wall)
	else
		T.ChangeTurf(/turf/simulated/floor)

/datum/random_map/maze/cleanup()
	return 1