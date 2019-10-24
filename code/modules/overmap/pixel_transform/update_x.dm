
/datum/pixel_transform/proc/update_x()
	//move along the x axis
	//this will probably not work nicely with moving more than 1 turf at a time (visual and collision glitches)

	//apply speed
	control_object.pixel_x += round(pixel_progress_x)

	//clear out old progress
	pixel_progress_x -= round(pixel_progress_x)

	var/newx = control_object.x
	while(control_object.pixel_x > 16)
		newx += 1
		control_object.pixel_x -= 32
	while(control_object.pixel_x < -16)
		newx -= 1
		control_object.pixel_x += 32

	//if we have a separate overmap object, update it's location
	if(my_overmap_object)
		my_overmap_object.pixel_x = 32 * (control_object.x / 255) - 16

	if(newx != control_object.x)
		var/turf/newloc = locate(newx, control_object.y, control_object.z)
		var/force_space_travel = 0
		if(newloc)
			if(!control_object.Move(newloc))
				//check if we're a multitile object trying to change sector
				if(control_object.bound_width > 32)
					var/tiledims = control_object.bound_width / 32
					if(control_object.x + tiledims >= world.maxx)
						force_space_travel = 1
						newx = world.maxx
					else if(control_object.x - tiledims <= 1)
						force_space_travel = 1
						newx = 1

				if(!force_space_travel)
					//collide with something!
					pixel_speed_x = 0
					control_object.pixel_x = 0
					recalc_speed()
		else
			force_space_travel = 1

		if(force_space_travel)
			//we're at the edge of the map, force a space travel
			/*
			var/edgex = min(max(1, newx), world.maxx)
			newloc = locate(edgex, control_object.y, control_object.z)
			overmap_controller.overmap_spacetravel(newloc, control_object)

			//preserve extra progress so we don't halt at each boundary edge causing erratic skips and jumps
			//pixel_progress_x += 32 * (edgex - newx)

			//call recursively with the new progress
			*/
			return 1
	return 0
