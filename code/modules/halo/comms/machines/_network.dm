/datum/overmap_comms_network
	var/list/machines = list()
	var/list/saved_freqs = list()
	var/list/virtual_dongles = list()

/datum/overmap_comms_network/proc/add_machine(var/obj/machinery/overmap_comms/machine)
	//are we already connected?
	if(machine.my_network == src)
		return NETWORK_ERROR_RECONNECT

	//remove from the old network
	if(machine.my_network)
		machine.my_network.remove_machine(machine.machine_type)

	//connect to us
	var/list/machines_subtype = machines[machine.machine_type]
	if(!machines_subtype)
		machines_subtype = list()
		machines[machine.machine_type] = machines_subtype
	machines_subtype.Add(machine)
	machine.my_network = src
	machine.added_to_network(src)

/datum/overmap_comms_network/proc/remove_machine(var/obj/machinery/overmap_comms/machine)
	var/list/machines_subtype = machines[machine.machine_type]
	if(!machines_subtype)
		machines_subtype = list()
		machines[machine.machine_type] = machines_subtype
	machines_subtype -= machine
	machine.my_network = null
	machine.removed_from_network(src)

/datum/overmap_comms_network/proc/server_connected(var/obj/machinery/overmap_comms/server/server)
	var/list/servers = machines[/obj/machinery/overmap_comms/server]
	var/list/new_freqs
	var/list/new_ciphers
	if(servers && servers.len)
		//work out any new data
		new_freqs = server.my_frequencies - saved_freqs
		new_ciphers = server.my_ciphers - all_ciphers

		//update the collective pool so all servers share the same data
		saved_freqs += new_freqs
		all_ciphers += new_ciphers
		server.my_frequencies = saved_freqs
		server.my_ciphers = all_ciphers
	else
		//we have no servers connected currently so just use this one
		new_freqs = server.my_frequencies
		saved_freqs = new_freqs
		new_ciphers = server.my_ciphers
		all_ciphers = new_ciphers

	//hubs control cipher and frequency interaction so give them the new stuff then let them update themselves
	var/list/hubs = machines[/obj/machinery/overmap_comms/hub]
	if(hubs)
		for(var/obj/machinery/overmap_comms/hub/hub in hubs)
			hub.frequencies_broadcast += new_freqs
			hub.frequencies_ciphers += new_freqs
			hub.ciphers_ui += new_ciphers
			hub.update_ui()

/datum/overmap_comms_network/proc/server_disconnected(var/obj/machinery/overmap_comms/server/server)
	//if this is our last server, we lose access to any saved data
	var/list/servers = machines[/obj/machinery/overmap_comms/server]
	if(!servers || !servers.len)
		saved_freqs = list()
		all_ciphers = list()

	//wipe all our hub data
	var/list/hubs = machines[/obj/machinery/overmap_comms/hub]
	if(hubs)
		for(var/obj/machinery/overmap_comms/hub/hub in hubs)
			hub.frequencies_broadcast = list()
			hub.frequencies_ciphers = list()
			hub.update_ui()

/datum/overmap_comms_network/proc/do_broadcast(var/datum/signal/signal)
	//0 means this network will not broadcast this signal
	//1 means this network will broadcast this signal

	//check if we have an active, working broadcaster
	. = 0
	var/obj/machinery/overmap_comms/broadcaster/broadcaster = find_broadcaster(signal)
	if(!broadcaster)
		return 0

	//is the hub going to allow the broadcast?
	. = allow_broadcast(signal)
	if(!.)
		return 0

	//check if we can decrypt it
	. = can_decrypt(signal)
	if(!.)
		return 0

	//make the broadcaster play an animation
	broadcaster.broadcast_signal()

/datum/overmap_comms_network/proc/find_broadcaster(var/datum/signal/signal)
	var/list/broadcasters = machines[/obj/machinery/overmap_comms/broadcaster]
	. = 0
	if(broadcasters && broadcasters.len)
		for(var/obj/machinery/overmap_comms/broadcaster/broadcaster in broadcasters)
			if(broadcaster.active)
				. = broadcaster
				break

/datum/overmap_comms_network/proc/allow_broadcast(var/datum/signal/signal)
	//check to see if a hub is blocking the broadcast of this frequency
	. = 1
	var/list/hubs = machines[/obj/machinery/overmap_comms/hub]
	if(hubs && hubs.len)
		for(var/obj/machinery/overmap_comms/hub/hub in hubs)
			if(!hub.allow_broadcast(signal))
				return 0

/datum/overmap_comms_network/proc/can_decrypt(var/datum/signal/signal)
	. = 0

	//check if the signal has an encryption cipher
	var/datum/encryption_cipher/cipher = signal.data["cipher"]
	if(!cipher)
		return 1

	//do we have the cipher saved?
	var/list/servers = machines[/obj/machinery/overmap_comms/server]
	if(servers)
		for(var/obj/machinery/overmap_comms/server/server in servers)
			if(server.has_cipher(cipher))
				. = 1
				break

	if(!.)
		return 0

	//is there a processor which will decrypt it?
	var/list/processors = machines[/obj/machinery/overmap_comms/processor]
	if(processors)
		for(var/obj/machinery/overmap_comms/processor/processor in processors)
			if(processor.can_decrypt(signal))
				. = 1
				break
