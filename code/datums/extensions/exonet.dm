/datum/extension/exonet_device
	base_type = /datum/extension/exonet_device
	var/ennid 		// Exonet network id. This is the name of the network we're connected to.
	var/netspeed	// How this device has connected to the network.

/datum/extension/exonet_device/proc/connect_network(var/mob/user, var/new_ennid, var/nic_netspeed, var/key_data)
	if(ennid == new_ennid)
		return "\The [holder] is already part of the '[ennid]' network."

	if(ennid)
		var/disconnect_result = disconnect_network(user)
		if(disconnect_result)
			return disconnect_result // There was a problem.


	var/datum/exonet/exonet = GLOB.exonets[new_ennid]
	if(!exonet)
		return "Error encountered when trying to register \the [holder] to the '[new_ennid]' network."
	else
		exonet.add_device(holder, key_data)
		ennid = new_ennid
		netspeed = nic_netspeed
	return FALSE // This is a success.

/datum/extension/exonet_device/proc/disconnect_network(var/mob/user)
	if(!ennid)
		return

	var/datum/exonet/old_exonet = GLOB.exonets[ennid]
	if(old_exonet)
		var/removed_device = old_exonet.remove_device(holder)
		if(!removed_device)
			return "Error encountered when trying to unregister \the [holder] from the '[ennid]' network."
	return FALSE // This is a success.

/datum/extension/exonet_device/proc/broadcast_network(var/b_ennid)
	// Broadcasts an ENNID. If the network doesn't exist, it will create it.
	// If the network does exist, this will attempt to be added as a relay.
	var/datum/exonet/exonet = GLOB.exonets[b_ennid]
	if(!exonet)
		exonet = new(b_ennid)
		GLOB.exonets[b_ennid] = exonet
		exonet.set_router(holder)
	else
		exonet.add_device(holder)
	ennid = b_ennid
	netspeed = NETWORKSPEED_ETHERNET

/datum/extension/exonet_device/proc/get_nearby_networks(var/nic_netspeed)
	var/list/results = list()
	for(var/datum/exonet/exonet in GLOB.exonets)
		if(exonet.get_signal_strength(holder, nic_netspeed) > 0)
			LAZYDISTINCTADD(results, exonet)
	return results

/datum/extension/exonet_device/proc/get_local_network()
	var/datum/exonet/network = GLOB.exonets[ennid]
	if(!network)
		return
	if(network.get_signal_strength(holder, netspeed) > 0)
		return network

/datum/extension/exonet_device/proc/get_mac_address()
	var/datum/exonet/network = get_local_network()
	if(network)
		return network.network_devices.Find(holder)

/datum/extension/exonet_device/proc/get_all_networks()
	return GLOB.exonets

/datum/extension/exonet_device/proc/get_mainframes()
	var/datum/exonet/network = get_local_network()
	if(!network)
		return
	return network.mainframes

/datum/extension/exonet_device/proc/get_network_tag(var/obj/device)
	// Gets a friendly, unique name for a device on a local network.
	var/datum/exonet/network = get_local_network()
	if(!network)
		return
	if(istype(device, /obj/machinery/exonet))
		var/obj/machinery/exonet/exonet_machine = device
		if(exonet_machine.net_tag)
			return exonet_machine.net_tag
	var/index = network.network_devices.Find(device)
	return replacetext("[device.name].[index]", " ", "_")

/datum/extension/exonet_device/proc/get_device_by_tag(var/net_tag)
	if(!net_tag)
		return
	var/datum/exonet/network = get_local_network()
	if(!network)
		return
	for(var/obj/machinery/exonet/exonet_machine in network.network_devices)
		if(!exonet_machine.net_tag)
			continue
		if(exonet_machine.net_tag == net_tag)
			return exonet_machine
	var/list/tokens = splittext(net_tag, ".")
	var/index = text2num(tokens[length(tokens)])
	return network.network_devices[index]
