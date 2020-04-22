
/datum/game_mode/firefight/process()
	//latest_tick_time = world.time

	if(is_spawning)
		//don't end the wave if there are still enemy troops
		if(enemy_strength_left <= 0 && !overmind.combat_troops.len)
			//end the wave and start the rest period
			is_spawning = 0
			time_rest_end = world.time + rest_time
			to_world("<span class='danger'>[rest_message]</span> \
				<span class='notice'>You now have a [round(rest_time / (1 MINUTE),1)] minute rest. There is [max_waves - current_wave] waves left until evacuation.</span>")

		else
			spawn(0)
				spawn_attackers_tick()
	else
		//rest period is currently ongoing
		if(world.time > time_rest_end)
			//end the rest period and start spawning enemies
			is_spawning = 1

			//enemies get stronger each wave
			enemy_strength_left = enemy_strength_base + enemy_strength_base * current_wave * wave_strength_multiplier

			//is this the final wave?
			current_wave++
			if(current_wave >= max_waves)
				evac_stage = 1
				to_world("<span class='danger'>[evac_message]</span>")
			else
				to_world("<span class='danger'>[wave_message]</span>")

	if(evac_stage)
		process_evac()
	else
		process_resupply()
