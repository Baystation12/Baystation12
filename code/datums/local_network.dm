GLOBAL_LIST_INIT(local_networks, new)		

/datum/local_network
	var/id_tag
	var/list/network_entities =    list()
	var/const/network_size    =    25 // Distance in tiles network objects can be from each other.

/datum/local_network/New(var/_id)
	id_tag = _id
	GLOB.local_networks[id_tag] = src

/datum/local_network/Destroy()
	network_entities.Cut()
	GLOB.local_networks -= src
	. = ..()

/datum/local_network/proc/within_radius(var/atom/checking)
	for(var/entity_list in network_entities)
		for(var/entity in entity_list)
			if(get_dist(entity, checking) > network_size)
				return FALSE
	return TRUE

/datum/local_network/proc/add_device(var/obj/machinery/device)
	var/type = device.type
	var/list/entities = network_entities[type]
	
	if(!entities)
		entities = list()
		network_entities[type] = entities
	
	entities[device] = TRUE

	return entities[device]

/datum/local_network/proc/remove_device(var/obj/machinery/device)
	var/type = device.type
	var/list/entities = network_entities[type]
	if(!entities)
		return TRUE

	entities -= device
	if(entities.len <= 0)
		network_entities -= type
	if(network_entities.len <= 0)
		qdel(src)
	return isnull(entities[device])

/datum/local_network/proc/is_connected(var/obj/machinery/device)
	var/type = device.type
	var/list/entities = network_entities[type]
	if(!entities)
		return FALSE
	return isnull(entities[device])

/datum/local_network/proc/get_devices(var/device_type)
	return network_entities[device_type]
