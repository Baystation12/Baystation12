//	Observer Pattern Implementation: Direction Set
//		Registration type: /atom
//
//		Raised when: An /atom changes dir using the set_dir() proc.
//
//		Arguments that the called proc should expect:
//			/atom/dir_changer: The instance that changed direction
//			/old_dir: The dir before the change.
//			/new_dir: The dir after the change.

var/decl/observ/dir_set/dir_set_event = new()

/decl/observ/dir_set
	name = "Direction Set"
	expected_type = /atom

/decl/observ/dir_set/register(var/atom/dir_changer, var/datum/listener, var/proc_call)
	. = ..()

	// Listen to the parent if possible.
	if(. && istype(dir_changer.loc, /atom/movable))	// We don't care about registering to turfs.
		register(dir_changer.loc, dir_changer, /atom/proc/recursive_dir_set)

/*********************
* Direction Handling *
*********************/

/atom/set_dir()
	var/old_dir = dir
	. = ..()
	if(old_dir != dir)
		dir_set_event.raise_event(src, old_dir, dir)

/atom/movable/Entered(var/atom/movable/am, atom/old_loc)
	. = ..()
	if(dir_set_event.has_listeners(am))
		dir_set_event.register(src, am, /atom/proc/recursive_dir_set)

/atom/movable/Exited(var/atom/movable/am, atom/old_loc)
	. = ..()
	dir_set_event.unregister(src, am, /atom/proc/recursive_dir_set)
