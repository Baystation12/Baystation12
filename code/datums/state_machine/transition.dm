/// Used to connect `/singleton/state`s together so the FSM knows what state to switch to, and on what conditions.
/// On a directed graph, these would be the arrows connecting the nodes representing states.
/singleton/state_transition
	var/list/from = null
	var/singleton/state/target = null

/// Called by one or more state singletons acting as nodes in a directed graph.
/singleton/state_transition/Initialize()
	. = ..()
	if(ispath(target))
		target = GET_SINGLETON(target)

/// Tells the FSM if it should or should not be allowed to transfer to the target state.
/singleton/state_transition/proc/is_open(datum/holder)
	return FALSE
