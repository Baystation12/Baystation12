
#define STATE_UNDOCKED		0
#define STATE_DOCKING		1
#define STATE_UNDOCKING		2
#define STATE_DOCKED		3


/datum/computer/file/embedded_program/airlock/docking
	var/tag_target				//the tag of the docking controller that we are trying to dock with
	var/airlock_override = 0	//allows use of the docking port as a normal airlock (normally this is only allowed in STATE_UNDOCKED)
	var/dock_state = STATE_UNDOCKED
	var/dock_master = 0			//are we the initiator of the dock?

/datum/computer/file/embedded_program/airlock/docking/receive_signal(datum/signal/signal, receive_method, receive_param)
	var/receive_tag = signal.data["tag"]	//for docking signals, this is the sender id
	var/command = signal.data["command"]
	var/recipient = signal.data["recipient"]
	
	if (recipient == id_tag)
		switch (command)
			if ("request_dock")
				if (state == STATE_UNDOCKED)
					tag_target = receive_tag
					begin_dock()
				
			if ("request_undock")
				if(receive_tag == tag_target)
					begin_undock()
			
			if ("confirm_dock")
				if(receive_tag == tag_target)
					dock_master = 1
					begin_dock()
				else
					send_docking_command(receive_tag, "docking_error")	//send an error message
			
			if ("confirm_undock")
				if(receive_tag == tag_target)
					begin_undock()
				
			if ("docking_error")
				if(receive_tag==tag_target)
					//try to return to a good state
					stop_cycling()
					
					//close the doors
					toggleDoor(memory["interior_status"], tag_interior_door, memory["secure"], "close")
					toggleDoor(memory["exterior_status"], tag_exterior_door, memory["secure"], "close")
					
					state = STATE_UNDOCKED
					tag_target = null
					dock_master = 0
	
	..()

/datum/computer/file/embedded_program/airlock/docking/receive_user_command(command)
	if (state == STATE_UNDOCKED || airlock_override)
		..(command)

/datum/computer/file/embedded_program/airlock/docking/process()
	..()	//process regular airlock stuff first
	
	switch(dock_state)
		if(STATE_DOCKING)
			if(done_cycling() || airlock_override)
				state = STATE_DOCKED
				
				if (!dock_master)
					send_docking_command(tag_target, "confirm_dock")	//send confirmation
				
				//open doors
				toggleDoor(memory["interior_status"], tag_interior_door, memory["secure"], "open")
				toggleDoor(memory["exterior_status"], tag_exterior_door, memory["secure"], "open")
		if(STATE_UNDOCKING)
			if(check_doors_closed() || airlock_override)	//check doors are closed or override
				state = STATE_UNDOCKED
				
				if (!dock_master)
					send_docking_command(tag_target, "confirm_undock")	//send confirmation
				
				dock_master = 0
				tag_target = null

/datum/computer/file/embedded_program/airlock/docking/cycleDoors(var/target)
	if (state == STATE_UNDOCKED || airlock_override)
		..(target)

//get the docking port into a good state for docking.
/datum/computer/file/embedded_program/airlock/docking/proc/begin_dock()
	dock_state = STATE_DOCKING
	begin_cycle_in()

//get the docking port into a good state for undocking.
/datum/computer/file/embedded_program/airlock/docking/proc/begin_undock()
	dock_state = STATE_UNDOCKING
	stop_cycling()
	
	//close the doors
	toggleDoor(memory["interior_status"], tag_interior_door, memory["secure"], "close")
	toggleDoor(memory["exterior_status"], tag_exterior_door, memory["secure"], "close")

/datum/computer/file/embedded_program/airlock/docking/proc/send_docking_command(var/recipient, var/command)
	var/datum/signal/signal = new
	signal.data["tag"] = id_tag
	signal.data["command"] = command
	signal.data["recipient"] = recipient
	post_signal(signal)

#undef STATE_UNDOCKED
#undef STATE_DOCKING
#undef STATE_UNDOCKING
#undef STATE_DOCKED