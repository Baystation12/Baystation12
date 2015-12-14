/datum/observ
	var/list/listeners

/datum/observ/Destroy()
	if(listeners)
		for(var/listener in listeners)
			unregister(listener)
		listeners.Cut()
	return ..()

/datum/observ/proc/register(var/datum/procOwner, var/proc_call)
	if(!listeners)
		listeners = list()
	listeners[procOwner] = proc_call
	procOwner.destruction.register(src, /datum/observ/proc/unregister)

/datum/observ/proc/unregister(var/datum/procOwner)
	if(!listeners)
		return
	listeners -= procOwner
	procOwner.destruction.unregister(src)

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
	init_observers()
	..()

/datum/Destroy()
	destruction.raise_event(list(src))
	destroy_observers()
	return ..()

/datum/proc/init_observers()
	destruction = new()

/datum/proc/destroy_observers()
	qdel(destruction)
	destruction = null

// This ensures that observer handlers don't create their own observer handlers, which create their own handlers, which create...
/datum/observ/init_observers()
	return

/datum/observ/destroy_observers()
	return
