//Takes click params as input, returns a list of global x and y pixel offsets, from world zero
/proc/get_world_pixel_click_location(var/params)
	var/screen_loc = params2list(params)["screen-loc"]
	/* This regex matches a screen-loc of the form
			"[tile_x]:[step_x],[tile_y]:[step_y]"
		given by the "params" argument of the mouse events.
	*/
	var global/regex/ScreenLocRegex = regex("(\\d+):(\\d+),(\\d+):(\\d+)")
	var/list/position = list(0,0)
	if(ScreenLocRegex.Find(screen_loc))
		var list/data = ScreenLocRegex.group
		position = list(
			text2num(data[2]) + (text2num(data[1]) - 1) * world.icon_size,
			text2num(data[4]) + (text2num(data[3]) - 1) * world.icon_size
		)

	return position




