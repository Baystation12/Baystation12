#define OBSERVER_EVENT_DESTROY "OnDestroy"

/datum
	var/list/observer_events

/datum/Destroy()
	var/list/destroy_listeners = get_listener_list_from_event(OBSERVER_EVENT_DESTROY)
	if(destroy_listeners)
		for(var/destroy_listener in destroy_listeners)
			call(destroy_listener, destroy_listeners[destroy_listener])(src)

	for(var/list/listeners in observer_events)
		listeners.Cut()

	return ..()

/datum/proc/register(var/event, var/procOwner, var/proc_call)
	var/list/listeners = get_listener_list_from_event(event)
	listeners[procOwner] = proc_call

/datum/proc/unregister(var/event, var/procOwner)
	var/list/listeners = get_listener_list_from_event(event)
	listeners -= procOwner

/datum/proc/get_listener_list_from_event(var/observer_event)
	if(!observer_events) observer_events = list()
	var/list/listeners = observer_events[observer_event]
	if(!listeners)
		listeners = list()
		observer_events[observer_event] = listeners
	return listeners
