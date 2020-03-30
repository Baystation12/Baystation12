
#define REWARD_FAVOUR 100
#define REWARD_CREDITS 10000
//
#define OBJ_KILL 1
#define OBJ_ASSASSINATE 2
#define OBJ_STEAL 3
//
#define STATUS_AVAIL 0
#define STATUS_PROGRESS 1
#define STATUS_FAIL 2
#define STATUS_WON 3
#define STATUS_ABANDON 4
#define STATUS_TIMEOUT 5

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

/datum/npc_quest/proc/accept_quest(var/datum/faction/attempt_faction)
	quest_status = 1
	time_failed = world.time + 20 MINUTES
	attempting_faction = attempt_faction
	faction.accepted_quests.Add(src)
	faction.start_processing()

/datum/faction/proc/reject_quest(var/datum/faction/attempting_faction, var/datum/npc_quest/Q, var/abandoned = 0)
	active_quests.Remove(Q)
	accepted_quests.Remove(Q)
	if(Q.quest_status == STATUS_PROGRESS)
		//lose the reputation
		var/favour_multiplier = -1.5
		if(abandoned)
			Q.quest_status = STATUS_ABANDON
			favour_multiplier = -2
		add_faction_reputation(attempting_faction.name, Q.favour_reward * favour_multiplier)
		completed_quests.Add(Q)
	else
		add_faction_reputation(attempting_faction.name, -Q.favour_reward)
		qdel(Q)
	attempting_faction.update_reputation_gear(src)
	generate_rep_rewards(get_faction_reputation(attempting_faction.name))

/datum/faction/proc/complete_quest(var/datum/npc_quest/Q)
	active_quests.Remove(Q)
	completed_quests.Add(Q)

	//deposit the favour
	if(Q.quest_status == STATUS_FAIL)
		//mission failed... lose a bit of reputation
		add_faction_reputation(Q.attempting_faction.name, -Q.favour_reward / 2)

	else if(Q.quest_status == STATUS_WON)
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
