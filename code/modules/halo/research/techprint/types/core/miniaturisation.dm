
/datum/techprint/miniaturisation
	name = "Miniaturisation I"
	desc = "Interacting with matter on an increasingly small scale."
	required_materials = list("steel" = 10)
	required_reagents = list(/datum/reagent/iron = 10, /datum/reagent/acid/hydrochloric = 10)
	ticks_max = 60
	design_unlocks = list(/datum/research_design/micro_mani)

/datum/techprint/miniaturisation_two
	name = "Miniaturisation II"
	desc = "Interacting with matter on an increasingly small scale."
	tech_req_all = list(/datum/techprint/miniaturisation)
	required_materials = list("steel" = 20)
	required_reagents = list(/datum/reagent/iron = 20, /datum/reagent/acid/hydrochloric = 20)
	ticks_max = 120
	design_unlocks = list(/datum/research_design/nano_mani)

/datum/techprint/miniaturisation_three
	name = "Miniaturisation III"
	desc = "Interacting with matter on an increasingly small scale."
	tech_req_all = list(/datum/techprint/miniaturisation_two)
	required_materials = list("steel" = 30, "plasteel" = 5)
	required_reagents = list(/datum/reagent/iron = 30, /datum/reagent/acid/hydrochloric = 30)
	ticks_max = 300
	design_unlocks = list(/datum/research_design/pico_mani)
