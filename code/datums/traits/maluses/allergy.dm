/singleton/trait/malus/allergy
	name = "Allergy"
	levels = list(TRAIT_LEVEL_MINOR, TRAIT_LEVEL_MAJOR)
	abstract_type = /singleton/trait/malus/allergy

/singleton/trait/malus/allergy/drug
	name = "Drug Allergy"
	maximum_count = 2

	metaoptions = list(
		/datum/reagent/antidexafen,
		/datum/reagent/bicaridine,
		/datum/reagent/dermaline,
		/datum/reagent/drugs/psilocybin,
		/datum/reagent/drugs/three_eye,
		/datum/reagent/hyperzine,
		/datum/reagent/kelotane,
		/datum/reagent/nanoblood,
		/datum/reagent/paracetamol,
		/datum/reagent/antidepressant,
		/datum/reagent/peridaxon,
		/datum/reagent/spaceacillin,
		/datum/reagent/opiate,
		/datum/reagent/tricordrazine,
		/datum/reagent/toxin/amatoxin,
		/datum/reagent/toxin/carpotoxin,
		/datum/reagent/toxin/venom
	)
	addprompt = "Select drug to make mob allergic to."
	remprompt = "Select drug to remove allergy to."
	selectable = TRUE

/singleton/trait/malus/allergy/food
	name = "Food Allergy"
	maximum_count = 2

	metaoptions = list(
		/datum/reagent/drink/juice/apple,
		/datum/reagent/drink/juice/berry,
		/datum/reagent/drink/juice/garlic,
		/datum/reagent/drink/juice/orange,
		/datum/reagent/ethanol,
		/datum/reagent/drink/kefir,
		/datum/reagent/drink/thoom,
		/datum/reagent/ethanol/creme_de_menthe,
		/datum/reagent/ethanol/gin,
		/datum/reagent/ethanol/tequilla,
		/datum/reagent/ethanol/vodka,
		/datum/reagent/nutriment/protein/egg,
		/datum/reagent/nutriment/protein/shellfish,
		/datum/reagent/nutriment/protein/fish,
		/datum/reagent/nutriment/protein/cheese,
		/datum/reagent/nutriment/peanut
	)
	addprompt = "Select food to make mob allergic to."
	remprompt = "Select food to remove allergy to."
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
