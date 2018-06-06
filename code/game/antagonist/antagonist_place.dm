/datum/antagonist/proc/get_starting_locations()
	if(landmark_id)
		starting_locations = list()
		for(var/obj/effect/landmark/L in landmarks_list)
			if(L.name == landmark_id)
				starting_locations |= get_turf(L)

/datum/antagonist/proc/announce_antagonist_spawn()

	if(spawn_announcement)
		if(announced)
			return
		announced = 1
		if(spawn_announcement_delay)
			// Or just always all addtimer, no matter the spawn_announcement_delay value
			addtimer(CALLBACK(src, .proc/do_announcement), spawn_announcement_delay)
		else
			do_announcement()

/datum/antagonist/proc/place_mob(var/mob/living/mob)
	if(!starting_locations || !starting_locations.len)
		return
	var/turf/T = pick_mobless_turf_if_exists(starting_locations)
	mob.forceMove(T)

/datum/antagonist/proc/do_announcement()
	if(spawn_announcement_sound)
		command_announcement.Announce("[spawn_announcement]", "[spawn_announcement_title ? spawn_announcement_title : "Priority Alert"]", new_sound = spawn_announcement_sound)
	else
		command_announcement.Announce("[spawn_announcement]", "[spawn_announcement_title ? spawn_announcement_title : "Priority Alert"]")
