/datum/build_mode/room_builder
	name = "Room Builder"
	icon_state = "buildmode5"

	var/turf/coordinate_A
	var/turf/coordinate_B

	var/floor_type = /turf/simulated/floor/plating
	var/wall_type = /turf/simulated/wall

/datum/build_mode/room_builder/Help()
	to_chat(user, SPAN_NOTICE("***********************************************************"))
	to_chat(user, SPAN_NOTICE("Left Click on Turf               = Select as point A"))
	to_chat(user, SPAN_NOTICE("Right Click on Turf              = Select as point B"))
	to_chat(user, SPAN_NOTICE("While Holding Shift              = Place ONLY floor"))
	to_chat(user, SPAN_NOTICE("While Holding Ctrl               = Place ONLY walls"))
	to_chat(user, SPAN_NOTICE("As soon as both points have been selected, the room is created."))
	to_chat(user, "")
	to_chat(user, SPAN_NOTICE("Right Click on Build Mode Button = Change floor/wall type"))
	to_chat(user, SPAN_NOTICE("***********************************************************"))

/datum/build_mode/room_builder/Configurate()
	var/choice = alert("Would you like to set the floor or wall type?", name, "Floor", "Wall", "Cancel")
	switch(choice)
		if("Floor")
			floor_type = select_subpath(floor_type) || floor_type
			to_chat(user, SPAN_NOTICE("Floor type set to [floor_type]."))
		if("Wall")
			wall_type = select_subpath(wall_type) || wall_type
			to_chat(user, SPAN_NOTICE("Wall type set to [wall_type]."))

/datum/build_mode/room_builder/OnClick(var/atom/A, var/list/parameters)
	if(parameters["left"])
		coordinate_A = get_turf(A)
		to_chat(user, SPAN_NOTICE("Defined [coordinate_A] ([coordinate_A.type]) as point A."))
	if(parameters["right"])
		coordinate_B = get_turf(A)
		to_chat(user, SPAN_NOTICE("Defined [coordinate_B] ([coordinate_B.type]) as point B."))

	if(coordinate_A && coordinate_B)
		to_chat(user, SPAN_NOTICE("Room coordinates set. Building room."))
		Log("Created a room with wall type [wall_type] and floor type [floor_type] from [log_info_line(coordinate_A)] to [log_info_line(coordinate_B)]")
		var/list/coords = make_rectangle(coordinate_A, coordinate_B)
		make_room(coords[1], coords[2], coords[3], coords[4], coords[5], wall_type, floor_type, parameters["shift"], parameters["ctrl"])
		coordinate_A = null
		coordinate_B = null

/datum/build_mode/room_builder/proc/make_room(low_bound_x, low_bound_y, high_bound_x, high_bound_y, z_level, turf/wall_type, turf/floor_type, only_walls, only_floors)
	for(var/i = low_bound_x, i <= high_bound_x, i++)
		for(var/j = low_bound_y, j <= high_bound_y, j++)
			var/turf/T = locate(i, j, z_level)
			if(!only_floors && (i == low_bound_x || i == high_bound_x || j == low_bound_y || j == high_bound_y))
				if(ispath(wall_type, /turf))
					T.ChangeTurf(wall_type)
				else
					new wall_type(T)
			else if (!only_walls)
				if(ispath(floor_type, /turf))
					T.ChangeTurf(floor_type)
				else
					new floor_type(T)
