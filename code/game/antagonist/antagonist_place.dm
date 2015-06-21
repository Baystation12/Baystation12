/datum/antagonist/proc/get_starting_locations()
	if(landmark_id)
		starting_locations = list()
		for(var/obj/effect/landmark/L in landmarks_list)
			if(L.name == landmark_id)
				starting_locations |= get_turf(L)

/datum/antagonist/proc/place_all_mobs()
	if(!starting_locations || !starting_locations.len || !current_antagonists || !current_antagonists.len)
		return
	for(var/datum/mind/player in current_antagonists)
		player.current.loc = pick(starting_locations)

/datum/antagonist/proc/announce_antagonist_spawn()
	if(spawn_announcement)
		if(announced)
			return
		announced = 1
		if(spawn_announcement_delay)
			sleep(spawn_announcement_delay)
		if(spawn_announcement_sound)
			command_announcement.Announce("[spawn_announcement]", "[spawn_announcement_title ? spawn_announcement_title : "Priority Alert"]", new_sound = spawn_announcement_sound)
		else
			command_announcement.Announce("[spawn_announcement]", "[spawn_announcement_title ? spawn_announcement_title : "Priority Alert"]")

/datum/antagonist/proc/place_mob(var/mob/living/mob)
	if(!starting_locations || !starting_locations.len)
		return
	mob.loc = pick(starting_locations)