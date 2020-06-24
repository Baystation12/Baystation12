/obj/machinery/atmospherics/trinary
	dir = SOUTH
	initialize_directions = SOUTH|NORTH|WEST
	use_power = POWER_USE_OFF

	var/datum/gas_mixture/air1
	var/datum/gas_mixture/air2
	var/datum/gas_mixture/air3

	var/obj/machinery/atmospherics/node3

	var/datum/pipe_network/network1
	var/datum/pipe_network/network2
	var/datum/pipe_network/network3

	pipe_class = PIPE_CLASS_TRINARY
	connect_dir_type = SOUTH | NORTH | WEST

/obj/machinery/atmospherics/trinary/Initialize()
	air1 = new
	air2 = new
	air3 = new

	air1.volume = 200
	air2.volume = 200
	air3.volume = 200
	. = ..()

// Housekeeping and pipe network stuff below
/obj/machinery/atmospherics/trinary/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(reference == node1)
		network1 = new_network

	else if(reference == node2)
		network2 = new_network

	else if (reference == node3)
		network3 = new_network

	if(new_network.normal_members.Find(src))
		return 0

	new_network.normal_members += src

	return null

/obj/machinery/atmospherics/trinary/Destroy()
	if(node1)
		node1.disconnect(src)
		qdel(network1)
	if(node2)
		node2.disconnect(src)
		qdel(network2)
	if(node3)
		node3.disconnect(src)
		qdel(network3)

	node1 = null
	node2 = null
	node3 = null

	return ..()

/obj/machinery/atmospherics/trinary/atmos_init()
	..()
	if(node1 && node2 && node3) return

	var/node1_connect = turn(dir, -180)
	var/node2_connect = turn(dir, -90)
	var/node3_connect = dir

	for(var/obj/machinery/atmospherics/target in get_step(src,node1_connect))
		if(target.initialize_directions & get_dir(target,src))
			if (check_connect_types(target,src))
				node1 = target
				break

	for(var/obj/machinery/atmospherics/target in get_step(src,node2_connect))
		if(target.initialize_directions & get_dir(target,src))
			if (check_connect_types(target,src))
				node2 = target
				break
	for(var/obj/machinery/atmospherics/target in get_step(src,node3_connect))
		if(target.initialize_directions & get_dir(target,src))
			if (check_connect_types(target,src))
				node3 = target
				break

	update_icon()
	update_underlays()

/obj/machinery/atmospherics/trinary/build_network()
	if(!network1 && node1)
		network1 = new /datum/pipe_network()
		network1.normal_members += src
		network1.build_network(node1, src)

	if(!network2 && node2)
		network2 = new /datum/pipe_network()
		network2.normal_members += src
		network2.build_network(node2, src)

	if(!network3 && node3)
		network3 = new /datum/pipe_network()
		network3.normal_members += src
		network3.build_network(node3, src)

/obj/machinery/atmospherics/trinary/return_network(obj/machinery/atmospherics/reference)
	build_network()

	if(reference==node1)
		return network1

	if(reference==node2)
		return network2

	if(reference==node3)
		return network3

	return null

/obj/machinery/atmospherics/trinary/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	if(network1 == old_network)
		network1 = new_network
	if(network2 == old_network)
		network2 = new_network
	if(network3 == old_network)
		network3 = new_network

	return 1

/obj/machinery/atmospherics/trinary/return_network_air(datum/pipe_network/reference)
	var/list/results = list()

	if(network1 == reference)
		results += air1
	if(network2 == reference)
		results += air2
	if(network3 == reference)
		results += air3

	return results

/obj/machinery/atmospherics/trinary/disconnect(obj/machinery/atmospherics/reference)
	if(reference==node1)
		qdel(network1)
		node1 = null

	else if(reference==node2)
		qdel(network2)
		node2 = null

	else if(reference==node3)
		qdel(network3)
		node3 = null

	update_underlays()

	return null
