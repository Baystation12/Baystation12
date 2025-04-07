/singleton/trait/malus/allergy
	name = "Allergy"
	levels = list(TRAIT_LEVEL_MINOR, TRAIT_LEVEL_MAJOR)
	maximum_count = 2
	///Used to select which reagent mob is allergic to.
	metaoptions = list(
		/datum/reagent/antidexafen,
		/datum/reagent/bicaridine,
		/datum/reagent/dermaline,
		/datum/reagent/drink/juice/apple,
		/datum/reagent/drink/juice/berry,
		/datum/reagent/drink/juice/garlic,
		/datum/reagent/drink/juice/orange,
		/datum/reagent/drink/kefir,
		/datum/reagent/drink/thoom,
		/datum/reagent/drugs/psilocybin,
		/datum/reagent/drugs/three_eye,
		/datum/reagent/ethanol,
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
	addprompt = "Select reagent to make mob allergic to."
	remprompt = "Select reagent to remove allergy to."
	selectable = TRUE
