
/datum/pixel_transform/proc/turn_to_dir(var/target_dir, var/max_degrees)

	var/rotate_angle = shortest_angle_to_dir(heading, target_dir, max_degrees)
	var/new_heading = heading + rotate_angle

	var/old_heading = heading

	//change the heading
	heading = new_heading
	while(heading >= 360)
		heading -= 360
	while(heading < 0)
		heading += 360

	//return the number of degrees travelled as a clockwise value
	var/degrees_travelled = new_heading - old_heading
	/*while(degrees_travelled < 0)
		degrees_travelled += 360*/

	//rotate the sprite
	if(control_object)

		var/matrix/M = matrix()
		M.Turn(heading)
		control_object.transform = M

		if(my_overmap_object)
			my_overmap_object.transform = M

	return degrees_travelled
