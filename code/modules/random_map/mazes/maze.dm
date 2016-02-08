/datum/random_map/maze
	descriptor = "maze"
	initial_wall_cell = 100
	var/list/checked_coord_cache = list()
	var/list/openlist = list()
	var/list/closedlist = list()

/datum/random_map/maze/set_map_size()
	// Map has to be odd so that there are walls on all sides.
	if(limit_x%2==0) limit_x++
	if(limit_y%2==0) limit_y++
	..()

/datum/random_map/maze/generate_map()

	// Grab a random point on the map to begin the maze cutting at.
	var/start_x = rand(1,limit_x-2)
	var/start_y = rand(1,limit_y-2)
	if(start_x%2!=0) start_x++
	if(start_y%2!=0) start_y++

	// Create the origin cell to start us off.
	openlist += new /datum/maze_cell(start_x,start_y)

	while(openlist.len)
		// Grab a maze point to use and remove it from the open list.
		var/datum/maze_cell/next = pick(openlist)
		openlist -= next
		if(!isnull(closedlist[next.name]))
			continue

		// Preliminary marking-off...
		closedlist[next.name] = next
		map[get_map_cell(next.x,next.y)] = FLOOR_CHAR

		// Apply the values required and fill gap between this cell and origin point.
		if(next.ox && next.oy)
			if(next.ox < next.x)
				map[get_map_cell(next.x-1,next.y)] = FLOOR_CHAR
			else if(next.ox == next.x)
				if(next.oy < next.y)
					map[get_map_cell(next.x,next.y-1)] = FLOOR_CHAR
				else
					map[get_map_cell(next.x,next.y+1)] = FLOOR_CHAR
			else
				map[get_map_cell(next.x+1,next.y)] = FLOOR_CHAR

		// Grab valid neighbors for use in the open list!
		add_to_openlist(next.x,next.y+2,next.x,next.y)
		add_to_openlist(next.x-2,next.y,next.x,next.y)
		add_to_openlist(next.x+2,next.y,next.x,next.y)
		add_to_openlist(next.x,next.y-2,next.x,next.y)

	 // Cleanup. Map stays in memory for display proc.
	checked_coord_cache.Cut()
	openlist.Cut()
	closedlist.Cut()

/datum/random_map/maze/proc/add_to_openlist(var/tx, var/ty, var/nx, var/ny)
	if(tx < 1 || ty < 1 || tx > limit_x || ty > limit_y || !isnull(checked_coord_cache["[tx]-[ty]"]))
		return 0
	checked_coord_cache["[tx]-[ty]"] = 1
	map[get_map_cell(tx,ty)] = DOOR_CHAR
	var/datum/maze_cell/new_cell = new(tx,ty,nx,ny)
	openlist |= new_cell
