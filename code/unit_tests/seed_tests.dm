/datum/unit_test/seed_types_have_at_least_one_sprite
	name = "SEED: Seed types should have at least one sprite"

/datum/unit_test/seed_types_have_at_least_one_sprite/start_test()
	var/any_failed = FALSE

	for (var/subtype in subtypesof(/datum/seed))
		var/datum/seed/S = new subtype()
		var/sprite = S.get_trait(TRAIT_PLANT_ICON)
		if(sprite && (!(sprite in SSplants.plant_sprites)))
			log_bad("[subtype] references nonexistent sprite [sprite].")
			any_failed = TRUE

	if (any_failed)
		fail("Some seed icons were missing.")
	else
		pass("All seed icons were found.")
	return 1
