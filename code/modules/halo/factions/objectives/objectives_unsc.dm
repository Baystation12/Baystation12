
/* UNSC */

/datum/objective/protect/unsc_leader
	short_text = "Protect the UNSC commander"
	explanation_text = "Protect the UNSC commander. Without a strong chain of command, everything is lost."
	lose_points = 50
	find_specific_target = 1

/datum/objective/protect/unsc_leader/find_target()
	target = GLOB.UNSC.get_commander()
	if(target)
		explanation_text = "Protect [target.current.real_name], the [target.assigned_role]."
	return target

/datum/objective/protect_ship/unsc
	short_text = "Protect the UNSC warship"
	explanation_text = "Although cheaper than a MJOLNIR suit, even Spartans need a way to leave atmosphere. Protect the UNSC ship."

/datum/objective/protect_ship/unsc/find_target()
	target_ship = GLOB.UNSC.get_flagship()
	return target_ship

//see objectives_cov.dm
/datum/objective/retrieve/nav_data/cole_protocol
	short_text = "Do not allow Covenant capture of human nav data"
	explanation_text = "We lose more colonies every year. Soon Earth will be all we have left. Do not allow navchips to be captured by the Covenant."
	points_per_item = 60
	lose_points = 240
	slipspace_affected = 1

/datum/objective/retrieve/nav_data/cole_protocol/check_completion()
	. = ..()
	lose_points = win_points
	win_points = 0
	return !.

/datum/objective/retrieve/steal_ai/cole_protocol
	points_per_item = 400
	short_text = "Do not allow Covenant capture of UNSC AI"
	explanation_text = "Destruction or capture of shipboard AI is absolutely unacceptable. They'll learn everything: weapons research, force deployments, Earth."
	slipspace_affected = 1

/datum/objective/retrieve/steal_ai/cole_protocol/check_completion()
	. = ..()
	lose_points = win_points
	win_points = 0
	return !.

//todo: oni agent job role

/datum/objective/capture_innies
	short_text = "Capture Insurrectionists for ONI interrogation"
	explanation_text = "The Insurrection worsens every year. Put some on ice in ONI cryopods for later black site interrogation. Kill the rest"
	var/points_per_capture = 25
	var/points_per_kill = 10
	var/list/minds_captured = list()
	var/list/minds_killed = list()

/datum/objective/capture_innies/check_completion()
	win_points = 0
	win_points += minds_captured.len * points_per_capture
	win_points += minds_killed.len * points_per_kill
	return win_points > 0

/datum/objective/retrieve_artifact/unsc
	short_text = "Secure the alien artifact"
	explanation_text = "ONI reports a high value unidentified alien artifact in the sector. It must be secured by the UNSC to prevent falling into the wrong hands."

/datum/objective/protect_colony
	short_text = "Protect the UEG colony"
	explanation_text = "There are a million innocent civilians on that colony. Prevent its destruction by any means necessary."
	lose_points = 100

/datum/objective/protect_colony/check_completion()
	var/obj/effect/overmap/human_colony = GLOB.HUMAN_CIV.get_base()
	if(human_colony && (human_colony.nuked || human_colony.glassed))
		return 0
	return 1

/datum/objective/destroy_ship/unsc
	short_text = "Destroy the Covenant warship"
	explanation_text = "We cannot allow the Covenant warship to escape to threaten Earth. Take it out before it retreats from the system."
	slipspace_affected = 1

/datum/objective/destroy_ship/unsc/find_target()
	target_ship = GLOB.COVENANT.get_flagship()
	return target_ship

/datum/objective/colony_capture/unsc
	short_text = "Hold the colony"
	explanation_text = "We draw the line here. Do not allow rebels or aliens to capture our world."
