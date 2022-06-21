#define PREPARE_INPUT \
	predicates = istype(predicates) ? predicates : list(predicates);\
	input = istype(input) ? input : list(input);

#define PREPARE_ARGUMENTS \
	var/extra_arguments = predicates[predicate];\
	var/list/predicate_input = input;\
	if(LAZYLEN(extra_arguments)) {\
		predicate_input = predicate_input.Copy();\
		predicate_input += list(extra_arguments);\
	}

/proc/all_predicates_true(var/list/input, var/list/predicates)
	PREPARE_INPUT
	for(var/predicate in predicates)
		PREPARE_ARGUMENTS
		if(!call(predicate)(arglist(predicate_input)))
			return FALSE
	return TRUE

/proc/any_predicate_true(var/list/input, var/list/predicates)
	PREPARE_INPUT
	if(!predicates.len)
		return TRUE

	for(var/predicate in predicates)
		PREPARE_ARGUMENTS
		if(call(predicate)(arglist(predicate_input)))
			return TRUE
	return FALSE

#undef PREPARE_ARGUMENTS
#undef PREPARE_INPUT

/proc/is_atom_predicate(var/value, var/feedback_receiver)
	. = isatom(value)
	if(!. && feedback_receiver)
		to_chat(feedback_receiver, "<span class='warning'>Value must be an atom.</span>")

/proc/is_num_predicate(var/value, var/feedback_receiver)
	. = isnum(value)
	if(!. && feedback_receiver)
		to_chat(feedback_receiver, "<span class='warning'>Value must be a numeral.</span>")

/proc/is_text_predicate(var/value, var/feedback_receiver)
	. = !value || istext(value)
	if(!. && feedback_receiver)
		to_chat(feedback_receiver, "<span class='warning'>Value must be a text.</span>")

/proc/is_dir_predicate(var/value, var/feedback_receiver)
	. = (value in GLOB.alldirs)
	if(!. && feedback_receiver)
		to_chat(feedback_receiver, "<span class='warning'>Value must be a direction.</span>")

/proc/is_strict_bool_predicate(value, feedback_receiver)
	. = (value == TRUE || value == FALSE)
	if (!. && feedback_receiver)
		to_chat(feedback_receiver, SPAN_WARNING("Value must be a boolean (Strict)."))

/proc/can_locate(var/atom/container, var/container_thing)
	return (locate(container_thing) in container)

/proc/can_not_locate(var/atom/container, var/container_thing)
	return !(locate(container_thing) in container) // We could just do !can_locate(container, container_thing) but BYOND is pretty awful when it comes to deep proc calls


/proc/where(var/list/list_to_filter, var/list/predicates, var/list/extra_predicate_input)
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
