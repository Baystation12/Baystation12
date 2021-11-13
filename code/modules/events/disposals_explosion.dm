/*
	Disposals explosion
	Marks a disposals pipe for a violent trash explosion if not repaired in time
*/

/datum/event/disposals_explosion
	startWhen	= 0
	announceWhen = 20
	endWhen		= 150 // Should be plenty of time to find it
	var/obj/structure/disposalpipe/segment/bursting_pipe = null

// Predicates for the pick_area and pick_area_turf proc
/proc/area_has_disposals_pipe(var/area/A)
	for(var/turf/T in A)
		if(has_disposals_pipe(T))
			return TRUE
	return FALSE

/proc/has_disposals_pipe(var/turf/T)
	for(var/atom/A in T)
		if(istype(A, /obj/structure/disposalpipe/segment))
			return TRUE
	return FALSE

// Event listener for the marked pipe's destruction
/datum/event/disposals_explosion/proc/pipe_destroyed()
	GLOB.destroyed_event.unregister(bursting_pipe, src, .proc/pipe_destroyed)

	bursting_pipe = null
	kill()

/datum/event/disposals_explosion/setup()
	var/list/area_predicates = GLOB.is_station_but_not_maint_area.Copy()
	area_predicates += /proc/area_has_disposals_pipe

	var/turf/containing_turf = pick_area_and_turf(area_predicates, list(/proc/has_disposals_pipe))
	if(isnull(containing_turf))
		log_debug("Couldn't find a turf containing a disposals pipe. Aborting.")
		kill()
		return

	for(var/atom/A in containing_turf)
		if(istype(A, /obj/structure/disposalpipe/segment))
			bursting_pipe = A
			// Subscribe to pipe destruction facts
			GLOB.destroyed_event.register(A, src, .proc/pipe_destroyed)
			break

	if(isnull(bursting_pipe))
		log_debug("Couldn't find a pipe to blow up. Aborting.")
		kill()
		return

	// Damage the pipe
	bursting_pipe.set_health(rand(2, 4))

/datum/event/disposals_explosion/announce()
	command_announcement.Announce("Pressure readings indicate an imminent explosion in \the [get_area(bursting_pipe)] disposal systems. Piping sections may be damaged.", "[location_name()] Atmospheric Monitoring System", zlevels = affecting_z)

/datum/event/disposals_explosion/tick()
	if(isnull(bursting_pipe))
		kill()
		return

	// Make some noise as a clue
	if(prob(40) && bursting_pipe.get_current_health() < 5)
		playsound(bursting_pipe, 'sound/machines/hiss.ogg', 40, 0, 0)

/datum/event/disposals_explosion/end()
	if(isnull(bursting_pipe))
		return

	GLOB.destroyed_event.unregister(bursting_pipe, src, .proc/pipe_destroyed)

	if(bursting_pipe.get_current_health() < 5)
		// Make a disposals holder for the trash
		var/obj/structure/disposalholder/trash_holder = new()

		// Fill it with trash
		for(var/i = 0 to rand(5,8))
			var/chosen_trash = pick(subtypesof(/obj/item/trash))
			var/obj/item/trash/T = new chosen_trash()
			T.forceMove(trash_holder)

		// Add the trash to the pipe
		trash_holder.forceMove(bursting_pipe)
		// Burst the pipe, spewing trash all over
		bursting_pipe.broken(1)
		// Make a scary noise
		playsound(bursting_pipe, get_sfx("explosion"), 40, 0, 0, 5)
