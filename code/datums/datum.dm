/datum
	var/gc_destroyed //Time when this object was destroyed.
	var/is_processing = FALSE

#ifdef TESTING
    var/running_find_references
    var/last_find_references = 0
#endif

// Default implementation of clean-up code.
// This should be overridden to remove all references pointing to the object being destroyed.
// Return the appropriate QDEL_HINT; in most cases this is QDEL_HINT_QUEUE.
/datum/proc/Destroy(force=FALSE)
	tag = null
	GLOB.nanomanager && GLOB.nanomanager.close_uis(src)
	return QDEL_HINT_QUEUE

/datum/proc/Process()
	set waitfor = 0
	return PROCESS_KILL
