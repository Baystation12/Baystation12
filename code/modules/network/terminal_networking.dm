/obj/machinery/terminal/proc/find_network()

	if(!can_add_connection())
		return 0

	var/obj/machinery/terminal/current_leader
	if(network_interface.wireless_range > 0)
		for(var/obj/machinery/terminal/T in range(get_turf(src),network_interface.wireless_range))
			if(T == src || (T in network_interface.connections) || (src in T.network_interface.connections))
				continue
			if(T.can_add_connection() && (current_leader && T.connection_priority > current_leader.connection_priority))
				current_leader = T
	if(current_leader)
		connect_to(current_leader)
	return 0

/obj/machinery/terminal/proc/connect_to(var/obj/machinery/terminal/connecting)
	sync_network_with(connecting)
	add_connection(connecting)
	connecting.add_connection(src)

/obj/machinery/terminal/proc/sync_network_with(var/obj/machinery/terminal/connecting)
	if(network && connecting.network) // merge networks.
		if(network.terminals.len > connecting.network.terminals.len)
			network.merge(connecting.network)
			connecting.network = network
		else
			connecting.network.merge(network)
			network = connecting.network
	else if(network)                  // connecting.network is null
		connecting.network = network
		network.connected(connecting)
	else if(connecting.network)       // network is null
		network = connecting.network
		network.connected(src)
	else                              // no existing network
		network = new()
		connecting.network = network
		network.connected(src)
		network.connected(connecting)

/obj/machinery/terminal/proc/add_connection(var/obj/machinery/terminal/connecting)
	if(!network_interface || !connecting)
		return 0

	if(!can_add_connection())
		return 0

	world << "[src] connected to [connecting]"
	network_interface.connections |= connecting
	return 1

/obj/machinery/terminal/proc/can_add_connection()
	return (network_interface && network_interface.can_add_connection())

/obj/machinery/terminal/proc/remove_connection(var/obj/machinery/terminal/connecting)
	if(!network_interface || !connecting)
		return 0

	world << "[src] lost connection to [connecting]"
	network_interface.connections -= connecting
	return 1

/obj/machinery/terminal/proc/recieve_network_address(var/new_address)
	if(!network_interface) //???
		return
	world << "[src] assigned network ID [new_address]"
	network_interface.address = new_address
