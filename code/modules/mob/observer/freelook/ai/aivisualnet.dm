/datum/visualnet/ai
	chunk_type = /datum/chunk/ai
	valid_source_types = list()

/datum/chunk/ai/acquire_visible_turfs(list/visible)
	for (var/turf/turf as anything in turfs)
		visible[turf] = turf
