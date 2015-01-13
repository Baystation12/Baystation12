/datum/random_map/maze
	descriptor = "maze"
	real_size = 128
	iterations = 0
	size = 4

	var/list/marked_walls = list()

/datum/random_map/maze/seed_map()
	for(var/x = 1, x <= real_size, x++)
		for(var/y = 1, y <= real_size, y++)
			map[get_map_cell(x,y)] = 2

	// Add a random cell to start the loop with.
	marked_walls |= list(list(rand(1,round(real_size/2)),rand(1,round(real_size/2))))
	iterate(1)

/datum/random_map/maze/iterate()

	// If we make this recursive BYOND freaks out, so it'll have to work as a big fat loop.
	while(marked_walls.len)

		// Grab a wall entry.
		var/index = rand(1,marked_walls.len)
		var/list/cell_data = marked_walls[index]
		marked_walls.Remove(index)
		var/x = cell_data[1]
		var/y = cell_data[2]

		// Mark as floor.
		if(within_bounds(get_map_cell(x,y)))
			map[get_map_cell(x,y)] = 1

		// Iterate over neighbors.
		if(within_bounds(get_map_cell(x,y+2)) && map[get_map_cell(x,y+2)] == 2)
			marked_walls |= list(list(x,y+2))
			map[get_map_cell(x,y+1)] = 1
		if(within_bounds(get_map_cell(x,y-2)) && map[get_map_cell(x,y-2)] == 2)
			marked_walls |= list(list(x,y-2))
			map[get_map_cell(x,y-1)] = 1
		if(within_bounds(get_map_cell(x+2,y)) && map[get_map_cell(x+2,y)] == 2)
			marked_walls |= list(list(x+2,y))
			map[get_map_cell(x+1,y)] = 1
		if(within_bounds(get_map_cell(x-2,y)) && map[get_map_cell(x-2,y)] == 2)
			marked_walls |= list(list(x-2,y))
			map[get_map_cell(x-1,y)] = 1