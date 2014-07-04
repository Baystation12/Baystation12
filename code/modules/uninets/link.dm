/type/uninet_link
	var/link_obj_type = /obj/structure/uninet_link
	var/list/connectable_types = list()
	var/network_controller_type = /datum/controller/uninet_controller

	var/abstract = 1

/obj/structure/uninet_link
	var/dirs = 0

	var/cable_piece_type = null
	var/link_type = /type/uninet_link
	var/link_obj_type = /obj/structure/uninet_link


/var/list/list/uninet_connectables = list()

/hook/startup/proc/createUninetLookups()
	var/type/uninet_link/link_type
	for(var/T in typesof(/type/uninet_link))
		link_type = new T
		if(istype(link_type.connectable_types))
			uninet_connectables[T] = link_type.connectable_types
		else
			uninet_connectables[T] = list()

	return 1


/obj/structure/uninet_link/proc/userTouched(var/mob/user)
	var/unified_network/network = networks[link_type]
	network.controller.linkTouched(src, user)
	return

/obj/structure/uninet_link/Del()
	destroy()
	..()


//GC del
/obj/structure/uninet_link/proc/destroy()
	if(!defer_uninet_rebuild)
		var/unified_network/network = networks[link_type]
		if(network)
			network.cutCable(src)
	loc = null
	return


/obj/structure/uninet_link/proc/cableConnections(var/turf/target, var/include_already_connected = 0)
	. = list()
	var/dir_to = get_dir_3d(target, src)

	for(var/obj/structure/uninet_link/link in target)
		if((!include_already_connected || !link.network_number[link_type]) && link.link_type == link_type)
			if(link.dirs & dir_to)
				. += link

	. -= src


/obj/structure/uninet_link/proc/getAllConnections(var/turf/target, var/include_already_connected = 0)
	. = list()
	var/dir_to = get_dir_3d(target, src)

	for(var/obj/structure/uninet_link/link in target)
		if((include_already_connected || !link.network_number[link_type]) && link.link_type == link_type)
			if(link.dirs & dir_to)
				. += link

	dir_to = reverse_dir_3d(dir_to)

	for(var/obj/O in target)
		if(istype(O, /obj/structure/uninet_link))
			continue
		if((include_already_connected || !O.network_number[link_type]) && canConnect(O))
			if(dirs & dir_to)
				. += O

	. -= src


/obj/structure/uninet_link/proc/canConnect(var/obj/connect_to)
	return (connect_to.type in uninet_connectables[link_type])


/*/obj/structure/uninet_link/proc/dropCablePieces()
	if(cable_piece_type)
		new cable_piece_type(loc, dir1 ? 2 : 1)

	return*/


/obj/structure/uninet_link/proc/objectBuilt(var/obj/object)
	var/dir_to = get_dir_3d(src, object)
	if(!(dirs & dir_to))
		return
	if(canConnect(object))
		var/unified_network/network = networks[link_type]
		network.addNode(object, src)
	return

/obj/New()
	..()
	if(ticker)
		for(var/direction in list(0) | cardinal8)
			for (var/obj/structure/uninet_link/cable/cable in get_step(src, direction))
				cable.objectBuilt(src)
	return
