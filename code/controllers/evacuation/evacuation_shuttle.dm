/datum/evacuation_controller/pods/shuttle
	name = "escape shuttle controller"
	evac_waiting =  new(0, new_sound = sound('sound/AI/shuttledock.ogg'))
	evac_called =   new(0, new_sound = sound('sound/AI/shuttlecalled.ogg'))
	evac_recalled = new(0, new_sound = sound('sound/AI/shuttlerecalled.ogg'))

	var/departed = 0
	var/autopilot = 1
	var/datum/shuttle/ferry/emergency/shuttle // Set in shuttle_emergency.dm
	var/shuttle_launch_time

/datum/evacuation_controller/pods/shuttle/has_evacuated()
	return departed

/datum/evacuation_controller/pods/shuttle/waiting_to_leave()
	return (!autopilot || (shuttle && shuttle.is_launching()))

/datum/evacuation_controller/pods/shuttle/launch_evacuation()

	if(waiting_to_leave())
		return

	for (var/datum/shuttle/ferry/escape_pod/pod in escape_pods)
		if (!pod.arming_controller || pod.arming_controller.armed)
			pod.move_time = evac_transit_delay
			pod.launch(src)

	if(autopilot && shuttle.moving_status == SHUTTLE_IDLE)
		evac_arrival_time = world.time + (shuttle.move_time*10) + (shuttle.warmup_time*10)
		shuttle.launch(src)
	// Announcements, state changes and such are handled by the shuttle itself to prevent desync.

/datum/evacuation_controller/pods/shuttle/finish_preparing_evac()
	departed = 1
	evac_launch_time = world.time + evac_launch_delay
	. = ..()

/datum/evacuation_controller/pods/shuttle/call_evacuation(var/mob/user, var/_emergency_evac, var/forced)
	if(..(user, _emergency_evac, forced))
		autopilot = 1
		shuttle_launch_time = world.time + (evac_prep_delay/2)
		evac_ready_time += shuttle.warmup_time*10

/datum/evacuation_controller/pods/shuttle/cancel_evacuation()
	if(..() && shuttle.moving_status != SHUTTLE_INTRANSIT)
		shuttle_launch_time = null
		shuttle.cancel_launch(src)
		return 1
	return 0

/datum/evacuation_controller/pods/shuttle/get_eta()
	if (shuttle && shuttle.has_arrive_time())
		return (shuttle.arrive_time-world.time)/10
	return ..()

/datum/evacuation_controller/pods/shuttle/get_status_panel_eta()
	if(has_eta() && waiting_to_leave())
		return "Launching..."
	return ..()

// This is largely handled by the emergency shuttle datum.
/datum/evacuation_controller/pods/shuttle/process()
	if(state == EVAC_PREPPING)
		if(!isnull(shuttle_launch_time) && world.time > shuttle_launch_time && shuttle.moving_status == SHUTTLE_IDLE)
			shuttle.launch()
			shuttle_launch_time = null
		return
	else if(state == EVAC_IN_TRANSIT)
		return
	return ..()

/datum/evacuation_controller/pods/shuttle/can_cancel()
	return (shuttle.moving_status == SHUTTLE_IDLE && shuttle.location && ..())

/datum/evacuation_controller/pods/shuttle/proc/shuttle_leaving()
	state = EVAC_IN_TRANSIT

/datum/evacuation_controller/pods/shuttle/proc/shuttle_evacuated()
	state = EVAC_COMPLETE

/datum/evacuation_controller/pods/shuttle/proc/shuttle_preparing()
	state = EVAC_PREPPING

/datum/evacuation_controller/pods/shuttle/proc/get_long_jump_time()
	if (shuttle.location)
		return round(evac_prep_delay/10)/2
	else
		return round(evac_transit_delay/10)
