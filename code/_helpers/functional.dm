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

/proc/all_predicates_true(list/input, list/predicates)
	PREPARE_INPUT
	for(var/predicate in predicates)
		PREPARE_ARGUMENTS
		if(!call(predicate)(arglist(predicate_input)))
			return FALSE
	return TRUE

/proc/any_predicate_true(list/input, list/predicates)
	PREPARE_INPUT
	if(!length(predicates))
		return TRUE

	for(var/predicate in predicates)
		PREPARE_ARGUMENTS
		if(call(predicate)(arglist(predicate_input)))
			return TRUE
	return FALSE

#undef PREPARE_ARGUMENTS
#undef PREPARE_INPUT

/proc/is_atom_predicate(value, feedback_receiver)
	. = isatom(value)
	if(!. && feedback_receiver)
		to_chat(feedback_receiver, SPAN_WARNING("Value must be an atom."))

/proc/is_num_predicate(value, feedback_receiver)
	. = isnum(value)
	if(!. && feedback_receiver)
		to_chat(feedback_receiver, SPAN_WARNING("Value must be a numeral."))

/proc/is_int_predicate(value, feedback_receiver)
	. = value == round(value)
	if (!. && feedback_receiver)
		to_chat(feedback_receiver, SPAN_WARNING("Value must be a whole number."))

/proc/is_non_zero_predicate(value, feedback_receiver)
	. = value != 0
	if (!. && feedback_receiver)
		to_chat(feedback_receiver, SPAN_WARNING("Value cannot be 0."))

/proc/is_non_negative_predicate(value, feedback_receiver)
	. = value >= 0
	if (!. && feedback_receiver)
		to_chat(feedback_receiver, SPAN_WARNING("Value must be a positive number."))

/proc/is_non_positive_predicate(value, feedback_receiver)
	. = value <= 0
	if (!. && feedback_receiver)
		to_chat(feedback_receiver, SPAN_WARNING("Value must be a negative number."))

/proc/is_text_predicate(value, feedback_receiver)
	. = !value || istext(value)
	if(!. && feedback_receiver)
		to_chat(feedback_receiver, SPAN_WARNING("Value must be a text."))

/proc/is_dir_predicate(value, feedback_receiver)
	. = (value in GLOB.alldirs)
	if(!. && feedback_receiver)
		to_chat(feedback_receiver, SPAN_WARNING("Value must be a direction."))

/proc/is_strict_bool_predicate(value, feedback_receiver)
	. = (value == TRUE || value == FALSE)
	if (!. && feedback_receiver)
		to_chat(feedback_receiver, SPAN_WARNING("Value must be a boolean (Strict)."))


/proc/is_not_abstract_predicate(datum/thing, feedback_receiver)
	. = !is_abstract(thing)
	if (!. && feedback_receiver)
		to_chat(feedback_receiver, SPAN_WARNING("Datum must not be abstract."))


/proc/can_locate(atom/container, container_thing)
	return (locate(container_thing) in container)

/proc/can_not_locate(atom/container, container_thing)
	return !(locate(container_thing) in container) // We could just do !can_locate(container, container_thing) but BYOND is pretty awful when it comes to deep proc calls


/proc/where(list/list_to_filter, list/predicates, list/extra_predicate_input)
	RETURN_TYPE(/list)
	. = list()
	for(var/entry in list_to_filter)
		var/predicate_input
		if(extra_predicate_input)
			predicate_input = (list(entry) + extra_predicate_input)
		else
			predicate_input = entry

		if(all_predicates_true(predicate_input, predicates))
			. += entry

/proc/map(list/list_to_map, map_proc)
	RETURN_TYPE(/list)
	. = list()
	for(var/entry in list_to_map)
		. += call(map_proc)(entry)
