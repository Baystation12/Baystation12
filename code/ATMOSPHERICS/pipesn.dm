/obj/machinery/atmospherics/proc/get_init_dir()
	var/init_dir = 0
	for(var/direction in initialize_directions)
		init_dir |= direction
	return init_dir


/obj/machinery/atmospherics/proc/generate_initialize_directions(var/init_dirs)
	if(!init_dirs) init_dirs = dir

	var/list/init_directions = new()
	for(var/direction in cardinal)
		if(direction&init_dirs)
			var/angle = dir2angle(direction)
			init_directions += turn(dir,-angle)

	return init_directions


/obj/machinery/atmospherics/proc/rotate_initialize_directions_clockwise()
	var/list/new_initialize_directions = new()
	for(var/direction in initialize_directions)
		new_initialize_directions += turn(direction,-90)
	initialize_directions = new_initialize_directions


/obj/machinery/atmospherics/proc/rotate_initialize_directions_counterclockwise()
	var/list/new_initialize_directions = new()
	for(var/direction in initialize_directions)
		new_initialize_directions += turn(direction,90)
	initialize_directions = new_initialize_directions

/*
/obj/machinery/atmospherics/pipe/New()
	generate_initialize_directions(init_dirs)
	if(!update_icon())
		update_icon()
	test()
*/

/obj/machinery/atmospherics/pipe/update_icon(var/safety = 0)
	if(!check_icon_cache())
		return

	alpha = 255

	overlays.Cut()

	switch(initialize_directions.len)
		if(4)
			overlays += icon_manager.get_atmos_icon("manifold", , pipe_color, "4way" + icon_connect_type)
			overlays += icon_manager.get_atmos_icon("manifold", , , "clamps_4way" + icon_connect_type)
		if(3)
			overlays += icon_manager.get_atmos_icon("manifold", , pipe_color, "core" + icon_connect_type)
			overlays += icon_manager.get_atmos_icon("manifold", , , "clamps" + icon_connect_type)
		if(2)
			overlays += icon_manager.get_atmos_icon("underlay", get_init_dir(), pipe_color, "bent" + icon_connect_type)
		if(1)
			if(!istype(src,/obj/machinery/atmospherics/pipe/tank))
				overlays += icon_manager.get_atmos_icon("pipe", initialize_directions[1], pipe_color, "cap")
				return 1

	underlays.Cut()

	var/turf/T = get_turf(src)
	var/list/directions = initialize_directions.Copy(1,0)

	for(var/obj/machinery/atmospherics/node in nodes)
		if(node) //maybe not needed, but better oversafe than undersafe
			var/node_direction = get_dir(src, node)
			directions -= node_direction
			add_underlay(T,node,node_direction,icon_connect_type)

	for(var/D in directions)
		add_underlay(T,,D,icon_connect_type)

//	del directions