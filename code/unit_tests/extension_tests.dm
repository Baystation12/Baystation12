/datum/unit_test/extensions
	name = "EXTENSIONS template"
	template = /datum/unit_test/extensions
	async = 0

/datum/unit_test/extensions/basic_extension_shall_lazy_initalize_as_expected
	name = "EXTENSIONS - Basic extension shall lazy initialize as expected"

/datum/unit_test/extensions/basic_extension_shall_lazy_initalize_as_expected/start_test()
	var/turf/start = get_safe_turf()
	var/obj/O = new(start)
	set_extension(O, /datum/extension/test_one)

	var/number_of_failures = 0
	for(var/extension in O.extensions)
		if(!islist(O.extensions[extension]))
			log_unit_test("[extension] was initalized.")
			number_of_failures++

	var/datum/extension/one = get_extension(O, /datum/extension/test_one)
	for(var/extension in O.extensions)
		if(islist(O.extensions[extension]))
			log_unit_test("[extension] was not initalized.")
			number_of_failures++

	if(one.type != /datum/extension/test_one)
		log_unit_test("[log_info_line(one)] was not strictly of the type [/datum/extension/test_one]")
		number_of_failures++

	if(one.holder != O)
		log_unit_test("[log_info_line(one)] had an unexpected holder: [log_info_line(one.holder)]")
		number_of_failures++

	if(number_of_failures)
		fail("[number_of_failures] failed assertion\s.")
	else
		pass("All assertions passed.")

	qdel(O)
	return TRUE

/datum/unit_test/extensions/basic_immediate_extension_shall_initalize_as_expected
	name = "EXTENSIONS - Basic immediate extension shall initialize as expected"

/datum/unit_test/extensions/basic_immediate_extension_shall_initalize_as_expected/start_test()
	var/turf/start = get_safe_turf()
	var/obj/O = new(start)
	set_extension(O, /datum/extension/test_two)

	var/number_of_failures = 0
	for(var/extension in O.extensions)
		if(islist(O.extensions[extension]))
			log_unit_test("[extension] was not initalized.")
			number_of_failures++

	var/datum/extension/two = get_extension(O, /datum/extension/test_two)
	if(two.type != /datum/extension/test_two)
		log_unit_test("[log_info_line(two)] was not strictly of the type [/datum/extension/test_two]")
		number_of_failures++

	if(two.holder != O)
		log_unit_test("[log_info_line(two)] had an unexpected holder: [log_info_line(two.holder)]")
		number_of_failures++

	if(number_of_failures)
		fail("[number_of_failures] failed assertion\s.")
	else
		pass("All assertions passed.")

	qdel(O)
	return TRUE

/datum/unit_test/extensions/shall_acquire_extension_subtype_as_expected
	name = "EXTENSIONS - Shall acquire extension subtype as expected"

/datum/unit_test/extensions/shall_acquire_extension_subtype_as_expected/start_test()
	var/turf/start = get_safe_turf()
	var/obj/O = new(start)
	set_extension(O, /datum/extension/test_three/subtype)

	var/datum/extension/three = get_extension(O, /datum/extension/test_three)
	if(three.type == /datum/extension/test_three/subtype)
		pass("All assertions passed.")
	else
		fail("[log_info_line(three)] was not strictly of the type [/datum/extension/test_three/subtype]")

	qdel(O)
	return TRUE

/datum/unit_test/extensions/extension_shall_be_provided_arguments_as_expected
	name = "EXTENSIONS - Extension shall be provided arguments as expected"

/datum/unit_test/extensions/extension_shall_be_provided_arguments_as_expected/start_test()
	var/turf/start = get_safe_turf()
	var/obj/O = new(start)
	set_extension(O, /datum/extension/test_four, list("a", "b"), list("c", "d"))

	var/datum/extension/test_four/four = get_extension(O, /datum/extension/test_four)
	if(four.holder == O && islist(four.first_argument) && islist(four.second_argument) && four.first_argument[1] == "a" && four.first_argument[2] == "b" &&	four.second_argument[1] == "c" && four.second_argument[2] == "d")
		pass("All assertions passed.")
	else
		fail("[log_info_line(four)] had unexpected arguments:\n[log_info_line(four.holder)]\n[log_info_line(four.first_argument)]\n[log_info_line(four.second_argument)]")

	return TRUE

/datum/unit_test/extensions/immediate_extension_shall_be_provided_arguments_as_expected
	name = "EXTENSIONS - Immediate extension shall be provided arguments as expected"

/datum/unit_test/extensions/immediate_extension_shall_be_provided_arguments_as_expected/start_test()
	var/turf/start = get_safe_turf()
	var/obj/O = new(start)
	set_extension(O, /datum/extension/test_five, list("a", "b"), list("c", "d"))

	var/datum/extension/test_five/five = get_extension(O, /datum/extension/test_five)
	if(five.holder == O && islist(five.first_argument) && islist(five.second_argument) && five.first_argument[1] == "a" && five.first_argument[2] == "b" &&	five.second_argument[1] == "c" && five.second_argument[2] == "d")
		pass("All assertions passed.")
	else
		fail("[log_info_line(five)] had unexpected arguments:\n[log_info_line(five.holder)]\n[log_info_line(five.first_argument)]\n[log_info_line(five.second_argument)]")

	return TRUE

/datum/unit_test/extensions/get_or_create_extension_shall_initialize_as_expected
	name = "EXTENSIONS - get_or_create() shall initialize as expected"

/datum/unit_test/extensions/get_or_create_extension_shall_initialize_as_expected/start_test()
	var/turf/start = get_safe_turf()
	var/obj/O = new(start)
	var/datum/extension/test_one/one = get_or_create_extension(O, /datum/extension/test_one)

	var/number_of_failures = 0
	if(one.type != /datum/extension/test_one)
		log_unit_test("[log_info_line(one)] was not strictly of the type [/datum/extension/test_one]")
		number_of_failures++

	if(one.holder != O)
		log_unit_test("[log_info_line(one)] had an unexpected holder: [log_info_line(one.holder)]")
		number_of_failures++

	if(number_of_failures)
		fail("[number_of_failures] failed assertion\s.")
	else
		pass("All assertions passed.")

	return TRUE

/datum/unit_test/extensions/get_or_create_extension_with_arguments_shall_initialize_as_expected
	name = "EXTENSIONS - get_or_create() with arguments shall initialize as expected"

/datum/unit_test/extensions/get_or_create_extension_with_arguments_shall_initialize_as_expected/start_test()
	var/turf/start = get_safe_turf()
	var/obj/O = new(start)

	var/datum/extension/test_four/four = get_or_create_extension(O, /datum/extension/test_four, list("a", "b"), list("c", "d"))
	if(four.holder == O && islist(four.first_argument) && islist(four.second_argument) && four.first_argument[1] == "a" && four.first_argument[2] == "b" &&	four.second_argument[1] == "c" && four.second_argument[2] == "d")
		pass("All assertions passed.")
	else
		fail("[log_info_line(four)] had unexpected arguments:\n[log_info_line(four.holder)]\n[log_info_line(four.first_argument)]\n[log_info_line(four.second_argument)]")

	return TRUE

/datum/extension/test_one
	base_type = /datum/extension/test_one

/datum/extension/test_two
	base_type = /datum/extension/test_two
	flags = EXTENSION_FLAG_IMMEDIATE

/datum/extension/test_three
	base_type = /datum/extension/test_three

/datum/extension/test_three/subtype

/datum/extension/test_four
	base_type = /datum/extension/test_four
	var/list/first_argument
	var/list/second_argument

/datum/extension/test_four/New(holder, first_argument, second_argument)
	..()
	src.first_argument = first_argument
	src.second_argument = second_argument

/datum/extension/test_five
	base_type = /datum/extension/test_five
	flags = EXTENSION_FLAG_IMMEDIATE
	var/list/first_argument
	var/list/second_argument

/datum/extension/test_five/New(holder, first_argument, second_argument)
	..()
	src.first_argument = first_argument
	src.second_argument = second_argument