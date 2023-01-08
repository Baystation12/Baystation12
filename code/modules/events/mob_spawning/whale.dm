/datum/event/mob_spawning/whale
	announceWhen = 5
	endWhen = 10
	wave_to_spawn = 2
	mobs_to_spawn = list(
		/mob/living/simple_animal/hostile/retaliate/space_whale = 2,
		/mob/living/simple_animal/passive/juvenile_space_whale = 1
	)


/datum/event/mob_spawning/whale_migration/setup()
	endWhen = rand(300, 800)
	total_to_spawn_per_z = rand(2, 3)
	..()


/datum/event/mob_spawning/whale_migration/announce()
	command_announcement.Announce("A migrating pod of spaceborn cetaceans has been detected in the vicinity of the [location_name()]. Please make your way to the nearest window.", "[location_name()] Sensor Array", affecting_z)


/datum/event/mob_spawning/whale_migration/end()
	command_announcement.Announce("The migrating pod of spaceborn cetaceans has continued past the [location_name()].", "[location_name()] Sensor Array", affecting_z)
