/datum
	var/gc_destroyed //Time when this object was destroyed.
	var/is_processing = FALSE
	var/list/active_timers  //for SStimer

#ifdef TESTING
	var/running_find_references
	var/last_find_references = 0
#endif


// Default implementation of clean-up code.
// This should be overridden to remove all references pointing to the object being destroyed.
// Return the appropriate QDEL_HINT; in most cases this is QDEL_HINT_QUEUE.
/datum/proc/Destroy(force=FALSE)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	tag = null
	weakref = null // Clear this reference to ensure it's kept for as brief duration as possible.

	SSnano && SSnano.close_uis(src)

	var/list/timers = active_timers
	active_timers = null
	for(var/datum/timedevent/timer as anything in timers)
		if (timer.spent)
			continue
		qdel(timer)

	if(extensions)
		for(var/expansion_key in extensions)
			var/list/extension = extensions[expansion_key]
			if(islist(extension))
				extension.Cut()
			else
				qdel(extension)
		extensions = null

	GLOB.destroyed_event && GLOB.destroyed_event.raise_event(src)

	if (!isturf(src))	// Not great, but the 'correct' way to do it would add overhead for little benefit.
		cleanup_events(src)

	var/list/machines = global.state_machines["\ref[src]"]
	if(length(machines))
		for(var/base_type in machines)
			qdel(machines[base_type])
		global.state_machines -= "\ref[src]"

	return QDEL_HINT_QUEUE

/datum/proc/Process()
	set waitfor = 0
	return PROCESS_KILL
