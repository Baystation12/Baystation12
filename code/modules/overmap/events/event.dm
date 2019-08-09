// We don't subtype /obj/effect/overmap because that'll create sections one can travel to
//  And with them "existing" on the overmap Z-level things quickly get odd.
/obj/effect/overmap_event
	name = "event"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "event"
	var/radius = 2
	var/count = 6
	var/list/events
	var/list/icon_states = list("event")
	var/difficulty = EVENT_LEVEL_MODERATE
	var/list/victims
	var/auto_spawn = TRUE //if the event should be spawned automatically
	var/continuous = TRUE //if it should form continous blob, or can have gaps
	var/weaknesses //if the BSA can destroy them and with what

	//Which turfs shall be registered for observation in range, zero = only loc
	var/extra_width = 0
	var/extra_height = 0

/obj/effect/overmap_event/Initialize()
	. = ..()
	icon_state = pick(icon_states)
	setup_observers(null)
	GLOB.moved_event.register(src, src, .proc/on_move)
	for(var/turfs in turfs())
		overmap_event_handler.events_by_turf[turfs] = src
	update_victims()

/obj/effect/overmap_event/Destroy()
	setup_observers(loc)
	GLOB.moved_event.unregister(src, src, .proc/on_move)
	for(var/turf in turfs())
		overmap_event_handler.events_by_turf -= turf
	for(var/leaver in victims)
		leave(leaver)
	. = ..()

/obj/effect/overmap_event/proc/setup_observers(turf/old_turf)
	if(old_turf)
		var/list/turfs = turfs(old_turf)
		for(var/target in turfs)
			GLOB.entered_event.unregister(target, src, .proc/on_victim_entered)
	if(old_turf != get_turf(src))
		var/list/turfs = turfs()
		for(var/target in turfs)
			GLOB.entered_event.register(target, src, .proc/on_victim_entered)

/obj/effect/overmap_event/proc/update_victims()
	var/list/new_turfs = turfs()
	var/list/new_victims = list()
	for(var/turf/T in new_turfs)
		for(var/obj/effect/overmap/ship/S in T)
			new_victims += S

	for(var/victim in victims)
		if(victim in new_victims)
			new_victims -= victim //The union of old victims and new victims shall be ignored
			continue
		leave(victim) //Those who belong only to the old victims are no longer inside
	for(var/welcome in new_victims)
		enter(welcome) //Those who belong only to the new victims are to be welcomed

/obj/effect/overmap_event/proc/on_victim_entered(new_loc, obj/effect/overmap/ship/victim, old_loc)
	if(!istype(victim))
		return
	if(new_loc == old_loc)
		return

	var/obj/effect/overmap_event/old_event = overmap_event_handler.events_by_turf[old_loc]
	if(old_event?.type == type)
		victims[victim] = old_event.victims[victim]
		LAZYREMOVE(old_event.victims, victim)
		return

	enter(victim)

/obj/effect/overmap_event/proc/on_victim_moved(obj/effect/overmap/ship/victim, turf/old_loc, turf/new_loc)
	var/obj/effect/overmap_event/new_event = overmap_event_handler.events_by_turf[new_loc]
	if(new_event?.type == type)
		return

	leave(victim)

/obj/effect/overmap_event/proc/on_move(obj/effect/overmap_event/moving_instance, turf/old_loc, turf/new_loc)
	for(var/turf in turfs(old_loc))
		overmap_event_handler.events_by_turf -= turf
	for(var/turf in turfs())
		overmap_event_handler.events_by_turf[turf] = src
	setup_observers(old_loc, new_loc)
	update_victims()

/obj/effect/overmap_event/proc/enter(obj/effect/overmap/ship/victim)
	if(victim in victims)
		CRASH("Multiple attempts to trigger the same event by [victim] detected.")
	LAZYADD(victims, victim)
	GLOB.moved_event.register(victim, src, .proc/on_victim_moved)
	for(var/event in events)
		var/datum/event_meta/EM = new(difficulty, "Overmap event - [name]", event, add_to_queue = FALSE, is_one_shot = TRUE)
		var/datum/event/E = new event(EM)
		E.startWhen = 0
		E.endWhen = INFINITY
		E.affecting_z = victim.map_z
		LAZYADD(victims[victim], E)

/obj/effect/overmap_event/proc/leave(obj/effect/overmap/ship/victim)
	if(victims && victims[victim])
		for(var/datum/event/E in victims[victim])
			E.kill()
		LAZYREMOVE(victims, victim)
		GLOB.moved_event.unregister(victim, src, .proc/on_victim_moved)

/datum/overmap_event/meteor
	name = "asteroid field"
	events = list(/datum/event/meteor_wave/overmap)
	count = 15
	radius = 4
	continuous = FALSE
	event_icon_states = list("meteor1", "meteor2", "meteor3", "meteor4")
	difficulty = EVENT_LEVEL_MAJOR
	weaknesses = OVERMAP_WEAKNESS_MINING | OVERMAP_WEAKNESS_EXPLOSIVE

/datum/overmap_event/meteor/enter(var/obj/effect/overmap/ship/victim)
	..()
	if(victims[victim])
		var/datum/event/meteor_wave/overmap/E = locate() in victims[victim]
		if(E)
			E.victim = victim

/datum/overmap_event/electric
	name = "electrical storm"
	events = list(/datum/event/electrical_storm)
	count = 11
	radius = 3
	opacity = 0
	event_icon_states = list("electrical1", "electrical2", "electrical3", "electrical4")
	difficulty = EVENT_LEVEL_MAJOR
	weaknesses = OVERMAP_WEAKNESS_EMP

/datum/overmap_event/dust
	name = "dust cloud"
	events = list(/datum/event/dust)
	count = 16
	radius = 4
	event_icon_states = list("dust1", "dust2", "dust3", "dust4")
	weaknesses = OVERMAP_WEAKNESS_MINING | OVERMAP_WEAKNESS_EXPLOSIVE | OVERMAP_WEAKNESS_FIRE

/datum/overmap_event/ion
	name = "ion cloud"
	events = list(/datum/event/ionstorm, /datum/event/computer_damage)
	count = 8
	radius = 3
	opacity = 0
	event_icon_states = list("ion1", "ion2", "ion3", "ion4")
	difficulty = EVENT_LEVEL_MAJOR
	weaknesses = OVERMAP_WEAKNESS_EMP

/datum/overmap_event/carp
	name = "carp shoal"
	events = list(/datum/event/carp_migration)
	count = 8
	radius = 3
	opacity = 0
	difficulty = EVENT_LEVEL_MODERATE
	continuous = FALSE
	event_icon_states = list("carp1", "carp2")
	weaknesses = OVERMAP_WEAKNESS_EXPLOSIVE | OVERMAP_WEAKNESS_FIRE

/datum/overmap_event/carp/major
	name = "carp school"
	count = 5
	radius = 4
	difficulty = EVENT_LEVEL_MAJOR
	event_icon_states = list("carp3", "carp4")

/obj/effect/overmap_event/proc/turfs(turf/T = null)
	if(!T)
		T = get_turf(loc)
	return block(locate(max(T.x, 1), max(T.y, 1), T.z), locate(min(T.x + extra_width, world.maxx), min(T.y + extra_height, world.maxy), T.z))
