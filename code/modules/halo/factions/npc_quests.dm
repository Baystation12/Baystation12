
/datum/npc_quest
	var/name
	var/desc_text
	var/list/gear_rewards = list()
	var/favour_reward = 0
	var/credit_reward = 0
	var/enemy_faction
	var/difficulty = 1
	var/quest_type = 0

/datum/faction/proc/generate_quest()
	var/datum/npc_quest/new_quest = new()

	new_quest.enemy_faction = pick(enemy_factions)

	new_quest.difficulty = rand(1,10)

	if(prob(50))
		new_quest.favour_reward = new_quest.difficulty * 5 * rand(2,6)
	else
		new_quest.credit_reward = new_quest.difficulty * 100 * rand(1,10)

	new_quest.quest_type = pick(1,2,3,4)

	//kill simple mobs

	//kill VIP simple mob

	//retrieve item

	//destroy machine

	active_quests.Add(new_quest)
	return new_quest

/datum/faction/proc/complete_quest(var/datum/npc_quest/Q)
	active_quests.Remove(Q)
	complete_quests.Add(Q)
