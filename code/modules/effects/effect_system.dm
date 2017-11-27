// -- Effect System --
// The base type for the new processor-driven effect system.
/datum/effect_system
	var/atom/movable/holder	 	// The object this effect is attached to. If this is set, the effect will not be qdel()'d at end of processing.
	var/turf/location 			// Where the effect is

/datum/effect_system/New(var/queue = TRUE)
	. = ..()
	if (queue)
		src.queue()

/datum/effect_system/Destroy()
	if (holder)
		holder = null
	STOP_EFFECT(src)
	return ..()

// Queues an effect.
/datum/effect_system/proc/queue()
	if (holder)
		set_loc(holder)
	QUEUE_EFFECT(src)

/datum/effect_system/process(elapsed)
	if (holder)
		location = get_turf(holder)
		return EFFECT_HALT
	return EFFECT_DESTROY	// Terminate effect if it's not attached to something.

/datum/effect_system/proc/bind(var/target)
	holder = target

/datum/effect_system/proc/set_loc(var/atom/movable/loc)
	if (isturf(loc))
		location = loc
	else
		location = get_turf(loc)
