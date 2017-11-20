
/datum/game_mode/stranded/proc/process_evac()
	if(world.time > time_pelican_arrive)
		switch(evac_stage)
			if(0)
				evac_stage = 1
				//force an immediate wave to spawn
				for(var/obj/effect/evac_pelican/E in world)
					evac_pelican = E.spawn_pelican()
				wave_num++
				spawns_per_tick_current = wave_num * spawn_wave_multi
				spawn_feral_chance = wave_num * 0.2
				time_wave_cycle = world.time + 3000
				is_spawning = 1
				to_world("<span class='warning'>The pelican has arrived! Protect it until it is ready to liftoff!</span>")
				evac_pelican.world_say_pilot_message("Hurry up and get on board! I'm out of here in [pelican_load_time / 10] seconds.")
			if(1)
				if(world.time > time_pelican_arrive + pelican_load_time / 2)
					evac_stage = 2
					if(evac_pelican)
						evac_pelican.world_say_pilot_message("Halfway there, only [pelican_load_time / 20] seconds to go.")
			if(2)
				if(world.time > time_pelican_leave - 100)
					evac_stage = 3
					if(evac_pelican)
						evac_pelican.world_say_pilot_message("10 seconds! Go go go go go!")

/datum/game_mode/stranded/proc/get_evac_time()
	var/seconds_left = (time_pelican_arrive - world.time) / 10
	if(seconds_left <= 60)
		return "[seconds_left] seconds"
	else
		return "[round(seconds_left / 60)] minutes"
