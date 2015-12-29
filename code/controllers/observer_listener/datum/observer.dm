#define OBSERVER_EVENT_DESTROY "OnDestroy"

/datum
	var/list/observer_events

/datum/Destroy()
	raise_event(OBSERVER_EVENT_DESTROY, list(src))
	for(var/list/listeners in observer_events)
		listeners.Cut()

	return ..()

/datum/proc/register(var/event, var/procOwner, var/proc_call)
	var/list/listeners = get_listener_list_from_event(event, TRUE)
	listeners[procOwner] = proc_call

/datum/proc/unregister(var/event, var/procOwner)
	var/list/listeners = get_listener_list_from_event(event, FALSE)
	listeners -= procOwner

/datum/proc/raise_event(var/event, var/list/args = list())
	var/list/listeners = get_listener_list_from_event(event, FALSE)
	if(listeners)
		for(var/listener in listeners)
			call(listener, listeners[listener])(arglist(args))

/datum/proc/get_listener_list_from_event(var/observer_event, var/create_list)
	if(!observer_events)
		if(create_list)
			observer_events = list()
		else
			return

	var/list/listeners = observer_events[observer_event]
	if(!listeners)
		if(create_list)
			listeners = list()
			observer_events[observer_event] = listeners
		else
			return
	return listeners
