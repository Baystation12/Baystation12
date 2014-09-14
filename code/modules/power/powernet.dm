/datum/powernet
	var/list/cables = list()	// all cables & junctions
	var/list/nodes = list()		// all APCs & sources

	var/newload = 0
	var/load = 0
	var/newavail = 0
	var/avail = 0
	var/viewload = 0
	var/number = 0
	
	var/perapc = 0			// per-apc avilability
	var/perapc_excess = 0
	var/netexcess = 0

/datum/powernet/proc/process()
	load = newload
	newload = 0
	avail = newavail
	newavail = 0


	viewload = 0.8*viewload + 0.2*load

	viewload = round(viewload)

	var/numapc = 0

	if(nodes && nodes.len) // Added to fix a bad list bug -- TLE
		for(var/obj/machinery/power/terminal/term in nodes)
			if( istype( term.master, /obj/machinery/power/apc ) )
				numapc++

	netexcess = avail - load

	if(numapc)
		//very simple load balancing. If there was a net excess this tick then it must have been that some APCs used less than perapc, since perapc*numapc = avail
		//Therefore we can raise the amount of power rationed out to APCs on the assumption that those APCs that used less than perapc will continue to do so.
		//If that assumption fails, then some APCs will miss out on power next tick, however it will be rebalanced for the tick after.
		if (netexcess >= 0)
			perapc_excess += min(netexcess/numapc, (avail - perapc) - perapc_excess)
		else
			perapc_excess = 0
		
		perapc = avail/numapc + perapc_excess

	if( netexcess > 100)		// if there was excess power last cycle
		if(nodes && nodes.len)
			for(var/obj/machinery/power/smes/S in nodes)	// find the SMESes in the network
				if(S.powernet == src)
					S.restore()				// and restore some of the power that was used
				else
					error("[S.name] (\ref[S]) had a [S.powernet ? "different (\ref[S.powernet])" : "null"] powernet to our powernet (\ref[src]).")
					nodes.Remove(S)




//Returns the amount of available power
/datum/powernet/proc/surplus()
	return max(avail - newload, 0)

//Returns the amount of excess power (before refunding to SMESs) from last tick.
//This is for machines that might adjust their power consumption using this data.
/datum/powernet/proc/last_surplus()
	return max(avail - load, 0)

//Attempts to draw power from a powernet. Returns the actual amount of power drawn
/datum/powernet/proc/draw_power(var/requested_amount)
	var/surplus = max(avail - newload, 0)
	var/actual_draw = min(requested_amount, surplus)
	newload += actual_draw
	
	return actual_draw

// cut a powernet at this cable object
/datum/powernet/proc/cut_cable(var/obj/structure/cable/C)
	var/turf/T1 = C.loc
	if(!T1)	return
	var/node = 0
	if(C.d1 == 0)
		node = 1

	var/turf/T2
	if(C.d2)	T2 = get_step(T1, C.d2)
	if(C.d1)	T1 = get_step(T1, C.d1)


	var/list/P1 = power_list(T1, C, C.d1)	// what joins on to cut cable in dir1
	var/list/P2 = power_list(T2, C, C.d2)	// what joins on to cut cable in dir2

//	if(Debug)
//		for(var/obj/O in P1)
//			world.log << "P1: [O] at [O.x] [O.y] : [istype(O, /obj/structure/cable) ? "[O:d1]/[O:d2]" : null] "
//		for(var/obj/O in P2)
//			world.log << "P2: [O] at [O.x] [O.y] : [istype(O, /obj/structure/cable) ? "[O:d1]/[O:d2]" : null] "


	if(P1.len == 0 || P2.len == 0)//if nothing in either list, then the cable was an endpoint no need to rebuild the powernet,
		cables -= C				//just remove cut cable from the list
//		if(Debug) world.log << "Was end of cable"
		return

	//null the powernet reference of all cables & nodes in this powernet
	var/i=1
	while(i<=cables.len)
		var/obj/structure/cable/Cable = cables[i]
		if(Cable)
			Cable.powernet = null
			if(Cable == C)
				cables.Cut(i,i+1)
				continue
		i++
	i=1
	while(i<=nodes.len)
		var/obj/machinery/power/Node = nodes[i]
		if(Node)
			Node.powernet = null
		i++

	// remove the cut cable from the network
//	C.netnum = -1

	C.loc = null

	powernet_nextlink(P1[1], src)		// propagate network from 1st side of cable, using current netnum	//TODO?

	// now test to see if propagation reached to the other side
	// if so, then there's a loop in the network
	var/notlooped = 0
	for(var/O in P2)
		if( istype(O, /obj/machinery/power) )
			var/obj/machinery/power/Machine = O
			if(Machine.powernet != src)
				notlooped = 1
				break
		else if( istype(O, /obj/structure/cable) )
			var/obj/structure/cable/Cable = O
			if(Cable.powernet != src)
				notlooped = 1
				break

	if(notlooped)
		// not looped, so make a new powernet
		var/datum/powernet/PN = new()
		powernets += PN

//		if(Debug) world.log << "Was not looped: spliting PN#[number] ([cables.len];[nodes.len])"

		i=1
		while(i<=cables.len)
			var/obj/structure/cable/Cable = cables[i]
			if(Cable && !Cable.powernet)	// non-connected cables will have powernet=null, since they weren't reached by propagation
				Cable.powernet = PN
				cables.Cut(i,i+1)	// remove from old network & add to new one
				PN.cables += Cable
				continue
			i++

		i=1
		while(i<=nodes.len)
			var/obj/machinery/power/Node = nodes[i]
			if(Node && !Node.powernet)
				Node.powernet = PN
				nodes.Cut(i,i+1)
				PN.nodes[Node] = Node
				continue
			i++

	// Disconnect machines connected to nodes
	if(node)
		for(var/obj/machinery/power/P in T1)
			if(P.powernet && !P.powernet.nodes[src])
				P.disconnect_from_network()
//		if(Debug)
//			world.log << "Old PN#[number] : ([cables.len];[nodes.len])"
//			world.log << "New PN#[PN.number] : ([PN.cables.len];[PN.nodes.len])"
//
//	else
//		if(Debug)
//			world.log << "Was looped."
//		//there is a loop, so nothing to be done
//		return

/datum/powernet/proc/get_electrocute_damage()
	switch(avail)/*
		if (1300000 to INFINITY)
			return min(rand(70,150),rand(70,150))
		if (750000 to 1300000)
			return min(rand(50,115),rand(50,115))
		if (100000 to 750000-1)
			return min(rand(35,101),rand(35,101))
		if (75000 to 100000-1)
			return min(rand(30,95),rand(30,95))
		if (50000 to 75000-1)
			return min(rand(25,80),rand(25,80))
		if (25000 to 50000-1)
			return min(rand(20,70),rand(20,70))
		if (10000 to 25000-1)
			return min(rand(20,65),rand(20,65))
		if (1000 to 10000-1)
			return min(rand(10,20),rand(10,20))*/
		if (1000000 to INFINITY)
			return min(rand(50,160),rand(50,160))
		if (200000 to 1000000)
			return min(rand(25,80),rand(25,80))
		if (100000 to 200000)//Ave powernet
			return min(rand(20,60),rand(20,60))
		if (50000 to 100000)
			return min(rand(15,40),rand(15,40))
		if (1000 to 50000)
			return min(rand(10,20),rand(10,20))
		else
			return 0

/proc/powernet_nextlink(var/obj/O, var/datum/powernet/PN)
	var/list/P

	while(1)
		if( istype(O,/obj/structure/cable) )
			var/obj/structure/cable/C = O
			C.powernet = PN
			P = C.get_connections()

		else if(O.anchored && istype(O,/obj/machinery/power))
			var/obj/machinery/power/M = O
			M.powernet = PN
			P = M.get_connections()

		else
			return

		if(P.len == 0)	return

		O = P[1]

		for(var/L = 2 to P.len)
			powernet_nextlink(P[L], PN)

//The powernet that calls this proc will consume the other powernet - Rockdtben
//TODO: rewrite so the larger net absorbs the smaller net
/proc/merge_powernets(var/datum/powernet/net1, var/datum/powernet/net2)
	if(!net1 || !net2)	return
	if(net1 == net2)	return

	//We assume net1 is larger. If net2 is in fact larger we are just going to make them switch places to reduce on code.
	if(net1.cables.len < net2.cables.len)	//net2 is larger than net1. Let's switch them around
		var/temp = net1
		net1 = net2
		net2 = temp

	for(var/i=1,i<=net2.nodes.len,i++)		//merge net2 into net1
		var/obj/machinery/power/Node = net2.nodes[i]
		if(Node)
			Node.powernet = net1
			net1.nodes[Node] = Node

	for(var/i=1,i<=net2.cables.len,i++)
		var/obj/structure/cable/Cable = net2.cables[i]
		if(Cable)
			Cable.powernet = net1
			net1.cables += Cable

	del(net2)
	return net1