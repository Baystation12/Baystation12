/singleton/trait/malus/allergy
	name = "Allergy"
	levels = list(TRAIT_LEVEL_MINOR, TRAIT_LEVEL_MAJOR)
	budget_cost = 2
	///Used to select which reagent mob is allergic to. Number represents budget cost. If none set; defaults to budget_cost.
	metaoptions = list(
		/datum/reagent/antidexafen = 2,
		/datum/reagent/bicaridine = 2,
		/datum/reagent/dermaline = 2,
		/datum/reagent/drugs/mindbreaker = 1,
		/datum/reagent/drink/juice/apple = 0,
		/datum/reagent/drink/juice/berry = 0,
		/datum/reagent/drink/juice/garlic = 0,
		/datum/reagent/drink/juice/orange = 0,
		/datum/reagent/drink/juice/lemon = 0,
		/datum/reagent/nutriment/peanut = 0,
		/datum/reagent/drink/kefir = 0,
		/datum/reagent/drink/thoom = 0,
		/datum/reagent/drugs/psilocybin = 1,
		/datum/reagent/drugs/three_eye = 1,
		/datum/reagent/ethanol = 1,
		/datum/reagent/hydrazine = 1,
		/datum/reagent/hyperzine = 2,
		/datum/reagent/space_cleaner = 0,
		/datum/reagent/kelotane = 2,
		/datum/reagent/nanoblood = 2,
		/datum/reagent/paracetamol = 2,
		/datum/reagent/antidepressant = 2,
		/datum/reagent/peridaxon = 2,
		/datum/reagent/spaceacillin = 2,
		/datum/reagent/opiate = 2,
		/datum/reagent/tricordrazine = 2,
		/datum/reagent/toxin/amatoxin = 1,
		/datum/reagent/toxin/carpotoxin = 1 ,
		/datum/reagent/toxin/venom = 1,
		/datum/reagent/nutriment/protein/fish = 1,
		/datum/reagent/nutriment/protein/shellfish = 1,
		/datum/reagent/nutriment/protein/egg = 1,
		/datum/reagent/nutriment/protein/cheese = 1
	)
	addprompt = "Select reagent to make mob allergic to."
	remprompt = "Select reagent to remove allergy to."
	selectable = TRUE

/// Migrates allergies from lower save versions to higher ones.
/// If you change the metaoptions list above via retyping, add a new migration below!!!
/singleton/trait/malus/allergy/migrate(metaoption, save_version)
	if (save_version < 4)
		switch (metaoption)
			// painkillers
			if ("/datum/reagent/tramadol")
				metaoption = "/datum/reagent/opiate"
			if ("/datum/reagent/tramadol/oxycodone")
				metaoption = "/datum/reagent/opiate"

			// antidepressants
			if ("/datum/reagent/citalopram")
				metaoption = "/datum/reagent/antidepressant"
			if ("/datum/reagent/paroxetine")
				metaoption = "/datum/reagent/antidepressant"

			// various alcohol types rolled into ethanol
			if ("/datum/reagent/ethanol/creme_de_menthe")
				metaoption = "/datum/reagent/ethanol"
			if ("/datum/reagent/ethanol/gin")
				metaoption = "/datum/reagent/ethanol"
			if ("/datum/reagent/ethanol/tequilla")
				metaoption = "/datum/reagent/ethanol"
			if ("/datum/reagent/ethanol/vodka")
				metaoption = "/datum/reagent/ethanol"
	return metaoption
