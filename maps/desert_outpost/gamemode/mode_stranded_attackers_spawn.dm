
/datum/game_mode/stranded/proc/spawn_attackers_tick(var/amount = 1)
	set background = 1
	if(allowed_ghost_roles.len == 0 || isnull(allowed_ghost_roles))
		allowed_ghost_roles += list(/datum/ghost_role/flood_combat_form)
	amount += bonus_spawns
	bonus_spawns = 0
	while(amount >= 1)
		var/number_to_spawn
		var/spawn_type
		if(prob(33))
			number_to_spawn = 1
			spawn_type = pick(typesof(/mob/living/simple_animal/hostile/flood/combat_form) - list(/mob/living/simple_animal/hostile/flood/combat_form,/mob/living/simple_animal/hostile/flood/combat_form/juggernaut))
		else if(prob(50))
			number_to_spawn = 1
			spawn_type = /mob/living/simple_animal/hostile/flood/carrier
		else
			number_to_spawn = rand(4,6)
			spawn_type = /mob/living/simple_animal/hostile/flood/infestor
		spawn_attackers(spawn_type, number_to_spawn)
		amount -= 1
	bonus_spawns = max(amount, 0)

/datum/game_mode/stranded/proc/spawn_attackers(var/spawntype, var/amount)
	if(GLOB.live_flood_simplemobs.len >= GLOB.max_flood_simplemobs)
		return
	if(flood_spawn_turfs.len)
		for(var/i = 0, i < amount, i++)
			var/turf/spawn_turf = pick(flood_spawn_turfs)
			var/mob/living/simple_animal/hostile/flood/F = new spawntype(spawn_turf)
			if(flood_assault_turfs.len)
				var/turf/assault_turf = pick(flood_assault_turfs)
				assault_turf = pick(range(7, assault_turf))
				F.set_assault_target(assault_turf)
			else
				log_admin("Error: gamemode unable to find any /obj/effect/landmark/flood_assault_target/")
	else
		log_admin("Error: gamemode unable to find any /obj/effect/landmark/flood_spawn/")
