// =
// = The Unified (-Type-Tree) Cable Network System
// = Written by Sukasa with assistance from Googolplexed
// =
// = Cleans up the type tree and reduces future code maintenance
// = Also makes it easy to add new cable & network types
// =

// Unified cable Network System - Generic cable Class

/var/list/equiv_cable_type_lookup = list()
/var/list/coil_to_cable_lookup = list()
/var/list/cable_to_coil_lookup = list()
/var/list/list/cable_connectables_lookup = list()

/hook/startup/proc/createUninetLookups()
	generateCablingLookups(/obj/structure/uninet_link/cable)
	return 1

//Recursive function to generate values for the lookup lists.
/proc/generateCablingLookups(var/cable_type)
	for(var/check_type in (typesof(cable_type) - cable_type))
		var/obj/structure/uninet_link/cable/cable = new check_type(null)

		equiv_cable_type_lookup[check_type] = cable.equivalent_cable_type
		if(cable.cable_piece_type && !coil_to_cable_lookup[cable.cable_piece_type])
			coil_to_cable_lookup[cable.cable_piece_type] = check_type
			cable_to_coil_lookup[check_type] = cable.cable_piece_type
		cable_connectables_lookup[check_type] = cable.connectable_types.Copy()

		generateCablingLookups(check_type)
	return


/obj/structure/uninet_link/cable
	icon_state = "0-1"
	layer = 2.5
	level = 1
	anchored = 1

	var/dir1 = 0
	var/dir2 = 0
	var/list/connectable_types = list( /obj/machinery )
	var/network_controller_type = /datum/controller/uninet_controller
	var/cable_piece_type = null
	var/equivalent_cable_type = /obj/structure/uninet_link/cable


/obj/structure/uninet_link/cable/New(var/loc, var/new_dir_1 = -1, var/new_dir_2 = -1)
	if(!loc)
		return

	..(loc)

	var/dash = findtext(icon_state, "-")

	if(new_dir_1 != -1)
		dir1 = new_dir_1
	else
		dir1 = text2num(copytext( icon_state, 1, dash))

	if(new_dir_2 != -1)
		dir2 = new_dir_2
	else
		dir2 = text2num(copytext( icon_state, dash + 1))

	if(level == 1)
		var/turf/T = src.loc
		hide(!T.is_plating())

	if(ticker)
		var/list/P = getAllConnections(get_step_3d(loc, dir1), 1) | getAllConnections(get_step_3d(loc, dir2), 1)

		if(locate(/obj/structure/uninet_link/cable) in P)
			var/obj/structure/uninet_link/cable/cable = locate(/obj/structure/uninet_link/cable) in P
			var/unified_network/new_network = cable.networks[cable.equivalent_cable_type]
			new_network.cableBuilt(src, P)
		else
			var/unified_network/new_network = createUnifiedNetwork(equivalent_cable_type)
			new_network.buildFrom(src, network_controller_type)
	return


/obj/structure/uninet_link/cable/proc/userTouched(var/mob/user)
	var/unified_network/network = networks[link_type]
	network.controller.linkTouched(src, user)
	return


/obj/structure/uninet_link/cable/hide(var/intact)
	if(!istype(loc, /turf/space) && level == 1)
		invisibility = intact ? 101 : 0
	update_icon()
	return


/obj/structure/uninet_link/cable/update_icon()
	icon_state = "[dir1]-[dir2][invisibility?"-f":""]"
	return


/obj/structure/uninet_link/cable/Del()
	destroy()
	..()


//GC del
/obj/structure/uninet_link/cable/proc/destroy()
	if(!defer_uninet_rebuild)
		var/unified_network/network = networks[equivalent_cable_type]
		if(network)
			network.cutCable(src)
	loc = null
	return


/obj/structure/uninet_link/cable/proc/cableConnections(var/turf/target, var/include_already_connected = 0)
	var/list/cables = list()
	var/Direction = get_dir_3d(target, src)

	for(var/obj/structure/uninet_link/cable/cable in target)
		if((!include_already_connected || !cable.network_number[equivalent_cable_type]) && cable.equivalent_cable_type == equivalent_cable_type)
			if(cable.dir1 == Direction || cable.dir2 == Direction)
				cables += cable

	cables -= src
	return cables


/obj/structure/uninet_link/cable/proc/getAllConnections(var/turf/target, var/include_already_connected = 0)
	var/list/connections = list( )
	var/direction = get_dir_3d(target, src)

	for(var/obj/structure/uninet_link/cable/cable in target)
		if((include_already_connected || !cable.network_number[equivalent_cable_type]) && cable.equivalent_cable_type == equivalent_cable_type)
			if(cable.dir1 == direction || cable.dir2 == direction)
				connections += cable

	direction = reverse_dir_3d(direction)

	for(var/obj/O in target)
		if(istype(O, /obj/structure/uninet_link/cable))
			continue
		if((include_already_connected || !O.network_number[equivalent_cable_type]) && canConnect(O))
			if(direction == dir1 || direction == dir2)
				connections += O

	connections -= src
	return connections


/obj/structure/uninet_link/cable/proc/canConnect(var/obj/connect_to)
	for(var/type in connectable_types)
		if(istype(connect_to, type))
			return 1
	return 0


/obj/structure/uninet_link/cable/attackby(var/obj/item/weapon/W, var/mob/user)
	var/unified_network/network = networks[equivalent_cable_type]
	add_fingerprint(user)

	var/turf/T = src.loc

	if(T.intact && level == 1)
		return

	if(istype(W, /obj/item/weapon/wirecutters))

		userTouched(user)

		if(cable_piece_type)
			dropCablePieces()

		for(var/mob/O in viewers(src, null))
			O.show_message("\red [user] disconnects the [name].", 1)

		network.controller.cableCut(src, user)

		del src

	else if(istype(W, /obj/item/device))
		network.controller.deviceUsed(W, src, user)

	return


/obj/structure/uninet_link/cable/proc/dropCablePieces()
	if(cable_piece_type)
		new cable_piece_type(loc, dir1 ? 2 : 1)

	return


/obj/structure/uninet_link/cable/ex_act(severity)
	switch(severity)
		if(1)
			var/unified_network/network = networks[equivalent_cable_type]
			network.unhandled_exp_dam = 1
			del(src)
		if(2)
			if(prob(50))
				dropCablePieces()
				var/unified_network/network = networks[equivalent_cable_type]
				network.unhandled_exp_dam = 1
				del(src)

		if(3)
			if(prob(25))
				dropCablePieces()
				var/unified_network/network = networks[equivalent_cable_type]
				network.unhandled_exp_dam = 1
				del(src)
	return

/obj/structure/uninet_link/cable/proc/objectBuilt(var/obj/object)
	var/direction = get_dir_3d(src, object)
	if(dir1 != direction && dir2 != direction)
		return
	if(canConnect(object))
		var/unified_network/network = networks[equivalent_cable_type]
		network.addNode(object, src)
	return

/obj/New()
	..()
	if(ticker)
		for(var/direction in list(0) | cardinal8)
			for (var/obj/structure/uninet_link/cable/cable in get_step(src, direction))
				cable.objectBuilt(src)
	return
