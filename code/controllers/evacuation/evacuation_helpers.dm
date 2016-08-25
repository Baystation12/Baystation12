/datum/evacuation_controller/proc/set_launch_time(var/val)
	evac_launch_time = val

/datum/evacuation_controller/proc/set_arrival_time(var/val)
	evac_arrival_time = val

/datum/evacuation_controller/proc/is_prepared()
	return (state == EVAC_LAUNCHING)

/datum/evacuation_controller/proc/is_in_transit()
	return (state == EVAC_IN_TRANSIT)

/datum/evacuation_controller/proc/is_idle()
	return (state == EVAC_IDLE)

/datum/evacuation_controller/proc/has_evacuated()
	return (!isnull(evac_launch_time) && world.time > evac_launch_time)

/datum/evacuation_controller/proc/round_over()
	return state == EVAC_COMPLETE

/datum/evacuation_controller/proc/is_on_cooldown()
	return state == EVAC_COOLDOWN

/datum/evacuation_controller/proc/is_evacuating()
	return state != EVAC_IDLE

/datum/evacuation_controller/proc/can_evacuate(var/mob/user, var/forced)

	if(!isnull(evac_called_at))
		return 0

	if (!universe.OnShuttleCall(null))
		return 0

	if(!forced)
		for(var/predicate in evacuation_predicates)
			var/datum/evacuation_predicate/esp = predicate
			if(!esp.is_valid())
				evacuation_predicates -= esp
				qdel(esp)
			else
				if(!esp.can_call(user))
					return 0
	return 1

/datum/evacuation_controller/proc/waiting_to_leave()
	return 0

/datum/evacuation_controller/proc/can_cancel()
	// Are we evacuating?
	if(isnull(evac_called_at))
		return 0
	// Have we already launched?
	if(state != EVAC_PREPPING)
		return 0
	// Are we already committed?
	if(world.time > evac_no_return)
		return 0
	return 1

/datum/evacuation_controller/proc/is_arriving()
	if(state == EVAC_LAUNCHING)
		return 0
	return has_eta()

/datum/evacuation_controller/proc/is_departing()
	if(state == EVAC_LAUNCHING)
		return 1
