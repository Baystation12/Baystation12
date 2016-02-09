//	Observer Pattern Implementation: Moved
//		Registration type: /atom/movable
//
//		Raised when: An /atom/movable instance has moved.
//
//		Arguments that the called proc should expect:
//			/atom/movable/moving_instance: The instance that moved
//			/atom/old_loc: The loc before the move.
//			/atom/new_loc: The loc after the move.
#define CANCEL_MOVE_EVENT -55

var/decl/observ/moved/moved_event = new()

/decl/observ/moved
	name = "Moved"
	expected_type = /atom/movable

/decl/observ/moved/register(var/eventSource, var/datum/procOwner, var/proc_call)
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
/atom/movable/proc/move_to_destination(var/atom/movable/am, var/old_loc, var/new_loc)
	var/turf/T = get_turf(new_loc)
	if(T && T != loc)
		forceMove(T)

/atom/movable/proc/recursive_move(var/atom/movable/am, var/old_loc, var/new_loc)
	moved_event.raise_event(list(src, old_loc, new_loc))

/atom/Entered(var/atom/movable/am, var/atom/old_loc)
	. = ..()
	if(. != CANCEL_MOVE_EVENT)
		moved_event.raise_event(list(am, old_loc, am.loc))

/atom/movable/Entered(var/atom/movable/am, atom/old_loc)
	. = ..()
	if(. != CANCEL_MOVE_EVENT && moved_event.has_listeners(am) && !moved_event.is_listening(src, am))
		moved_event.register(src, am, /atom/movable/proc/recursive_move)

/atom/movable/Exited(var/atom/movable/am, atom/old_loc)
	..()
	if(moved_event.is_listening(src, am, /atom/movable/proc/recursive_move))
		moved_event.unregister(src, am)
