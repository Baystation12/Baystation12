
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

/datum/chemical_reaction/hyperzine_concentrated
	name = "Concentrated Hyperzine"
	result = /datum/reagent/hyperzine_concentrated
	required_reagents = list(/datum/reagent/hyperzine = 2, /datum/reagent/impedrezene = 1) //Impedrezene slows down brain function, so let's say combining it with hyperzine concentrates the effects.
	result_amount = 1

