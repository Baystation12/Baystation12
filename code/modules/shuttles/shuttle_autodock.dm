#define DOCK_ATTEMPT_TIMEOUT 200	//how long in ticks we wait before assuming the docking controller is broken or blown up.

/datum/shuttle/autodock
	var/process_state = IDLE_STATE
	var/in_use = null	//tells the controller whether this shuttle needs processing, also attempts to prevent double-use
	var/last_dock_attempt_time = 0
	var/current_dock_target

	var/datum/shuttle_destination/current_destination
	var/datum/computer/file/embedded_program/docking/active_docking_controller

	var/obj/effect/shuttle_landmark/landmark_transition
	var/move_time = 0		//the time spent in the transition area

	category = /datum/shuttle/autodock

/datum/shuttle/autodock/New(_name)
	..(_name)

	//Optional
	if(landmark_transition)
		landmark_transition = locate(landmark_transition)

	//TODO initial dock

/datum/shuttle/autodock/Destroy()
	current_destination = null
	active_docking_controller = null
	landmark_transition = null

	return ..()

/datum/shuttle/autodock/move(var/atom/destination)
	if(active_docking_controller)
		active_docking_controller.force_undock() //bye
	..()

/*
	Docking stuff
*/
//TODO refactor out the need for these, make launch(), force_launch() set current_destination, update current_location in move()
/datum/shuttle/autodock/proc/get_destination()
	return null //To be implemented by subtypes

/datum/shuttle/autodock/proc/get_docking_controller()
	return null //To be implemented by subtypes

/datum/shuttle/autodock/proc/get_dock_target()
	return null //To be implemented by subtypes

/datum/shuttle/autodock/proc/dock(var/dock_target)
	var/datum/computer/file/embedded_program/docking/docking_controller = get_docking_controller()
	if(docking_controller)
		current_dock_target = dock_target
		docking_controller.initiate_docking(dock_target)
		last_dock_attempt_time = world.time

/datum/shuttle/autodock/proc/undock()
	var/datum/computer/file/embedded_program/docking/docking_controller = get_docking_controller()
	if(docking_controller)
		docking_controller.initiate_undocking()

/datum/shuttle/autodock/proc/check_docked()
	var/datum/computer/file/embedded_program/docking/docking_controller = get_docking_controller()
	if(docking_controller)
		return docking_controller.docked()
	return TRUE

/datum/shuttle/autodock/proc/check_undocked()
	var/datum/computer/file/embedded_program/docking/docking_controller = get_docking_controller()
	if(docking_controller)
		return docking_controller.can_launch()
	return TRUE

/*
	Please ensure that long_jump() and short_jump() are only called from here. This applies to subtypes as well.
	Doing so will ensure that multiple jumps cannot be initiated in parallel.
*/
/datum/shuttle/autodock/proc/process()
	switch(process_state)
		if (WAIT_LAUNCH)
			if(!current_dock_target || check_undocked())
				process_launch()
				process_state = WAIT_ARRIVE

		if (FORCE_LAUNCH)
			process_launch()
			process_state = WAIT_ARRIVE

		if (WAIT_ARRIVE)
			if (moving_status == SHUTTLE_IDLE)
				current_dock_target = get_dock_target() //TODO ugly
				dock(current_dock_target)

				in_use = null	//release lock
				process_state = WAIT_FINISH

		if (WAIT_FINISH)
			if (!current_dock_target || world.time > last_dock_attempt_time + DOCK_ATTEMPT_TIMEOUT || check_docked())
				process_state = IDLE_STATE
				arrived()

/datum/shuttle/autodock/proc/process_launch()
	var/destination = get_destination()
	if (move_time && landmark_transition)
		long_jump(destination, landmark_transition, move_time)
	else
		short_jump(destination)

/*
	Guards
*/
/datum/shuttle/autodock/proc/can_launch()
	if (moving_status != SHUTTLE_IDLE)
		return 0
	if (in_use)
		return 0
	return 1

/datum/shuttle/autodock/proc/can_force()
	if (moving_status == SHUTTLE_IDLE && process_state == WAIT_LAUNCH)
		return 1
	return 0

/datum/shuttle/autodock/proc/can_cancel()
	if (moving_status == SHUTTLE_WARMUP || process_state == WAIT_LAUNCH || process_state == FORCE_LAUNCH)
		return 1
	return 0

/*
	"Public" procs
*/
/datum/shuttle/autodock/proc/launch(var/user)
	if (!can_launch()) return

	in_use = user	//obtain an exclusive lock on the shuttle

	process_state = WAIT_LAUNCH
	undock()

/datum/shuttle/autodock/proc/force_launch(var/user)
	if (!can_force()) return

	in_use = user	//obtain an exclusive lock on the shuttle

	process_state = FORCE_LAUNCH

/datum/shuttle/autodock/proc/cancel_launch(var/user)
	if (!can_cancel()) return

	moving_status = SHUTTLE_IDLE
	process_state = WAIT_FINISH
	in_use = null

	var/datum/computer/file/embedded_program/docking/docking_controller = get_docking_controller()
	if(docking_controller && !docking_controller.undocked())
		docking_controller.force_undock()

	spawn(1 SECOND)
		dock(current_dock_target)

//returns 1 if the shuttle is getting ready to move, but is not in transit yet
/datum/shuttle/autodock/proc/is_launching()
	return (moving_status == SHUTTLE_WARMUP || process_state == WAIT_LAUNCH || process_state == FORCE_LAUNCH)

//This gets called when the shuttle finishes arriving at it's destination
//This can be used by subtypes to do things when the shuttle arrives.
//Note that this is called when the shuttle leaves the WAIT_FINISHED state, the proc name is a little misleading
/datum/shuttle/autodock/proc/arrived()
	return	//do nothing for now

