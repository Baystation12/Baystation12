
/datum/game_mode/stranded/pre_setup()
	..()

	GLOB.hostile_attackables += /obj/structure/evac_pelican
	GLOB.hostile_attackables += /obj/structure/tanktrap
	GLOB.max_flood_simplemobs = 300

	//loop over the map creating resupply spawn points
	spawn(-1)
		var/resup_dist = 20
		for(var/curx = 1, curx < world.maxx, curx += resup_dist + pick(-7,0,7))
			for(var/cury = 1, cury < world.maxy, cury += resup_dist)
				var/turf/T = locate(curx, cury, 1)
				//if there is a scavenge_spawn_skip landmark, skip this spot (place one eg near the player base)
				var/obj/effect/landmark/scavenge_spawn_skip/N = locate() in range(resup_dist, T)
				if(N)
					continue
				var/obj/effect/landmark/scavenge_spawn/S = new(T)
				available_resupply_points.Add(S)

	spawn(-1)
		for(var/obj/effect/landmark/flood_spawn/F in world)
			flood_spawn_turfs.Add(get_turf(F))

	spawn(-1)
		for(var/obj/effect/landmark/flood_assault_target/F in world)
			flood_assault_turfs.Add(get_turf(F))

	//planet_area = locate() in world

/datum/game_mode/stranded/announce()
	..()
	to_world("<span class='notice'>You must survive for [round(survive_duration/600)] minutes until the evacuation pelican arrives. \
		Chop down trees, dig up rocks and sand, gather cloth from plants or scavenge resources from around the map.</span>")

/datum/game_mode/stranded/post_setup()
	..()
	time_pelican_arrive = world.time + survive_duration
	time_pelican_leave = time_pelican_arrive + pelican_load_time
	time_wave_cycle = world.time + duration_rest_base / 2
	time_next_resupply = world.time + interval_resupply
	//time_new_cycle = world.time + solar_cycle_duration - solar_cycle_duration * threshold_dawn

	/*daynight_controller = locate() in world
	if(!daynight_controller)
		daynight_controller = new (1,1,1)*/
