
/datum/pixel_transform/proc/update_y()
	//move alobg the y axis
	//this will probably not work nicely with moving more than 1 turf at a time (visual and collision glitches)

	//apply speed
	control_object.pixel_y += round(pixel_progress_y)

	//clear out old progress
	pixel_progress_y -= round(pixel_progress_y)

	var/newy = control_object.y
	while(control_object.pixel_y > 16)
		newy += 1
		control_object.pixel_y -= 32
	while(control_object.pixel_y < -16)
		newy -= 1
		control_object.pixel_y += 32

	//if we have a separate overmap object, update it's location
	if(my_overmap_object)
		my_overmap_object.pixel_y = 32 * (control_object.y / 255) - 16

	if(newy != control_object.y)
		var/turf/newloc = locate(control_object.x, newy, control_object.z)
		var/force_space_travel = 0
		if(newloc)
			if(!control_object.Move(newloc))
				//check if we're a multitile object trying to change sector
				if(control_object.bound_height > 32)
					var/tiledims = control_object.bound_height / 32
					if(control_object.y + tiledims >= world.maxy)
						force_space_travel = 1
						newy = world.maxy
					else if(control_object.y - tiledims <= 1)
						force_space_travel = 1
						newy = 1

				if(!force_space_travel)
					//collide with something!
					pixel_speed_y = 0
					control_object.pixel_y = 0
					recalc_speed()
		else
			force_space_travel = 1

		if(force_space_travel)
			/*
			//we're at the edge of the map, force a space travel
			var/edgey = min(max(1, newy), world.maxy)
			newloc = locate(control_object.x, edgey, control_object.z)
			overmap_controller.overmap_spacetravel(newloc, control_object)

			//preserve extra progress so we don't halt at each boundary edge causing erratic skips and jumps
			//pixel_progress_y += 32 * (edgey - newy)

			//call recursively with the new progress
			*/
			return 1
	return 0
