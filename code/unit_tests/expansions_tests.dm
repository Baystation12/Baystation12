/datum/unit_test/expansions
	name = "EXPANSIONS template"
	async = 0

/datum/unit_test/expansions/shall_initalize_as_expected
	name = "EXPANSIONS - Shall Initialize as Expected"

/datum/unit_test/expansions/shall_initalize_as_expected/start_test()
	var/turf/start = locate(20,20,1)
	var/obj/test/expansions/expansion_obj = new(start, TRUE)

	var/number_of_failures = 0
	for(var/extension in expansion_obj)
		if(ispath(extension))
			log_unit_test("[extension] was uninitalized.")
			number_of_failures++

	var/datum/expansion/exp = get_expansion(expansion_obj, /datum/expansion)
	if(exp.type != /datum/expansion)
		log_unit_test("[exp]/([exp.type]) was not strictly of the type /datum/expansion.")
		number_of_failures++

	var/datum/expansion/multitool/multi = get_expansion(expansion_obj, /datum/expansion/multitool)
	if(multi.type != /datum/expansion/multitool/cryo)
		log_unit_test("[exp]/([exp.type]) was not strictly of the type /datum/expansion/multitool/cryo.")
		number_of_failures++
	else
		if(multi.interact_predicates.len != 2)
			log_unit_test("Unexpected interaction predicate length. Was [multi.interact_predicates.len], expected 2.")
			number_of_failures++
		else if(multi.interact_predicates[1] != /proc/is_operable)
			log_unit_test("Unexpected interaction predicate at index 1. Was [multi.interact_predicates[1]], expected /proc/is_operable.")
			number_of_failures++
		else if(multi.interact_predicates[2] != /proc/is_operable)
			log_unit_test("Unexpected interaction predicate at index 2. Was [multi.interact_predicates[2]], expected /proc/is_operable.")
			number_of_failures++

	if(number_of_failures)
		fail("[number_of_failures] failed assertion\s.")
	else
		pass("All assertions passed.")

	qdel(expansion_obj)
	return TRUE

/obj/test/expansions/New()
	set_expansion(src, /datum/expansion, /datum/expansion)
	set_expansion(src, /datum/expansion/multitool, /datum/expansion/multitool/cryo, list(/proc/is_operable, /proc/is_operable))
	..()
