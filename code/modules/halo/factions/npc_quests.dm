
#define REWARD_FAVOUR 100
#define REWARD_CREDITS 10000

/datum/npc_quest
	var/desc_text
	var/list/gear_rewards = list()
	var/favour_reward = 0
	var/credit_reward = 0
	var/enemy_faction
	var/difficulty = 1
	var/quest_type = 0
	var/location_name
	var/quest_status = 0		//0 = available, 1 = in progress, 2 = failed, 3 = won
	var/dist = 0
	var/datum/objective/npc_quest/quest_objective
	var/datum/faction/faction
	var/datum/faction/attempting_faction

/datum/npc_quest/proc/get_status_text()
	switch(quest_status)
		if(0)
			return "Available"
		if(1)
			return "In progress"
		if(2)
			return "Failed"
		if(3)
			return "Completed"

/datum/npc_quest/proc/is_expired()
	return quest_status > 1

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

/datum/npc_quest/proc/finalise_quest()
	//WIP: just auto succeed for now
	/*
	if(quest_objective.check_completion())
		quest_status = 3
	else
		quest_status = 2
		*/
	quest_status = 3
	faction.complete_quest(src)

/datum/faction/proc/generate_quest()
	//create a new quest
	var/datum/npc_quest/new_quest = new()

	//quest details
	new_quest.enemy_faction = pick(enemy_factions + GLOB.criminal_factions)
	new_quest.location_name = "\
		[pick(GLOB.station_departments)] \
		[pick(GLOB.station_suffixes)] \
		[pick(pick(GLOB.greek_letters, GLOB.phonetic_alphabet, GLOB.numbers_as_words))]"
	new_quest.difficulty = rand(1, 100)/100
	new_quest.dist = rand(1,10000)

	//quest rewards
	new_quest.favour_reward = 10 + round((REWARD_FAVOUR-10) * new_quest.difficulty)		//minimum 11 rep
	if(prob(50))
		//give a reduced favour reward but award credits
		new_quest.favour_reward = round(new_quest.favour_reward / 2)
		new_quest.credit_reward = round(REWARD_CREDITS / 2 + REWARD_CREDITS * new_quest.difficulty)

	//quest type
	new_quest.quest_type = pick(1,2)//pick(1,2,3,4)
	switch(new_quest.quest_type)
		if(1)
			//kill simple mobs
			new_quest.desc_text = "Kill everyone to [pick("send them a message","take them down a notch","scare them","weaken them")]."
			new_quest.quest_objective = new /datum/objective/npc_quest/kill()
		if(2)
			//kill VIP simple mob
			new_quest.desc_text = "Kill the leader"
			new_quest.quest_objective = new /datum/objective/npc_quest/assassinate()
		if(3)
			//retrieve item
			new_quest.desc_text = "Steal [pick("weapons","credits","armour","equipment")]."
			new_quest.quest_objective = new /datum/objective/npc_quest/steal()
		if(4)
			//destroy machine
			new_quest.desc_text = "Destroy equipment."
			new_quest.quest_objective = new /datum/objective/npc_quest/sabotage()

	//quest enemies
	var/datum/faction/F = GLOB.factions_by_name[new_quest.enemy_faction]
	new_quest.quest_objective.defender_types = F.defender_mob_types

	//finish up
	active_quests.Add(new_quest)
	new_quest.faction = src
	return new_quest

/datum/faction/proc/reject_quest(var/faction_name, var/datum/npc_quest/Q)
	active_quests.Remove(Q)
	if(Q.quest_status == 1)
		Q.quest_status = 2
		//lose double the reputation if we accepted the quest
		add_faction_reputation(faction_name, -Q.favour_reward * 2)
		completed_quests.Add(Q)
	else
		add_faction_reputation(faction_name, -Q.favour_reward)
		qdel(Q)

/datum/faction/proc/complete_quest(var/datum/npc_quest/Q)
	active_quests.Remove(Q)
	completed_quests.Add(Q)

	//deposit the favour
	if(Q.quest_status == 2)
		//mission failed... lose a bit of reputation
		add_faction_reputation(Q.attempting_faction.name, -Q.favour_reward / 2)

	else if(Q.quest_status == 3)
		//mission success
		add_faction_reputation(Q.attempting_faction.name, Q.favour_reward)

		//deposit the credits
		if(Q.credit_reward)
			var/transaction_desc = "[pick("Mission to", "Sent to","Job at","Dispatched to","Requested at")] [Q.location_name] on behalf of [src.name] to [pick(\
				"take out the trash",\
				"do some babysitting",\
				"drop off a parcel",\
				"discipline the kids",\
				"drop the kids off",\
				"deliver a pizza",\
				"do some cleaning",\
				"handle a problem",\
				"sit in on a meeting",\
				"investigate a noise complaint"\
				)]."
			var/datum/transaction/T = new(src.name, transaction_desc, Q.credit_reward, "UEG Terminal #[rand(100000,999999)]")
			Q.attempting_faction.money_account.transaction_log.Add(T)
			Q.attempting_faction.money_account.money += Q.credit_reward

#undef REWARD_FAVOUR
#undef REWARD_CREDITS
