
/* COVENANT */

/datum/objective/protect/protect_cov_leader
	short_text = "Protect Covenant leader"
	explanation_text = "The most skilled warriors lead the fight. Their loss is a terrible setback to the Great Journey."
	lose_points = 50
	find_specific_target = 1

/datum/objective/protect/protect_cov_leader/find_target_specific(var/datum/mind/check_mind)
	if(check_mind)
		if(!target)
			if(check_mind.assigned_role == "Sangheili - Shipmaster")
				target = check_mind
			else if(check_mind.assigned_role == "Kig-Yar Ship-captain")
				target = check_mind
			if(target)
				return 1
	else
		find_target_by_role("Sangheili - Shipmaster")
		if(!target)
			find_target_by_role("Kig-Yar Ship-captain")
		if(target)
			return 1

/datum/objective/destroy_unsc_ship
	short_text = "Destroy the UNSC warship"
	explanation_text = "The human captains are tenacious, and their weapons are crude but occasionally effective. Eliminate the warship in the area."
	win_points = 100

/datum/objective/destroy_unsc_ship/check_completion()
	var/datum/game_mode/invasion/game_mode = ticker.mode
	if(istype(game_mode))
		if(!game_mode.unsc_ship)
			return 1
	return 0

/datum/objective/protect_cov_ship
	short_text = "Protect Covenant ship"
	explanation_text = "This is your only route back to Covenant space. Do not allow it to be destroyed."
	lose_points = 100

/datum/objective/protect_cov_ship/check_completion()
	var/datum/game_mode/invasion/game_mode = ticker.mode
	if(istype(game_mode))
		if(game_mode.cov_ship)
			return 1
	return 0

/datum/objective/steal_ai
	var/points_per_ai = 100
	var/ai_stolen = 0
	short_text = "Capture human AI"
	explanation_text = "The human intelligent constructs are vast repositories of tactical and navigational data. Retrieving one would be a great boost to the Covenant."

/datum/objective/steal_ai/check_completion()
	var/datum/game_mode/invasion/game_mode = ticker.mode
	ai_stolen = 0
	if(istype(game_mode))
		for(var/area/area in game_mode.covenant_ship_areas)
			for(var/mob/living/silicon/ai/A in area)
				ai_stolen += 1

	win_points = ai_stolen * points_per_ai

	return ai_stolen > 0

/datum/objective/steal_ai/get_award_points()
	return points_per_ai

/datum/objective/retrieve_artifact
	short_text = "Retrieve the Forerunner artifact"
	explanation_text = "These vermin are hiding a Forerunner artifact somewhere in this system. Locate it and bring it home!"
	var/artifacts_recovered = 0
	var/points_per_artifact = 200

/datum/objective/retrieve_artifact/check_completion()
	var/datum/game_mode/invasion/game_mode = ticker.mode
	if(istype(game_mode))
		for(var/area/area in game_mode.covenant_ship_areas)
			for(var/obj/machinery/artifact/A in area)
				artifacts_recovered += 1

	win_points = artifacts_recovered * points_per_artifact

	return artifacts_recovered > 0

/datum/objective/retrieve_artifact/get_award_points()
	return points_per_artifact

/datum/objective/steal_nav_data
	short_text = "Steal navigation datachips from the humans."
	explanation_text = "We must locate the hideout of these vermin! Retrieve all nav data chips you can for examination"
	var/points_per_nav = 30

/datum/objective/steal_nav_data/check_completion()
	var/list/cov_ship_areas = list()
	win_points = 0
	for(var/area/area in cov_ship_areas)
		for(var/obj/item/nav_data_chip/C in area)
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

/datum/objective/steal_nav_data/get_award_points()
	return points_per_nav * 4

/datum/objective/glass_colony
	short_text = "Glass the human colony."
	explanation_text = "These vermin cannot be allowed to live. The surface of their worlds must burn until it is glass!"
	win_points = 100

/datum/objective/glass_colony/check_completion()
	var/datum/game_mode/invasion/game_mode = ticker.mode
	if(istype(game_mode))
		if(game_mode.human_colony && game_mode.human_colony.glassed)
			return 1
	return 0
