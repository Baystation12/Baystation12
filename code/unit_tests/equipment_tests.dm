#define SUCCESS 1
#define FAILURE 0


datum/unit_test/vision_glasses/
	name = "EQUIPMENT: Vision Template"
	var/mob/living/carbon/human/H = null
	var/expectation = SEE_INVISIBLE_NOLIGHTING
	var/glasses_type = null
	async = 1

datum/unit_test/vision_glasses/start_test()
	spawn(0)
		var/list/test = create_test_mob_with_mind(null, /mob/living/carbon/human)
		if(isnull(test))
			fail("Check Runtimed in Mob creation")

		if(test["result"] == FAILURE)
			fail(test["msg"])
			async = 0

			return 0

		H = locate(test["mobref"])

		var/obj/item/clothing/glasses/G = new glasses_type()
		H.glasses = G

	return 1


datum/unit_test/vision_glasses/check_result()

	if(isnull(H) || H.life_tick < 2)
		return 0       

	if(isnull(H.glasses))
		fail("Mob doesn't have glasses on")

	H.handle_vision()	// Because Life has a client check that bypasses updating vision

	if(H.see_invisible == expectation)
		pass("Mob See invisible is [H.see_invisible]")
	else
		fail("Mob See invisible is [H.see_invisible] / expected [expectation]")

	return 1

datum/unit_test/vision_glasses/NVG
	name = "EQUIPMENT: NVG see_invis"
	glasses_type = /obj/item/clothing/glasses/night

datum/unit_test/vision_glasses/mesons
	name = "EQUIPMENT: Mesons see_invis"
	glasses_type = /obj/item/clothing/glasses/meson

datum/unit_test/vision_glasses/plain
	name = "EQUIPMENT: Plain glasses. see_invis"
	glasses_type = /obj/item/clothing/glasses/regular
	expectation = SEE_INVISIBLE_LIVING

// ============================================================================

datum/unit_test/storage_capacity_test
	name = "EQUIPMENT: Storage items should be able to actually hold their initial contents"

datum/unit_test/storage_capacity_test/start_test()
	var/bad_tests = 0

	// obj/item/weapon/storage/internal cannot be tested sadly, as they expect their host object to create them
	for(var/storage_type in subtypesof(/obj/item/weapon/storage) - typesof(/obj/item/weapon/storage/internal))
		var/obj/item/weapon/storage/S = new storage_type(null) //should be fine to put it in nullspace...
		var/bad_msg = "[ascii_red]--------------- [S.name] \[[S.type]\]"
		bad_tests += test_storage_capacity(S, bad_msg)

	if(bad_tests)
		fail("\[[bad_tests]\] Some storage item types were not able to hold their default initial contents.")
	else
		pass("All storage item types were able to hold their default initial contents.")

	return 1

/proc/test_storage_capacity(obj/item/weapon/storage/S, var/bad_msg)
	var/bad_tests = 0

	if(!isnull(S.storage_slots) && S.contents.len > S.storage_slots)
		log_unit_test("[bad_msg] Contains more items than it has slots for ([S.contents.len] / [S.storage_slots]). [ascii_reset]")
		bad_tests++

	var/total_storage_space = 0
	for(var/obj/item/I in S.contents)
		if(I.w_class > S.max_w_class)
			log_unit_test("[bad_msg] Contains an item \[[I.type]\] that is too big to be held ([I.w_class] / [S.max_w_class]). [ascii_reset]")
			bad_tests++
		if(istype(I, /obj/item/weapon/storage) && I.w_class >= S.w_class)
			log_unit_test("[bad_msg] Contains a storage item \[[I.type]\] the same size or larger than its container ([I.w_class] / [S.w_class]). [ascii_reset]")
			bad_tests++
		total_storage_space += I.get_storage_cost()

	if(total_storage_space > S.max_storage_space)
		log_unit_test("[bad_msg] Contains more items than it has storage space for ([total_storage_space] / [S.max_storage_space]). [ascii_reset]")
		bad_tests++

	return bad_tests

#undef SUCCESS
#undef FAILURE

