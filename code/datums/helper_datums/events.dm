/datum/events
	var/list/events = list()


/datum/events/proc/addEventType(event_type as text)
	if (!(event_type in events) || !islist(events[event_type]))
		events[event_type] = list()
		return TRUE


// Arguments: event_type as text, proc_holder as datum, proc_name as text
// Returns: New event, null on error.
/datum/events/proc/addEvent(event_type as text, proc_holder, proc_name as text)
	if (!event_type || !proc_holder || !proc_name)
		return
	addEventType(event_type)
	var/list/event = events[event_type]
	var/datum/event/E = new /datum/event(proc_holder,proc_name)
	event += E
	return E


// Arguments: event_type as text, any number of additional arguments to pass to event handler
// Returns: null
/datum/events/proc/fireEvent()
	var/list/event = LAZYACCESS(events, args[1])
	if (istype(event))
		spawn(-1)
			for (var/datum/event/E in event)
				if (!E.Fire(arglist(args.Copy(2))))
					clearEvent(args[1],E)


// Arguments: event_type as text, E as /datum/event
// Returns: 1 if event cleared, null on error
/datum/events/proc/clearEvent(event_type, datum/event/E)
	if (E && event_type)
		var/list/event = LAZYACCESS(events, event_type)
		if (event)
			event -= E
			return TRUE


/datum/event
	var/listener
	var/proc_name


/datum/event/New(tlistener, tprocname)
	listener = tlistener
	proc_name = tprocname


/datum/event/proc/Fire()
	if (listener)
		call(listener,proc_name)(arglist(args))
		return TRUE
