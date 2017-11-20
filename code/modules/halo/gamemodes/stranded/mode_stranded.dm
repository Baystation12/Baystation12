
/datum/game_mode/stranded
	name = "Stranded"
	config_tag = "Stranded"
	required_players = 0
	required_enemies = 0
	end_on_antag_death = 0
	round_description = "Build a base in order to survive. The Flood is coming..."
	extended_round_description = "Your ship has crash landed on a distant alien world. Now waves of Flood are attacking and there is only limited time to setup defences. Can you survive until the rescue team arrives?"
	//hub_descriptions = list("desperately struggling to survive against waves of parasitic aliens on a distant world...")

	var/wave_num = 0
	var/area/planet/daynight/planet_area
	var/list/flood_spawn_turfs = list()
	var/list/flood_assault_turfs = list()

	var/is_spawning = 0	//0 = rest, 1 = spawning
	var/spawns_per_tick_base = 1
	var/spawns_per_tick_current = 1
	var/bonus_spawns = 0
	var/spawn_wave_multi = 1.1
	var/wave_dur_multi = 1//1.25
	var/rest_dur_multi = 1//0.9
	var/spawn_feral_chance = 0.1
	var/time_next_spawn_tick = 0
	var/spawn_interval = 30

	//deciseconds
	var/duration_wave_base = 3000
	var/duration_wave_current = 3000
	var/duration_rest_base = 6000
	var/duration_rest_current = 6000
	var/time_wave_cycle = 0
	//
	var/duration_day = 3000
	var/duration_night = 3000
	//var/daynight_start = 0
	//var/daynight_end = 0
	var/threshold_dusk = 0.75
	var/threshold_dawn = 0.75
	var/is_daytime = 1
	var/current_light_level = 1
	var/time_lightchange = 0
	//
	var/time_pelican_arrive = 9999

	var/worldtime_offset = 0

	var/latest_tick_time = 0
	var/round_start

	var/do_daynight_cycle = 0
	var/datum/light_source/ambient/ambient_light
	var/list/light_sources
	var/light_power = 1
	var/light_range = 255
	var/light_color = 0//"#ffff00"
	var/daytime_brightness = 2
	var/dawn_brightness = 0.5
	var/dusk_brightness = 0.5

/datum/game_mode/stranded/pre_setup()
	for(var/obj/effect/landmark/flood_spawn/F in world)
		flood_spawn_turfs.Add(get_turf(F))

	for(var/obj/effect/landmark/flood_assault_target/F in world)
		flood_assault_turfs.Add(get_turf(F))

	planet_area = locate() in world
	GLOB.max_flood_simplemobs = 300

	//lighting and day/night cycle
	time_lightchange = world.time + duration_day
	is_daytime = 1
	set_ambient_light(daytime_brightness)

/datum/game_mode/stranded/proc/set_ambient_light(var/brightness)
	light_power = brightness
	if(!ambient_light)
		var/turf/T = locate(1,1,1)
		ambient_light = new(src,T)
	ambient_light.update()

	//destroy the old light if it is fully dark
	if(!brightness)
		ambient_light = null

/datum/game_mode/stranded/post_setup()
	time_pelican_arrive = world.time + 24000 + 24000 * rand()
	//time_wave_cycle = world.time + duration_rest_base / 2

/datum/game_mode/stranded/process()
	latest_tick_time = world.time

	if(do_daynight_cycle)
		process_daynight()
	//process_spawning()
	process_evac()

/datum/game_mode/stranded/proc/process_daynight()

	var/phase_duration = is_daytime ? duration_day : duration_night
	var/daynight_progress = 1 - (time_lightchange - world.time) / phase_duration
	daynight_progress = max(daynight_progress, 0)
	daynight_progress = min(daynight_progress, 1)

	var/duskdawn_threshold = is_daytime ? threshold_dusk : threshold_dawn
	if(daynight_progress > duskdawn_threshold)
		var/updated = 0
		if(is_daytime && current_light_level > dusk_brightness)
			current_light_level = dusk_brightness
			to_world("<span class='danger'>It is now dusk!</span>")
			updated = 1
		else if(!is_daytime && current_light_level < dawn_brightness)
			current_light_level = dawn_brightness
			to_world("<span class='danger'>It is now dawn!</span>")
			updated = 1
		if(daynight_progress >= 1)
			time_lightchange = world.time + (is_daytime ? duration_night : duration_day)
			//
			is_daytime = !is_daytime
			if(is_daytime)
				current_light_level = daytime_brightness
			else
				current_light_level = 0
			updated = 1
			to_world("<span class='danger'>It is now [is_daytime ? "daytime" : "nighttime"]!</span>")

		if(updated)
			updated = 0
			spawn(-1)
				/*var/duskdawn_progress = (daynight_progress - duskdawn_threshold) / (1 - duskdawn_threshold)
				if(is_daytime)
					duskdawn_progress = 1 - duskdawn_progress
				set_ambient_light(duskdawn_progress * daytime_brightness)*/
				set_ambient_light(current_light_level)

/datum/game_mode/stranded/proc/process_spawning()
	if(is_spawning)
		//wave is currently ongoing
		if(world.time > time_wave_cycle)
			//end the wave and start the rest period
			is_spawning = 0
			time_wave_cycle = world.time + duration_rest_current
			duration_rest_current *= rest_dur_multi
			to_world("<span class='danger'>Flood spawns have stopped! Rest and recuperate before the next wave...</span>")

		if(world.time > time_next_spawn_tick)
			time_next_spawn_tick = world.time + spawn_interval
			/*spawn(0)
				spawn_attackers_tick(spawns_per_tick_current)*/
	else
		//rest period is currently ongoing
		if(world.time > time_wave_cycle)
			//end the rest period and start the wave
			is_spawning = 1
			time_wave_cycle = world.time + duration_wave_current
			duration_wave_current *= wave_dur_multi
			to_world("<span class='danger'>Flood spawns have started! Get back to your base and dig in...</span>")
			//
			wave_num++
			spawns_per_tick_current = wave_num * spawn_wave_multi
			spawn_feral_chance = wave_num * 0.2

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
		to_world("<span class='danger'>The pelican is due to arrive! Unfortunately the coders haven't added it in yet. Good luck hahahahahahahahaha!</span>")

/datum/game_mode/stranded/proc/spawn_attackers_tick(var/amount = 1)
	set background = 1
	amount += bonus_spawns
	bonus_spawns = 0
	while(amount >= 1)
		var/number_to_spawn
		var/spawn_type
		if(prob(33))
			number_to_spawn = 1
			spawn_type = /mob/living/simple_animal/hostile/flood/combat_human
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

/datum/game_mode/stranded/proc/get_mode_time()
	/*if(is_daytime)
		return time2text(daynight_start)
	return time2text(daynight_start + duration_day)*/
/*
	if(!roundstart_hour) roundstart_hour = pick(2,7,12,17)
	return timeshift ? time2text(time+(36000*roundstart_hour), "hh:mm") : time2text(time, "hh:mm")
	*/
	return

/obj/effect/evac_pelican/
	name = "Evac Pelican Spawn"
	desc = "You shouldn't see this."
	//invisibility = 101
	anchored = 1
	density = 0
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x3"
	var/spawned = 0

/obj/effect/evac_pelican/verb/spawn_pelican()
	set name = "Spawn the Evac Pelican"
	set src in view()
	set category = "IC"

	if(!spawned)
		spawned = 1
		new /obj/structure/evac_pelican(src.loc)
		qdel(src)
