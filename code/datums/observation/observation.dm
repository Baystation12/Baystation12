/datum/observ
	var/name = "Unnamed Event"
	var/expected_type = /datum
	var/list/listeners_assoc

/datum/observ/New()
	all_observable_events.events += src
	listeners_assoc = list()
	..()

/datum/observ/proc/is_listening(var/eventSource, var/datum/procOwner, var/proc_call)
	var/listeners = listeners_assoc[eventSource]
	if(!listeners)
		return FALSE

	var/stored_proc_call = listeners[procOwner]
	return stored_proc_call && (!proc_call || stored_proc_call == proc_call)

/datum/observ/proc/has_listeners(var/eventSource)
	var/list/listeners = listeners_assoc[eventSource]
	return listeners && listeners.len

/datum/observ/proc/register(var/eventSource, var/datum/procOwner, var/proc_call)
	if(!(eventSource && procOwner && procOwner))
		return FALSE
	if(istype(eventSource, /datum/observ))
		return FALSE

	if(!istype(eventSource, expected_type))
		CRASH("Unexpected type. Expected [expected_type], was [eventSource]")

	var/listeners = listeners_assoc[eventSource]
	if(!listeners)
		listeners = list()
		listeners_assoc[eventSource] = listeners
	listeners[procOwner] = proc_call
	destroyed_event.register(procOwner, src, /datum/observ/proc/unregister)
	return TRUE

/datum/observ/proc/unregister(var/eventSource, var/datum/procOwner)
	if(!(eventSource && procOwner))
		return FALSE
	if(istype(eventSource, /datum/observ))
		return FALSE

	var/listeners = listeners_assoc[eventSource]
	if(!listeners)
		return FALSE

	listeners -= procOwner
	destroyed_event.unregister(procOwner, src)
	return TRUE

/datum/observ/proc/raise_event(var/list/args = list())
	if(!args.len)
		return
	var/listeners = listeners_assoc[args[1]]
	if(!listeners)
		return
	for(var/listener in listeners)
		call(listener, listeners[listener])	(arglist(args))
