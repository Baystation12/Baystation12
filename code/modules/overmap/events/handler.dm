/var/decl/overmap_event_handler/overmap_event_handler = new()

/decl/overmap_event_handler
	var/list/events_by_turf

/decl/overmap_event_handler/New()
	..()
	if(GLOB.using_map.use_overmap)
		events_by_turf = list()

/decl/overmap_event_handler/proc/create_events(z_level, overmap_size, number_of_events)
	// Acquire the list of not-yet utilized overmap turfs on this Z-level
	var/list/candidate_turfs = block(locate(OVERMAP_EDGE, OVERMAP_EDGE, z_level),locate(overmap_size - OVERMAP_EDGE, overmap_size - OVERMAP_EDGE,z_level))
	candidate_turfs = where(candidate_turfs, /proc/can_not_locate, /obj/effect/overmap) - events_by_turf

	var/startype = pick(80;/obj/effect/overmap_event/star,19;/obj/effect/overmap_event/star/pulsar,1;/obj/effect/overmap_event/star/blackhole)
	var/obj/effect/overmap_event/star/star = new startype(locate(round(overmap_size / 2), round(overmap_size / 2), z_level))
	candidate_turfs -= star.turfs()

	for(var/i = 1 to number_of_events)
		if(!candidate_turfs.len)
			break
		var/obj/effect/overmap_event/overmap_event_type = pick(subtypesof(/obj/effect/overmap_event))
		while(!initial(overmap_event_type.auto_spawn))
			overmap_event_type = pick(subtypesof(/obj/effect/overmap_event))

		var/list/event_turfs = acquire_event_turfs(initial(overmap_event_type.count), initial(overmap_event_type.radius), candidate_turfs, initial(overmap_event_type.continuous))

		for(var/event_turf in event_turfs)
			var/obj/effect/overmap_event/event = new overmap_event_type(event_turf)
			candidate_turfs -= event.turfs()

/decl/overmap_event_handler/proc/acquire_event_turfs(var/number_of_turfs, var/distance_from_origin, var/list/candidate_turfs, var/continuous = TRUE)
	number_of_turfs = min(number_of_turfs, candidate_turfs.len)
	candidate_turfs = candidate_turfs.Copy() // Not this proc's responsibility to adjust the given lists

	var/origin_turf = pick(candidate_turfs)
	var/list/selected_turfs = list(origin_turf)
	var/list/selection_turfs = list(origin_turf)
	candidate_turfs -= origin_turf

	while(selection_turfs.len && selected_turfs.len < number_of_turfs)
		var/selection_turf = pick(selection_turfs)
		var/random_neighbour = get_random_neighbour(selection_turf, candidate_turfs, continuous, distance_from_origin)

		if(random_neighbour)
			candidate_turfs -= random_neighbour
			selected_turfs += random_neighbour
			if(get_dist(origin_turf, random_neighbour) < distance_from_origin)
				selection_turfs += random_neighbour
		else
			selection_turfs -= selection_turf

	return selected_turfs

/decl/overmap_event_handler/proc/get_random_neighbour(var/turf/origin_turf, var/list/candidate_turfs, var/continuous = TRUE, var/range)
	var/fitting_turfs
	if(continuous)
		fitting_turfs = origin_turf.CardinalTurfs(FALSE)
	else
		fitting_turfs = trange(range, origin_turf)
	fitting_turfs = shuffle(fitting_turfs)
	for(var/turf/T in fitting_turfs)
		if(T in candidate_turfs)
			return T
