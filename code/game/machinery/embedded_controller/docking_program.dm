
#define STATE_UNDOCKED		0
#define STATE_DOCKING		1
#define STATE_UNDOCKING		2
#define STATE_DOCKED		3

/datum/computer/file/embedded_program/docking_port
	var/tag_target				//the tag of the docking controller that we are trying to dock with
	var/airlock_override = 0	//allows use of the docking port as a normal airlock (normally this is only allowed in STATE_UNDOCKED)
	var/dock_state = STATE_UNDOCKED

/datum/computer/file/embedded_program/docking_port/receive_signal(datum/signal/signal, receive_method, receive_param)
	var/receive_tag = signal.data["tag"]
	var/command = signal.data["command"]
	
	if(!receive_tag) return

	if(receive_tag==tag_target && command="request_undock")
		begin_undock()
	else if (command=="request_dock")
		if (tag_target)	//something is already docked here
			//send an error message
		else
			tag_target = receive_tag
			begin_dock()
	
	..()

/datum/computer/file/embedded_program/docking_port/receive_user_command(command)

/datum/computer/file/embedded_program/docking_port/process()
	..()	//process regular airlock stuff first
	
	switch(dock_state)
		if(STATE_DOCKING)
			if(done_cycling())
				state = STATE_DOCKED
				
				//send confirmation
				
				//open doors
				toggleDoor(memory["interior_status"], tag_interior_door, memory["secure"], "open")
				toggleDoor(memory["exterior_status"], tag_exterior_door, memory["secure"], "open")
		if(STATE_UNDOCKING)
			if()	//check doors are closed or override
				state = STATE_UNDOCKED
				
				
				//send confirmation
				tag_target = null

/datum/computer/file/embedded_program/docking_port/cycleDoors(var/target)
	if (state == STATE_UNDOCKED || airlock_override)
		..()

//get the docking port into a good state for docking.
/datum/computer/file/embedded_program/proc/begin_dock()
	dock_state = STATE_DOCKING
	begin_cycle_in()

//get the docking port into a good state for undocking.
/datum/computer/file/embedded_program/proc/begin_undock()
	dock_state = STATE_UNDOCKING
	stop_cycling()
	
	//close the doors
	toggleDoor(memory["interior_status"], tag_interior_door, memory["secure"], "close")
	toggleDoor(memory["exterior_status"], tag_exterior_door, memory["secure"], "close")