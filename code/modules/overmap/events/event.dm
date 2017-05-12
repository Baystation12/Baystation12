/var/decl/overmap_event_handler/overmap_event_handler = new()

/decl/overmap_event_handler
	var/list/event_turfs_by_z_level

/decl/overmap_event_handler/New()
	..()
	event_turfs_by_z_level = list()

/decl/overmap_event_handler/proc/create_events(var/z_level, var/overmap_size, var/number_of_events)
	// Acquire the list of not-yet utilized overmap turfs on this Z-level
	var/list/events_by_turf = get_event_turfs_by_z_level(z_level)
	var/list/candidate_turfs = block(locate(OVERMAP_EDGE, OVERMAP_EDGE, z_level),locate(overmap_size - OVERMAP_EDGE, overmap_size - OVERMAP_EDGE,z_level))
	candidate_turfs -= events_by_turf
	candidate_turfs = filter(candidate_turfs, /proc/can_not_locate, /obj/effect/overmap)

	for(var/i = 1 to number_of_events)
		if(!candidate_turfs.len)
			break
		var/overmap_event_type = pick(subtypesof(/datum/overmap_event))
		var/datum/overmap_event/overmap_event = new overmap_event_type

		var/list/event_turfs = acquire_event_turfs(overmap_event.count, overmap_event.radius, candidate_turfs)
		candidate_turfs -= event_turfs

		for(var/event_turf in event_turfs)
			events_by_turf[event_turf] = overmap_event
			GLOB.entered_event.register(event_turf, src, /decl/overmap_event_handler/proc/on_turf_entered)
			GLOB.exited_event.register(event_turf, src, /decl/overmap_event_handler/proc/on_turf_exited)

			var/obj/effect/overmap_event/event = new(event_turf)
			event.name = overmap_event.name
			event.icon_state = pick(overmap_event.event_icon_states)

		points_of_interest += overmap_event.name

/decl/overmap_event_handler/proc/get_event_turfs_by_z_level(var/z_level)
	var/z_level_text = num2text(z_level)
	. = event_turfs_by_z_level[z_level_text]
	if(!.)
		. = list()
		event_turfs_by_z_level[z_level_text] = .

/decl/overmap_event_handler/proc/acquire_event_turfs(var/number_of_turfs, var/distance_from_origin, var/list/candidate_turfs)
	number_of_turfs = min(number_of_turfs, candidate_turfs.len)
	candidate_turfs = candidate_turfs.Copy() // Not this proc's responsibility to adjust the given lists

	var/origin_turf = pick(candidate_turfs)
	var/list/selected_turfs = list(origin_turf)
	var/list/selection_turfs = list(origin_turf)
	candidate_turfs -= origin_turf

	while(selection_turfs.len && selected_turfs.len < number_of_turfs)
		var/selection_turf = pick(selection_turfs)
		var/random_neighbour = get_random_neighbour(selection_turf, candidate_turfs)

		if(random_neighbour)
			candidate_turfs -= random_neighbour
			selected_turfs += random_neighbour
			if(get_dist(origin_turf, random_neighbour) < distance_from_origin)
				selection_turfs += random_neighbour
		else
			selection_turfs -= selection_turf

	return selected_turfs

/decl/overmap_event_handler/proc/get_random_neighbour(var/turf/origin_turf, var/list/candidate_turfs)
	var/cardinal_turfs = shuffle(origin_turf.CardinalTurfs(FALSE))
	for(var/cardinal_turf in cardinal_turfs)
		if(cardinal_turf in candidate_turfs)
			return cardinal_turf

/decl/overmap_event_handler/proc/on_turf_exited(var/turf/old_loc, var/obj/effect/overmap/ship/entering_ship, var/new_loc)
	if(!istype(entering_ship))
		return
	if(new_loc == old_loc)
		return

	var/list/events_by_turf = get_event_turfs_by_z_level(old_loc.z)
	var/datum/overmap_event/old_event = events_by_turf[old_loc]
	var/datum/overmap_event/new_event = events_by_turf[new_loc]

	if(old_event == new_event)
		return
	if(old_event)
		if(new_event && old_event.difficulty == new_event.difficulty && old_event.event == new_event.event)
			return
		old_event.leave(entering_ship)

/decl/overmap_event_handler/proc/on_turf_entered(var/turf/new_loc, var/obj/effect/overmap/ship/entering_ship, var/old_loc)
	if(!istype(entering_ship))
		return
	if(new_loc == old_loc)
		return

	var/list/events_by_turf = get_event_turfs_by_z_level(new_loc.z)
	var/datum/overmap_event/old_event = events_by_turf[old_loc]
	var/datum/overmap_event/new_event = events_by_turf[new_loc]

	if(old_event == new_event)
		return
	if(new_event)
		if(old_event && old_event.difficulty == new_event.difficulty && initial(old_event.event) == initial(new_event.event))
			return
		new_event.enter(entering_ship)

// We don't subtype /obj/effect/overmap because that'll create sections one can travel to
//  And with them "existing" on the overmap Z-level things quickly get odd.
/obj/effect/overmap_event
	name = "event"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "event"

/datum/overmap_event
	var/name = "map event"
	var/radius = 2
	var/count = 6
	var/event = null
	var/list/event_icon_states = list("event")
	var/difficulty = EVENT_LEVEL_MODERATE
	var/list/victims

/datum/overmap_event/proc/enter(var/obj/effect/overmap/ship/victim)
	if(!event_manager)
		log_error("Event manager not setup.")
		return
	if(victim in victims)
		log_error("Multiple attempts to trigger the same event by [victim] detected.")
		return
	LAZYADD(victims, victim)
	var/datum/event_meta/EM = new(difficulty, "Overmap event - [name]", event, add_to_queue = FALSE, is_one_shot = TRUE)
	var/datum/event/E = new event(EM)
	E.startWhen = 0
	E.endWhen = INFINITY
	victims[victim] = E

/datum/overmap_event/proc/leave(victim)
	if(victims && victims[victim])
		var/datum/event/E = victims[victim]
		E.kill()
		LAZYREMOVE(victims, victim)

/datum/overmap_event/meteor
	name = "asteroid field"
	event = /datum/event/meteor_wave/overmap
	count = 7
	event_icon_states = list("meteor1", "meteor2", "meteor3", "meteor4")
	difficulty = EVENT_LEVEL_MAJOR

/datum/overmap_event/meteor/enter(var/obj/effect/overmap/ship/victim)
	..()
	if(victims[victim])
		var/datum/event/meteor_wave/overmap/E = victims[victim]
		E.victim = victim

/datum/overmap_event/electric
	name = "electrical storm"
	event = /datum/event/electrical_storm
	count = 9
	event_icon_states = list("electrical1", "electrical2", "electrical3", "electrical4")
	difficulty = EVENT_LEVEL_MAJOR

/datum/overmap_event/dust
	name = "dust cloud"
	event = /datum/event/dust
	count = 11
	event_icon_states = list("dust1", "dust2", "dust3", "dust4")
