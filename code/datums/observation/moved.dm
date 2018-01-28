//	Observer Pattern Implementation: Moved
//		Registration type: /atom/movable
//
//		Raised when: An /atom/movable instance has moved using Move() or forceMove().
//
//		Arguments that the called proc should expect:
//			/atom/movable/moving_instance: The instance that moved
//			/atom/old_loc: The loc before the move.
//			/atom/new_loc: The loc after the move.

GLOBAL_DATUM_INIT(moved_event, /decl/observ/moved, new)

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
	GLOB.moved_event.raise_event(am, old_loc, am.loc)

/atom/movable/Entered(var/atom/movable/am, atom/old_loc)
	. = ..()
	if(GLOB.moved_event.has_listeners(am))
		GLOB.moved_event.register(src, am, /atom/movable/proc/recursive_move)

/atom/movable/Exited(var/atom/movable/am, atom/old_loc)
	. = ..()
	GLOB.moved_event.unregister(src, am, /atom/movable/proc/recursive_move)

// Entered() typically lifts the moved event, but in the case of null-space we'll have to handle it.
/atom/movable/Move(turf/newloc,dir)
	var/old_loc = loc
	. = ..()
	if(. && !loc)
		GLOB.moved_event.raise_event(src, old_loc, null)
	if(!.) //On-Move Elevation Handling.//
		var/list/changed_atoms = list() //Used to track the atoms we've changed the density of, to allow for a later revert.
		for(var/atom/movable/AM in newloc.contents)
			if(AM.elevation != src.elevation && AM.density != 0)
				changed_atoms.Add(AM)
				AM.density = 0
		. = ..() //Recalling the move once we've made the atoms non-dense.
		if(!.)
			for(var/atom/movable/AM in changed_atoms)
				AM.density = 1 //If it still fails here, reset the changed atoms

/atom/movable/forceMove(atom/destination)
	var/old_loc = loc
	. = ..()
	if(. && !loc)
		GLOB.moved_event.raise_event(src, old_loc, null)
