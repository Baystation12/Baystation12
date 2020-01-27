
/datum/unit_test/reagent_colors_test
	name = "REAGENTS: Reagents must have valid colors without alpha in color value"

/datum/unit_test/reagent_colors_test/start_test()
	var/list/bad_reagents = list()

	for(var/T in typesof(/datum/reagent))
		var/datum/reagent/R = T
		if(length(initial(R.color)) != 7)
			bad_reagents += "[T] ([initial(R.color)])"

	if(length(bad_reagents))
		fail("Reagents with invalid colors found: [english_list(bad_reagents)]")
	else
		pass("All reagents have valid colors.")

	return 1
