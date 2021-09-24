
/datum/game_mode/firefight/process()
	//latest_tick_time = world.time

	if(is_spawning)
		//don't end the wave if there are still enemy troops
		if(enemy_numbers_left <= 0 && !overmind.combat_troops.len)
			//end the wave and start the rest period
			is_spawning = 0
			time_rest_end = world.time + rest_time
			to_world("<span class='danger'>[rest_message]</span> \
				<span class='notice'>You now have a [round(rest_time / (1 MINUTE),1)] minute rest. There is [max_waves - current_wave] waves left until evacuation.</span>")

			//give the players a resupply
			spawn(20)
				do_resupply()

			//unlock something special
			spawn(60)
				unlock_special_job()

		else
			spawn(0)
				spawn_attackers_tick()
	else
		//rest period is currently ongoing
		if(world.time > time_rest_end)
			//end the rest period and start spawning enemies
			is_spawning = 1

			//enemies get stronger each wave
			var/wave_bonus = wave_bonus_enemies[GLOB.difficulty_level] * current_wave

			//more players means stronger enemies
			var/players_alive = max(player_faction.players_alive() - 1, 0)
			var/playercount_bonus = player_bonus_enemies[GLOB.difficulty_level]
			var/player_bonus = playercount_bonus * players_alive
			max_spawns_tick = min(max_spawns_tick_perf,round(max_spawns_tick_base + player_bonus))

			//calculate the enemy strength for this wave
			enemy_numbers_left = enemy_numbers_base + wave_bonus + player_bonus

			//choose the places they will spawn from
			current_wave++
			var/list/possible_spawns = spawn_landmarks.Copy()
			for(var/i=0,i<current_wave,i++)
				if(!possible_spawns.len)
					break
				var/list/chosen_spawns = pick(possible_spawns)
				wave_spawn_landmarks |= chosen_spawns
				possible_spawns -= chosen_spawns

			if(!possible_spawns.len)
				log_admin("SPAWN: cannot find spawn landmark list")

			//is this the final wave?
			if(current_wave == max_waves)
				evac_stage = 1
				to_world("<span class='danger'>[evac_message]</span>")
			else
				to_world("<span class='danger'>[wave_message]</span>")

				//give the players a resupply
				spawn(20)
					do_resupply()

	if(evac_stage)
		process_evac()
	/*else
		process_resupply()*/
