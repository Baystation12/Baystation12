// For straight pipes
/proc/rotate_pipe_straight(var/newdir)
	switch(newdir)
		if(SOUTH)
			return NORTH
		if(WEST)
			return EAST
		if(NORTHWEST)
			return NORTH
		if(NORTHEAST)
			return EAST
		if(SOUTHWEST)
			return NORTH
		if(SOUTHEAST)
			return EAST
	return newdir

/proc/connect(var/obj/machinery/atmospherics/reference1,var/obj/machinery/atmospherics/reference2)
	var/return_val
	if(reference1 && reference1.nodes && !reference1.nodes.Find(reference2))
		reference1.nodes += reference2
		reference1.build_network()
		return_val = 1
	else
		return_val = 0
	if(reference2 && reference2.nodes && !reference2.nodes.Find(reference1))
		reference2.nodes += reference1
		reference2.build_network()
		return_val = 1
	else
		return_val = 0

	reference1.update_icon()
	reference2.update_icon()

	return return_val

/proc/disconnect(var/obj/machinery/atmospherics/reference1,var/obj/machinery/atmospherics/reference2)
	var/return_val
	if(reference1 && reference1.nodes && reference1.nodes.Find(reference2))
		reference1.nodes -= reference2
		reference1.build_network()
		return_val = 1
	else
		return_val = 0
	if(reference2 && reference2.nodes && reference2.nodes.Find(reference1))
		reference2.nodes -= reference1
		reference2.build_network()
		return_val = 1
	else
		return_val = 0

	reference1.update_icon()
	reference2.update_icon()

	return return_val


proc/disconnect_all(var/obj/machinery/atmospherics/reference)
	for(var/obj/machinery/atmospherics/node in reference.nodes)
		if(node) //maybe not needed, but better oversafe than undersafe
			disconnect(reference, node)
