/datum/unit_test/extensions
	name = "EXTENSIONS template"
	async = 0

/datum/unit_test/extensions/shall_initalize_as_expected
	name = "EXTENSIONS - Shall Initialize as Expected"

/datum/unit_test/extensions/shall_initalize_as_expected/start_test()
	var/turf/start = get_safe_turf()
	var/obj/test/extensions/expansion_obj = new(start, TRUE)

	var/number_of_failures = 0
	for(var/extension in expansion_obj)
		if(ispath(extension))
			log_unit_test("[extension] was uninitalized.")
			number_of_failures++

	var/datum/extension/exp = get_extension(expansion_obj, /datum/extension)
	if(exp.type != /datum/extension)
		log_unit_test("[exp]/([exp.type]) was not strictly of the type /datum/extension.")
		number_of_failures++

	var/datum/extension/interactive/multitool/multi = get_extension(expansion_obj, /datum/extension/interactive/multitool)
	if(multi.type != /datum/extension/interactive/multitool/cryo)
		log_unit_test("[exp]/([exp.type]) was not strictly of the type /datum/extension/interactive/multitool/cryo.")
		number_of_failures++
	else
		if(multi.host_predicates.len != 2)
			log_unit_test("Unexpected interaction predicate length. Was [multi.host_predicates.len], expected 2.")
			number_of_failures++
		else if(multi.host_predicates[1] != /proc/is_operable)
			log_unit_test("Unexpected interaction predicate at index 1. Was [multi.host_predicates[1]], expected /proc/is_operable.")
			number_of_failures++
		else if(multi.host_predicates[2] != /proc/is_operable)
			log_unit_test("Unexpected interaction predicate at index 2. Was [multi.host_predicates[2]], expected /proc/is_operable.")
			number_of_failures++

	if(number_of_failures)
		fail("[number_of_failures] failed assertion\s.")
	else
		pass("All assertions passed.")

	qdel(expansion_obj)
	return TRUE

/obj/test/extensions/New()
	set_extension(src, /datum/extension, /datum/extension)
	set_extension(src, /datum/extension/interactive/multitool, /datum/extension/interactive/multitool/cryo, list(/proc/is_operable, /proc/is_operable))
	..()
