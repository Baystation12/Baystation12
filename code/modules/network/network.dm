var/global/list/networks = list()
var/global/list/domain_masks = list()
var/global/list/assigned_domain_masks = list()

/datum/data_network
	var/network_id
	var/list/terminals = list()
	var/list/allocated_addresses = list()
	var/max_network_connections = 256

/datum/data_network/New()
	network_id = 1
	while(!isnull(networks["[network_id]"]))
		network_id++
	network_id = "[network_id]"
	networks[network_id] = src

/datum/data_network/proc/connected(var/obj/machinery/terminal/connecting)
	if(connecting in terminals)
		return
	var/new_address = get_new_network_address(connecting.domain)
	if(!new_address)
		return null
	allocated_addresses[new_address] = connecting
	terminals |= connecting
	connecting.recieve_network_address(new_address)

/datum/data_network/proc/get_new_network_address(var/connection_domain)

	if(!domain_masks[connection_domain])
		for(var/i=64;i<255;i++)
			if(!(i in assigned_domain_masks))
				domain_masks[connection_domain] = "[i]"
				break

	for(var/i = 1;i<max_network_connections;i++)
		// Should find something to use the second-last hex.
		var/tmp_address = "[network_id].[domain_masks[connection_domain]].0.[i]"
		if(isnull(allocated_addresses[tmp_address]))
			return tmp_address
	return 0

// We assume that this proc is being called after
// the actual connection has been handled.
/datum/data_network/proc/merge(var/datum/data_network/N)
	if(!N)
		return
	var/list/terminals_to_merge = N.terminals
	N.terminals.Cut()
	N.allocated_addresses.Cut()
	networks[N.network_id] = null
	for(var/obj/machinery/terminal/T in terminals_to_merge)
		T.network = null
		connected(T)
