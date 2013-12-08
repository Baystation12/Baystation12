//Definitons to allow the base /obj/machinery class to use networking.

/obj/machinery
	var/use_networking = 0
	var/ip_addr/net_address = null
	var/net_state = NET_MCH_STATE_NONE

	var/obj/machinery/networking/connected_parent = null

	//Small cache for the IP; if a machine disconnects and then reconnects later it will try first to get this IP.
	var/ip_addr/last_ip = null

//Default implementation tries to find an ANC on localnet, then wirelessnet, and tries to connect to it.
/obj/machinery/proc/setup_network()
	if(!use_networking)
		return 0 //This machine doesn't use networking. (probably)
	if(!get_area(src))
		return 0 //Needs to exist somewhere in the world.

	var/obj/machinery/networking/anc/conn_anc = null
	var/method = 0 //1: wired, 2: wireless

	//if(localcablestuff... [TODO]
	if(0)
		world << "WHAT."
	else
		if(NET_WIRELESS_ANC_TO_DEVICES == -1) //Just check area.
			conn_anc = locate(/obj/machinery/networking/anc) in get_area(src)
			if(conn_anc)
				method = 2
		else
			//Run through all ANCs on the current zlevel, getting the ANC with the smallest circular distance.
			var/best_dist = NET_WIRELESS_ANC_TO_DEVICES+1
			for(var/obj/machinery/networking/anc/find_anc in ancs_by_zlevel[num2text(src.z)])
				if(round(distance2p(src.x, src.y, find_anc.x, find_anc.y)) < best_dist)
					conn_anc = find_anc
			if(conn_anc)
				method = 2

	if(!conn_anc) //We can find no way to connect to an ANC, quitting.
		return 0

	//conn_anc.connect_child(src)

