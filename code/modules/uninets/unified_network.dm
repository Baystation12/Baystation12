// =
// = The Unified (-Type-Tree) Cable Network System
// = Written by Sukasa with assistance from Googolplexed
// =
// = Cleans up the type tree and reduces future code maintenance
// = Also makes it easy to add new link & network types
// =

// Unified link Network System - Generic Network Class




//TODO: Instead of forcing machines to connect to only one Unified Network for each link type, allow them to connect to multiple
//      networks if that network type allows it (or just always?)

/var/tmp/net_uid = 0
/proc/getNetUID()
	return ++net_uid

/proc/createUnifiedNetwork(var/link_type)
	var/unified_network/new_network = new()
	var/list/network_list = all_networks[link_type]

	if(!network_list)
		network_list = list()
		all_networks[link_type] = network_list

	network_list += new_network
	new_network.network_number = getNetUID()
	new_network.link_type = link_type

	return new_network

/proc/countUnifiedNetworks()
	var/count = 0
	for(var/key in all_networks)
		var/list/network_list = all_networks[key]
		if(network_list)
			count += network_list.len
	return count

/unified_network
	var/datum/controller/uninet_controller/controller = null
	var/unhandled_exp_dam = 0
	var/network_number = 0
	var/list/nodes = list()
	var/list/links = list()
	var/link_type = null


/unified_network/proc/destroy()
	if(controller)
		controller.finalize()
		controller = null

	all_networks[link_type] -= src
	return


/unified_network/proc/delLink(var/obj/structure/uninet_link/link)

	var/list/connected_links = link.linkConnections(get_step_3d(link, link.dir1)) | link.linkConnections(get_step_3d(link, link.dir2))

	controller.removeLinks(link)

	if(!connected_links.len)
		links -= link
		if(!links.len)
			for(var/obj/node in nodes)
				if(!node.network_number)
					controller.detachNode(node)
					node.networks[link.equivalent_link_type] = null
					node.network_number[link.equivalent_link_type] = 0

			destroy()

		return

	for(var/obj/C in links)
		C.network_number[link.equivalent_link_type] = 0
	for(var/obj/N in nodes)
		N.network_number[link.equivalent_link_type] = 0

	link.loc = null
	links -= link
	if(link in connected_links) CRASH("link connects to self.")

	propagateNetwork(connected_links[1], network_number)

	connected_links -= connected_links[1]

	for(var/obj/structure/uninet_link/O in connected_links)
		if(O.network_number[link.equivalent_link_type] == 0)

			var/unified_network/new_network = createUnifiedNetwork(link.equivalent_link_type)
			new_network.buildFrom(O, link.network_controller_type)

			//propagateNetwork(O, new_network.network_number) [This is redundant after buildFrom(). -Aryn]

			controller.startSplit(new_network)

			for(var/obj/structure/uninet_link/C in new_network.links)
				controller.removeLinks(C)
				links -= C

			for(var/obj/node in new_network.nodes)
				nodes -= node

			//buildFrom() has already given the new network its boundaries,
			//so there's no need to add here. Instead, we should take away
			//anything now governed by the split network from this one's list.
			// -Aryn

			//for(var/obj/structure/uninet_link/C in links)
			//	if(!C.network_number[link.equivalent_link_type])
			//		new_network.addLink(C)

			//for(var/obj/Node in Nodes)
			//	if(!Node.network_number[link.equivalent_link_type])
			//		new_network.addNode(Node,link)

			controller.finishSplit(new_network)

			new_network.controller.initialize()
	return


/unified_network/proc/buildFrom(var/obj/structure/uninet_link/start, var/controller_type = /datum/controller/uninet_controller)
	var/list/components = propagateNetwork(start, network_number)

	controller = new controller_type(src)

	for (var/obj/component in components)
		if(istype(component, /obj/structure/uninet_link))
			links += component
			controller.addLink(component)
		else
			nodes += component
			controller.attachNode(component)

	controller.initialize()

	return


/unified_network/proc/propagateNetwork(var/obj/structure/uninet_link/start, var/new_network_number)

	var/list/connections = list()
	var/list/possibilities = list(start)

	while(possibilities.len)
		for(var/obj/structure/uninet_link/link in possibilities.Copy())
			possibilities |= link.getAllConnections(get_step_3d(link, link.dir1))
			possibilities |= link.getAllConnections(get_step_3d(link, link.dir2))

		for(var/obj/component in possibilities.Copy())
			if(component.network_number[start.equivalent_link_type] != new_network_number)
				component.network_number[start.equivalent_link_type] = new_network_number
				component.networks[start.equivalent_link_type] = src
				connections += component
				if(!istype(component, /obj/structure/uninet_link))
					possibilities -= component
			else
				possibilities -= component

	log_debug("Created Unified Network (Type [start.equivalent_link_type]) with [connections.len] Components from [start.x], [start.y], [start.z]")
	return connections

/unified_network/proc/addNode(var/obj/new_node, var/obj/structure/uninet_link/link)
	//world << "Adding [new_node.name] to \[[link.equivalent_link_type]\] Network [network_number]"
	if(!istype(link, /obj/structure/uninet_link))
		CRASH("Faulty second arg to addNode: [link]")

	var/unified_network/current_network = new_node.networks[link.equivalent_link_type]

	if(current_network == src)
		return

	if(current_network)
		current_network.controller.detachNode(new_node)

	new_node.network_number[link.equivalent_link_type] = network_number
	new_node.networks[link.equivalent_link_type] = src

	if(current_network)
		current_network.nodes -= new_node

	nodes += new_node
	controller.attachNode(new_node)
	return

/unified_network/proc/addLink(var/obj/structure/uninet_link/link)

	var/unified_network/current_network = link.networks[link.equivalent_link_type]
	if(current_network == src)
		return

	if(current_network)
		current_network.controller.removeLinks(link)
	link.network_number[link.equivalent_link_type] = network_number
	link.networks[link.equivalent_link_type] = src
	if(current_network)
		current_network.links -= link
	links += link
	controller.addLink(link)
	return

/unified_network/proc/linkBuilt(var/obj/structure/uninet_link/link, var/list/connections)
	var/list/merge_links = list()

	for(var/obj/structure/uninet_link/C in connections)
		merge_links += C

	for(var/obj/structure/uninet_link/C in merge_links)
		if(C.networks[C.equivalent_link_type] != src)
			var/unified_network/other_network = C.networks[C.equivalent_link_type]
			controller.beginMerge(other_network, 0)
			other_network.controller.beginMerge(src, 1)

			for (var/obj/structure/uninet_link/CC in other_network.links)
				addLink(CC)

			for (var/obj/M in other_network.nodes)
				addNode(M, link)

			controller.finishMerge()
			other_network.controller.finishMerge()
			other_network.destroy()

	for(var/obj/object in connections - merge_links)
		addNode(object, link)

	addLink(link)
	controller.addLink(link)
	link.network_number[link.equivalent_link_type] = network_number
	link.networks[link.equivalent_link_type] = src

	return
