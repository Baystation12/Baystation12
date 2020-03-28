/datum/extension/exonet_device
	base_type = /datum/extension/exonet_device
	var/ennid 		// Exonet network id. This is the name of the network we're connected to.
	var/netspeed	// How this device has connected to the network.

/datum/extension/exonet_device/proc/set_tag(var/mob/user, var/new_ennid, var/nic_netspeed, var/key_data)
	if(ennid == new_ennid)
		return "\The [holder] is already part of the '[ennid]' network."

	if(ennid)
		var/datum/exonet/old_exonet = GLOB.exonets[ennid]
		if(old_exonet)
			var/removed_device = old_exonet.remove_device(holder)
			if(!removed_device)
				return "Error encountered when trying to unregister \the [holder] from the '[ennid]' network."


	var/datum/exonet/exonet = GLOB.exonets[new_ennid]
	if(!exonet)
		return "Error encountered when trying to register \the [holder] to the '[new_ennid]' network."
	else
		exonet.add_device(holder)
		ennid = new_ennid
	return FALSE // This is a success.

/datum/extension/exonet_device/proc/broadcast_network(var/b_ennid)
	// Broadcasts an ENNID. If the network doesn't exist, it will create it.
	// If the network does exist, this will attempt to be added as a relay.
	var/datum/exonet/exonet = GLOB.exonets[b_ennid]
	if(!exonet)
		exonet = new(b_ennid)
		GLOB.exonets[b_ennid] = exonet
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
	if(network.get_signal_strength(holder, netspeed) > 0)
		return network

/datum/extension/exonet_device/proc/get_mac_address()
	var/datum/exonet/network = get_local_network()
	if(!network)
		return network.network_devices.Find(holder)
	