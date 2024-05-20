/atom/movable/proc/recursive_move(atom/movable/am, old_loc, new_loc)
	GLOB.moved_event.raise_event(src, old_loc, new_loc)

/atom/movable/proc/move_to_turf(atom/movable/am, old_loc, new_loc)
	var/turf/T = get_turf(new_loc)
	if(T && T != loc)
		forceMove(T)

// Similar to above but we also follow into nullspace
/atom/movable/proc/move_to_turf_or_null(atom/movable/am, old_loc, new_loc)
	var/turf/T = get_turf(new_loc)
	if(T != loc)
		forceMove(T)

/atom/movable/proc/move_to_loc_or_null(atom/movable/am, old_loc, new_loc)
	if(new_loc != loc)
		forceMove(new_loc)

/**
 * Handler for setting an atom's dir when mimicking movements. Calls `set_dir()`.
 *
 * **Parameters**:
 * - `a` - The atom triggering the event.
 * - `old_dir` - The atom's prior `dir`.
 * - `new_dir` - The new `dir` to set.
 */
/atom/proc/recursive_dir_set(atom/a, old_dir, new_dir)
	set_dir(new_dir)

// Sometimes you just want to end yourself
/datum/proc/qdel_self()
	qdel(src)

/proc/register_all_movement(event_source, listener)
	GLOB.moved_event.register(event_source, listener, TYPE_PROC_REF(/atom/movable, recursive_move))
	GLOB.dir_set_event.register(event_source, listener, TYPE_PROC_REF(/atom, recursive_dir_set))

/proc/unregister_all_movement(event_source, listener)
	GLOB.moved_event.unregister(event_source, listener, TYPE_PROC_REF(/atom/movable, recursive_move))
	GLOB.dir_set_event.unregister(event_source, listener, TYPE_PROC_REF(/atom, recursive_dir_set))
