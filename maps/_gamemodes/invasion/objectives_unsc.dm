
/* UNSC */

/datum/objective/protect/protect_unsc_leader
	short_text = "Protect the UNSC commander"
	explanation_text = "Without a strong chain of command, everything is lost."
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
				return 1
	else
		find_target_by_role("UNSC Heavens Above Commanding Officer")
		if(!target)
			find_target_by_role("UNSC Bertels Commanding Officer")
		if(target)
			return 1

/datum/objective/protect_unsc_ship
	short_text = "Protect the UNSC warship"
	explanation_text = "Although it might not cost as much as a MJOLNIR suit, even the Spartans need a way to leave atmosphere."
	lose_points = 100

/datum/objective/protect_unsc_ship/check_completion()
	var/datum/game_mode/invasion/game_mode = ticker.mode
	if(istype(game_mode))
		if(game_mode.unsc_ship)
			return 1
	return 0

//see objectives_cov.dm
/datum/objective/steal_nav_data/cole_protocol
	short_text = "Do not allow Covenant capture of human nav data"
	explanation_text = "We're losing more colonies every year. Soon, Earth will be all we have left. Do not allow the Covenant to discover any more colonies."
	points_per_nav = 60

/datum/objective/steal_nav_data/cole_protocol/check_completion()
	. = ..()

	lose_points = win_points
	win_points = 0

	return !.

/datum/objective/steal_nav_data/cole_protocol/get_award_points()
	return 0

/datum/objective/steal_ai/cole_protocol
	points_per_ai = 200
	short_text = "Do not allow Covenant capture of UNSC AI"
	explanation_text = "Destruction or capture of shipboard AI is absolutely unacceptable. They'll learn everything: weapons research, force deployments, Earth."

/datum/objective/steal_ai/cole_protocol/check_completion()
	. = ..()

	lose_points = win_points
	win_points = 0

	return !.

/datum/objective/steal_ai/cole_protocol/get_award_points()
	return 0

//todo: oni agent job role

/datum/objective/capture_innies
	short_text = "Capture Insurrectionists for ONI interrogation"
	explanation_text = "Projections indicate the  Insurrection is worsening. Left unchecked, the UEG will be torn apart in a few decades."
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
	explanation_text = "ONI reports a high value unidentified alien artifact in the sector. It must be secured to prevent it falling into the wrong hands."

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
	explanation_text = "Earth. Soon it's all we'll have left. Stop them here so we don't have to fight them there."
	lose_points = 100

/datum/objective/protect_colony/check_completion()
	var/datum/game_mode/invasion/game_mode = ticker.mode
	if(istype(game_mode))
		if(game_mode.human_colony && (game_mode.human_colony.nuked || game_mode.human_colony.glassed))
			return 0
	return 1

/datum/objective/destroy_cov_ship
	short_text = "Destroy the Covenant warship"
	explanation_text = "We cannot allow this warship to escape to threaten Earth. Take it out by any means necessary."
	win_points = 100

/datum/objective/destroy_cov_ship/check_completion()
	var/datum/game_mode/invasion/game_mode = ticker.mode
	if(istype(game_mode))
		if(!game_mode.cov_ship)
			return 1
	return 0
