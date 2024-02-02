/singleton/trait/malus/allergy
	name = "Allergy"
	levels = list(TRAIT_LEVEL_MINOR, TRAIT_LEVEL_MAJOR)
	///Used to select which reagent mob is allergic to.
	metaoptions = list(
		/datum/reagent/paracetamol,
		/datum/reagent/tramadol
	)
	addprompt = "Select reagent to make mob allergic to."
	remprompt = "Select reagent to remove allergy to."
