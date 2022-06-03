/datum/visualnet/cultnet
	valid_source_types = list(/mob/living, /mob/observer/eye/cult)
	chunk_type = /datum/chunk/cultnet

/datum/chunk/cultnet/acquire_visible_turfs(var/list/visible)
	for(var/source in sources)
		if(istype(source, /mob/living))
			var/mob/living/L = source
			if(L.stat == DEAD)
				continue

		for(var/turf/t in seen_turfs_in_range(source, world.view))
			visible[t] = t
