/datum/build_mode/room_builder
	name = "Room Builder"
	icon_state = "buildmode5"

	var/turf/coordinate_A
	var/turf/coordinate_B

	var/floor_type = /turf/simulated/floor/plating
	var/wall_type = /turf/simulated/wall

/datum/build_mode/room_builder/Help()
	to_chat(user, "<span class='notice'>***********************************************************</span>")
	to_chat(user, "<span class='notice'>Left Click on Turf               = Select as point A</span>")
	to_chat(user, "<span class='notice'>Right Click on Turf              = Select as point B</span>")
	to_chat(user, "<span class='notice'>As soon as both points have been selected, the room is created.</span>")
	to_chat(user, "")
	to_chat(user, "<span class='notice'>Right Click on Build Mode Button = Change floor/wall type</span>")
	to_chat(user, "<span class='notice'>***********************************************************</span>")

/datum/build_mode/room_builder/Configurate()
	var/choice = alert("Would you like to set the floor or wall type?", name, "Floor", "Wall", "Cancel")
	switch(choice)
		if("Floor")
			floor_type = select_subpath(floor_type) || floor_type
			to_chat(user, "<span class='notice'>Floor type set to [floor_type].</span>")
		if("Wall")
			wall_type = select_subpath(wall_type) || wall_type
			to_chat(user, "<span class='notice'>Wall type set to [wall_type].</span>")

/datum/build_mode/room_builder/OnClick(var/atom/A, var/list/parameters)
	if(parameters["left"])
		coordinate_A = get_turf(A)
		to_chat(user, "<span class='notice'>Defined [coordinate_A] ([coordinate_A.type]) as point A.</span>")
	if(parameters["right"])
		coordinate_B = get_turf(A)
		to_chat(user, "<span class='notice'>Defined [coordinate_B] ([coordinate_B.type]) as point B.</span>")

	if(coordinate_A && coordinate_B)
		to_chat(user, "<span class='notice'>Room coordinates set. Building room.</span>")
		Log("Created a room with wall type [wall_type] and floor type [floor_type] from [log_info_line(coordinate_A)] to [log_info_line(coordinate_B)]")
		make_rectangle(coordinate_A, coordinate_B, wall_type, floor_type)
		coordinate_A = null
		coordinate_B = null

/datum/build_mode/room_builder/proc/make_rectangle(var/turf/A, var/turf/B, var/turf/wall_type, var/turf/floor_type)
	if(!A || !B) // No coords
		return
	if(A.z != B.z) // Not same z-level
		return

	var/height = A.y - B.y
	var/width = A.x - B.x
	var/z_level = A.z

	var/turf/lower_left_corner = null
	// First, try to find the lowest part
	var/desired_y = 0
	if(A.y <= B.y)
		desired_y = A.y
	else
		desired_y = B.y

	//Now for the left-most part.
	var/desired_x = 0
	if(A.x <= B.x)
		desired_x = A.x
	else
		desired_x = B.x

	lower_left_corner = locate(desired_x, desired_y, z_level)

	// Now we can begin building the actual room.  This defines the boundries for the room.
	var/low_bound_x = lower_left_corner.x
	var/low_bound_y = lower_left_corner.y

	var/high_bound_x = lower_left_corner.x + abs(width)
	var/high_bound_y = lower_left_corner.y + abs(height)

	for(var/i = low_bound_x, i <= high_bound_x, i++)
		for(var/j = low_bound_y, j <= high_bound_y, j++)
			var/turf/T = locate(i, j, z_level)
			if(i == low_bound_x || i == high_bound_x || j == low_bound_y || j == high_bound_y)
				if(ispath(wall_type, /turf))
					T.ChangeTurf(wall_type)
				else
					new wall_type(T)
			else
				if(ispath(floor_type, /turf))
					T.ChangeTurf(floor_type)
				else
					new floor_type(T)
