/datum/event/mob_spawning/carp
	announceWhen = 45
	endWhen = 75
	total_to_spawn_per_z = 9
	delete_on_end = FALSE
	mobs_to_spawn = list(
		/mob/living/simple_animal/hostile/carp = 96,
		/mob/living/simple_animal/hostile/carp/shark = 3,
		/mob/living/simple_animal/hostile/carp/pike = 1
	)


/datum/event/mob_spawning/carp/setup()
	announceWhen = rand(30, 60)
	endWhen += severity * 25
	..()


/datum/event/mob_spawning/carp/announce()
	var/announcement = ""
	if(severity > EVENT_LEVEL_MODERATE)
		announcement = "A massive migration of unknown biological entities has been detected in the vicinity of the [location_name()]. Exercise external operations with caution."
	else
		announcement = "A large migration of unknown biological entities has been detected in the vicinity of the [location_name()]. Caution is advised."

	command_announcement.Announce(announcement, "[location_name()] Sensor Array", zlevels = affecting_z)
