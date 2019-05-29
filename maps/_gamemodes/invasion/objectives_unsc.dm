
/* UNSC */

/datum/objective/protect/protect_unsc_leader
	short_text = "Protect the UNSC commander"
	explanation_text = "Without a strong chain of command, everything is lost. Protect the UNSC executive officer."
	lose_points = 50
	find_specific_target = 1

/datum/objective/protect/protect_unsc_leader/find_target_specific(var/datum/mind/check_mind)
	if(check_mind)
		if(!target)
			if(check_mind.assigned_role == "UNSC Heavens Above Commanding Officer")
				target = check_mind
			else if(check_mind.assigned_role == "UNSC Bertels Commanding Officer")
				target = check_mind
			if(target)
				. = 1
	else
		find_target_by_role("UNSC Heavens Above Commanding Officer")
		if(!target)
			find_target_by_role("UNSC Bertels Commanding Officer")
		if(target)
			. = 1

	if(explanation_text == "Free Objective")
		explanation_text  = "Protect your executive officer."

/datum/objective/protect_unsc_ship
	short_text = "Protect the UNSC warship"
	explanation_text = "Although cheaper than a MJOLNIR suit, even Spartans need a way to leave atmosphere. Protect the UNSC ship."
	lose_points = 100

/datum/objective/protect_unsc_ship/check_completion()
	var/datum/game_mode/invasion/game_mode = ticker.mode
	if(istype(game_mode))
		if(game_mode.unsc_ship && game_mode.unsc_ship.loc)
			return 1
	return 0

//see objectives_cov.dm
/datum/objective/steal_nav_data/cole_protocol
	short_text = "Do not allow Covenant capture of human nav data"
	explanation_text = "We lose more colonies every year. Soon Earth will be all we have left. Do not allow navchips to be captured by the Covenant."
	points_per_nav = 60
	slipspace_affected = 1

/datum/objective/steal_nav_data/cole_protocol/check_completion()
	if(override > 0)
		return 1
	else if(override < 0)
		return 0

	. = ..()

	lose_points = win_points
	win_points = 0

	return !.

/datum/objective/steal_nav_data/cole_protocol/get_win_points()
	return 0

/datum/objective/steal_ai/cole_protocol
	points_per_ai = 200
	short_text = "Do not allow Covenant capture of UNSC AI"
	explanation_text = "Destruction or capture of shipboard AI is absolutely unacceptable. They'll learn everything: weapons research, force deployments, Earth."
	slipspace_affected = 1

/datum/objective/steal_ai/cole_protocol/check_completion()
	if(override > 0)
		return 1
	else if(override < 0)
		return 0

	. = ..()

	lose_points = win_points
	win_points = 0

	return !.

/datum/objective/steal_ai/cole_protocol/get_win_points()
	return 0

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

/datum/objective/retrieve_artifact/unsc/check_completion()
	var/datum/game_mode/invasion/game_mode = ticker.mode
	if(istype(game_mode))
		for(var/area/area in game_mode.unsc_base_areas)
			for(var/obj/machinery/artifact/A in area)
				artifacts_recovered += 1

	win_points = artifacts_recovered * points_per_artifact

	return artifacts_recovered > 0

/datum/objective/protect_colony
	short_text = "Protect the UEG colony"
	explanation_text = "There are a million innocent civilians on that colony. Prevent its destruction by any means necessary."
	lose_points = 100

/datum/objective/protect_colony/check_completion()
	var/datum/game_mode/invasion/game_mode = ticker.mode
	if(istype(game_mode))
		if(game_mode.human_colony && (game_mode.human_colony.nuked || game_mode.human_colony.glassed))
			return 0
	return 1

/datum/objective/destroy_cov_ship
	short_text = "Destroy the Covenant warship"
	explanation_text = "We cannot allow the Covenant warship to escape to threaten Earth. Take it out before it retreats from the system."
	win_points = 100
	slipspace_affected = 1

/datum/objective/destroy_cov_ship/check_completion()
	if(override > 0)
		return 1
	else if(override < 0)
		return 0

	var/datum/game_mode/invasion/game_mode = ticker.mode
	if(istype(game_mode))
		if(!game_mode.cov_ship)
			return 1
	return 0

/datum/objective/colony_capture/innie
	short_text = "Hold the colony"
	explanation_text = "We draw the line here. Do not allow rebels or aliens to capture our world."
