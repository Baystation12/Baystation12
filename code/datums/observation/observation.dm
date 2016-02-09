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
	var/list/event_sources     // Associate list of event sources, each with their own associate list. This associate list contains an instance/proc pair to call when the event is raised.
	var/list/global_listeners  // Associative list of instances that listen to all events of this type (as opposed to events belonging to a specific source) and the proc to call.

/decl/observ/New()
	all_observable_events.events += src
	event_sources = list()
	..()

/decl/observ/proc/is_listening(var/event_source, var/datum/proc_owner, var/proc_call)
	var/listeners = event_sources[event_source]
	if(!listeners)
		return FALSE

	var/stored_proc_call = listeners[proc_owner]
	return stored_proc_call && (!proc_call || stored_proc_call == proc_call)

/decl/observ/proc/has_listeners(var/event_source)
	var/list/listeners = event_sources[event_source]
	return listeners && listeners.len

/decl/observ/proc/register(var/datum/event_source, var/datum/proc_owner, var/proc_call)
	if(!(event_source && proc_owner && proc_call))
		return FALSE
	if(istype(event_source, /decl/observ))
		return FALSE

	if(!istype(event_source, expected_type))
		CRASH("Unexpected type. Expected [expected_type], was [event_source.type]")

	var/listeners = event_sources[event_source]
	if(!listeners)
		listeners = list()
		event_sources[event_source] = listeners
	listeners[proc_owner] = proc_call

	return TRUE

/decl/observ/proc/unregister(var/event_source, var/datum/proc_owner)
	if(!(event_source && proc_owner))
		return FALSE

	var/listeners = event_sources[event_source]
	if(!listeners)
		return FALSE

	listeners -= proc_owner
	return TRUE

/decl/observ/proc/register_global(var/datum/proc_owner, var/proc_call)
	if(!(proc_owner && proc_call))
		return FALSE
	if(!global_listeners)
		global_listeners = list()

	global_listeners[proc_owner] = proc_call
	return TRUE

/decl/observ/proc/unregister_global(var/datum/proc_owner)
	if(!(proc_owner && global_listeners))
		return FALSE

	global_listeners -= proc_owner
	return TRUE

/decl/observ/proc/raise_event(var/list/args = list())
	if(!args.len)
		return
	var/listeners = event_sources[args[1]]
	if(listeners)
		for(var/listener in listeners)
			call(listener, listeners[listener])(arglist(args))	// Sadly arglist() cannot be stored in a var for re-use
	for(var/listener in global_listeners)
		call(listener, global_listeners[listener])(arglist(args))
