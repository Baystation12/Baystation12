/datum/unit_test/reagent_dispensers_shall_have_valid_initial_reagents
	name = "REAGENT: Dispensers shall have valid initial reagents"

/datum/unit_test/reagent_dispensers_shall_have_valid_initial_reagents/start_test()
	var/list/bad_reagents = list()

	for(var/dispenser_type in typesof(/obj/structure/reagent_dispensers))
		var/obj/structure/reagent_dispensers/rd = dispenser_type
		var/list/reagent_list = json_decode(initial(rd.initial_reagents))
		var/total_ratio = 0
		for(var/reagent in reagent_list)
			if(!(reagent in chemical_reagents_list))
				bad_reagents |= dispenser_type
				log_bad("[dispenser_type]: The reagent '[reagent]' is invalid.")

			var/reagent_ratio = reagent_list[reagent]
			total_ratio += reagent_ratio
			if(reagent_ratio <= 0 || reagent_ratio > 1)
				bad_reagents |= dispenser_type
				log_bad("[dispenser_type]: Reagent ratio was [reagent_ratio], expected a number 0 < x <= 1.")

		if(total_ratio < 0 || total_ratio > 1) // A dispenser may of course be empty
			bad_reagents |= dispenser_type
			log_bad("[dispenser_type]: Total reagent ratio was [total_ratio], expected a number 0 <= x <= 1.")

	if(bad_reagents.len)
		fail("Following reagent dispenser types have an invalid initial reagent setup: [english_list(bad_reagents)]")
	else
		pass("All reagent dispenser types have an expected initial reagents setup.")

	return 1
