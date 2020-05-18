// These tests are intended to verify functionality of overrides in ~unit_test_overrides.dm

/datum/unit_test/override
	name = "OVERRIDE template"
	template = /datum/unit_test/override

/datum/unit_test/override/obj_random_shall_spawn_heaviest_item
	name = "OVERRIDE - obj/random shall spawn heaviest item"

/datum/unit_test/override/obj_random_shall_spawn_heaviest_item/start_test()
	GLOB.unit_test_last_obj_random_creation = null
	var/obj/random/unit_test/R = new()

	if(GLOB.unit_test_last_obj_random_creation && GLOB.unit_test_last_obj_random_creation.type == /obj/unit_test_heavy)
		pass("[log_info_line(R)] created an object of the expected type.")
	else
		if(GLOB.unit_test_last_obj_random_creation)
			fail("[log_info_line(R)] did not create an object of the expected type. Expected /obj/unit_test_heavy, was [GLOB.unit_test_last_obj_random_creation.type]")
		else
			fail("[log_info_line(R)] did not create an object")

	return 1

/datum/unit_test/override/atom_creator_simple_shall_always_spawn
	name = "OVERRIDE - /datum/atom_creator/simple shall always spawn"

/datum/unit_test/override/atom_creator_simple_shall_always_spawn/start_test()
	var/datum/atom_creator/simple/S = new/datum/atom_creator/simple(/obj/unit_test_light, 1)
	S.probability = 0

	var/safe_turf = get_safe_turf()
	S.create(safe_turf)
	var/created_object = locate(/obj/unit_test_light) in safe_turf
	if(created_object)
		pass("[log_info_line(S)] successfully created its object.")
		qdel(created_object)
	else
		fail("[log_info_line(S)] failed to create its object.")

	return 1

/datum/unit_test/override/atom_creator_weighted_shall_spawn_heaviest
	name = "OVERRIDE - /datum/atom_creator/weighted shall spawn heaviest"

/datum/unit_test/override/atom_creator_weighted_shall_spawn_heaviest/start_test()
	var/datum/atom_creator/weighted/W = new/datum/atom_creator/weighted(list(/obj/unit_test_light = 9001, /obj/unit_test_heavy = 1))

	var/safe_turf = get_safe_turf()
	W.create(safe_turf)
	var/created_object = locate(/obj/unit_test_heavy) in safe_turf
	if(created_object)
		pass("[log_info_line(W)] successfully created the heaviest object.")
		qdel(created_object)
	else
		fail("[log_info_line(W)] failed to create its heaviest object.")

	return 1

/datum/unit_test/override/atom_creator_weighted_shall_spawn_heaviest_recursive
	name = "OVERRIDE - /datum/atom_creator/weighted shall spawn heaviest - Recursive"

/datum/unit_test/override/atom_creator_weighted_shall_spawn_heaviest_recursive/start_test()
	var/datum/atom_creator/weighted/W = new/datum/atom_creator/weighted(
		list(
			new/datum/atom_creator/weighted(list(/obj/unit_test_light = 9001, /obj/unit_test_heavy = 1)),
			new/datum/atom_creator/simple(/obj/unit_test_medium, 50)
		)
	)

	var/safe_turf = get_safe_turf()
	W.create(safe_turf)
	var/created_object = locate(/obj/unit_test_heavy) in safe_turf
	if(created_object)
		pass("[log_info_line(W)] successfully created the heaviest object.")
		qdel(created_object)
	else
		fail("[log_info_line(W)] failed to create its heaviest object.")

	return 1
