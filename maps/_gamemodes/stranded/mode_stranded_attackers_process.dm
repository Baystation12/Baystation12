
/datum/game_mode/stranded/proc/process_spawning()
	if(is_spawning)
		//wave is currently ongoing
		if(world.time > time_wave_cycle)
			//end the wave and start the rest period
			is_spawning = 0
			time_wave_cycle = world.time + duration_rest_current
			duration_rest_current *= rest_dur_multi
			to_world("<span class='danger'>Flood spawns have stopped! Rest and recuperate before the next wave...</span> \
				<span class='notice'>there is [get_evac_time()] left until evacuation.</span>")

		if(world.time > time_next_spawn_tick)
			time_next_spawn_tick = world.time + spawn_interval
			spawn(0)
				spawn_attackers_tick(spawns_per_tick_current)
	else
		//rest period is currently ongoing
		if(world.time > time_wave_cycle)
			//end the rest period and start the wave
			is_spawning = 1
			time_wave_cycle = world.time + duration_wave_current
			duration_wave_current *= wave_dur_multi
			to_world("<span class='danger'>Flood spawns have started! Get back to your base and dig in...</span> \
				<span class='notice'>there is [get_evac_time()] left until evacuation.</span>")
			//
			wave_num++
			spawns_per_tick_current = wave_num * spawn_wave_multi
			spawns_per_tick_current += max((get_num_survivors() - 1), 0)
			spawn_feral_chance = wave_num * 0.2
