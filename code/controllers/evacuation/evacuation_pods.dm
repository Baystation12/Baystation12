/datum/evacuation_controller/pods
	name = "escape pod controller"

/datum/evacuation_controller/pods/finish_preparing_evac()
	. = ..()
	// Arm the escape pods.
	if (emergency_evacuation)
		for (var/datum/shuttle/ferry/escape_pod/pod in escape_pods)
			if (pod.arming_controller)
				pod.arming_controller.arm()

/datum/evacuation_controller/pods/launch_evacuation()

	state = EVAC_IN_TRANSIT

	// Launch the pods!
	for (var/datum/shuttle/ferry/escape_pod/pod in escape_pods)
		if (!pod.arming_controller || pod.arming_controller.armed)
			pod.move_time = (evac_transit_delay/10)
			pod.launch(src)

	if (emergency_evacuation)
		priority_announcement.Announce(replacetext(replacetext(using_map.emergency_shuttle_leaving_dock, "%dock_name%", "[dock_name]"),  "%ETA%", "[round(get_eta()/60,1)] minute\s"))
	else
		priority_announcement.Announce(replacetext(replacetext(using_map.shuttle_leaving_dock, "%dock_name%", "[dock_name]"),  "%ETA%", "[round(get_eta()/60,1)] minute\s"))

/datum/evacuation_controller/pods/available_evac_options()
	if (is_idle())
		return list(new /datum/evacuation_option/abandon_ship())
	else
		return list(new /datum/evacuation_option/cancel_abandon_ship())

#define EVAC_OPT_ABANDON_SHIP "abandon_ship"
#define EVAC_OPT_CANCEL_ABANDON_SHIP "cancel_abandon_ship"

/datum/evacuation_controller/pods/handle_evac_option(var/option_target)
	switch (option_target)
		if (EVAC_OPT_ABANDON_SHIP)
			call_evacuation(usr, 1)
		if (EVAC_OPT_CANCEL_ABANDON_SHIP)
			cancel_evacuation()

/datum/evacuation_option/abandon_ship
	option_text = "Abandon ship"
	option_target = EVAC_OPT_ABANDON_SHIP
	needs_syscontrol = FALSE
	silicon_allowed = TRUE

/datum/evacuation_option/cancel_abandon_ship
	option_text = "Cancel abandonment"
	option_target = EVAC_OPT_CANCEL_ABANDON_SHIP
	needs_syscontrol = FALSE
	silicon_allowed = FALSE

#undef EVAC_OPT_ABANDON_SHIP
#undef EVAC_OPT_CANCEL_ABANDON_SHIP