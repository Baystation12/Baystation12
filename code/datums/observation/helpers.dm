/atom/movable/proc/recursive_move(var/atom/movable/am, var/old_loc, var/new_loc)
	GLOB.moved_event.raise_event(src, old_loc, new_loc)

/atom/movable/proc/move_to_turf(var/atom/movable/am, var/old_loc, var/new_loc)
	var/turf/T = get_turf(new_loc)
	if(T && T != loc)
		forceMove(T)

// Similar to above but we also follow into nullspace
/atom/movable/proc/move_to_turf_or_null(var/atom/movable/am, var/old_loc, var/new_loc)
	var/turf/T = get_turf(new_loc)
	if(T != loc)
		forceMove(T)

/atom/movable/proc/move_to_loc_or_null(var/atom/movable/am, var/old_loc, var/new_loc)
	if(new_loc != loc)
		forceMove(new_loc)

/atom/proc/recursive_dir_set(var/atom/a, var/old_dir, var/new_dir)
	set_dir(new_dir)

// Sometimes you just want to end yourself
/datum/proc/qdel_self()
	qdel(src)

/proc/register_all_movement(var/event_source, var/listener)
	GLOB.moved_event.register(event_source, listener, /atom/movable/proc/recursive_move)
	GLOB.dir_set_event.register(event_source, listener, /atom/proc/recursive_dir_set)

/proc/unregister_all_movement(var/event_source, var/listener)
	GLOB.moved_event.unregister(event_source, listener, /atom/movable/proc/recursive_move)
	GLOB.dir_set_event.unregister(event_source, listener, /atom/proc/recursive_dir_set)
