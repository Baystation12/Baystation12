
/datum/game_mode/stranded/proc/process_evac()
	if(world.time > time_pelican_arrive)
		//force an immediate wave to spawn
		for(var/obj/effect/evac_pelican/E in world)
			E.spawn_pelican()
		wave_num++
		spawns_per_tick_current = wave_num * spawn_wave_multi
		spawn_feral_chance = wave_num * 0.2
		time_wave_cycle = world.time + 3000
		time_pelican_arrive += 9999999		//round is about to end anyway so meh
		is_spawning = 1
		to_world("<span class='warning'>The pelican has arrived! Protect it for [pelican_load_time / 10] seconds until it is ready to liftoff!</span>")

/datum/game_mode/stranded/proc/get_evac_time()
	var/seconds_left = (time_pelican_arrive - world.time) / 10
	if(seconds_left <= 60)
		return "[seconds_left] seconds"
	else
		return "[round(seconds_left / 60)] minutes"
