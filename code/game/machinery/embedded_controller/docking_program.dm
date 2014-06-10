
#define STATE_UNDOCKED		0
#define STATE_DOCKING		1
#define STATE_UNDOCKING		2
#define STATE_DOCKED		3

#define MODE_NONE			0
#define MODE_SERVER			1
#define MODE_CLIENT			2	//The one who initiated the docking, and who can initiate the undocking. The server cannot initiate undocking. (Think server == station, client == shuttle)

/*
	*** STATE TABLE ***
	
	MODE_CLIENT|STATE_UNDOCKED		sent a request for docking and now waiting for a reply.
	MODE_CLIENT|STATE_DOCKING		server told us they are OK to dock, waiting for our docking port to be ready.
	MODE_CLIENT|STATE_DOCKED		idle - docked as client.
	MODE_CLIENT|STATE_UNDOCKING		we are either waiting for our docking port to be ready or for the server to give us the OK to undock.
	
	MODE_SERVER|STATE_UNDOCKED		should never happen.
	MODE_SERVER|STATE_DOCKING		someone requested docking, we are waiting for our docking port to be ready.
	MODE_SERVER|STATE_DOCKED		idle - docked as server
	MODE_SERVER|STATE_UNDOCKING		client requested undocking, we are waiting for our docking port to be ready.
	
	MODE_NONE|STATE_UNDOCKED		idle - not docked.
	MODE_NONE|anything else			should never happen.
	
*/


/datum/computer/file/embedded_program/docking
	var/tag_target				//the tag of the docking controller that we are trying to dock with
	var/dock_state = STATE_UNDOCKED
	var/control_mode = MODE_NONE
	var/response_sent = 0		//so we don't spam confirmation messages
	
	var/override_enabled = 0	//skips checks for the docking port being ready

/datum/computer/file/embedded_program/docking/receive_signal(datum/signal/signal, receive_method, receive_param)
	var/receive_tag = signal.data["tag"]		//for docking signals, this is the sender id
	var/command = signal.data["command"]
	var/recipient = signal.data["recipient"]	//the intended recipient of the docking signal
	
	if (recipient != id_tag)
		return	//this signal is not for us
	
	switch (command)
		if ("confirm_dock")
			if (control_mode == MODE_CLIENT && dock_state == STATE_UNDOCKED && receive_tag == tag_target)
				dock_state = STATE_DOCKING
				if (!override_enabled)
					prepare_for_docking()
			else if (control_mode == MODE_SERVER && dock_state == STATE_DOCKING && receive_tag == tag_target)	//client just sent us the confirmation back, we're done with the docking process
				dock_state = STATE_DOCKED
				if (!override_enabled)
					finish_docking()	//server done docking!
				response_sent = 0
			else
				send_docking_command(tag_target, "abort_dock")	//not expecting confirmation for anything - tell the other guy.
		
		if ("request_dock")
			if (control_mode == MODE_NONE && dock_state == STATE_UNDOCKED)
				control_mode = MODE_SERVER
				dock_state = STATE_DOCKING
				tag_target = receive_tag
				if (!override_enabled)
					prepare_for_docking()
		
		if ("confirm_undock")
			if (control_mode == MODE_CLIENT && dock_state == STATE_UNDOCKING && receive_tag == tag_target)
				send_docking_command(tag_target, "confirm_undock")
				reset()		//client is done undocking!
		
		if ("request_undock")
			if (control_mode == MODE_SERVER && dock_state == STATE_DOCKED && receive_tag == tag_target)
				dock_state = STATE_UNDOCKING
				prepare_for_undocking()
	
		if ("dock_error")
			if (receive_tag == tag_target)
				reset()

/datum/computer/file/embedded_program/docking/process()
	switch(dock_state)
		if (STATE_DOCKING)	//waiting for our docking port to be ready for docking
			if (ready_for_docking() || override_enabled)
				if (!response_sent)
					send_docking_command(tag_target, "confirm_dock")	//tell the other guy we're ready
					response_sent = 1
				
				if (control_mode == MODE_CLIENT)	//client doesn't need to do anything further
					dock_state = STATE_DOCKED
					if (!override_enabled)
						finish_docking()	//client done docking!
					response_sent = 0
		if (STATE_UNDOCKING)
			if (ready_for_undocking() || override_enabled)
				if (control_mode == MODE_CLIENT)
					if (!response_sent)
						send_docking_command(tag_target, "request_undock")	//tell the server we want to undock now.
						response_sent = 1
				else if (control_mode == MODE_SERVER)
					send_docking_command(tag_target, "confirm_undock")	//tell the client we are OK to undock.
					reset()		//server is done undocking!
	
	if (dock_state != STATE_DOCKING && dock_state != STATE_UNDOCKING)
		response_sent = 0
	
	//handle invalid states
	if (control_mode == MODE_NONE && dock_state != STATE_UNDOCKED)
		if (tag_target)
			send_docking_command(tag_target, "dock_error")
		reset()
	if (control_mode == MODE_SERVER && dock_state == STATE_UNDOCKED)
		control_mode = MODE_NONE


/datum/computer/file/embedded_program/docking/proc/initiate_docking(var/target)
	if (dock_state != STATE_UNDOCKED || control_mode == MODE_SERVER)	//must be undocked and not serving another request to begin a new docking handshake
		return
	
	tag_target = target
	control_mode = MODE_CLIENT
	
	send_docking_command(tag_target, "request_dock")

/datum/computer/file/embedded_program/docking/proc/initiate_undocking()
	if (dock_state != STATE_DOCKED || control_mode != MODE_CLIENT)		//must be docked and must be client to start undocking
		return
	
	dock_state = STATE_UNDOCKING
	prepare_for_undocking()
	
	send_docking_command(tag_target, "request_undock")


//tell the docking port to start getting ready for docking - e.g. pressurize
/datum/computer/file/embedded_program/docking/proc/prepare_for_docking()
	return

//are we ready for docking?
/datum/computer/file/embedded_program/docking/proc/ready_for_docking()
	return 1

//we are docked, open the doors or whatever.
/datum/computer/file/embedded_program/docking/proc/finish_docking()
	return

//tell the docking port to start getting ready for undocking - e.g. close those doors.
/datum/computer/file/embedded_program/docking/proc/prepare_for_undocking()
	return

//are we ready for undocking?
/datum/computer/file/embedded_program/docking/proc/ready_for_undocking()
	return 1

/datum/computer/file/embedded_program/docking/proc/enable_override()
	override_enabled = 1
	//if (tag_target)
	//	send_docking_command(tag_target, "enable_override")

/datum/computer/file/embedded_program/docking/proc/disable_override()
	override_enabled = 0
	//if (tag_target)
	//	send_docking_command(tag_target, "disable_override")

/datum/computer/file/embedded_program/docking/proc/reset()
	dock_state = STATE_UNDOCKED
	control_mode = MODE_NONE
	tag_target = null
	response_sent = 0

/datum/computer/file/embedded_program/docking/proc/force_undock()
	if (tag_target)
		send_docking_command(tag_target, "dock_error")
	reset()

/datum/computer/file/embedded_program/docking/proc/docked()
	return (dock_state == STATE_DOCKED)

/datum/computer/file/embedded_program/docking/proc/undocked()
	return (dock_state == STATE_UNDOCKED)

//returns 1 if we are saftely undocked (and the shuttle can leave)
/datum/computer/file/embedded_program/docking/proc/can_launch()
	return undocked()

/datum/computer/file/embedded_program/docking/proc/send_docking_command(var/recipient, var/command)
	var/datum/signal/signal = new
	signal.data["tag"] = id_tag
	signal.data["command"] = command
	signal.data["recipient"] = recipient
	post_signal(signal)

//this is mostly for NanoUI
/datum/computer/file/embedded_program/docking/proc/get_docking_status()
	switch (dock_state)
		if (STATE_UNDOCKED) return "undocked"
		if (STATE_DOCKING) return "docking"
		if (STATE_UNDOCKING) return "undocking"
		if (STATE_DOCKED) return "docked"
	
	

	
#undef STATE_UNDOCKED
#undef STATE_DOCKING
#undef STATE_UNDOCKING
#undef STATE_DOCKED

#undef MODE_NONE
#undef MODE_SERVER
#undef MODE_CLIENT