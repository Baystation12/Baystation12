/proc/all_predicates_true(var/input, var/list/predicates)
	for(var/i = 1 to predicates.len)
		if(!call(predicates[i])(input))
			return FALSE
	return TRUE

/proc/any_predicate_true(var/input, var/list/predicates)
	if(!predicates.len)
		return TRUE

	for(var/i = 1 to predicates.len)
		if(call(predicates[i])(input))
			return TRUE
	return FALSE
