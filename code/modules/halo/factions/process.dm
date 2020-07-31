
/datum/faction/proc/start_processing()
	if(!is_processing)
		GLOB.factions_controller.processing_factions.Add(src)
		is_processing = 1

/datum/faction/proc/process()
	//only do a process tick if we need to
	var/keep_processing = 0

	//negative reputation will decay upwards to 0 over time
	for(var/datum/faction/F in angry_factions)
		if(get_faction_reputation(F.name) < 0)
			add_faction_reputation(F.name, 0.1)
		if(get_faction_reputation(F.name) >= 0)
			angry_factions -= F

	//regain some rep next tick too
	if(angry_factions.len)
		keep_processing = 1

	//a new quest has become available
	if(available_quests.len < max_npc_quests)
		if(world.time > time_next_quest)
			time_next_quest = world.time + rand(quest_interval_min, quest_interval_max)
			generate_quest()
		keep_processing = 1

	//quests need processing sometimes
	if(processing_quests.len)
		for(var/datum/npc_quest/Q in processing_quests)
			if(Q.process() != PROCESS_KILL)
				//assume the quest has already been removed from processing_quests elsewhere if PROCESS_KILL is returned
				keep_processing = 1

	if(handle_fleet())
		keep_processing = 1

	if(income)
		handle_income()
		keep_processing = 1

	//looks like we're finished and can go dormant for now
	if(!keep_processing)
		GLOB.factions_controller.processing_factions.Remove(src)
		is_processing = 0
