// This SS manages circuit components; there is another SS that handles power use and init.

SUBSYSTEM_DEF(circuit_components)
	name = "Circuit Components"
	priority = SS_PRIORITY_CIRCUIT_COMP
	flags = SS_NO_INIT
	wait = 1

	var/list/queued_components = list()              // Queue of components for activation
	var/position = 1                                 // Helper index to order newly activated components properly

/datum/controller/subsystem/circuit_components/stat_entry(text, force)
	IF_UPDATE_STAT
		force = TRUE
		text = "[text] | Component Queue: [queued_components.len]"
	..(text, force)

/datum/controller/subsystem/circuit_components/fire(resumed = FALSE)
	if(paused_ticks >= 10) // The likeliest fail mode, due to the fast tick rate, is that it can never clear the full queue, running resumed every tick and accumulating a backlog.
		disable()          // As this SS deals with optional and potentially abusable content, it will autodisable if overtaxing the server.
		return

	var/list/queued_components = src.queued_components
	while(length(queued_components))
		var/list/entry = queued_components[queued_components.len]
		position = queued_components.len
		queued_components.len--
		if(!length(entry))
			if(MC_TICK_CHECK)
				break
			continue

		var/obj/item/integrated_circuit/circuit = entry[1]
		entry.Cut(1,2)
		if(QDELETED(circuit))
			if(MC_TICK_CHECK)
				break
			continue

		circuit.check_then_do_work(arglist(entry))
		if(MC_TICK_CHECK)
			break
	position = null

/datum/controller/subsystem/circuit_components/disable()
	..()
	queued_components.Cut()
	log_and_message_admins("Circuit component processing has been disabled.")

/datum/controller/subsystem/circuit_components/enable()
	..()
	log_and_message_admins("Circuit component processing has been enabled.")

// Store the entries like this so that components can be queued multiple times at once.
// With immediate set, will generally imitate the order of the call stack if execution happened directly.
// With immediate off, you go to the bottom of the pile.
/datum/controller/subsystem/circuit_components/proc/queue_component(obj/item/integrated_circuit/circuit, immediate = TRUE)
	if(!can_fire)
		return
	var/list/entry = list(circuit) + args.Copy(3)
	if(!immediate || !position)
		queued_components.Insert(1, list(entry))
		if(position)
			position++
	else
		queued_components.Insert(position, list(entry))

/datum/controller/subsystem/circuit_components/proc/dequeue_component(obj/item/integrated_circuit/circuit)
	var/i = 1
	while(i <= length(queued_components)) // Either i increases or length decreases on every iteration.
		var/list/entry = queued_components[i]
		if(length(entry) && entry[1] == circuit)
			queued_components.Cut(i, i+1)
			if(position > i)
				position--
		else
			i++
