
#define COLONY_GLASSED_AMOUNT_REQUIRED 5 //5 projector hit for glassing to count.

/* COVENANT */

/datum/objective/protect/protect_cov_leader
	short_text = "Protect Covenant leader"
	explanation_text = "The most skilled warriors lead the fight. Their loss is a terrible setback to the Great Journey."
	lose_points = 50
	find_specific_target = 1
	slipspace_affected = 1

/datum/objective/protect/protect_cov_leader/find_target_specific(var/datum/mind/check_mind)
	if(check_mind)
		if(!target)
			if(check_mind.assigned_role == "Sangheili - Shipmaster")
				target = check_mind
			else if(check_mind.assigned_role == "Kig-Yar Ship-captain")
				target = check_mind
			if(target)
				. = 1
	else
		find_target_by_role("Sangheili - Shipmaster")
		if(!target)
			find_target_by_role("Kig-Yar Ship-captain")
		if(target)
			. = 1

	if(explanation_text == "Free Objective")
		explanation_text  = "Protect your shipmaster."

/datum/objective/protect/protect_cov_leader/check_completion()
	if(override > 0)
		return 1
	else if(override < 0)
		return 0
	return ..()

/datum/objective/destroy_unsc_ship
	short_text = "Destroy the human warship"
	explanation_text = "The human weapons are crude but occasionally effective. Eliminate the warship in the area."
	win_points = 100
	slipspace_affected = 1

/datum/objective/destroy_unsc_ship/check_completion()
	var/datum/game_mode/invasion/game_mode = ticker.mode
	if(istype(game_mode))
		if(!game_mode.unsc_ship)
			return 1
	return 0

/datum/objective/protect_cov_ship
	short_text = "Protect Covenant ship"
	explanation_text = "Your ship is your only route back to Covenant space. Do not allow it to be destroyed."
	lose_points = 100
	slipspace_affected = 1

/datum/objective/protect_cov_ship/check_completion()
	if(override > 0)
		return 1
	else if(override < 0)
		return 0

	var/datum/game_mode/invasion/game_mode = ticker.mode
	if(istype(game_mode))
		if(game_mode.cov_ship && game_mode.cov_ship.loc)
			return 1
	return 0

/datum/objective/steal_ai
	var/points_per_ai = 100
	var/ai_stolen = 0
	short_text = "Capture human construct"
	explanation_text = "These humans store tactical and navigational data in their intelligent constructs. What a prize!"
	slipspace_affected = 1

/datum/objective/steal_ai/check_completion()
	if(override > 0)
		return 1
	else if(override < 0)
		return 0

	var/datum/game_mode/invasion/game_mode = ticker.mode
	ai_stolen = 0
	if(istype(game_mode))
		for(var/area/area in game_mode.cov_ship_areas)
			for(var/mob/living/silicon/ai/A in area)
				ai_stolen += 1

	win_points = ai_stolen * points_per_ai

	return ai_stolen > 0

/datum/objective/steal_ai/get_win_points()
	return points_per_ai

/datum/objective/retrieve_artifact
	short_text = "Retrieve the Forerunner artifact"
	explanation_text = "The humans are hiding a Forerunner artifact somewhere in this system. Locate it and bring it to High Charity."
	var/artifacts_recovered = 0
	var/points_per_artifact = 200
	slipspace_affected = 1
	var/list/win_areas

/datum/objective/retrieve_artifact/check_completion()
	if(override > 0)
		return 1
	else if(override < 0)
		return 0

	if(!win_areas)
		var/datum/game_mode/invasion/game_mode = ticker.mode
		if(istype(game_mode))
			win_areas = game_mode.cov_ship_areas

	if(win_areas)
		for(var/area/cur_area in win_areas)
			for(var/obj/machinery/artifact/A in cur_area)
				artifacts_recovered += 1

	win_points = artifacts_recovered * points_per_artifact

	return artifacts_recovered > 0

/datum/objective/retrieve_artifact/get_win_points()
	return points_per_artifact

/datum/objective/steal_nav_data
	short_text = "Steal navigation datachips from the humans"
	explanation_text = "We must locate the hideout of these humans! Retrieve as many nav data chips you can for examination."
	var/points_per_nav = 30
	slipspace_affected = 1
	var/list/win_areas

/datum/objective/steal_nav_data/check_completion()
	if(override > 0)
		return 1
	else if(override < 0)
		return 0

	if(!win_areas)
		var/datum/game_mode/invasion/game_mode = ticker.mode
		if(istype(game_mode))
			win_areas = game_mode.cov_ship_areas

	if(win_areas)
		for(var/area/cur_area in win_areas)
			for(var/obj/item/nav_data_chip/C in cur_area)
				if(C.chip_faction == "covenant")
					continue
				if(istype(C, /obj/item/nav_data_chip/fragmented))
					//award partial points for fragments
					var/obj/item/nav_data_chip/fragmented/F = C
					win_points += points_per_nav * (F.fragments_have / F.fragments_required)
				else
					//award full points for the chip
					win_points += points_per_nav

	return win_points > 0

/datum/objective/steal_nav_data/get_win_points()
	return points_per_nav * 4

/datum/objective/glass_colony
	short_text = "Glass the human colony"
	explanation_text = "These humans cannot be allowed to live. The surface of their worlds must burn until they are glass!"
	win_points = 100
	slipspace_affected = 1

/datum/objective/glass_colony/check_completion()
	var/datum/game_mode/invasion/game_mode = ticker.mode
	if(istype(game_mode))
		if(game_mode.human_colony && game_mode.human_colony.glassed >= COLONY_GLASSED_AMOUNT_REQUIRED)
			return 1
	return 0

/datum/objective/colony_capture/cov
	short_text = "Capture the human colony"
	explanation_text = "Holding the human colony will give us time to search it for artifacts."

#undef COLONY_GLASSED_AMOUNT_REQUIRED
