// =
// = The Unified (-Type-Tree) Cable Network System
// = Written by Sukasa with assistance from Googolplexed
// =
// = Cleans up the type tree and reduces future code maintenance
// = Also makes it easy to add new cable & network types
// =

// Unified cable Network System - Generic Network Class




//TODO: Instead of forcing machines to connect to only one Unified Network for each cable type, allow them to connect to multiple
//      networks if that network type allows it (or just always?)

/var/tmp/net_uid = 0
/proc/getNetUID()
	return ++net_uid

/proc/createUnifiedNetwork(var/cable_type)
	var/unified_network/new_network = new()
	var/list/network_list = all_networks[cable_type]

	if(!network_list)
		network_list = list()
		all_networks[cable_type] = network_list

	network_list += new_network
	new_network.network_number = getNetUID()
	new_network.cable_type = cable_type

	return new_network


/unified_network
	var/datum/controller/uninet_controller/controller = null
	var/unhandled_exp_dam = 0
	var/network_number = 0
	var/list/nodes = list()
	var/list/cables = list()
	var/cable_type = null


/unified_network/proc/destroy()
	if(controller)
		controller.finalize()
		controller = null

	all_networks[cable_type] -= src
	return


/unified_network/proc/cutCable(var/obj/structure/cabling/cable)

	var/list/connected_cables = cable.cableConnections(get_step_3d(cable, cable.dir1)) | cable.cableConnections(get_step_3d(cable, cable.dir2))

	controller.removeCable(cable)

	if(!connected_cables.len)
		cables -= cable
		if(!cables.len)
			for(var/obj/node in nodes)
				if(!node.network_number)
					controller.detachNode(node)
					node.networks[cable.equivalent_cable_type] = null
					node.network_number[cable.equivalent_cable_type] = 0

			destroy()

		return

	for(var/obj/C in cables)
		C.network_number[cable.equivalent_cable_type] = 0
	for(var/obj/N in nodes)
		N.network_number[cable.equivalent_cable_type] = 0

	cable.loc = null
	cables -= cable
	if(cable in connected_cables) CRASH("cable connects to self.")

	propagateNetwork(connected_cables[1], network_number)

	connected_cables -= connected_cables[1]

	for(var/obj/structure/cabling/O in connected_cables)
		if(O.network_number[cable.equivalent_cable_type] == 0)

			var/unified_network/new_network = createUnifiedNetwork(cable.equivalent_cable_type)
			new_network.buildFrom(O, cable.network_controller_type)

			//propagateNetwork(O, new_network.network_number) [This is redundant after buildFrom(). -Aryn]

			controller.startSplit(new_network)

			for(var/obj/structure/cabling/C in new_network.cables)
				controller.removeCable(C)
				cables -= C

			for(var/obj/node in new_network.nodes)
				nodes -= node

			//buildFrom() has already given the new network its boundaries,
			//so there's no need to add here. Instead, we should take away
			//anything now governed by the split network from this one's list.
			// -Aryn

			//for(var/obj/structure/cabling/C in cables)
			//	if(!C.network_number[cable.equivalent_cable_type])
			//		new_network.addCable(C)

			//for(var/obj/Node in Nodes)
			//	if(!Node.network_number[cable.equivalent_cable_type])
			//		new_network.addNode(Node,cable)

			controller.finishSplit(new_network)

			new_network.controller.initialize()
	return


/unified_network/proc/buildFrom(var/obj/structure/cabling/start, var/controller_type = /datum/controller/uninet_controller)
	var/list/components = propagateNetwork(start, network_number)

	controller = new controller_type(src)

	for (var/obj/component in components)
		if(istype(component, /obj/structure/cabling))
			cables += component
			controller.addCable(component)
		else
			nodes += component
			controller.attachNode(component)

	controller.initialize()

	return


/unified_network/proc/propagateNetwork(var/obj/structure/cabling/start, var/new_network_number)

	var/list/connections = list()
	var/list/possibilities = list(start)

	while(possibilities.len)
		for(var/obj/structure/cabling/cable in possibilities.Copy())
			possibilities |= cable.getAllConnections(get_step_3d(cable, cable.dir1))
			possibilities |= cable.getAllConnections(get_step_3d(cable, cable.dir2))

		for(var/obj/component in possibilities.Copy())
			if(component.network_number[start.equivalent_cable_type] != new_network_number)
				component.network_number[start.equivalent_cable_type] = new_network_number
				component.networks[start.equivalent_cable_type] = src
				connections += component
				if(!istype(component, /obj/structure/cabling))
					possibilities -= component
			else
				possibilities -= component

#ifdef DEBUG
	world.log << "Created Unified Network (Type [start.equivalent_cable_type]) with [connections.len] Components from [start.x], [start.y], [start.z]"
#endif
	return connections

/unified_network/proc/addNode(var/obj/new_node, var/obj/structure/cabling/cable)
	//world << "Adding [new_node.name] to \[[cable.equivalent_cable_type]\] Network [network_number]"
	if(!istype(cable, /obj/structure/cabling))
		CRASH("Faulty second arg to addNode: [cable]")

	var/unified_network/current_network = new_node.networks[cable.equivalent_cable_type]

	if(current_network == src)
		return

	if(current_network)
		current_network.controller.detachNode(new_node)

	new_node.network_number[cable.equivalent_cable_type] = network_number
	new_node.networks[cable.equivalent_cable_type] = src

	if(current_network)
		current_network.nodes -= new_node

	nodes += new_node
	controller.attachNode(new_node)
	return

/unified_network/proc/addCable(var/obj/structure/cabling/cable)

	var/unified_network/current_network = cable.networks[cable.equivalent_cable_type]
	if(current_network == src)
		return

	if(current_network)
		current_network.controller.removeCable(cable)
	cable.network_number[cable.equivalent_cable_type] = network_number
	cable.networks[cable.equivalent_cable_type] = src
	if(current_network)
		current_network.cables -= cable
	cables += cable
	controller.addCable(cable)
	return

/unified_network/proc/cableBuilt(var/obj/structure/cabling/cable, var/list/connections)
	var/list/merge_cables = list()

	for(var/obj/structure/cabling/C in connections)
		merge_cables += C

	for(var/obj/structure/cabling/C in merge_cables)
		if(C.networks[C.equivalent_cable_type] != src)
			var/unified_network/other_network = C.networks[C.equivalent_cable_type]
			controller.beginMerge(other_network, 0)
			other_network.controller.beginMerge(src, 1)

			for (var/obj/structure/cabling/CC in other_network.cables)
				addCable(CC)

			for (var/obj/M in other_network.nodes)
				addNode(M, cable)

			controller.finishMerge()
			other_network.controller.finishMerge()
			other_network.destroy()

	for(var/obj/object in connections - merge_cables)
		addNode(object, cable)

	addCable(cable)
	controller.addCable(cable)
	cable.network_number[cable.equivalent_cable_type] = network_number
	cable.networks[cable.equivalent_cable_type] = src

	return
