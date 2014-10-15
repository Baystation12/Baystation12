/datum/powernet
	var/list/cables = list()	// all cables & junctions
	var/list/nodes = list()		// all connected machines

	var/load = 0				// the current load on the powernet, increased by each machine at processing
	var/newavail = 0			// what available power was gathered last tick, then becomes...
	var/avail = 0				//...the current available power in the powernet
	var/viewload = 0			// the load as it appears on the power console (gradually updated)
	var/number = 0				// Unused //TODEL
	var/netexcess = 0			// excess power on the powernet (typically avail-load)

/datum/powernet/New()
	powernets += src

/datum/powernet/Del()
	powernets -= src

/datum/powernet/proc/draw_power(var/amount)
	var/draw = min(amount, avail - load, 0)
	load += draw
	return draw

/datum/powernet/proc/is_empty()
	return !cables.len && !nodes.len

//remove a cable from the current powernet
//if the powernet is then empty, delete it
//Warning : this proc DON'T check if the cable exists
/datum/powernet/proc/remove_cable(var/obj/structure/cable/C)
	cables -= C
	C.powernet = null
	if(is_empty())//the powernet is now empty...
		del(src)///... delete it - qdel

//add a cable to the current powernet
//Warning : this proc DON'T check if the cable exists
/datum/powernet/proc/add_cable(var/obj/structure/cable/C)
	if(C.powernet)// if C already has a powernet...
		if(C.powernet == src)
			return
		else
			C.powernet.remove_cable(C) //..remove it
	C.powernet = src
	cables +=C

//remove a power machine from the current powernet
//if the powernet is then empty, delete it
//Warning : this proc DON'T check if the machine exists
/datum/powernet/proc/remove_machine(var/obj/machinery/power/M)
	nodes -=M
	M.powernet = null
	if(is_empty())//the powernet is now empty...
		del(src)///... delete it - qdel


//add a power machine to the current powernet
//Warning : this proc DON'T check if the machine exists
/datum/powernet/proc/add_machine(var/obj/machinery/power/M)
	if(M.powernet)// if M already has a powernet...
		if(M.powernet == src)
			return
		else
			M.disconnect_from_network()//..remove it
	M.powernet = src
	nodes[M] = M

//handles the power changes in the powernet
//called every ticks by the powernet controller
/datum/powernet/proc/reset()

	//see if there's a surplus of power remaining in the powernet and stores unused power in the SMES
	netexcess = avail - load

	if(netexcess > 100 && nodes && nodes.len)		// if there was excess power last cycle
		for(var/obj/machinery/power/smes/S in nodes)	// find the SMESes in the network
			S.restore()				// and restore some of the power that was used

	//updates the viewed load (as seen on power computers)
	viewload = 0.8*viewload + 0.2*load
	viewload = round(viewload)

	//reset the powernet
	load = 0
	avail = newavail
	newavail = 0

/datum/powernet/proc/get_electrocute_damage()
	switch(avail)
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

////////////////////////////////////////////////
// Misc.
///////////////////////////////////////////////


// return a knot cable (O-X) if one is present in the turf
// null if there's none
/turf/proc/get_cable_node()
	if(!istype(src, /turf/simulated/floor))
		return null
	for(var/obj/structure/cable/C in src)
		if(C.d1 == 0)
			return C
	return null

/area/proc/get_apc()
	for(var/area/RA in src.related)
		var/obj/machinery/power/apc/FINDME = locate() in RA
		if (FINDME)
			return FINDME