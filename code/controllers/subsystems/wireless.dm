//-------------------------------
/*
	Wireless controller

	Used for connecting devices to each other (i.e. machinery, doors, emitters, etc.)
	Unlike the radio controller, the wireless controller does not pass communications between devices. Once the devices
	have been connected they call each others procs directly, they do not use the wireless controller to communicate.

	See code/modules/wireless/interfaces.dm for details of how to connect devices.
*/
//-------------------------------

SUBSYSTEM_DEF(wireless)
	name = "Wireless"
	priority = SS_PRIORITY_WIRELESS
	flags = SS_KEEP_TIMING|SS_BACKGROUND|SS_NO_INIT
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	wait = 50

	var/list/receiver_list       = list()
	var/list/pending_connections = list()
	var/list/retry_connections   = list()
	var/list/failed_connections  = list()

/datum/controller/subsystem/wireless/proc/add_device(var/datum/wifi/receiver/R)
	receiver_list |= R

/datum/controller/subsystem/wireless/proc/remove_device(var/datum/wifi/receiver/R)
	receiver_list -= R

/datum/controller/subsystem/wireless/proc/add_request(var/datum/connection_request/C)
	pending_connections += C

/datum/controller/subsystem/wireless/stat_entry()
	..("RL:[receiver_list.len]|PC:[pending_connections.len]|RC:[retry_connections.len]|FC:[failed_connections.len]")

/datum/controller/subsystem/wireless/Recover()
	if (istype(SSwireless.receiver_list))
		receiver_list = SSwireless.receiver_list
	if (istype(SSwireless.pending_connections))
		pending_connections = SSwireless.pending_connections
	if (istype(SSwireless.retry_connections))
		retry_connections = SSwireless.retry_connections
	if (istype(SSwireless.failed_connections))
		failed_connections = SSwireless.failed_connections

/datum/controller/subsystem/wireless/fire(resumed = 0)
	//process any connection requests waiting to be retried
	if(process_queue(retry_connections, failed_connections))
		return
	//process any pending connection requests
	if(process_queue(pending_connections, retry_connections))
		return

/datum/controller/subsystem/wireless/proc/process_queue(var/list/process_connections, var/list/unsuccesful_connections)
	while(process_connections.len)
		var/datum/connection_request/C = process_connections[process_connections.len]
		process_connections--
		var/target_found = 0
		for(var/datum/wifi/receiver/R in receiver_list)
			if(R.id == C.id)
				var/datum/wifi/sender/S = C.source
				S.connect_device(R)
				R.connect_device(S)
				target_found = 1
		if(!target_found)
			unsuccesful_connections += C
		if(MC_TICK_CHECK)
			return TRUE
