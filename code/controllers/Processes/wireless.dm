var/datum/controller/process/wireless/wirelessProcess

/datum/controller/process/wireless
	var/list/receiver_list
	var/list/pending_connections
	var/list/retry_connections
	var/list/failed_connections

/datum/controller/process/wireless/setup()
	name = "wireless"
	schedule_interval = 50
	pending_connections = new()
	retry_connections = new()
	failed_connections = new()
	receiver_list = new()
	wirelessProcess = src

/datum/controller/process/wireless/proc/add_device(var/datum/wifi/receiver/R)
	receiver_list |= R

/datum/controller/process/wireless/proc/remove_device(var/datum/wifi/receiver/R)
	receiver_list -= R

/datum/controller/process/wireless/proc/add_request(var/datum/connection_request/C)
	pending_connections += C

/datum/controller/process/wireless/doWork()
	//process any pending connection requests
	if(pending_connections.len > 0)
		process_queue(pending_connections, retry_connections)
		return		//quit here so the retry connection attempt is delayed

	//process any connection request waiting to be retried
	if(retry_connections.len > 0)
		process_queue(retry_connections, failed_connections)

/datum/controller/process/wireless/proc/process_queue(var/list/input_queue, var/list/output_queue)
	for(var/datum/connection_request/C in input_queue)
		var/target_found = 0
		for(var/datum/wifi/receiver/R in receiver_list)
			if(R.id == C.target)
				var/datum/wifi/sender/S = C.source
				S.connect_device(R)
				R.connect_device(S)
				target_found = 1
		input_queue -= C
		if(!target_found)
			output_queue += C
		SCHECK
