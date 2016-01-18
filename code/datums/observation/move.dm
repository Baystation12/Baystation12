
/***********************
* Movement Handling *
***********************/
/atom/movable
	var/datum/observ/moved

/atom/movable/Move()
	var/old_loc = loc
	if(..() && moved)
		moved.raise_event(list(src, old_loc, loc))

/atom/movable/init_observers()
	. = ..()
	if(.)
		moved = new()

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
		am.moved.raise_event(list(am, old_loc, src.loc))

/atom/movable/Entered(var/atom/movable/am, atom/old_loc)
	..()
	if(src.moved)
		src.moved.register(am, /atom/movable/proc/recursive_move)

/atom/movable/Exited(var/atom/movable/am, atom/old_loc)
	..()
	if(src.moved)
		src.moved.unregister(am)
