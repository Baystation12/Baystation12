/datum/event/carp_migration
	announceWhen	= 50
	endWhen 		= 900

	var/list/spawned_carp = list()

/datum/event/carp_migration/setup()
	announceWhen = rand(40, 60)
	endWhen = rand(600,1200)

/datum/event/carp_migration/announce()
	var/announcement = ""
	if(severity == EVENT_LEVEL_MAJOR)
		announcement = "Massive migration of unknown biological entities has been detected near [station_name()], please stand-by."
	else
		announcement = "Unknown biological [spawned_carp.len == 1 ? "entity has" : "entities have"] been detected near [station_name()], please stand-by."
	command_announcement.Announce(announcement, "Lifesign Alert")

/datum/event/carp_migration/start()
	if(severity == EVENT_LEVEL_MAJOR)
		for(var/i = 1 to rand(3,5))
			spawn_fish(landmarks_list.len)
	else if(severity == EVENT_LEVEL_MODERATE)
		spawn_fish(landmarks_list.len)
	else
		spawn_fish(rand(1, 5))

/datum/event/carp_migration/proc/spawn_fish(var/limit)
	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "carpspawn")
			spawned_carp.Add(new /mob/living/simple_animal/hostile/carp(C.loc))
			if(spawned_carp.len >= limit)
				return

/datum/event/carp_migration/end()
	for(var/mob/living/simple_animal/hostile/carp/C in spawned_carp)
		if(!C.stat)
			var/turf/T = get_turf(C)
			if(istype(T, /turf/space))
				del(C)
