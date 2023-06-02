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
var/global/const/GC_CURRENTLY_BEING_QDELETED = -1


SUBSYSTEM_DEF(garbage)
	name = "Garbage"
	priority = SS_PRIORITY_GARBAGE
	wait = 10 SECONDS
	flags = SS_POST_FIRE_TIMING | SS_BACKGROUND | SS_NEEDS_SHUTDOWN
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	init_order = SS_INIT_GARBAGE

	var/static/last_tick_enqueues = 0
	var/static/last_tick_deletions = 0
	var/static/last_tick_collections = 0
	var/static/total_deletions = 0
	var/static/total_collections = 0
	var/static/failed_collections = 0

	var/static/list/datum/qdel_details/details_by_path = list(
		/datum/qdel_details = new /datum/qdel_details
	)

	var/static/pause_deletion_queue = FALSE

	var/static/collection_time_limit = 60 SECONDS

	var/static/list/datum/collection_queue = list()

	var/static/list/datum/deletion_queue = list()


/datum/controller/subsystem/garbage/Shutdown()
	var/list/qdel_log = list()
	sortTim(details_by_path, cmp = /proc/cmp_qdel_details_time, associative = TRUE)
	for (var/path in details_by_path)
		var/datum/qdel_details/details = details_by_path[path]
		qdel_log += "Path: [path]"
		if (details.failures)
			qdel_log += "\tFailures: [details.failures]"
		qdel_log += "\tqdel() Count: [details.qdels]"
		if (details.extra_qdels)
			qdel_log += "\tunecessary qdel() Count: [details.extra_qdels]"
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


/datum/controller/subsystem/garbage/Initialize(start_uptime)
	pause_deletion_queue = config.deletion_starts_paused


/datum/controller/subsystem/garbage/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..({"\
		collection queue: [length(collection_queue)], deletion queue: [length(deletion_queue)]\n\
		last run: [last_tick_deletions + last_tick_collections], collected: [total_collections], deleted: [total_deletions], failed: [failed_collections]\n\
	"})


/datum/controller/subsystem/garbage/fire()
	HandleCollectionQueue()
	if (!pause_deletion_queue && state == SS_RUNNING)
		HandleDeletionQueue()


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
		++details.failures
		++failed_collections
		deletion_queue[datum] = world.time
	if (cut_until)
		collection_queue.Cut(1, cut_until)


/datum/controller/subsystem/garbage/proc/HandleDeletionQueue()
	var/size = length(deletion_queue)
	if (!size)
		return
	var/cut_until = 1
	for (var/i = 1 to size)
		++cut_until
		var/datum/datum = deletion_queue[i]
		if (!datum)
			continue
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
	/// Number of times the associated path has been queued for deletion
	var/qdels = 0

	/// Number of times an instance was queued more than once
	var/extra_qdels = 0

	/// Total milliseconds spent on Destroy calls
	var/destroy_time = 0

	/// Number of times rolled over from collection to deletion
	var/failures = 0

	/// Number of times hard deleted, failure and intended
	var/hard_deletes = 0

	/// Total milliseconds spent on del calls
	var/hard_delete_time = 0

	/// Number of times Destroy did not return a QDEL_HINT_*
	var/no_hint = 0

	/// Number of times Destroy calls slept
	var/slept_destroy = 0


/proc/cmp_qdel_details_time(datum/qdel_details/A, datum/qdel_details/B)
	. = B.hard_delete_time - A.hard_delete_time
	if (!.)
		. = B.destroy_time - A.destroy_time
	if (!.)
		. = B.failures - A.failures
	if (!.)
		. = B.extra_qdels - A.extra_qdels
	if (!.)
		. = B.qdels - A.qdels


/// Queue datum D for garbage collection / deletion. Calls the datum's Destroy() and sets its gc_destroyed value.
/proc/qdel(datum/datum)
	var/static/list/details_by_path = SSgarbage.details_by_path
	var/static/list/collection_queue = SSgarbage.collection_queue
	var/static/list/deletion_queue = SSgarbage.deletion_queue
	if (!datum)
		return
	if (!istype(datum))
		crash_with("qdel() can only handle /datum (sub)types, was passed: [log_info_line(datum)]")
		return
	var/datum/qdel_details/details = details_by_path[datum.type]
	if (!details)
		details = new
		details_by_path[datum.type] = details
	++details.qdels
	switch (datum.gc_destroyed)
		if (null)
			datum.gc_destroyed = GC_CURRENTLY_BEING_QDELETED
			var/start_time = world.time
			var/start_tick = world.tick_usage
			var/hint = datum.Destroy()
			if (world.time != start_time)
				++details.slept_destroy
			else
				details.destroy_time += (world.tick_usage - start_tick) * world.tick_lag
			switch (hint)
				if (QDEL_HINT_QUEUE)
					if (ismovable(datum))
						var/atom/movable/movable = datum
						if (movable.loc)
							crash_with("QDEL_HINT_QUEUE: [movable] loc not null after Destroy")
							movable.forceMove(null)
					datum.gc_destroyed = world.time
					collection_queue["\ref[datum]"] = world.time
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
					datum.gc_destroyed = world.time
					deletion_queue[datum] = world.time
				if (QDEL_HINT_HARDDEL_NOW)
					SSgarbage.HardDelete(datum)
				else
					++details.no_hint
					datum.gc_destroyed = world.time
					collection_queue["\ref[datum]"] = world.time
		if (GC_CURRENTLY_BEING_QDELETED)
			crash_with("GC_CURRENTLY_BEING_QDELETED: [datum.type] Destroy() called more than once.")
		else
			++details.extra_qdels
