GLOBAL_VAR(carp_events)

/datum/event/carp_migration
	announceWhen	= 50
	endWhen = 55
	var/spawned_carp //this is only for the announcement logic and for debug count
	var/no_show = FALSE // Carp are laggy, so if there is too much stuff going on we're going to dial it down.

/datum/event/carp_migration/setup()
	announceWhen = rand(40, 60)
	if(GLOB.carp_events >= 3 || SSmobs.ticks >= 10)
		no_show = TRUE
	else
		GLOB.carp_events++

/datum/event/carp_migration/announce()
	var/announcement = ""
	if(no_show)
		announcement = "A massive migration of unknown biological entities has been detected in the vicinity of the [location_name()] gravity well. Caution is advised."
	else if(severity == EVENT_LEVEL_MAJOR)
		announcement = "A massive migration of unknown biological entities has been captured by the [location_name()] gravity well. Exercise external operations with caution."
	else
		announcement = "Unknown biological [spawned_carp == 1 ? "entity has" : "entities have"] been captured by the [location_name()] gravity well."
	command_announcement.Announce(announcement, "[location_name()] Sensor Array", zlevels = affecting_z)

/datum/event/carp_migration/start()
	if(no_show)
		spawn_fish(affecting_z, 1, 1, 1)
	else if(severity == EVENT_LEVEL_MAJOR)
		spawn_fish(affecting_z, rand(20, 25), 2, 4)
	else if(severity == EVENT_LEVEL_MODERATE)
		spawn_fish(affecting_z, rand(4, 6)) 			//12 to 30 carp, in small groups
	else
		spawn_fish(affecting_z, rand(1, 3), 1, 2)	//1 to 6 carp, alone or in pairs

/datum/event/carp_migration/proc/spawn_fish(var/list/affecting_z, var/num_groups, var/group_size_min=3, var/group_size_max=5)
	var/list/spawn_locations = list()

	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "carpspawn" && (C.z in affecting_z))
			spawn_locations.Add(C.loc)
	spawn_locations = shuffle(spawn_locations)
	num_groups = min(num_groups, spawn_locations.len)

	var/i = 1
	while (i <= num_groups)
		var/group_size = rand(group_size_min, group_size_max)
		if(prob(96))
			for (var/j = 1, j <= group_size, j++)
				new /mob/living/simple_animal/hostile/carp(spawn_locations[i])
				spawned_carp++
			i++
		else
			group_size = max(1,round(group_size/6))
			group_size = min(spawn_locations.len-i+1,group_size)
			for(var/j = 1, j <= group_size, j++)
				new /mob/living/simple_animal/hostile/carp/pike(spawn_locations[i+j])
				spawned_carp++
			i += group_size

/datum/event/carp_migration/end()
	log_debug("Carp migration event spawned [spawned_carp] carp.")
	if(!no_show)
		GLOB.carp_events--
