GLOBAL_LIST_EMPTY(global_listen_count)
GLOBAL_LIST_EMPTY(event_sources_count)
GLOBAL_LIST_EMPTY(event_listen_count)

/proc/cleanup_events(var/source)
	if(GLOB.global_listen_count[source])
		cleanup_global_listener(source, GLOB.global_listen_count[source])
	if(GLOB.event_sources_count[source])
		cleanup_source_listeners(source, GLOB.event_sources_count[source])
	if(GLOB.event_listen_count[source])
		cleanup_event_listener(source, GLOB.event_listen_count[source])

/decl/observ/register(var/datum/event_source, var/datum/listener, var/proc_call)
	. = ..()
	if(.)
		GLOB.event_sources_count[event_source] += 1
		GLOB.event_listen_count[listener] += 1

/decl/observ/unregister(var/datum/event_source, var/datum/listener, var/proc_call)
	. = ..()
	if(.)
		GLOB.event_sources_count[event_source] -= 1
		GLOB.event_listen_count[listener] -= 1

		if(GLOB.event_sources_count[event_source] <= 0)
			GLOB.event_sources_count -= event_source
		if(GLOB.event_listen_count[listener] <= 0)
			GLOB.event_listen_count -= listener

/decl/observ/register_global(var/datum/listener, var/proc_call)
	. = ..()
	if(.)
		GLOB.global_listen_count[listener] += 1

/decl/observ/unregister_global(var/datum/listener, var/proc_call)
	. = ..()
	if(.)
		GLOB.global_listen_count[listener] -= 1
		if(GLOB.global_listen_count[listener] <= 0)
			GLOB.global_listen_count -= listener

/proc/cleanup_global_listener(listener, listen_count)
	GLOB.global_listen_count -= listener
	for(var/entry in GLOB.all_observable_events)
		var/decl/observ/event = entry
		if(event.unregister_global(listener))
			log_debug("[event] - [listener] was deleted while still registered to global events.")
			if(!(--listen_count))
				return

/proc/cleanup_source_listeners(event_source, source_listener_count)
	GLOB.event_sources_count -= event_source
	for(var/entry in GLOB.all_observable_events)
		var/decl/observ/event = entry
		var/proc_owners = event.event_sources[event_source]
		if(proc_owners)
			for(var/proc_owner in proc_owners)
				if(event.unregister(event_source, proc_owner))
					log_debug("[event] - [event_source] was deleted while still being listened to by [proc_owner].")
					if(!(--source_listener_count))
						return

/proc/cleanup_event_listener(listener, listener_count)
	GLOB.event_listen_count -= listener
	for(var/entry in GLOB.all_observable_events)
		var/decl/observ/event = entry
		for(var/event_source in event.event_sources)
			if(event.unregister(event_source, listener))
				log_debug("[event] - [listener] was deleted while still listening to [event_source].")
				if(!(--listener_count))
					return
