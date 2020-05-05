
/datum/event/ship/gravity_failure
	announceWhen = 5
	announce_message = "Feedback surge detected in mass-distributions systems. Artificial gravity has been disabled whilst the system reinitializes."
	title = "Gravity Failure"
	custom_sound = 'sound/AI/granomalies.ogg'
	var/list/impacted_areas = list()

/datum/event/ship/gravity_failure/setup()
	. = ..()
	endWhen = rand(15, 60)

	if(severity == EVENT_LEVEL_MUNDANE)
		//this is very cheeky, changing the variable type dynamically
		//thank you byond for supporting my bad coding habits! -C
		impacted_areas = get_random_area()
		announce_message = "Localised feedback surge detected in mass-distributions systems. Artificial gravity in [impacted_areas] has been disabled whilst the system reinitializes."
	else
		impacted_areas = get_area_list()

/datum/event/ship/gravity_failure/proc/reset_gravity()
	for(var/area/cur_area in impacted_areas)
		cur_area.gravitychange(gravity_is_on)

/datum/event/ship/gravity_failure/start()
	gravity_is_on = 0
	reset_gravity()

/datum/event/ship/gravity_failure/end()
	if(!gravity_is_on)
		gravity_is_on = 1

		reset_gravity()

		affected_faction.AnnounceUpdate("Gravity generators are again functioning within normal parameters. Sorry for any inconvenience.")
