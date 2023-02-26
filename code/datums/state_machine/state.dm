// An individual state, defined as a `/singleton` to save memory.
// On a directed graph, these would be the nodes themselves, connected to each other by unidirectional arrows.
/singleton/state
	// Transition singleton types, which get turned into refs to those types.
	// Note that the order DOES matter, as singletons earlier in the list have higher priority
	// if more than one becomes 'open'.
	var/list/transitions = null

/singleton/state/Initialize()
	. = ..()
	for(var/i in 1 to LAZYLEN(transitions))
		var/singleton/state_transition/T = GET_SINGLETON(transitions[i])
		LAZYADD(T.from, src)
		transitions[i] = T

// Returns a list of transitions that a FSM could switch to.
// Note that `holder` is NOT the FSM, but instead the thing the FSM is attached to.
/singleton/state/proc/get_open_transitions(datum/holder)
	for(var/singleton/state_transition/T as anything in transitions)
		if(T.is_open(holder))
			LAZYADD(., T)

// Stub for child states to modify the holder when switched to.
// Again, `holder` is not the FSM.
/singleton/state/proc/entered_state(datum/holder)
	return

// Another stub for when leaving a state.
/singleton/state/proc/exited_state(datum/holder)
	return
