/datum/event/mob_spawning/rogue_drones
	endWhen = 1000
	wave_to_spawn = 1
	mobs_to_spawn = list(
		/mob/living/simple_animal/hostile/retaliate/malf_drone
	)


/datum/event/mob_spawning/rogue_drones/setup()
	total_to_spawn_per_z = rand(1, 3)
	. = ..()


/datum/event/mob_spawning/rogue_drones/announce()
	command_announcement.Announce("Attention: unidentified patrol drones detected within proximity to the [location_name()]", "[location_name()] Sensor Array", zlevels = affecting_z)


/datum/event/mob_spawning/rogue_drone/end()
	command_announcement.Announce("Be advised: sensors indicate the unidentified drone swarm has left the immediate proximity of the [location_name()].", "[location_name()] Sensor Array", zlevels = affecting_z)
