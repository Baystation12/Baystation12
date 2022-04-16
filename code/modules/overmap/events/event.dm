var/global/decl/overmap_event_handler/overmap_event_handler = new()

/decl/overmap_event_handler
	var/list/hazard_by_turf
	var/list/ship_events

/decl/overmap_event_handler/New()
	..()
	hazard_by_turf = list()
	ship_events = list()

/decl/overmap_event_handler/proc/create_events(var/z_level, var/overmap_size, var/number_of_events)
	// Acquire the list of not-yet utilized overmap turfs on this Z-level
	var/list/candidate_turfs = block(locate(OVERMAP_EDGE, OVERMAP_EDGE, z_level),locate(overmap_size - OVERMAP_EDGE, overmap_size - OVERMAP_EDGE,z_level))
	candidate_turfs = where(candidate_turfs, /proc/can_not_locate, /obj/effect/overmap/visitable)

	for(var/i = 1 to number_of_events)
		if(!candidate_turfs.len)
			break
		var/overmap_event_type = pick(subtypesof(/datum/overmap_event))
		var/datum/overmap_event/datum_spawn = new overmap_event_type

		var/list/event_turfs = acquire_event_turfs(datum_spawn.count, datum_spawn.radius, candidate_turfs, datum_spawn.continuous)
		candidate_turfs -= event_turfs

		for(var/event_turf in event_turfs)
			var/type = pick(datum_spawn.hazards)
			new type(event_turf)

		qdel(datum_spawn)//idk help how do I do this better?

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

/decl/overmap_event_handler/proc/start_hazard(var/obj/effect/overmap/visitable/ship/ship, var/obj/effect/overmap/event/hazard)//make these accept both hazards or events
	if(!(ship in ship_events))
		ship_events += ship

	for(var/event_type in hazard.events)
		if(is_event_active(ship,event_type, hazard.difficulty))//event's already active, don't bother
			continue
		var/datum/event_meta/EM = new(hazard.difficulty, "Overmap event - [hazard.name]", event_type, add_to_queue = FALSE, is_one_shot = TRUE)
		var/datum/event/E = new event_type(EM)
		E.startWhen = 0
		E.endWhen = INFINITY
		E.affecting_z = ship.map_z
		if("victim" in E.vars)//for meteors and other overmap events that uses ships//might need a better solution
			E.vars["victim"] = ship
		LAZYADD(ship_events[ship], E)

/decl/overmap_event_handler/proc/stop_hazard(var/obj/effect/overmap/visitable/ship/ship, var/obj/effect/overmap/event/hazard)
	for(var/event_type in hazard.events)
		var/datum/event/E = is_event_active(ship,event_type,hazard.difficulty)
		if(E)
			E.kill()
			LAZYREMOVE(ship_events[ship], E)

/decl/overmap_event_handler/proc/is_event_active(var/ship, var/event_type, var/severity)
	if(!ship_events[ship])	return
	for(var/datum/event/E in ship_events[ship])
		if(E.type == event_type && E.severity == severity)
			return E

/decl/overmap_event_handler/proc/on_turf_entered(var/turf/new_loc, var/obj/effect/overmap/visitable/ship/ship, var/old_loc)
	if(!istype(ship))
		return
	if(new_loc == old_loc)
		return

	for(var/obj/effect/overmap/event/E in hazard_by_turf[new_loc])
		start_hazard(ship, E)

/decl/overmap_event_handler/proc/on_turf_exited(var/turf/old_loc, var/obj/effect/overmap/visitable/ship/ship, var/new_loc)
	if(!istype(ship))
		return
	if(new_loc == old_loc)
		return

	for(var/obj/effect/overmap/event/E in hazard_by_turf[old_loc])
		if(is_event_included(hazard_by_turf[new_loc],E))
			continue
		stop_hazard(ship,E)

/decl/overmap_event_handler/proc/update_hazards(var/turf/T)//catch all updater
	if(!istype(T))
		return

	var/list/active_hazards = list()
	for(var/obj/effect/overmap/event/E in T)
		if(is_event_included(active_hazards, E, TRUE))
			continue
		active_hazards += E

	if(!active_hazards.len)
		hazard_by_turf -= T
		GLOB.entered_event.unregister(T, src, /decl/overmap_event_handler/proc/on_turf_entered)
		GLOB.exited_event.unregister(T, src, /decl/overmap_event_handler/proc/on_turf_exited)
	else
		hazard_by_turf |= T
		hazard_by_turf[T] = active_hazards
		GLOB.entered_event.register(T, src,/decl/overmap_event_handler/proc/on_turf_entered)
		GLOB.exited_event.register(T, src, /decl/overmap_event_handler/proc/on_turf_exited)

	for(var/obj/effect/overmap/visitable/ship/ship in T)
		for(var/datum/event/E in ship_events[ship])
			if(is_event_in_turf(E,T))
				continue
			E.kill()
			LAZYREMOVE(ship_events[ship], E)

		for(var/obj/effect/overmap/event/E in active_hazards)
			start_hazard(ship,E)

/decl/overmap_event_handler/proc/is_event_in_turf(var/datum/event/E, var/turf/T)
	for(var/obj/effect/overmap/event/hazard in hazard_by_turf[T])
		if(E in hazard.events && E.severity == hazard.difficulty)
			return TRUE

/decl/overmap_event_handler/proc/is_event_included(var/list/hazards, var/obj/effect/overmap/event/E, var/equal_or_better)//this proc is only used so it can break out of 2 loops cleanly
	for(var/obj/effect/overmap/event/A in hazards)
		if(istype(A,E.type) || istype(E,A.type))
			if(same_entries(A.events, E.events))
				if(equal_or_better)
					if(A.difficulty >= E.difficulty)
						return TRUE
					else
						hazards -= A
				else
					if(A.difficulty == E.difficulty)
						return TRUE

// We don't subtype /obj/effect/overmap/visitable because that'll create sections one can travel to
//  And with them "existing" on the overmap Z-level things quickly get odd.
/obj/effect/overmap/event
	name = "event"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "event"
	opacity = 1
	color = "#880000"
	var/list/events
	var/list/event_icon_states
	var/difficulty = EVENT_LEVEL_MODERATE
	var/weaknesses //if the BSA can destroy them and with what
	var/list/victims //basically cached events on which Z level

/obj/effect/overmap/event/Initialize()
	. = ..()
	icon_state = pick(event_icon_states)
	overmap_event_handler.update_hazards(loc)

/obj/effect/overmap/event/Move()
	var/turf/old_loc = loc
	. = ..()
	if(.)
		overmap_event_handler.update_hazards(old_loc)
		overmap_event_handler.update_hazards(loc)

/obj/effect/overmap/event/forceMove(atom/destination)
	var/old_loc = loc
	. = ..()
	if(.)
		overmap_event_handler.update_hazards(old_loc)
		overmap_event_handler.update_hazards(loc)

/obj/effect/overmap/event/Destroy()//takes a look at this one as well, make sure everything is A-OK
	var/turf/T = loc
	. = ..()
	overmap_event_handler.update_hazards(T)

/obj/effect/overmap/event/meteor
	name = "asteroid field"
	events = list(/datum/event/meteor_wave/overmap)
	event_icon_states = list("meteor1", "meteor2", "meteor3", "meteor4")
	difficulty = EVENT_LEVEL_MAJOR
	weaknesses = OVERMAP_WEAKNESS_MINING | OVERMAP_WEAKNESS_EXPLOSIVE
	color = "#a08444"

/obj/effect/overmap/event/electric
	name = "electrical storm"
	events = list(/datum/event/electrical_storm)
	opacity = 0
	event_icon_states = list("electrical1", "electrical2", "electrical3", "electrical4")
	difficulty = EVENT_LEVEL_MAJOR
	weaknesses = OVERMAP_WEAKNESS_EMP
	color = "#e8e85c"

/obj/effect/overmap/event/dust
	name = "dust cloud"
	events = list(/datum/event/dust)
	event_icon_states = list("dust1", "dust2", "dust3", "dust4")
	weaknesses = OVERMAP_WEAKNESS_MINING | OVERMAP_WEAKNESS_EXPLOSIVE | OVERMAP_WEAKNESS_FIRE
	color = "#6c6c6c"

/obj/effect/overmap/event/ion
	name = "ion cloud"
	events = list(/datum/event/ionstorm, /datum/event/computer_damage)
	opacity = 0
	event_icon_states = list("ion1", "ion2", "ion3", "ion4")
	difficulty = EVENT_LEVEL_MAJOR
	weaknesses = OVERMAP_WEAKNESS_EMP
	color = "#7cb4d4"

/obj/effect/overmap/event/carp
	name = "carp shoal"
	events = list(/datum/event/carp_migration/overmap)
	opacity = 0
	difficulty = EVENT_LEVEL_MODERATE
	event_icon_states = list("carp1", "carp2")
	weaknesses = OVERMAP_WEAKNESS_EXPLOSIVE | OVERMAP_WEAKNESS_FIRE
	color = "#783ca4"

/obj/effect/overmap/event/carp/major
	name = "carp school"
	difficulty = EVENT_LEVEL_MAJOR
	event_icon_states = list("carp3", "carp4")


/obj/effect/overmap/event/gravity
	name = "dark matter influx"
	weaknesses = OVERMAP_WEAKNESS_EXPLOSIVE
	events = list(/datum/event/gravity)
	event_icon_states = list("grav1", "grav2", "grav3", "grav4")
	opacity = 0
	color = "#321945"

//These now are basically only used to spawn hazards. Will be useful when we need to spawn group of moving hazards
/datum/overmap_event
	var/name = "map event"
	var/radius = 2
	var/count = 6
	var/hazards
	var/opacity = 1
	var/continuous = TRUE //if it should form continous blob, or can have gaps

/datum/overmap_event/meteor
	name = "asteroid field"
	count = 15
	radius = 4
	continuous = FALSE
	hazards = /obj/effect/overmap/event/meteor

/datum/overmap_event/electric
	name = "electrical storm"
	count = 11
	radius = 3
	opacity = 0
	hazards = /obj/effect/overmap/event/electric

/datum/overmap_event/dust
	name = "dust cloud"
	count = 16
	radius = 4
	hazards = /obj/effect/overmap/event/dust

/datum/overmap_event/ion
	name = "ion cloud"
	count = 8
	radius = 3
	opacity = 0
	hazards = /obj/effect/overmap/event/ion

/datum/overmap_event/carp
	name = "carp shoal"
	count = 8
	radius = 3
	opacity = 0
	continuous = FALSE
	hazards = /obj/effect/overmap/event/carp

/datum/overmap_event/carp/major
	name = "carp school"
	count = 5
	radius = 4
	hazards = /obj/effect/overmap/event/carp/major

/datum/overmap_event/gravity
	name = "dark matter influx"
	count = 12
	radius = 4
	opacity = 0
	hazards = /obj/effect/overmap/event/gravity