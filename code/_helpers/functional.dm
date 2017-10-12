/proc/all_predicates_true(var/list/input, var/list/predicates)
	predicates = istype(predicates) ? predicates : list(predicates)

	for(var/i = 1 to predicates.len)
		if(istype(input))
			if(!call(predicates[i])(arglist(input)))
				return FALSE
		else
			if(!call(predicates[i])(input))
				return FALSE
	return TRUE

/proc/any_predicate_true(var/list/input, var/list/predicates)
	predicates = istype(predicates) ? predicates : list(predicates)
	if(!predicates.len)
		return TRUE

	for(var/i = 1 to predicates.len)
		if(istype(input))
			if(call(predicates[i])(arglist(input)))
				return TRUE
		else
			if(call(predicates[i])(input))
				return TRUE
	return FALSE

/proc/is_atom_predicate(var/value, var/feedback_receiver)
	. = isatom(value)
	if(!. && feedback_receiver)
		to_chat(feedback_receiver, "<span class='warning'>Value must be an atom.</span>")

/proc/is_num_predicate(var/value, var/feedback_receiver)
	. = isnum(value)
	if(!. && feedback_receiver)
		to_chat(feedback_receiver, "<span class='warning'>Value must be a numeral.</span>")

/proc/is_dir_predicate(var/value, var/feedback_receiver)
	. = (value in GLOB.alldirs)
	if(!. && feedback_receiver)
		to_chat(feedback_receiver, "<span class='warning'>Value must be a direction.</span>")

/proc/can_locate(var/atom/container, var/container_thing)
	return (locate(container_thing) in container)

/proc/can_not_locate(var/atom/container, var/container_thing)
	return !(locate(container_thing) in container) // We could just do !can_locate(container, container_thing) but BYOND is pretty awful when it comes to deep proc calls


/proc/filter(var/list/list_to_filter, var/list/predicates, var/list/extra_predicate_input)
	. = list()
	for(var/entry in list_to_filter)
		var/predicate_input
		if(extra_predicate_input)
			predicate_input = (list(entry) + extra_predicate_input)
		else
			predicate_input = entry

		if(all_predicates_true(predicate_input, predicates))
			. += entry

/proc/map(var/list/list_to_map, var/map_proc)
	. = list()
	for(var/entry in list_to_map)
		. += call(map_proc)(entry)
