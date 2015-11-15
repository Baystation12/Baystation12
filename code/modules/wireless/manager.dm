/datum/wifi_manager
	var/list/pending_connections
	var/list/receiver_list
	var/list/failed_connections

/datum/wifi_manager/New()
	pending_connections = new()
	receiver_list = new()
	failed_connections = new()

/datum/wifi_manager/proc/add_device(var/datum/wifi/receiver/R)
	receiver_list |= R

/datum/wifi_manager/proc/remove_device(var/datum/wifi/receiver/R)
	receiver_list -= R

/datum/wifi_manager/proc/add_request(var/datum/connection_request/C)
	pending_connections += C

/datum/wifi_manager/proc/process()
	//check any failed connections from the previous pass
	if(failed_connections.len > 0)
		for(var/datum/connection_request/C in failed_connections)
			var/target_found = 0
			for(var/datum/wifi/receiver/R in receiver_list)
				if(R.id == C.target)
					var/datum/wifi/sender/S = C.source
					S.connect_device(R)
					R.connect_device(S)
					target_found = 1
			failed_connections -= C
			if(!target_found)
				log_debug("[C.source] could not connect to \"[C.target]\"")

	//check and try assigning any pending connections
	if(pending_connections.len > 0)
		for(var/datum/connection_request/C in pending_connections)
			var/target_found = 0
			for(var/datum/wifi/receiver/R in receiver_list)
				if(R.id == C.target)
					var/datum/wifi/sender/S = C.source
					S.connect_device(R)
					R.connect_device(S)
					target_found = 1
			pending_connections -= C
			if(!target_found)
				failed_connections += C
