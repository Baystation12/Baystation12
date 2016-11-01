/datum/evacuation_controller/proc/get_status_panel_eta()

	if(waiting_to_leave())
		return "Delayed"
	var/timeleft = get_eta()
	if(timeleft < 0)
		return ""
	return "[is_on_cooldown() ? "Returning" : (is_arriving() ? "ETA" : "ETD")] [add_zero(num2text((timeleft / 60) % 60),2)]:[add_zero(num2text(timeleft % 60), 2)]"

/datum/evacuation_controller/proc/has_eta()
	return (state == EVAC_PREPPING || state == EVAC_LAUNCHING || state == EVAC_IN_TRANSIT || state == EVAC_COOLDOWN)

/datum/evacuation_controller/proc/get_eta()
	if(state == EVAC_PREPPING)
		return (evac_ready_time ? (evac_ready_time - world.time)/10 : -1)
	else if(state == EVAC_LAUNCHING)
		return (evac_launch_time ? (evac_launch_time - world.time)/10 : -1)
	else if(state == EVAC_IN_TRANSIT)
		return (evac_arrival_time ? (evac_arrival_time - world.time)/10 : -1)
	else if(state == EVAC_COOLDOWN)
		return (evac_cooldown_time ? (evac_cooldown_time - world.time)/10 : -1)
	return -1
