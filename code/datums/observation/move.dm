/datum/observ/moved/New(var/atom/movable/event_holder)
	if(!istype(event_holder))
		CRASH("Improper event holder type: '[event_holder]'/[event_holder.type]")
	..()

/datum/observ/moved/register(var/datum/procOwner, var/proc_call)
	. = ..()
	var/atom/movable/child = event_holder
	if(.)
		var/atom/movable/parent = child.loc
		while(istype(parent) && parent.moved && !parent.moved.is_listening(child))
			parent.moved.register(child, /atom/movable/proc/recursive_move)
			child = parent
			parent = child.loc

/***********************
* Movement Handling *
***********************/
/atom/movable
	var/datum/observ/moved/moved

/atom/movable/Move()
	var/old_loc = loc
	if(..() && moved)
		moved.raise_event(list(src, old_loc, loc))

/atom/movable/init_observers(var/event_holder)
	. = ..()
	if(.)
		moved = new(event_holder)

/atom/movable/destroy_observers()
	. = ..()
	if(.)
		qdel(moved)
		moved = null

/atom/movable/proc/move_to_destination(var/atom/movable/am, var/old_loc, var/new_loc)
	var/turf/T = get_turf(new_loc)
	if(T && T != loc)
		forceMove(T)

/atom/movable/proc/recursive_move(var/atom/movable/am, var/old_loc, var/new_loc)
	moved.raise_event(list(src, old_loc, new_loc))

/atom/Entered(var/atom/movable/am, atom/old_loc)
	..()
	if(am.moved)
		am.moved.raise_event(list(am, old_loc, am.loc))

/atom/movable/Entered(var/atom/movable/am, atom/old_loc)
	..()
	if(src.moved && am.moved && am.moved.has_listeners() && !src.moved.is_listening(am))
		src.moved.register(am, /atom/movable/proc/recursive_move)

/atom/movable/Exited(var/atom/movable/am, atom/old_loc)
	..()
	if(src.moved && src.moved.is_listening(am, /atom/movable/proc/recursive_move))
		src.moved.unregister(am)
