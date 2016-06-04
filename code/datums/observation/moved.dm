//	Observer Pattern Implementation: Moved
//		Registration type: /atom/movable
//
//		Raised when: An /atom/movable instance has moved using Move() or forceMove().
//
//		Arguments that the called proc should expect:
//			/atom/movable/moving_instance: The instance that moved
//			/atom/old_loc: The loc before the move.
//			/atom/new_loc: The loc after the move.

var/decl/observ/moved/moved_event = new()

/decl/observ/moved
	name = "Moved"
	expected_type = /atom/movable

/decl/observ/moved/register(var/atom/movable/mover, var/datum/listener, var/proc_call)
	. = ..()

	// Listen to the parent if possible.
	if(. && istype(mover.loc, expected_type))
		register(mover.loc, mover, /atom/movable/proc/recursive_move)

/********************
* Movement Handling *
********************/

/atom/Entered(var/atom/movable/am, var/atom/old_loc)
	. = ..()
	moved_event.raise_event(am, old_loc, am.loc)

/atom/movable/Entered(var/atom/movable/am, atom/old_loc)
	. = ..()
	if(moved_event.has_listeners(am))
		moved_event.register(src, am, /atom/movable/proc/recursive_move)

/atom/movable/Exited(var/atom/movable/am, atom/old_loc)
	. = ..()
	moved_event.unregister(src, am, /atom/movable/proc/recursive_move)

// Entered() typically lifts the moved event, but in the case of null-space we'll have to handle it.
/atom/movable/Move()
	var/old_loc = loc
	. = ..()
	if(. && !loc)
		moved_event.raise_event(src, old_loc, null)

/atom/movable/forceMove(atom/destination)
	var/old_loc = loc
	. = ..()
	if(. && !loc)
		moved_event.raise_event(src, old_loc, null)
