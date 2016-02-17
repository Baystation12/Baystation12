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
	if(. && istype(dir_changer.loc, expected_type))
		register(dir_changer.loc, dir_changer, /atom/proc/recursive_dir_set)

/decl/observ/dir_set/unregister(var/atom/dir_changer, var/datum/listener, var/proc_call)
	. = ..()

	// Stop listening to the parent if we aren't being listened to.
	if(. && !has_listeners(dir_changer))
		unregister(dir_changer.loc, dir_changer, /atom/proc/recursive_dir_set)

/atom/proc/recursive_dir_set(var/atom/a, var/old_dir, var/new_dir)
	set_dir(new_dir)
