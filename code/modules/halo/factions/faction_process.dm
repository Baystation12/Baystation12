
/datum/faction/proc/start_processing()
	if(!is_processing)
		GLOB.factions_controller.processing_factions.Add(src)
		is_processing = 1

/datum/faction/proc/process()
	var/keep_processing = 0
	for(var/datum/faction/F in angry_factions)
		if(get_faction_reputation(F.name) < 0)
			add_faction_reputation(F.name, 0.1)
		if(get_faction_reputation(F.name) >= 0)
			angry_factions -= F

	if(angry_factions.len)
		keep_processing = 1

	if(active_quests.len < max_npc_quests)
		if(world.time > time_next_quest)
			time_next_quest = world.time + rand(quest_interval_min, quest_interval_max)
			generate_quest()
		keep_processing = 1

	if(accepted_quests.len)
		for(var/datum/npc_quest/Q in accepted_quests)
			if(world.time > Q.time_failed)
				reject_quest(Q.attempting_faction, Q)
		keep_processing = 1

	if(!keep_processing)
		GLOB.factions_controller.processing_factions.Remove(src)
		is_processing = 0
