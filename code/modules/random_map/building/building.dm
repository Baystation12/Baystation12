/datum/random_map/building
	descriptor = "generic room"
	limit_x = 7
	limit_y = 7

/datum/random_map/building/generate_map()
	for(var/x = 1, x <= limit_x, x++)
		for(var/y = 1, y <= limit_y, y++)
			var/current_cell = get_map_cell(x,y)
			if(!current_cell)
				continue
			if(x == 1 || y == 1 || x == limit_x || y == limit_y)
				map[current_cell] = WALL_CHAR
			else
				map[current_cell] = FLOOR_CHAR

/datum/random_map/building/handle_post_overlay_on(var/datum/random_map/target_map, var/tx, var/ty)
	var/list/possible_doors
	for(var/x = 1, x <= limit_x, x++)
		for(var/y = 1, y <= limit_y, y++)
			var/current_cell = get_map_cell(x,y)
			if(!current_cell)
				continue
			if(!(x == 1 || y == 1 || x == limit_x || y == limit_y))
				continue
			if(tx+x > target_map.limit_x)
				continue
			if(ty+y > target_map.limit_y)
				continue

			var/place_door
			// #.# ... .## ##.
			// #X# #X# .X. .X. == place a door
			// ... # # .## ##.

			// (tx+x)-1,(ty+y-1)     (tx+x),(ty+y)-1     (tx+x)+1,(ty+y)-1
			// (tx+x)-1,(ty+y)       (tx+x),(ty+y)       (tx+x)+1,(ty+y)
			// (tx+x)-1,(ty+y+1)     (tx+x),(ty+y)+1     (tx+x)+1,(ty+y)+1


			if(place_door)
				possible_doors |= target_map.get_map_cell(tx+x,ty+y)

	if(possible_doors.len)
		// Place at least one door.
		var/placing_door = pick(possible_doors)
		possible_doors -= placing_door
		target_map.map[placing_door] = DOOR_CHAR
		// Keep placing doors until we get bored or lose interest.
		while(possible_doors && !prob(30))
			placing_door = pick(possible_doors)
			possible_doors -= placing_door
			target_map.map[placing_door] = DOOR_CHAR

	return