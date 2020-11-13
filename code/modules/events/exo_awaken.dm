GLOBAL_LIST_INIT(exo_event_mob_count,list())// a list of all mobs currently spawned

/datum/event/exo_awakening
	announceWhen	= 45
	endWhen			= 75
	var/no_show = FALSE //set to true once we hit the target mob count of spawned mobs so we stop spawning
	var/spawned_mobs //total count of all spawned mobs by the event
	var/list/exoplanet_areas //all possible exoplanet areas the event can take place on
	var/area/chosen_area //the single chosen exoplanet to have the event occur on
	var/list/players_on_site = list() //a list of the players on the planet
	var/players_on_site_count = 0 //how many players are currently on the planet
	var/required_players_count = 2 //how many players we need present on the planet for the event to start
	var/target_mob_count = 0 //overall target mob count, set to nonzero during setup
	var/target_mob_count_major = 55 //the target mob counts to choose from, based on severity (Major or Moderate)
	var/target_mob_count_moderate = 35
	var/list/chosen_mob_list = list(list()) //the chosen list of mobs we will pick from when spawning, also based on severity


	/*
		Spawn list format:
		list(
			"A message", // message to play to the players on the planet when the event starts.
			'sound/something.ogg', //sound to play to the players on the planet when the event starts (must be a valid sound)
			list(
				list(/mob/living/..., ##) //the thing to spawn and its spawn chance as a percentage from 1-100 (doesn't have to be a mob, despite the name)
			)
		)
	*/
	var/list/major_event_mobs = list(
		list(
			"A blood curdling howl echoes through the air as the planet starts to shake violently, and you feel hungry eyes set their sight on you...",
			'sound/ambience/meat_monster_arrival.ogg',
			list(
				list(/mob/living/simple_animal/hostile/meat/abomination, 95),
				list(/mob/living/simple_animal/hostile/meat/horror, 75),
				list(/mob/living/simple_animal/hostile/meat/strippedhuman, 80),
				list(/mob/living/simple_animal/hostile/meat/horrorminer, 80),
				list(/mob/living/simple_animal/hostile/meat/horrorsmall, 98),
				list(/mob/living/simple_animal/hostile/meat, 75)
			)
		),
		list(
			"The planet rumbles as you begin to feel an uncountable number of eyes suddenly staring at you from all around.",
			'sound/effects/wind/wind_3_1.ogg',
			list(
				list(/mob/living/simple_animal/hostile/giant_spider/guard, 100),
				list(/mob/living/simple_animal/hostile/giant_spider/hunter, 100),
				list(/mob/living/simple_animal/hostile/giant_spider/nurse, 100),
				list(/mob/living/simple_animal/hostile/giant_spider/spitter, 100)
			)
		),
		list(
			"The ground beneath you rumbles as you hear the sounds of machinery from all around you...",
			'sound/effects/wind/wind_3_1.ogg',
			list(
				list(/mob/living/simple_animal/hostile/hivebot, 80),
				list(/mob/living/simple_animal/hostile/hivebot/range, 45),
				list(/mob/living/simple_animal/hostile/hivebot/strong, 25),
				list(/mob/living/simple_animal/hostile/hivebot/mega, 10),
			)
		)
	)

	var/list/moderate_event_mobs = list(
		list(
			"You feel uneasy as you hear something skittering about...",
			'sound/effects/wind/wind_3_1.ogg',
			list(
				list(/obj/effect/spider/spiderling, 100)
			)
		),
		list(
			"You hear the distant sound of creaking metal joints, what is that?",
			'sound/effects/wind/wind_3_1.ogg',
			list(
				list(/mob/living/simple_animal/hostile/hivebot, 95),
				list(/mob/living/simple_animal/hostile/hivebot/range, 15)
			)
		)
	)

/datum/event/exo_awakening/setup()
	announceWhen = rand(15, 45)
	endWhen += severity*25
	affecting_z = list()

	for (var/area/A in world)
		if (A.planetary_surface)
			LAZYADD(exoplanet_areas, A)
	if (severity > EVENT_LEVEL_MODERATE) //choose a mob list and a target number of mobs to spawn (based on severity)
		chosen_mob_list = pick(major_event_mobs)
		target_mob_count = target_mob_count_major
	else
		chosen_mob_list = pick(moderate_event_mobs)
		target_mob_count = target_mob_count_moderate


/datum/event/exo_awakening/proc/count_mobs()
	var/total_mobs
	total_mobs = GLOB.exo_event_mob_count.len

	//stop spawning mobs if we've exceeded the cap, or it looks like they're affecting performance, or if nobody is on the planet anymore (or they're all dead)
	if(total_mobs >= target_mob_count || SSmobs.ticks >= 10 || !living_observers_present(affecting_z))
		no_show = TRUE
	else
		no_show = FALSE

/datum/event/exo_awakening/start()
	var/list/players_on_site = list()
	var/torch_players_present = FALSE

	for (var/area/A in exoplanet_areas)
		players_on_site = list() //make sure the list is empty before checking the next planet.
		for (var/mob/M in GLOB.player_list)
			if (M.stat != DEAD && M.z == A.z)
				LAZYADD(players_on_site, M.client)

				if(get_crewmember_record(M.real_name || M.name)) //event is geared at torch/exploration, only valid if they're around.
					torch_players_present = TRUE
					chosen_area = A
					LAZYADD(affecting_z, A.z)

		players_on_site_count = players_on_site.len
		if (torch_players_present && players_on_site_count >= required_players_count)
			break

		torch_players_present = FALSE

	if (!torch_players_present) // if this is true, then we've passed the count check already and can proceed
		log_and_message_admins("Failed to start the Exoplanet Awakening event, not enough players present on planetary surface.")
		kill()
		return

	for (var/client/C in players_on_site)
		if (severity > EVENT_LEVEL_MODERATE)
			to_chat(C, SPAN_DANGER(chosen_mob_list[1]))
		else
			to_chat(C, SPAN_WARNING(chosen_mob_list[1]))

		sound_to(C, chosen_mob_list[2])


/datum/event/exo_awakening/announce()
	var/announcement = ""
	if(severity > EVENT_LEVEL_MODERATE)
		announcement = "Extreme biological activity spike detected on [location_name()]. Recommend away team evacuation."
	else
		announcement = "Anomalous biological activity detected on [location_name()]."

	var/obj/effect/overmap/visitable/O = map_sectors["[chosen_area.z]"]

	for(var/obj/effect/overmap/visitable/OO in range(O,2)) //announce the event to ships in range of the planet
		if (istype(OO, /obj/effect/overmap/visitable/ship))
			command_announcement.Announce(announcement, "[OO.name] Sensor Array", zlevels = OO.find_z_levels())

/datum/event/exo_awakening/tick()
	count_mobs()
	if(no_show && prob(95))
		return

	spawn_mob(chosen_area)

/datum/event/exo_awakening/proc/spawn_mob(area/chosen_area, list/category)
	if(!living_observers_present(affecting_z))
		return

	var/n = rand(severity-1, severity*2)
	var/I = 0
	while(I < n)
		var/turf/T
		for (var/i = 1; i <= 5; i++) //check up to 5 times for a good turf to spawn on
			T = pick(get_area_turfs(chosen_area))

			if (is_edge_turf(T))
				continue
			if (T.is_wall())
				continue

			break

		if (is_edge_turf(T) || T.is_wall()) //could still have selected a bad turf by this point (ruins have lots of walls)
			log_debug("Exoplanet Awakening: Failed to spawn mob on a viable turf.")
			return


		var/list/mob_list = pick(chosen_mob_list[3])

		var/spawn_chance = mob_list[2]
		var/mob_to_spawn = mob_list[1]

		if (prob(spawn_chance))
			var/mob/living/simple_animal/hostile/M = new mob_to_spawn(T)
			if (istype(M))
				M.visible_message(SPAN_DANGER("\The [M] bursts forth from the ground!"))
				GLOB.death_event.register(M,src,/datum/event/exo_awakening/proc/reduce_mob_count)
				GLOB.destroyed_event.register(M,src,/datum/event/exo_awakening/proc/reduce_mob_count)
				LAZYADD(GLOB.exo_event_mob_count, M)

		spawned_mobs ++
		I++
		if(no_show)
			break

/datum/event/exo_awakening/proc/reduce_mob_count(mob/M)
	var/list/L = GLOB.exo_event_mob_count
	if(M in L)
		LAZYREMOVE(L,M)

	GLOB.death_event.unregister(M,src,/datum/event/exo_awakening/proc/reduce_mob_count)
	GLOB.destroyed_event.unregister(M,src,/datum/event/exo_awakening/proc/reduce_mob_count)

/datum/event/exo_awakening/end()
	log_debug("Exoplanet Awakening event spawned [spawned_mobs] mobs.")