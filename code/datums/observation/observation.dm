/datum/observ
	var/event_holder
	var/list/listeners

/datum/observ/New(var/event_holder)
	src.event_holder = event_holder
	..()

/datum/observ/Destroy()
	event_holder = null
	if(listeners)
		for(var/listener in listeners)
			unregister(listener)
		listeners.Cut()
	return ..()

/datum/observ/proc/is_listening(var/datum/procOwner, var/proc_call)
	return listeners && (procOwner in listeners) && (!proc_call || listeners[procOwner] == proc_call)

/datum/observ/proc/has_listeners()
	return listeners && listeners.len

/datum/observ/proc/register(var/datum/procOwner, var/proc_call)
	if(!(procOwner && procOwner.destruction))
		return FALSE
	if(!listeners)
		listeners = list()
	listeners[procOwner] = proc_call
	procOwner.destruction.register(src, /datum/observ/proc/unregister)
	return TRUE

/datum/observ/proc/unregister(var/datum/procOwner)
	if(!(listeners && procOwner && procOwner.destruction))
		return FALSE
	listeners -= procOwner
	procOwner.destruction.unregister(src)
	return TRUE

/datum/observ/proc/raise_event(var/list/args = list())
	if(!listeners)
		return
	for(var/listener in listeners)
		call(listener, listeners[listener])	(arglist(args))

/***********************
* Destruction Handling *
***********************/
/datum
	var/datum/observ/destruction

/datum/New()
	init_observers(src)
	..()

/datum/Destroy()
	destroy_observers()
	return ..()

/datum/proc/init_observers(var/event_holder)
	destruction = new(event_holder)
	return TRUE

/datum/proc/destroy_observers()
	if(!destruction)
		return FALSE

	destruction.raise_event(list(src))
	qdel(destruction)
	destruction = null
	return TRUE

// This ensures that observer handlers don't create their own observer handlers, which create their own handlers, which create...
/datum/observ/init_observers()
	return FALSE

// And this ensures that observer handlers don't attempt to notify others about their own death while being unable to.
/datum/observ/destroy_observers()
	return FALSE
