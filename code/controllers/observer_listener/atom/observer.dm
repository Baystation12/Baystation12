#define OBSERVER_ON_DESTROY "OnDestroy"

/atom
	var/list/observer_events

/atom/Destroy()
	raise_event(OBSERVER_ON_DESTROY, list(src))
	for(var/list/observer_event in observer_events)
		var/list/listeners = observer_events[observer_event]
		listeners.Cut()
	observer_events.Cut()

	return ..()

/atom/proc/raise_event(var/event_type, var/list/arguments)
	var/list/listeners = get_listener_list_from_event(event_type)
	for(var/listener in listeners)
		call(listener, listeners[listener])(arglist(arguments))

/atom/proc/register(var/event, var/procOwner, var/proc_call)
	var/list/listeners = get_listener_list_from_event(event)
	listeners[procOwner] = proc_call

/atom/proc/unregister(var/event, var/procOwner)
	var/list/listeners = get_listener_list_from_event(event)
	listeners -= procOwner

/atom/proc/get_listener_list_from_event(var/observer_event)
	if(!observer_events) observer_events = list()
	var/list/listeners = observer_events[observer_event]
	if(!listeners)
		listeners = list()
		observer_events[observer_event] = listeners
	return listeners
