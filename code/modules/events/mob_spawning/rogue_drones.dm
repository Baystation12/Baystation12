/datum/event/mob_spawning/rogue_drones
	endWhen = 1000
	wave_to_spawn = 1
	mobs_to_spawn = list(
		/mob/living/simple_animal/hostile/retaliate/malf_drone
	)
	var/mobs_to_spawn_major = list (
		/mob/living/simple_animal/hostile/fleet_heavy
	)


/datum/event/mob_spawning/rogue_drones/setup()
	if (severity > EVENT_LEVEL_MODERATE)
		total_to_spawn_per_z = rand(6, 12)
		mobs_to_spawn += mobs_to_spawn_major
	else
		total_to_spawn_per_z = rand(1, 3)
	. = ..()


/datum/event/mob_spawning/rogue_drones/announce()
	if (severity > EVENT_LEVEL_MODERATE)
		command_announcement.Announce("Priority Warning: Unidentified drone attack-swarm detected near the [location_name()]", "[location_name()] Sensor Array", zlevels = affecting_z)
	else
		command_announcement.Announce("Attention: unidentified patrol drones detected within proximity to the [location_name()]", "[location_name()] Sensor Array", zlevels = affecting_z)


/datum/event/mob_spawning/rogue_drone/end()
	command_announcement.Announce("Be advised: sensors indicate the unidentified drone swarm has left the immediate proximity of the [location_name()].", "[location_name()] Sensor Array", zlevels = affecting_z)
