
/datum/faction/proc/generate_quest()
	//create a new quest
	var/datum/npc_quest/new_quest = new()
	all_quests.Add(new_quest)
	available_quests.Add(new_quest)
	new_quest.faction = src
	. = new_quest

	//quest details
	new_quest.enemy_faction = pick(enemy_factions + GLOB.criminal_factions_by_name)
	new_quest.location_name = "\
		[pick(GLOB.station_departments)] \
		[pick(GLOB.station_suffixes)] \
		[pick(pick(GLOB.greek_letters, GLOB.phonetic_alphabet, GLOB.numbers_as_words))]"
	new_quest.difficulty = rand(1, 100)/100
	new_quest.dist = rand(100,10000)
	new_quest.loot_type = pick("coins","weapons","armour")

	//quest rewards
	new_quest.favour_reward = 10 + round((REWARD_FAVOUR-10) * new_quest.difficulty)		//minimum 11 rep
	if(prob(50))
		//give a reduced favour reward but award credits
		new_quest.favour_reward = round(new_quest.favour_reward / 2)
		new_quest.credit_reward = round(REWARD_CREDITS / 10 + 0.9 * REWARD_CREDITS * new_quest.difficulty)

	//number of attempts allowed scales with difficulty
	new_quest.attempts_allowed = max(round(new_quest.difficulty * 5, 1), 1)

	//quest type
	new_quest.quest_type = pick(OBJ_KILL, OBJ_ASSASSINATE, OBJ_STEAL)
	new_quest.map_path = pick(new_quest.map_references)
	switch(new_quest.quest_type)
		if(OBJ_KILL)
			//kill simple mobs
			new_quest.desc_text = "Eliminate everyone you find."
		if(OBJ_ASSASSINATE)
			//kill VIP simple mob
			new_quest.desc_text = "Assassinate the leader."
		if(OBJ_STEAL)
			//retrieve item
			new_quest.desc_text = "Steal [new_quest.loot_type]."

	//quest enemies
	var/datum/faction/F = GLOB.factions_by_name[new_quest.enemy_faction]
	new_quest.defender_types = F.defender_mob_types

	//update any comms programs that need updating
	for(var/datum/nano_module/program/innie_comms/listening_program in listening_programs)
		listening_program.quest_generated(src)
