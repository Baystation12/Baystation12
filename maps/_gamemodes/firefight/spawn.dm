
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

/datum/game_mode/firefight/proc/spawn_attackers_tick()
	set background = 1
	var/amount = min(max_spawns_tick, enemy_strength_left)
	enemy_strength_left -= amount

	//pick a hostile mob to spawn
	while(amount >= 1)
		//using the weighting here is a bit of a hack...
		//a higher weighting should correspond with a weak, common enemy
		//therefore a higher weighted mob type we will spawn more of
		var/spawn_type = pickweight(enemy_faction.defender_mob_types)
		var/weighting = enemy_faction.defender_mob_types[spawn_type]
		spawn_attackers(spawn_type, weighting)
		amount -= 1

/datum/game_mode/firefight/proc/spawn_attackers(var/spawntype, var/amount)

	//spawn_landmarks
	var/list/available_spawns = list()
	for(var/previous_wave = 1, previous_wave <= current_wave, previous_wave++)
		if(previous_wave > spawn_landmarks.len)
			break
		var/list/spawn_tier = spawn_landmarks[previous_wave]
		available_spawns.Add(spawn_tier)

	if(available_spawns.len)
		for(var/i = 0, i < amount, i++)
			var/obj/spawn_landmark = pick(available_spawns)
			var/atom/spawnloc = spawn_landmark.loc		//could be inside a vehicle etc
			var/mob/living/simple_animal/hostile/H = new spawntype(spawnloc)
			H.our_overmind = overmind
			H.assault_target_type = assault_landmark_type
			overmind.combat_troops += H
	else
		log_admin("GAMEMODE ERROR: gamemode unable to find any spawn landmarks")
