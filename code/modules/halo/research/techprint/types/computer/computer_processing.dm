
/datum/techprint/processing
	name = "Digital Processing I"
	desc = "Algorithms for sorting, analysing and processing vast amounts of data."
	required_materials = list("gold" = 10)
	required_reagents = list(/datum/reagent/silicate = 10, /datum/reagent/copper = 5, /datum/reagent/acid = 5)
	ticks_max = 60
	design_unlocks = list(/datum/research_design/processor)

/datum/techprint/processing_two
	name = "Digital Processing II"
	desc = "Algorithms for sorting, analysing and processing vast amounts of data."
	tech_req_all = list(/datum/techprint/processing)
	required_materials = list("gold" = 20)
	required_reagents = list(/datum/reagent/silicate = 20, /datum/reagent/copper = 10, /datum/reagent/acid = 10)
	ticks_max = 120
	design_unlocks = list(/datum/research_design/processor_quantum)

/datum/techprint/processing_three
	name = "Digital Processing III"
	desc = "Algorithms for sorting, analysing and processing vast amounts of data."
	tech_req_all = list(/datum/techprint/processing_two)
	required_materials = list("gold" = 30, "osmium" = 5)
	required_reagents = list(/datum/reagent/silicate = 30, /datum/reagent/copper = 15, /datum/reagent/acid = 10)
	required_objs = list(/obj/item/crystal/pink)
	ticks_max = 300
	design_unlocks = list(/datum/research_design/processor_photonic)
