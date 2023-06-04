/// If this datum is pooled, the pool it belongs to.
/datum/var/singleton/instance_pool/instance_pool


/// If this datum is pooled, the last configurator applied (if any).
/datum/var/singleton/instance_configurator/instance_configurator


/datum/Destroy()
	if (instance_pool?.ReturnInstance(src)) // We have a pool and it wants us back.
		return QDEL_HINT_IWILLGC // Retain gc_destroyed as world.time. It might be useful.
	instance_configurator = null
	instance_pool = null
	return ..() // Destroy normally.
