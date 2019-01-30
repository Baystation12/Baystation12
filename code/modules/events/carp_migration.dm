/datum/event/carp_migration
	announceWhen	= 50
	endWhen = 55
	var/spawned_carp //this is only for the announcement logic and for debug count

/datum/event/carp_migration/setup()
	announceWhen = rand(40, 60)

/datum/event/carp_migration/announce()
	var/announcement = ""
	if(severity == EVENT_LEVEL_MAJOR)
		announcement = "A massive migration of unknown biological entities has been captured by the [location_name()] gravity well. Exercise external operations with caution."
	else
		announcement = "Unknown biological [spawned_carp == 1 ? "entity has" : "entities have"] been captured by the [location_name()] gravity well."
	command_announcement.Announce(announcement, "[location_name()] Sensor Array", zlevels = affecting_z)

/datum/event/carp_migration/start()
	if(severity == EVENT_LEVEL_MAJOR)
		spawn_fish(landmarks_list.len)
	else if(severity == EVENT_LEVEL_MODERATE)
		spawn_fish(rand(4, 6)) 			//12 to 30 carp, in small groups
	else
		spawn_fish(rand(1, 3), 1, 2)	//1 to 6 carp, alone or in pairs

/datum/event/carp_migration/proc/spawn_fish(var/num_groups, var/group_size_min=3, var/group_size_max=5)
	var/list/spawn_locations = list()

	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "carpspawn")
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
