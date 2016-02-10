//
//	Observer Pattern Implementation
//
//	Implements a basic observer pattern with the following main procs:
//
//	/decl/observ/proc/is_listening(var/event_source, var/datum/proc_owner, var/proc_call)
//		event_source: The instance which is generating events.
//		proc_owner: The instance which may be listening to events by event_source
//		proc_call: Optional. The specific proc to call when the event is raised.
//
//		Returns true if proc_owner is listening for events by event_source, and proc_call supplied is either null or the same proc that will be called when an event is raised.
//
//	/decl/observ/proc/has_listeners(var/event_source)
//		event_source: The instance which is generating events.
//
//		Returns true if the given event_source has any listeners at all.
//
//	/decl/observ/proc/register(var/event_source, var/datum/proc_owner, var/proc_call)
//		event_source: The instance you wish to receive events from.
//		proc_owner: The instance/owner of the proc to call when an event is raised by the event_source.
//		proc_call: The proc to call when an event is raised.
//
//		Calling register() multiple times using the same event_source and proc_owner will replace the current proc to be called with the supplied proc_call.
//		As such, some care will have to be taken should you even conduct registrations for other instances/proc_owners than src in case other registrations have already been made.
//		A call to register() does not override the proc_call provided in a register_global() call, these are fully separate.
//
//		When proc_call is called the first argument is always the source of the event (event_source).
//		Additional arguments may or may not be supplied, see individual event definition files (destroyed.dm, moved.dm, etc.) for details.
//
//		The instance making the register() call is also responsible for calling unregister(), including when event_source is destroyed.
//			This can be handled by listening to the event_source's destroyed event, unregistering in the proc_owner's Destroy() proc, etc.
//
//	/decl/observ/proc/unregister(var/event_source, var/datum/proc_owner)
//		event_source: The instance you wish to stop receiving events from.
//		proc_owner: The instance/owner of the proc which will no longer receive the events.
//
//		Calling unregister() multiple times with the same event_source and proc_owner is safe/will have no side-effect once a prior register() call has been undone.
//
//	/decl/observ/proc/register_global(var/datum/proc_owner, var/proc_call)
//		proc_owner: The instance/owner of the proc to call when an event is raised by any and all sources.
//		proc_call: The proc to call when an event is raised.
//
//		Calling register_global() multiple times using the same proc_owner will replace the current proc to be called with the supplied proc_call.
//		As such, some care will have to be taken should you even conduct registrations for other instances/proc_owners than src in case other registrations have already been made.
//		A call to register_global() does not override the proc_call provided in a register() call, these are fully separate.
//
//		The instance making the register() call is also responsible for calling unregister(), except for when event_sources are destroyed (as it isn't bound to any specific instance).
//			This can for example be handled in the proc_owner's Destroy() proc.
//
//		For additional details see: /decl/observ/proc/register() above as details concerning which arguments proc_call will receive.
//
//	/decl/observ/proc/unregister_global(var/datum/proc_owner)
//		proc_owner: The instance/owner of the proc which will no longer receive the events.
//
//		Calling unregister_global() multiple times with the same event_source and proc_owner is safe/will have no side-effect once a prior register_global() call has been undone.
//
//	/decl/observ/proc/raise_event(var/list/args = list())
//		Should never be called unless implementing a new event type.
//		The argument shall always be a list, and the first element shall always be the event_source instance belonging to the event.
//		Beyond that there are no restrictions.

/decl/observ
	var/name = "Unnamed Event" // The name of this event, used mainly for debug/VV purposes. The list of event managers can be reached through the "Debug Controller" verb, selecting the "Observation" entry.
	var/expected_type = /datum // The expected event source for this event. register() will CRASH() if it receives an unexpected type.
	var/list/event_sources     // Associative list of event sources, each with their own associative list. This associative list contains an instance/proc pair to call when the event is raised.
	var/list/global_listeners  // Associative list of instances that listen to all events of this type (as opposed to events belonging to a specific source) and the proc to call.

/decl/observ/New()
	all_observable_events.events += src
	return ..()

/decl/observ/Del()
	all_observable_events.events -= src
	return ..()

/decl/observ/proc/is_listening(var/event_source, var/datum/listener, var/proc_call)
	// Return whether there are global listeners unless the event source is given.
	if (!event_source)
		return !!global_listeners

	// Return whether anything is listening to a source, if no listener is given.
	if (!listener)
		return global_listeners || (event_sources && event_source in event_sources)

	// Return false if there are no sources or nothing is associated with that source.
	if (!(event_sources && event_source in event_sources))
		return FALSE

	// Get and check the listeners for the reuqested event.
	var/listeners = event_sources[event_source]
	if (!(listener in listeners))
		return FALSE

	// Return true unless a specific callback needs checked.
	if (!proc_call)
		return TRUE

	// Check if the specific callback exists.
	var/list/callback = listeners[listener]
	if (istype(callback))
		return proc_call in callback
	return proc_call == callback

/decl/observ/proc/has_listeners(var/event_source)
	return is_listening(event_source)

/decl/observ/proc/register(var/datum/event_source, var/datum/listener, var/proc_call)
	// Sanity checking.
	if (!(event_source && listener && proc_call))
		return FALSE
	if (istype(event_source, /decl/observ))
		return FALSE

	// Crash if the event source is the wrong type.
	if (!istype(event_source, expected_type))
		CRASH("Unexpected type. Expected [expected_type], was [event_source.type]")

	// Perform some setup.
	if (!event_sources)
		event_sources = list()

	var/list/listeners = event_sources[event_source]
	if (!listeners)
		listeners = list()
		event_sources[event_source] = listeners

	// If no callbacks are set or the callback is set to the value we want, return true..
	var/list/callbacks = listeners[listener]
	if (!callbacks || callbacks == proc_call)
		listeners[listener] = proc_call
		return TRUE

	// Otherwise, make sure the callbacks are a list.
	if (!istype(callbacks))
		callbacks = list(callbacks)
		listeners[listener] = callbacks

	// Add the callback, and return true.
	callbacks |= proc_call
	return TRUE

/decl/observ/proc/unregister(var/event_source, var/datum/listener, var/proc_call)
	// Sanity.
	if (!(event_sources && event_source && listener && event_source in event_sources))
		return FALSE

	// Return false if nothing is listening for this event.
	var/list/listeners = event_sources[event_source]
	if (!listeners)
		return FALSE

	// Remove all callbacks if no specific one is given.
	if (!proc_call)
		listeners -= listener

		// Perform some cleanup and return true.
		if (!listeners.len)
			event_sources -= event_source
		if (!event_sources.len)
			event_sources = null
		return TRUE

	// See if we can find the callback.
	var/list/callbacks = listeners[listener]
	if (istype(callbacks) && callbacks.len)
		var/index = callbacks.Find(proc_call)
		if (!index)
			return FALSE

		callbacks.Cut(index, index + 1)
	else if (callbacks)
		if(callbacks != proc_call)
			return FALSE

		callbacks = null
	else
		return FALSE

	// If we made it to here, we found the callback and need to tidy up.
	if (!(callbacks && callbacks.len))
		listeners -= listener
	if (!listeners.len)
		event_sources -= event_source
	if (!event_sources.len)
		event_sources = null

	// We found it, so return true.
	return TRUE

/decl/observ/proc/register_global(var/datum/listener, var/proc_call)
	// Sanity.
	if (!(listener && proc_call))
		return FALSE

	// Set up the global listeners if needed.
	if (!global_listeners)
		global_listeners = list()

	// If no callbacks are set or the callback is set to the value we want, return true..
	var/list/callbacks = global_listeners[listener]
	if (!callbacks || callbacks == proc_call)
		global_listeners[listener] = proc_call
		return TRUE

	// Otherwise, make sure the callbacks are a list.
	if (!istype(callbacks))
		callbacks = list(callbacks)
		global_listeners[listener] = callbacks

	// Add the callback and return true.
	callbacks |= proc_call
	return TRUE

/decl/observ/proc/unregister_global(var/datum/listener, var/proc_call)
	// Return false unless the listener is set as a global listener.
	if (!(global_listeners && listener && listener in global_listeners))
		return FALSE

	// Remove all callbacks if no specific one is given.
	if (!proc_call)
		global_listeners -= listener

		// Perform some cleanup and return true.
		if (!global_listeners.len)
			global_listeners = null
		return TRUE

	// See if we can find the callback.
	var/list/callbacks = global_listeners[listener]
	if (istype(callbacks) && callbacks.len)
		var/index = callbacks.Find(proc_call)
		if (!index)
			return FALSE

		callbacks.Cut(index, index + 1)
	else if (callbacks)
		if(callbacks != proc_call)
			return FALSE

		callbacks = null
	else
		return FALSE

	// If we made it to here, we found the callback and need to tidy up.
	if (!(callbacks && callbacks.len))
		global_listeners -= listener
	if (!global_listeners.len)
		global_listeners = null

	// We found it, so return true.
	return TRUE

/decl/observ/proc/raise_event()
	// Sanity
	if (!args.len)
		return

	// Call the global listeners, if they exist.
	if (global_listeners)
		for (var/datum/listener in global_listeners)
			var/list/callback = global_listeners[listener]

			// If it's not a list, the callback is used as the procedure name.
			if (!istype(callback))
				try
					world << call(listener, callback)(arglist(args))
				catch (var/exception/e)
					error(e.desc)
					unregister_global(listener, callback)
				continue

			// Otherwise, call each procedure on the object with the arguments.
			for (var/proc_call in callback)
				try
					call(listener, proc_call)(arglist(args))
				catch (var/exception/e)
					error(e.desc)
					unregister_global(listener, proc_call)

	// Call the listeners for this specific event source, if they exist.
	var/source = args[1]
	if (event_sources && source in event_sources)
		var/listeners = event_sources[source]
		for (var/datum/listener in listeners)
			var/list/callback = listeners[listener]

			// If it's not a list, the callback is used as the procedure name.
			if (!istype(callback))
				try
					call(listener, callback)(arglist(args))
				catch (var/exception/e)
					error(e.desc)
					unregister(source, listener, callback)
				continue

			// Otherwise, call each procedure on the object with the arguments.
			for (var/proc_call in callback)
				try
					call(listener, proc_call)(arglist(args))
				catch (var/exception/e)
					error(e.desc)
					unregister(source, listener, proc_call)
