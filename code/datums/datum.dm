/datum
	/// Int. `world.time` when this datum was destroyed, or `GC_CURRENTLY_BEING_QDELETED` if currently being deleted. Controlled by `qdel()`.
	var/gc_destroyed

	/// Whether or not this datum is currently being processed, and by which subsystem. Controlled by the various `START_PROCESSING*()` and `STOP_PROCESSING*()` defines.
	var/is_processing = FALSE

	/// If this datum is pooled, the pool it belongs to.
	var/singleton/instance_pool/instance_pool

	/// If this datum is pooled, the last configurator applied (if any).
	var/singleton/instance_configurator/instance_configurator


/**
 * Default implementation of clean-up code.
 * This should be overridden to remove all references pointing to the object being destroyed.
 * Return the appropriate `QDEL_HINT`; in most cases this is `QDEL_HINT_QUEUE`.
 */
/datum/proc/Destroy()
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	tag = null
	SSnano && SSnano.close_uis(src)
	if (extensions)
		for (var/expansion_key in extensions)
			var/list/extension = extensions[expansion_key]
			if (islist(extension))
				extension.Cut()
			else
				qdel(extension)
		extensions = null
	GLOB.destroyed_event && GLOB.destroyed_event.raise_event(src)
	cleanup_events(src)
	var/list/machines = global.state_machines["\ref[src]"]
	if (length(machines))
		for (var/base_type in machines)
			qdel(machines[base_type])
		global.state_machines -= "\ref[src]"
	if (instance_pool?.ReturnInstance(src))
		return QDEL_HINT_IWILLGC
	instance_configurator = null
	instance_pool = null
	weakref = null
	return QDEL_HINT_QUEUE


/**
 * The processing handler for this datum. Called regularly by the relevant subsystem defined by `is_processing`.
 *
 * Return `PROCESS_KILL` to tell the subsystem to stop processing this datum.
 */
/datum/proc/Process()
	set waitfor = 0
	return PROCESS_KILL
