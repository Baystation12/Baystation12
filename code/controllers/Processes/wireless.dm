//-------------------------------
/*
	Wireless controller

	Used for connecting devices to each other (i.e. machinery, doors, emitters, etc.)
	Unlike the radio controller, the wireless controller does not pass communications between devices. Once the devices
	have been connected they call each others procs directly, they do not use the wireless controller to communicate.

	See code/modules/wireless/interfaces.dm for details of how to connect devices.
*/
//-------------------------------

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
	if(receiver_list)
		receiver_list |= R
	else
		receiver_list = new()
		receiver_list |= R

/datum/controller/process/wireless/proc/remove_device(var/datum/wifi/receiver/R)
	if(receiver_list)
		receiver_list -= R

/datum/controller/process/wireless/proc/add_request(var/datum/connection_request/C)
	if(pending_connections)
		pending_connections += C
	else
		pending_connections = new()
		pending_connections += C

/datum/controller/process/wireless/doWork()
	//process any connection requests waiting to be retried
	if(retry_connections.len > 0)
		//any that fail are moved into the failed connections list
		process_queue(retry_connections, failed_connections)

	//process any pending connection requests
	if(pending_connections.len > 0)
		//any that fail are moved to the retry queue
		process_queue(pending_connections, retry_connections)

/datum/controller/process/wireless/proc/process_queue(var/list/process_conections, var/list/unsuccesful_connections)
	for(last_object in process_conections)
		var/datum/connection_request/C = last_object
		var/target_found = 0
		for(var/datum/wifi/receiver/R in receiver_list)
			if(R.id == C.id)
				var/datum/wifi/sender/S = C.source
				S.connect_device(R)
				R.connect_device(S)
				target_found = 1
		process_conections -= C
		if(!target_found)
			unsuccesful_connections += C
		SCHECK
