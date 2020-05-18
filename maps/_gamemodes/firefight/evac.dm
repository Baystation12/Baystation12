
/datum/game_mode/firefight/proc/process_evac()
	switch(evac_stage)
		if(1)
			time_evac_leave = world.time + evac_wait_time

			//spawn the evac ship
			for(var/obj/effect/evac_ship/E in world)
				evac_ship = E.spawn_dropship()
				break
			evac_ship.arrival_message(evac_wait_time)

			evac_stage = 2
		if(2)
			if(world.time > time_evac_leave - evac_wait_time / 2)
				evac_stage = 3
				evac_ship.halfway_message(evac_wait_time / 2)
		if(3)
			if(world.time > time_evac_leave - 10 SECONDS)
				evac_stage = 4
				evac_ship.leaving_message(10 SECONDS)
