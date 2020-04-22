
/datum/game_mode/firefight/proc/process_evac()
	switch(evac_stage)
		if(1)
			evac_stage = 2
			time_evac_leave = world.time + evac_wait_time

			//spawn the evac ship
			for(var/obj/effect/evac_ship/E in world)
				evac_ship = E.spawn_pelican()
			evac_ship.world_say_pilot_message("Get ready to fall back! I'm out of here in [evac_wait_time / 10] seconds.")
		if(2)
			if(world.time > time_evac_leave - evac_wait_time / 2)
				evac_stage = 3
				evac_ship.world_say_pilot_message("Halfway there, only [evac_wait_time / 20] seconds to go.")
		if(3)
			if(world.time > time_evac_leave - 10 SECONDS)
				evac_stage = 4
				evac_ship.world_say_pilot_message("10 seconds! Go go go go go!")
