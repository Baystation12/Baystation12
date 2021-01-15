GLOBAL_LIST_INIT(exo_event_mob_count,list())// a list of all mobs currently spawned

/datum/event/exo_awakening
	announceWhen	= 45
	endWhen			= 75
	var/no_show = FALSE //set to true once we hit the target mob count of spawned mobs so we stop spawning
	var/spawned_mobs //total count of all spawned mobs by the event
	var/list/exoplanet_areas //all possible exoplanet areas the event can take place on
	var/area/chosen_area
	var/obj/effect/overmap/visitable/sector/chosen_planet
	var/required_players_count = 2 //how many players we need present on the planet for the event to start
	var/list/players_on_site = list()
	var/target_mob_count = 0 //overall target mob count, set to nonzero during setup
	var/datum/mob_list/chosen_mob_list //the chosen list of mobs we will pick from when spawning, also based on severity
	var/original_severity

/datum/mob_list
	var/list/mobs = list()
	var/sound/arrival_sound
	var/arrival_message
	var/limit //target number of mobs to spawn
	var/length = 75 //length of time the event should run for
	var/spawn_near_chance = 20 //chance a mob spawns near a player

/datum/mob_list/major/meat
	mobs = list(
				list(/mob/living/simple_animal/hostile/meat/abomination, 95),
				list(/mob/living/simple_animal/hostile/meat/horror, 75),
				list(/mob/living/simple_animal/hostile/meat/strippedhuman, 80),
				list(/mob/living/simple_animal/hostile/meat/horrorminer, 80),
				list(/mob/living/simple_animal/hostile/meat/horrorsmall, 98),
				list(/mob/living/simple_animal/hostile/meat, 75)
			)
	arrival_message = "A blood curdling howl echoes through the air as the planet starts to shake violently. Something has woken up..."
	arrival_sound   = 'sound/ambience/meat_monster_arrival.ogg'
	limit = 55
	spawn_near_chance = 30

/datum/mob_list/major/spiders
	mobs = list(
				list(/mob/living/simple_animal/hostile/giant_spider/guard, 85),
				list(/mob/living/simple_animal/hostile/giant_spider/hunter, 75),
				list(/mob/living/simple_animal/hostile/giant_spider/nurse, 60),
				list(/mob/living/simple_animal/hostile/giant_spider/spitter, 55)
			)
	arrival_message = "The planet rumbles as you begin to feel an uncountable number of eyes suddenly staring at you from all around."
	arrival_sound   = 'sound/effects/wind/wind_3_1.ogg'
	limit = 25
	length = 45
	spawn_near_chance = 10

/datum/mob_list/major/machines
	mobs = list(
				list(/mob/living/simple_animal/hostile/hivebot, 80),
				list(/mob/living/simple_animal/hostile/hivebot/range, 45),
				list(/mob/living/simple_animal/hostile/hivebot/strong, 25),
				list(/mob/living/simple_animal/hostile/hivebot/mega, 2),
			)
	arrival_message = "The ground beneath you rumbles as you hear the sounds of machinery from all around you..."
	arrival_sound   = 'sound/effects/wind/wind_3_1.ogg'
	limit = 45
	length = 50
	spawn_near_chance = 10

/datum/mob_list/moderate/spiders
	mobs = list(
				list(/mob/living/simple_animal/hostile/giant_spider/guard, 60),
				list(/mob/living/simple_animal/hostile/giant_spider/hunter, 15),
				list(/mob/living/simple_animal/hostile/giant_spider/nurse, 30),
				list(/mob/living/simple_animal/hostile/giant_spider/spitter, 10)
			)
	arrival_message = "You feel uneasy as you hear something skittering about..."
	arrival_sound = 'sound/effects/wind/wind_3_1.ogg'
	limit = 15
	length = 40
	spawn_near_chance = 5

/datum/mob_list/moderate/machines
	mobs = list(
				list(/mob/living/simple_animal/hostile/hivebot, 95),
				list(/mob/living/simple_animal/hostile/hivebot/range, 15)
			)
	arrival_message = "You hear the distant sound of creaking metal joints, what is that?"
	arrival_sound = 'sound/effects/wind/wind_3_1.ogg'
	limit = 25
	length = 50
	spawn_near_chance = 15

/datum/event/exo_awakening/setup()
	announceWhen = rand(15, 45)
	affecting_z = list()
	original_severity = severity //incase we need to re-roll a different event.
	if (severity == EVENT_LEVEL_MAJOR || prob(25))
		severity = EVENT_LEVEL_MAJOR //if original event was moderate, this will need updating

		chosen_mob_list = pick(typesof(/datum/mob_list/major) - /datum/mob_list/major)
	else
		chosen_mob_list = pick(typesof(/datum/mob_list/moderate) - /datum/mob_list/moderate)

	for (var/area/A in world)
		if (A.planetary_surface)
			LAZYADD(exoplanet_areas, A)

	chosen_mob_list = new chosen_mob_list
	target_mob_count = chosen_mob_list.limit
	endWhen = chosen_mob_list.length
	endWhen += severity*25

/datum/event/exo_awakening/proc/count_mobs()
	var/total_mobs
	total_mobs = GLOB.exo_event_mob_count.len

	if(total_mobs >= target_mob_count || SSmobs.ticks >= 10 || !living_observers_present(affecting_z))
		no_show = TRUE
	else
		no_show = FALSE

/datum/event/exo_awakening/start()
	var/torch_players_present = FALSE
	var/list/sites = list() //a list of sites that have players present
	var/list/players = list()

	for (var/area/A in exoplanet_areas)
		var/mob/M
		for (var/i = length(GLOB.player_list) to 1 step -1)
			M = GLOB.player_list[i]
			if (M.stat != DEAD && (M.z in GetConnectedZlevels(A.z)))
				players += M

				if (get_crewmember_record(M.real_name || M.name))
					torch_players_present = TRUE
					chosen_area = A
					chosen_planet = map_sectors["[A.z]"]
					affecting_z = GetConnectedZlevels(A.z)

		if (length(players))
			sites += A
			players_on_site[A] = players

		if (torch_players_present && (length(players_on_site[A]) >= required_players_count))
			break

		torch_players_present = FALSE

	if (!torch_players_present)

		if (!length(sites))
			log_debug("Exoplanet Awakening failed to run, not enough players on any planet. Aborting.")
			severity = original_severity
			kill(TRUE)
			return

		chosen_area = pick(sites)
		chosen_planet = map_sectors["[chosen_area.z]"]
		affecting_z = GetConnectedZlevels(chosen_area.z)

	for (var/mob/M in players_on_site[chosen_area])
		if (severity > EVENT_LEVEL_MODERATE)
			to_chat(M, SPAN_DANGER(chosen_mob_list.arrival_message))
		else
			to_chat(M, SPAN_WARNING(chosen_mob_list.arrival_message))

		sound_to(M, chosen_mob_list.arrival_sound)

	var/list/dimensions = chosen_area.get_dimensions()
	if (dimensions["x"] <= 100)
		target_mob_count = round(target_mob_count / 3.5) //keep mob count lower in smaller areas.


/datum/event/exo_awakening/announce()
	var/announcement = ""
	if (severity > EVENT_LEVEL_MODERATE)
		announcement = "Extreme biological activity spike detected on [location_name()]. Recommend away team evacuation."
	else
		announcement = "Anomalous biological activity detected on [location_name()]."

	for (var/obj/effect/overmap/visitable/ship/S in range(chosen_planet,2)) //announce the event to ships in range of the planet
		command_announcement.Announce(announcement, "[S.name] Biological Sensor Array", zlevels = S.map_z)

/datum/event/exo_awakening/tick()
	count_mobs()
	if (no_show && prob(98))
		return

	spawn_mob()

/datum/event/exo_awakening/proc/spawn_mob()
	if(!living_observers_present(affecting_z))
		return

	var/list/area_turfs = get_area_turfs(chosen_area)
	var/n = rand(severity-1, severity*2)
	var/I = 0
	while(I < n)
		var/turf/T
		for (var/i = 1 to 5)

			if (prob(chosen_mob_list.spawn_near_chance))
				var/mob/M = pick(players_on_site[chosen_area])
				var/turf/MT = get_turf(M)
				if(MT)
					T = pick(trange(10, MT) - trange(7, MT))
				else
					T = pick(area_turfs)
			else
				T = pick(area_turfs)

			if (is_edge_turf(T) || T.is_wall() || T.density)
				continue

			break

		if (is_edge_turf(T) || T.is_wall() || T.density)
			return


		var/list/mob_list = pick(chosen_mob_list.mobs)


		var/spawn_chance = mob_list[2]
		var/mob_to_spawn = mob_list[1]

		if (prob(spawn_chance))
			var/mob/living/simple_animal/hostile/M = new mob_to_spawn(T)
			if (istype(M))
				M.visible_message(SPAN_DANGER("\The [M] bursts forth from the ground!"))
				GLOB.death_event.register(M,src,/datum/event/exo_awakening/proc/reduce_mob_count)
				GLOB.destroyed_event.register(M,src,/datum/event/exo_awakening/proc/reduce_mob_count)
				LAZYADD(GLOB.exo_event_mob_count, M)

				if (istype(chosen_planet, /obj/effect/overmap/visitable/sector/exoplanet))
					var/obj/effect/overmap/visitable/sector/exoplanet/E = chosen_planet
					E.adapt_animal(M, FALSE)

			spawned_mobs++
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
	if(!chosen_area)
		return

	QDEL_NULL(chosen_mob_list)
	log_debug("Exoplanet Awakening event spawned [spawned_mobs] mobs. It was a level [severity] out of 3 severity.")

	for (var/mob/M in GLOB.player_list)
		if (M && M.z == chosen_area.z)
			to_chat(M, SPAN_NOTICE("The planet grows calm, the ground no longer heaving its horrors to the surface."))