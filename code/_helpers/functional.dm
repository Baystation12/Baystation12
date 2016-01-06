/proc/all_predicates_true(var/list/input, var/list/predicates)
	functional_sanity(input, predicates)

	for(var/i = 1 to predicates.len)
		if(!call(predicates[i])(arglist(input)))
			return FALSE
	return TRUE

/proc/any_predicate_true(var/list/input, var/list/predicates)
	functional_sanity(input, predicates)

	if(!predicates.len)
		return TRUE

	for(var/i = 1 to predicates.len)
		if(call(predicates[i])(arglist(input)))
			return TRUE
	return FALSE

/proc/functional_sanity(var/list/input, var/list/predicates)
	if(!istype(input))
		CRASH("Expected list input. Was [input ? "[input.type]" : "null"]")
	if(!istype(predicates))
		CRASH("Expected predicate list. Was [predicates ? "[predicates.type]" : "null"]")
