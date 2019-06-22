//Takes click params as input, returns a list of global x and y pixel offsets, from world zero
/proc/get_screen_pixel_click_location(var/params)
	var/screen_loc = params2list(params)["screen-loc"]
	/* This regex matches a screen-loc of the form
			"[tile_x]:[step_x],[tile_y]:[step_y]"
		given by the "params" argument of the mouse events.
	*/
	var global/regex/ScreenLocRegex = regex("(\\d+):(\\d+),(\\d+):(\\d+)")
	var/vector2/position = new /vector2(0,0)
	if(ScreenLocRegex.Find(screen_loc))
		var list/data = ScreenLocRegex.group
		//position.x = text2num(data[2]) + (text2num(data[1])) * world.icon_size
		//position.y = text2num(data[4]) + (text2num(data[3])) * world.icon_size

		position.x = text2num(data[2]) + (text2num(data[1]) - 1) * world.icon_size
		position.y = text2num(data[4]) + (text2num(data[3]) - 1) * world.icon_size

	return position


//Gets a global-context pixel location. This requires a client to use
/proc/get_global_pixel_click_location(var/params, var/client/client)
	var/vector2/world_loc = new /vector2(0,0)
	if (!client)
		return world_loc

	world_loc = get_screen_pixel_click_location(params)
	world_loc = client.ViewportToWorldPoint(world_loc)
	return world_loc


/atom/proc/get_global_pixel_loc()
	return new /vector2(((x-1)*world.icon_size) + pixel_x + 16, ((y-1)*world.icon_size) + pixel_y + 16)



//Given a set of global pixel coords as input, this moves the atom and sets its pixel offsets so that it sits exactly on the specified point
/atom/movable/proc/set_global_pixel_loc(var/vector2/coords)

	var/vector2/tilecoords = new /vector2(round(coords.x / world.icon_size)+1, round(coords.y / world.icon_size)+1)
	forceMove(locate(tilecoords.x, tilecoords.y, z))
	pixel_x = (coords.x % world.icon_size)-16
	pixel_y = (coords.y % world.icon_size)-16


//Takes pixel coordinates relative to a tile. Returns true if those coords would offset an object to outside the tile
/proc/is_outside_cell(var/vector2/newpix)
	if (newpix.x < -16 || newpix.x > 16 || newpix.y < -16 || newpix.y > 16)
		return TRUE

//Takes pixel coordinates relative to a tile. Returns true if those coords would offset an object to more than 8 pixels into an adjacent tile
/proc/is_far_outside_cell(var/vector2/newpix)
	if (newpix.x < -24 || newpix.x > 24 || newpix.y < -24 || newpix.y > 24)
		return TRUE


//Given a pixel offset relative to this atom, finds the turf under the target point.
//This does not account for the object's existing pixel offsets, roll them into the input first if you wish
/atom/proc/get_turf_at_pixel_offset(var/vector2/newpix)
	//First lets just get the global pixel position of where this atom+newpix is
	var/vector2/new_global_pixel_loc = new /vector2(((x-1)*world.icon_size) + newpix.x + 16, ((y-1)*world.icon_size) + newpix.y + 16)

	return get_turf_at_pixel_coords(new_global_pixel_loc, z)



//Global version of the above, requires a zlevel to check on
/proc/get_turf_at_pixel_coords(var/vector2/coords, var/zlevel)
	coords = new /vector2(round(coords.x / world.icon_size)+1, round(coords.y / world.icon_size)+1)
	return locate(coords.x, coords.y, zlevel)