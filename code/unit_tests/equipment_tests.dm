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

#undef SUCCESS
#undef FAILURE

