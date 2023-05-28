/// Destroy() return value. Queue the instance for eventual hard deletion.
var/global/const/QDEL_HINT_QUEUE = 0

/// Destroy() return value. Do not queue the instance for hard deletion. Does not expect to be refcount GCd.
var/global/const/QDEL_HINT_LETMELIVE = 1

/// Destroy() return value. Same as QDEL_HINT_LETMELIVE but the instance expects to refcount GC without help.
var/global/const/QDEL_HINT_IWILLGC = 2

/// Destroy() return value. Queue this instance for hard deletion regardless of its refcount GC state.
var/global/const/QDEL_HINT_HARDDEL = 3

/// Destroy() return value. Immediately hard delete the instance.
var/global/const/QDEL_HINT_HARDDEL_NOW = 4


/// datum.gc_destroyed signal value
var/global/const/GC_QUEUED_FOR_QUEUING = -1

/// datum.gc_destroyed signal value
var/global/const/GC_QUEUED_FOR_HARD_DEL = -2

/// datum.gc_destroyed signal value
var/global/const/GC_CURRENTLY_BEING_QDELETED = -3


SUBSYSTEM_DEF(garbage)
	name = "Garbage"
	priority = SS_PRIORITY_GARBAGE
	wait = 2 SECONDS
	flags = SS_POST_FIRE_TIMING | SS_BACKGROUND | SS_NO_INIT | SS_NEEDS_SHUTDOWN
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	init_order = SS_INIT_GARBAGE

	/// fire() step state. Currently adding from the prequeue to the check queue.
	var/const/GC_QUEUE_PREQUEUE = 1

	/// fire() step state. Currently checking entries in the check queue.
	var/const/GC_QUEUE_CHECK = 2

	/// fire() step state. Currently hard deleting entries in the hard deletion queue.
	var/const/GC_QUEUE_HARDDELETE = 3

	var/static/last_tick_enqueues = 0
	var/static/last_tick_deletions = 0
	var/static/last_tick_collections = 0
	var/static/total_deletions = 0
	var/static/total_collections = 0

	var/static/list/datum/qdel_details/details_by_path = list(
		/datum/qdel_details = new /datum/qdel_details
	)

	var/static/pause_deletion_queue = FALSE

	var/static/collection_time_limit = 30 SECONDS
	var/static/deletion_time_limit = 10 SECONDS

	var/static/collections_failed = 0

	var/static/list/datum/pre_queue = list()
	var/static/list/datum/collection_queue = list()
	var/static/list/datum/deletion_queue = list()
	var/static/run_step = GC_QUEUE_PREQUEUE


/datum/controller/subsystem/garbage/Shutdown()
	var/list/qdel_log = list()
	sortTim(details_by_path, cmp = /proc/cmp_qdel_details_time, associative = TRUE)
	for (var/path in details_by_path)
		var/datum/qdel_details/details = details_by_path[path]
		qdel_log += "Path: [path]"
		if (details.failures)
			qdel_log += "\tFailures: [details.failures]"
		qdel_log += "\tqdel() Count: [details.qdels]"
		qdel_log += "\tDestroy() Cost: [details.destroy_time]ms"
		if (details.hard_deletes)
			qdel_log += "\tTotal Hard Deletes [details.hard_deletes]"
			qdel_log += "\tTime Spent Hard Deleting: [details.hard_delete_time]ms"
		if (details.slept_destroy)
			qdel_log += "\tSleeps: [details.slept_destroy]"
		if (details.no_hint)
			qdel_log += "\tNo hint: [details.no_hint] times"
	var/log_file = file("[GLOB.log_directory]/qdel.log")
	to_file(log_file, jointext(qdel_log, "\n"))


/datum/controller/subsystem/garbage/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..({"\
		prequeue: [length(pre_queue)], collection queue: [length(collection_queue)], deletion queue: [length(deletion_queue)]\n\
		last run: [last_tick_deletions + last_tick_collections], collected: [total_collections], deleted: [total_deletions], failed: [collections_failed]\n\
	"})


/datum/controller/subsystem/garbage/fire()
	run_step = GC_QUEUE_PREQUEUE
	while (state == SS_RUNNING)
		switch (run_step)
			if (GC_QUEUE_PREQUEUE)
				HandlePreQueue()
				run_step = GC_QUEUE_CHECK
			if (GC_QUEUE_CHECK)
				HandleCollectionQueue()
				run_step = GC_QUEUE_HARDDELETE
			if (GC_QUEUE_HARDDELETE)
				if (!pause_deletion_queue)
					HandleDeletionQueue()
				break
	if (state == SS_PAUSED)
		state = SS_RUNNING


/datum/controller/subsystem/garbage/proc/HandlePreQueue()
	var/size = length(pre_queue)
	if (!size)
		return
	var/bound
	var/cut_until = 1
	for (var/i = 1 to size)
		++cut_until
		var/datum/datum = pre_queue[i]
		if (!datum)
			continue
		var/time = world.time
		var/reftext = "\ref[datum]"
		switch (datum.gc_destroyed)
			if (GC_QUEUED_FOR_HARD_DEL)
				deletion_queue[datum] = time
			else
				collection_queue[reftext] = time
		datum.gc_destroyed = time
		if (++bound == 50)
			bound = 0
			if (MC_TICK_CHECK)
				break
	pre_queue.Cut(1, cut_until)


/datum/controller/subsystem/garbage/proc/HandleCollectionQueue()
	last_tick_deletions = 0
	last_tick_collections = 0
	var/size = length(collection_queue)
	if (!size)
		return
	var/cutoff_time = world.time - collection_time_limit
	var/cut_until = 1
	for (var/i = 1 to size)
		++cut_until
		var/reftext = collection_queue[i]
		if (!reftext)
			continue
		var/queue_time = collection_queue[reftext]
		if (queue_time > cutoff_time)
			--cut_until
			break
		var/datum/datum = locate(reftext)
		if (!datum || datum.gc_destroyed != queue_time)
			++last_tick_collections
			++total_collections
			if (MC_TICK_CHECK)
				break
			continue
		var/path = datum.type
		var/datum/qdel_details/details = details_by_path[path]
		if (!details.failures)
			to_world_log("GC: [reftext] [path] unable to be collected")
		++details.failures
		++collections_failed
		deletion_queue[datum] = world.time
	if (cut_until)
		collection_queue.Cut(1, cut_until)


/datum/controller/subsystem/garbage/proc/HandleDeletionQueue()
	var/size = length(deletion_queue)
	if (!size)
		return
	var/cutoff_time = world.time - deletion_time_limit
	var/cut_until = 1
	for (var/i = 1 to size)
		++cut_until
		var/datum/datum = deletion_queue[i]
		if (!datum)
			continue
		var/queue_time = deletion_queue[datum]
		if (queue_time > cutoff_time)
			--cut_until
			break
		HardDelete(datum)
		if (MC_TICK_CHECK)
			break
	if (cut_until)
		deletion_queue.Cut(1, cut_until)


/datum/controller/subsystem/garbage/proc/HardDelete(datum/datum)
	if (!datum)
		return
	var/time = world.timeofday
	var/tick = world.tick_usage
	var/ticktime = world.time
	++last_tick_deletions
	++total_deletions
	var/type = datum.type
	var/refID = "\ref[datum]"
	del(datum)
	tick = world.tick_usage - tick + ((world.time - ticktime) / world.tick_lag * 100)
	var/datum/qdel_details/details = details_by_path[type]
	++details.hard_deletes
	details.hard_delete_time += tick * world.tick_lag
	time = world.timeofday - time
	if (!time && tick * world.tick_lag > 1)
		time = tick * world.tick_lag * 0.01
	if (time > 10)
		log_game("Error: [type]([refID]) took longer than 1 second to delete (took [round(time / 10, 0.1)] seconds to delete)")
		message_admins("Error: [type]([refID]) took longer than 1 second to delete (took [round(time / 10, 0.1)] seconds to delete).")
		postpone(time)


/datum/qdel_details
	var/qdels = 0 //Total number of times it's passed thru qdel.
	var/destroy_time = 0 //Total amount of milliseconds spent processing this type's Destroy()
	var/failures = 0 //Times it was queued for soft deletion but failed to soft delete.
	var/hard_deletes = 0 //Different from failures because it also includes QDEL_HINT_HARDDEL deletions
	var/hard_delete_time = 0 //Total amount of milliseconds spent hard deleting this type.
	var/no_hint = 0 //Number of times it's not even bother to give a qdel hint
	var/slept_destroy = 0 //Number of times it's slept in its destroy


/proc/cmp_qdel_details_time(datum/qdel_details/A, datum/qdel_details/B)
	. = B.hard_delete_time - A.hard_delete_time
	if (!.)
		. = B.destroy_time - A.destroy_time
	if (!.)
		. = B.failures - A.failures
	if (!.)
		. = B.qdels - A.qdels


/// Queue datum D for garbage collection / deletion. Calls the datum's Destroy() and sets its gc_destroyed value.
/proc/qdel(datum/datum)
	if (!datum)
		return
	if (!istype(datum))
		crash_with("qdel() can only handle /datum (sub)types, was passed: [log_info_line(datum)]")
		del(datum)
		return
	var/static/list/details_by_path = SSgarbage.details_by_path
	var/datum/qdel_details/details = details_by_path[datum.type]
	if (!details)
		details = new
		details_by_path[datum.type] = details
	++details.qdels
	if (isnull(datum.gc_destroyed))
		datum.gc_destroyed = GC_CURRENTLY_BEING_QDELETED
		var/start_time = world.time
		var/start_tick = world.tick_usage
		var/hint = datum.Destroy()
		if (world.time != start_time)
			++details.slept_destroy
		else
			details.destroy_time += (world.tick_usage - start_tick) * world.tick_lag
		var/static/immediate = TRUE
		if (immediate)
			immediate = Master.current_runlevel < RUNLEVEL_GAME
		var/static/list/pre_queue = SSgarbage.pre_queue
		var/static/list/collection_queue = SSgarbage.collection_queue
		var/static/list/deletion_queue = SSgarbage.deletion_queue
		switch(hint)
			if (QDEL_HINT_QUEUE)
				if (ismovable(datum))
					var/atom/movable/movable = datum
					if (movable.loc)
						crash_with("QDEL_HINT_QUEUE: [movable] loc not null after Destroy")
						movable.forceMove(null)
				if (immediate)
					datum.gc_destroyed = world.time
					collection_queue["\ref[datum]"] = world.time
				else
					pre_queue += datum
					datum.gc_destroyed = GC_QUEUED_FOR_QUEUING
			if (QDEL_HINT_IWILLGC)
				datum.gc_destroyed = world.time
			if (QDEL_HINT_LETMELIVE)
				datum.gc_destroyed = null
			if (QDEL_HINT_HARDDEL)
				if (ismovable(datum))
					var/atom/movable/movable = datum
					if (movable.loc)
						crash_with("QDEL_HINT_HARDDEL: [movable] loc not null after Destroy")
						movable.forceMove(null)
				if (datum.gc_destroyed == GC_CURRENTLY_BEING_QDELETED)
					if (immediate)
						datum.gc_destroyed = world.time
						deletion_queue[datum] = world.time
					else
						datum.gc_destroyed = GC_QUEUED_FOR_HARD_DEL
						pre_queue += datum
			if (QDEL_HINT_HARDDEL_NOW)
				SSgarbage.HardDelete(datum)
			else
				++details.no_hint
				if (immediate)
					datum.gc_destroyed = world.time
					collection_queue["\ref[datum]"] = world.time
				else
					pre_queue += datum
					datum.gc_destroyed = GC_QUEUED_FOR_QUEUING
	else if (datum.gc_destroyed == GC_CURRENTLY_BEING_QDELETED)
		CRASH("[datum.type] destroy proc was called multiple times, likely due to a qdel loop in the Destroy logic")
