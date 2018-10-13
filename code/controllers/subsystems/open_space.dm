//
// Controller handling icon updates of open space turfs
//

GLOBAL_DATUM_INIT(over_OS_darkness, /image, image('icons/turf/open_space.dmi', "black_open"))


SUBSYSTEM_DEF(open_space)
	name = "Open Space"
	init_order = SS_INIT_OPEN_SPACE
	priority = SS_PRIORITY_OPEN_SPACE
	wait = 1 SECOND
	var/list/turfs_to_process = list()		// List of turfs queued for update.
	var/list/turfs_to_process_old = list()  //List of previous turfs that is set to update
	var/counter = 1 //Can't use .len because we need to iterate in order
	var/times_updated = 0

/datum/controller/subsystem/open_space/Initialize()
	. = ..()
	GLOB.over_OS_darkness.plane = OVER_OPENSPACE_PLANE
	GLOB.over_OS_darkness.layer = MOB_LAYER

/datum/controller/subsystem/open_space/fire(resumed = 0)
	// We use a different list so any additions to the update lists during a delay from CHECK_TICK
	// don't cause things to be cut from the list without being updated.

	//If we're not resuming, this must mean it's a new iteration so we have to grab the turfs
	if(!resumed)
		counter = 1
		src.turfs_to_process_old = turfs_to_process
		//Clear list
		turfs_to_process = list()

	//Apparently this is actually faster
	var/list/turfs_to_process_old = src.turfs_to_process_old

	while(counter <= turfs_to_process_old.len)
		var/turf/T = turfs_to_process_old[counter]
		counter += 1
		update_turf(T)
		times_updated++
		if (MC_TICK_CHECK)
			return

	if(!length(turfs_to_process))
		suspend()

/datum/controller/subsystem/open_space/stat_entry()
	..("T: [length(turfs_to_process)], U: [times_updated]")

/datum/controller/subsystem/open_space/proc/update_turf(var/turf/T)
	for(var/atom/movable/A in T)
		A.fall()
	T.update_icon()

/datum/controller/subsystem/open_space/proc/add_turf(var/turf/T, var/recursive = 0)
	ASSERT(isturf(T))
	//Check for multiple additions
	if(turfs_to_process[T])
		//If we want to add it again, the implication is
		//That we need to know what happened below
		//so It has to happen after previous addition
		//take it out and readd
		turfs_to_process -= T
	turfs_to_process[T] = TRUE
	if(recursive > 0)
		var/turf/above = GetAbove(T)
		if(above && isopenspace(above))
			add_turf(above, recursive)
	wake()

/turf/simulated/open/Initialize()
	. = ..()
	SSopen_space.add_turf(src)


/obj/on_update_icon()
	. = ..()
	if(!invisibility && isturf(loc))
		var/turf/T = GetAbove(src)
		if(isopenspace(T))
			// log_debug("[T] ([T.x],[T.y],[T.z]) queued for update for [src].update_icon()")
			SSopen_space.add_turf(T, 1)



//Probably should hook Destroy() If we can think of something more efficient, lets hear it.
/obj/Destroy()
	if(!invisibility && isturf(loc))
		var/turf/T = GetAbove(src)
		if(isopenspace(T))
			SSopen_space.add_turf(T, 1)
	. = ..() // Important that this be at the bottom, or we will have been moved to nullspace.