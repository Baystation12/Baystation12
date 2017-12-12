
/datum/game_mode/stranded/pre_setup()
	..()

	spawn(-1)
		for(var/obj/effect/landmark/flood_spawn/F in world)
			flood_spawn_turfs.Add(get_turf(F))

	spawn(-1)
		for(var/obj/effect/landmark/flood_assault_target/F in world)
			flood_assault_turfs.Add(get_turf(F))

	planet_area = locate() in world
	GLOB.max_flood_simplemobs = 300

	//lighting and day/night cycle
	time_lightchange = world.time + duration_day
	is_daytime = 1
	//set_ambient_light(daytime_brightness)

/datum/game_mode/stranded/announce()
	..()
	to_world("<span class='notice'>There is [get_evac_time()] until the evacuation pelican arrives.</span>")

/datum/game_mode/stranded/post_setup()
	..()
	time_pelican_arrive = world.time + survive_duration
	time_pelican_leave = time_pelican_arrive + pelican_load_time
	time_wave_cycle = world.time + duration_rest_base / 2
