/datum/event/inertial_damper
	announceWhen = 5

/datum/event/inertial_damper/setup()
	endWhen = rand(45, 120)

/datum/event/inertial_damper/check_conditions() // Check if we have any ships that require dampers for this event to affect
	for(var/obj/effect/overmap/visitable/ship/S in SSshuttle.ships)
		if(S.needs_dampers)
			return TRUE
	return FALSE

/datum/event/inertial_damper/announce()
	command_announcement.Announce("Inertial damper calibration error. Please restrict thruster use. Recalibration cycle initiated...", "[location_name()] Inertial Damper Subsystem", zlevels = affecting_z)

/datum/event/inertial_damper/start()
	for(var/obj/machinery/inertial_damper/I in SSmachines.machinery)
		I.damping_modifier += -5 //Gm/h
		I.was_reset = FALSE

/datum/event/inertial_damper/end()
	var/display_announcement = FALSE
	for(var/obj/machinery/inertial_damper/I in SSmachines.machinery)
		I.damping_modifier = initial(I.damping_modifier)
		if(!I.was_reset)
			display_announcement = TRUE
			break

	if(display_announcement)
		command_announcement.Announce("Inertial dampers are again functioning within normal parameters. Sorry for any inconvenience.", "[location_name()] Inertial Damper Subsystem", zlevels = affecting_z)
