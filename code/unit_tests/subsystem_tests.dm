/datum/unit_test/subsystem_atom_shall_have_no_bad_init_calls
	name = "SUBSYSTEM - ATOMS: Shall have no bad init calls"

/datum/unit_test/subsystem_atom_shall_have_no_bad_init_calls/start_test()
	if(SSatoms.BadInitializeCalls.len)
		log_bad(jointext(SSatoms.InitLog(), null))
		fail("[SSatoms] had bad initialization calls.")
	else
		pass("[SSatoms] had no bad initialization calls.")
	return 1

/datum/unit_test/subsystem_garbage_await_empty_queue
	name = "SUBSYSTEM - GARBAGE: Awaiting queue to be empty"
	async = TRUE
	var/next_check

/datum/unit_test/subsystem_garbage_await_empty_queue/start_test()
	SSgarbage.collection_timeout = 60 SECONDS
	return 1

/datum/unit_test/subsystem_garbage_await_empty_queue/check_result()
	if(world.time < next_check)
		return 0
	next_check = world.time + 10 SECONDS

	var/garbage_len = 0
	for(var/i = 1 to GC_QUEUE_COUNT)
		garbage_len += length(SSgarbage.queues[i])

	log_debug("[garbage_len] item\s remaining.")
	if(garbage_len)
		return 0

	var/failures = 0
	for(var/item_type in SSgarbage.items)
		var/datum/qdel_item/qdel_item = SSgarbage.items[item_type]
		if(qdel_item.failures)
			log_bad("[item_type] - Failed to soft GC [qdel_item.failures] time\s")
			failures++
		if(qdel_item.no_hint)
			log_bad("[item_type] - Did not return a GC hint [qdel_item.no_hint] time\s")
			failures++
		if(qdel_item.no_respect_force)
			log_bad("[item_type] - Did not respect the force flag [qdel_item.no_respect_force] time\s")
			failures++
		if(qdel_item.slept_destroy)
			log_bad("[item_type] - Slept during destroy [qdel_item.slept_destroy] time\s")
			failures++

	if(failures)
		fail("GC queue empty. [failures] GC issue\s encountered.")
	else
		pass("GC queue empty. No failed GCs have occured.")

	return 1
