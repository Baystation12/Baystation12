var/datum/observ/moved/moved_event = new()

/datum/observ/moved
	name = "Moved"
	expected_type = /atom/movable

/datum/observ/moved/register(var/eventSource, var/datum/procOwner, var/proc_call)
	. = ..()
	var/atom/movable/child = eventSource
	if(.)
		var/atom/movable/parent = child.loc
		while(istype(parent) && !moved_event.is_listening(parent, child))
			moved_event.register(parent, child, /atom/movable/proc/recursive_move)
			child = parent
			parent = child.loc

/********************
* Movement Handling *
********************/

/atom/movable/Move()
	var/old_loc = loc
	. = ..()
	if(.)
		moved_event.raise_event(list(src, old_loc, loc))

/atom/movable/proc/move_to_destination(var/atom/movable/am, var/old_loc, var/new_loc)
	var/turf/T = get_turf(new_loc)
	if(T && T != loc)
		forceMove(T)

/atom/movable/proc/recursive_move(var/atom/movable/am, var/old_loc, var/new_loc)
	moved_event.raise_event(list(src, old_loc, new_loc))

/atom/Entered(var/atom/movable/am, atom/old_loc)
	..()
	moved_event.raise_event(list(am, old_loc, am.loc))

/atom/movable/Entered(var/atom/movable/am, atom/old_loc)
	..()
	if(moved_event.has_listeners(am) && !moved_event.is_listening(src, am))
		moved_event.register(src, am, /atom/movable/proc/recursive_move)

/atom/movable/Exited(var/atom/movable/am, atom/old_loc)
	..()
	if(moved_event.is_listening(src, am, /atom/movable/proc/recursive_move))
		moved_event.unregister(src, am)
