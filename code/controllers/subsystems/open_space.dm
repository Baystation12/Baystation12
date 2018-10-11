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

	var/list/fallers = list() // Currently falling atoms

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

/datum/controller/subsystem/open_space/proc/do_fall(atom/movable/faller)
	set waitfor = FALSE
	var/datum/fall/fall_datum = fallers[faller]
	if(!faller.should_fall())
		if(fall_datum)
			fall_datum.end_fall()
			qdel(fall_datum)
		return
	if(!fall_datum)
		fall_datum = new (faller)
	fall_datum.process_fall()

/datum/fall
	var/atom/movable/faller
	var/turf/start_loc
	var/is_client_moving

/datum/fall/New(atom/movable/faller)
	src.faller = faller
	GLOB.destroyed_event.register(faller, src, .proc/qdel_self)
	SSopen_space.fallers[faller] = src
	start_loc = faller.loc // Guaranteed to be a turf by earlier checks, in fact

	var/mob/M = faller
	is_client_moving = istype(M) && M.moving

/datum/fall/Destroy()
	GLOB.destroyed_event.unregister(faller, src, .proc/qdel_self)
	SSopen_space.fallers -= faller
	faller = null
	start_loc = null
	return ..()

/datum/fall/proc/process_fall()
	var/mob/M = faller
	if(is_client_moving)
		M.moving = 1
	faller.forceMove(GetBelow(faller)) // Will call do_fall again from Entered(), which will run after this completes.
	if(!faller)
		return // Check for possible deletion on Entered(); this will call the listener for actual deletion handling (nulling faller), but we still need to stop.
	if(is_client_moving)
		M.moving = 0
	if(!faller.should_fall(faller))
		end_fall()
		qdel(src)
		return
	faller.visible_message("\The [faller] falls from the deck above through \the [faller.loc]!", "You hear a whoosh of displaced air.")

/datum/fall/proc/end_fall()
	var/turf/landing = get_turf(faller)
	if((start_loc.z - faller.z <= 1) && (locate(/obj/structure/stairs) in landing))
		return
	faller.handle_fall_effect(landing, start_loc)
