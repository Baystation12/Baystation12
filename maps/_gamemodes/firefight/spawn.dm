
/obj/effect/landmark/spawn_easy
	name = "spawn marker easy"
	icon = 'spawn.dmi'
	icon_state = "easy"

/obj/effect/landmark/spawn_medium
	name = "spawn marker medium"
	icon = 'spawn.dmi'
	icon_state = "medium"

/obj/effect/landmark/spawn_hard
	name = "spawn marker hard"
	icon = 'spawn.dmi'
	icon_state = "hard"

/obj/effect/landmark/spawn_legendary
	name = "spawn marker legendary"
	icon = 'spawn.dmi'
	icon_state = "legendary"

/datum/game_mode/firefight
	var/list/wave_spawns = list(\
		list(\
			/mob/living/simple_animal/hostile/covenant/grunt = 2,\
			/mob/living/simple_animal/hostile/covenant/drone/ranged = 1,\
			/mob/living/simple_animal/hostile/covenant/jackal/shield = 1,\
			/mob/living/simple_animal/hostile/covenant/elite = 1\
			),\
		list(\
			/mob/living/simple_animal/hostile/covenant/grunt/major = 2,\
			/mob/living/simple_animal/hostile/covenant/drone/ranged = 1,\
			/mob/living/simple_animal/hostile/covenant/drone = 1,\
			/mob/living/simple_animal/hostile/covenant/jackal/shield = 2,\
			/mob/living/simple_animal/hostile/covenant/jackal = 1,\
			/mob/living/simple_animal/hostile/covenant/elite = 1,\
			/mob/living/simple_animal/hostile/covenant/elite/major = 1\
			),\
		list(\
			/mob/living/simple_animal/hostile/covenant/grunt/ultra = 1,\
			/mob/living/simple_animal/hostile/covenant/grunt/heavy = 1,\
			/mob/living/simple_animal/hostile/covenant/jackal/shield = 1,\
			/mob/living/simple_animal/hostile/covenant/drone = 1,\
			/mob/living/simple_animal/hostile/covenant/jackal/sniper = 1,\
			/mob/living/simple_animal/hostile/covenant/elite/major = 2,\
			/mob/living/simple_animal/hostile/covenant/elite/ultra = 1\
			),\
		list(\
			/mob/living/simple_animal/hostile/covenant/grunt = 1,\
			/mob/living/simple_animal/hostile/covenant/grunt/major = 1,\
			/mob/living/simple_animal/hostile/covenant/grunt/ultra = 1,\
			/mob/living/simple_animal/hostile/covenant/grunt/heavy = 1,\
			/mob/living/simple_animal/hostile/covenant/drone/ranged = 1,\
			/mob/living/simple_animal/hostile/covenant/drone = 1,\
			/mob/living/simple_animal/hostile/covenant/jackal = 1,\
			/mob/living/simple_animal/hostile/covenant/jackal/shield = 1,\
			/mob/living/simple_animal/hostile/covenant/jackal/sniper = 1,\
			/mob/living/simple_animal/hostile/covenant/elite = 1,\
			/mob/living/simple_animal/hostile/covenant/elite/major = 1,\
			/mob/living/simple_animal/hostile/covenant/elite/ultra = 1,\
			/mob/living/simple_animal/hostile/covenant/elite/zealot = 1\
			),\
		list(\
			/mob/living/simple_animal/hostile/covenant/grunt/heavy = 1,\
			/mob/living/simple_animal/hostile/covenant/jackal/sniper = 1,\
			/mob/living/simple_animal/hostile/covenant/elite/zealot = 1\
			),\
		list(\
			/mob/living/simple_animal/hostile/covenant/grunt = 1,\
			/mob/living/simple_animal/hostile/covenant/grunt/major = 1,\
			/mob/living/simple_animal/hostile/covenant/grunt/ultra = 1,\
			/mob/living/simple_animal/hostile/covenant/grunt/heavy = 1,\
			/mob/living/simple_animal/hostile/covenant/drone/ranged = 1,\
			/mob/living/simple_animal/hostile/covenant/drone = 1,\
			/mob/living/simple_animal/hostile/covenant/jackal = 1,\
			/mob/living/simple_animal/hostile/covenant/jackal/shield = 1,\
			/mob/living/simple_animal/hostile/covenant/jackal/sniper = 1,\
			/mob/living/simple_animal/hostile/covenant/elite = 1,\
			/mob/living/simple_animal/hostile/covenant/elite/major = 1,\
			/mob/living/simple_animal/hostile/covenant/elite/ultra = 1,\
			/mob/living/simple_animal/hostile/covenant/elite/zealot = 1\
			)\
		)

/datum/game_mode/firefight/proc/spawn_attackers_tick()
	set background = 1
	if(world.time < next_subwave_at)
		return
	var/amount = min(max_spawns_tick, enemy_numbers_left)
	enemy_numbers_left -= amount

	//pick a hostile mob to spawn
	var/list/weighted_spawn_list
	if(wave_spawns.len)
		//this gamemode has a custom list of spawns in increasing difficulty per wave
		var/spawn_list_index = current_wave
		if(spawn_list_index > wave_spawns.len)
			spawn_list_index = wave_spawns.len
		weighted_spawn_list = wave_spawns[spawn_list_index]
		last_spawns_list = weighted_spawn_list
	else
		if(last_spawns_list)
			weighted_spawn_list = last_spawns_list
		else
			//no custom emeny list and no previous wave list, just pull from the faction defender list
			weighted_spawn_list = enemy_faction.defender_mob_types
			last_spawns_list = weighted_spawn_list

	while(amount >= 1)
		var/spawn_type = pickweight(weighted_spawn_list)
		spawn_attackers(spawn_type, 1)
		amount -= 1
	next_subwave_at = world.time + spawn_subwave_interval

/datum/game_mode/firefight/proc/spawn_attackers(var/spawntype, var/amount)

	//random list of spawns for enemy mobs
	//later waves unlock more spawn locations
	//higher difficulties unlock the spawn locations faster
	/*
	var/list/available_spawns = list()
	var/difficulty_modifier = max(GLOB.difficulty_level - 2, 0)
	for(var/previous_wave = 1, previous_wave <= current_wave + difficulty_modifier, previous_wave++)
		if(previous_wave > spawn_landmarks.len)
			break
		var/list/spawn_tier = spawn_landmarks[previous_wave]
		available_spawns.Add(spawn_tier)
		*/

	if(wave_spawn_landmarks.len)
		for(var/i=0, i<amount, i++)
			var/obj/spawn_landmark = pick(wave_spawn_landmarks)
			var/atom/spawnloc = spawn_landmark.loc		//could be inside a vehicle etc
			var/mob/living/simple_animal/hostile/H = new spawntype(spawnloc)
			H.our_overmind = overmind
			H.assault_target_type = assault_landmark_type
			overmind.combat_troops += H

	else
		log_admin("GAMEMODE ERROR: gamemode unable to find any spawn landmarks")
