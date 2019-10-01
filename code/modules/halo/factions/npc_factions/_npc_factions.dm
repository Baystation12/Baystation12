
/datum/faction/npc
	max_npc_quests = 4
	defender_mob_types = list(/mob/living/simple_animal/hostile/defender_mob/innie/medium = 3, /mob/living/simple_animal/hostile/defender_mob/innie/heavy)

/datum/faction/npc/New()
	. = ..()
	GLOB.npc_factions.Add(src)
	GLOB.innie_factions.Add(src)
	GLOB.innie_factions_by_name[name] = src

/datum/faction/npc/Initialize()
	start_processing()
	generate_quest()

/datum/faction/npc/generate_rep_rewards(var/player_reputation = 0)
	. = ..()

	var/rep_required = 9999999
	if(player_reputation < rep_required)
		locked_rep_rewards.Add(list(list(
			"name" = "Summon Allied Fleet",
			"cost" = "10,000 Reputation",
			"rep" = rep_required,
			"type" = "ability"
		)))
	else
		unlocked_rep_rewards.Add(list(list(
			"name" = "Summon Allied Fleet",
			"cost" = "10,000 Reputation",
			"rep" = rep_required,
			"type" = "ability"
		)))
