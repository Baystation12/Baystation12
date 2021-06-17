/obj/machinery/atmospherics/unary
	dir = SOUTH
	initialize_directions = SOUTH

	layer = ABOVE_TILE_LAYER

	var/datum/gas_mixture/air_contents

	var/obj/machinery/atmospherics/node

	var/datum/pipe_network/network

	pipe_class = PIPE_CLASS_UNARY

/obj/machinery/atmospherics/unary/Initialize()
	air_contents = new
	air_contents.volume = 200
	. = ..()

// Housekeeping and pipe network stuff below
/obj/machinery/atmospherics/unary/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(reference == node)
		network = new_network

	if(list_find(new_network.normal_members, src))
		return 0

	new_network.normal_members += src

	return null

/obj/machinery/atmospherics/unary/Destroy()
	if(node)
		node.disconnect(src)
		qdel(network)

	node = null

	. = ..()

/obj/machinery/atmospherics/unary/atmos_init()
	..()
	if(node) return

	var/node_connect = dir

	for(var/obj/machinery/atmospherics/target in get_step(src,node_connect))
		if(target.initialize_directions & get_dir(target,src))
			if (check_connect_types(target,src))
				node = target
				break

	update_icon()
	update_underlays()

/obj/machinery/atmospherics/unary/build_network()
	if(!network && node)
		network = new /datum/pipe_network()
		network.normal_members += src
		network.build_network(node, src)

/obj/machinery/atmospherics/unary/return_network(obj/machinery/atmospherics/reference)
	build_network()

	if(reference==node)
		return network

	return null

/obj/machinery/atmospherics/unary/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	if(network == old_network)
		network = new_network

	return 1

/obj/machinery/atmospherics/unary/return_network_air(datum/pipe_network/reference)
	var/list/results = list()

	if(network == reference)
		results += air_contents

	return results

/obj/machinery/atmospherics/unary/disconnect(obj/machinery/atmospherics/reference)
	if(reference==node)
		qdel(network)
		node = null

	update_icon()
	update_underlays()

	return null