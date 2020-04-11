
/datum/npc_quest
	var/desc_text
	var/list/gear_rewards = list()
	var/favour_reward = 0
	var/credit_reward = 0
	var/enemy_faction
	var/difficulty = 1
	var/quest_type = 0
	var/location_name
	var/quest_status = STATUS_AVAIL		//0 = available, 1 = in progress, 2 = failed, 3 = won, 4 = abandoned
	var/dist = 0
	var/datum/objective/npc_quest/quest_objective
	var/datum/faction/faction
	var/datum/faction/attempting_faction
	var/datum/computer_file/data/coord/coords
	var/map_path
	var/instance_loaded = 0
	var/time_failed = 0
	var/area/instance_area
	var/number_of_attempts = 0
	var/attempts_allowed = 3

	var/static/list/map_references = list(\
	'maps/submaps/civilian/factory1.dmm' = "Factory",\
	'maps/submaps/civilian/drugalug1.dmm' = "Slums",\
	'maps/submaps/civilian/bank1.dmm' = "Bank vault"\
	)

/datum/npc_quest/proc/get_status_text()
	switch(quest_status)
		if(STATUS_AVAIL)
			return "Available"
		if(STATUS_PROGRESS)
			return "In progress"
		if(STATUS_TIMEOUT)
			return "Failed (ran out of time)"
		if(STATUS_FAIL)
			return "Failed"
		if(STATUS_WON)
			return "Completed"
		if(STATUS_ABANDON)
			return "Abandoned"

/datum/npc_quest/proc/get_time_left()
	return "[round((time_failed - world.time) / (1 MINUTE))] minutes left"

/datum/npc_quest/proc/is_expired()
	return quest_status > 1

/datum/npc_quest/proc/is_quest_active()
	return (quest_status == STATUS_AVAIL || quest_status == STATUS_PROGRESS)

/datum/npc_quest/proc/get_attempts_left()
	if(attempts_allowed < 1)
		return "unlimited"

	return "[attempts_allowed - number_of_attempts]"

/datum/npc_quest/proc/get_difficulty_stars()
	var/stars_left = difficulty * 5
	var/nanoui_string = ""
	do
		nanoui_string += "<div class='uiIcon16 icon-star'></div>"
		stars_left -= 1
	while(stars_left > 0)

	return nanoui_string

/datum/npc_quest/proc/get_difficulty_text()
	if(difficulty > 0.8)
		return "very hard"
	else if(difficulty > 0.6)
		return "hard"
	else if(difficulty > 0.4)
		return "moderate"
	else if(difficulty > 0.2)
		return "easy"
	else
		return "very easy"

/datum/npc_quest/proc/get_fail_favour()
	return favour_reward * -0.1

/datum/npc_quest/proc/get_win_favour()
	return favour_reward

/datum/npc_quest/proc/accept_quest(var/datum/faction/attempt_faction)
	//let's begin
	quest_status = STATUS_PROGRESS
	time_failed = world.time + 20 MINUTES
	attempting_faction = attempt_faction

	//tell our parent faction we have begun
	faction.available_quests.Remove(src)
	faction.processing_quests.Add(src)
	faction.start_processing()

/datum/npc_quest/proc/shuttle_returned()
	number_of_attempts++

	//update any comms programs that need updating
	for(var/datum/nano_module/program/innie_comms/listening_program in faction.listening_programs)
		listening_program.quest_attempted(faction)

	//quests have a limited number of attempts
	if(attempts_allowed > 0 && number_of_attempts >= attempts_allowed)
		faction.finalise_quest(src, STATUS_FAIL)
		faction.processing_quests.Remove(src)
		return 1

	//check if an objective was completed
	if(check_quest_objective())
		faction.processing_quests.Remove(src)
		return 1

	return 0
