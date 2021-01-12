
/datum/chemical_reaction/triadrenaline
	name = "Tri-Adrenaline"
	result = /datum/reagent/triadrenaline
	required_reagents = list(/datum/reagent/inaprovaline = 1, /datum/reagent/dexalin = 1, /datum/reagent/tramadol = 1)
	result_amount = 3

/datum/chemical_reaction/biofoam
	name = "Bio-Foam"
	result = /datum/reagent/biofoam
	required_reagents = list(/datum/reagent/foaming_agent = 1, /datum/reagent/tricordrazine = 1, /datum/reagent/bicaridine = 1)
	result_amount = 2

/datum/chemical_reaction/biofoampenalise
	name = "Bio-Foam Remnant Neutralisation"
	result = /datum/reagent/biofoampenaliser
	required_reagents = list(/datum/reagent/biofoam = 1,/datum/reagent/biofoampenaliser = 1)
	result_amount = 1

/datum/chemical_reaction/hyperzine_concentrated
	name = "Concentrated Hyperzine"
	result = /datum/reagent/hyperzine_concentrated
	required_reagents = list(/datum/reagent/hyperzine = 2, /datum/reagent/impedrezene = 1) //Impedrezene slows down brain function, so let's say combining it with hyperzine concentrates the effects.
	result_amount = 1

/datum/chemical_reaction/hexaline
	name = "Hexaline Glycol"
	result = /datum/reagent/hexaline
	required_reagents = list(/datum/reagent/glycerol = 1, /datum/reagent/ethanol = 4)
	result_amount = 5

/datum/chemical_reaction/cryoprethaline
	name = "Cryoprethaline"
	result = /datum/reagent/cryoprethaline
	required_reagents = list(/datum/reagent/hexaline = 5, /datum/reagent/cryoxadone = 5, /datum/reagent/toxin/phoron = 0.1)
	result_amount = 5

/datum/chemical_reaction/ketoprofen
	name = "Ketoprofen"
	result = /datum/reagent/ketoprofen
	required_reagents = list(/datum/reagent/tramadol = 1, /datum/reagent/leporazine = 1)
	result_amount = 2

//Stacking dermaline/kelotane allows for a much faster regen speed of burns than regeneration of brute.//
//Don't want to highly punish people for trying an obvious mix idea, so we let them keep the higher tier chem.//
/datum/chemical_reaction/dermaline_kelostack_prevent
	name = "Dermaline/Kelotane Mix"
	result = /datum/reagent/dermaline
	required_reagents = list(/datum/reagent/kelotane = 1,/datum/reagent/dermaline = 1)
	result_amount = 1