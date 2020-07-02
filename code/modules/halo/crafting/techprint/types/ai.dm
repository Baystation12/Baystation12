
/datum/techprint/intelicard
	name = "AI Intelicard"
	desc = "Highly advanced device capable of storing smart AI."
	design_unlocks = list(/datum/research_design/intelicard)
	tech_req_all = list(/datum/techprint/energy)
	required_materials = list("plasteel" = 20, "gold" = 10, "diamond" = 1)
	required_reagents = list(/datum/reagent/mercury = 10, /datum/reagent/acid = 15)
	ticks_max = 220

/datum/techprint/dumb_ai
	name = "Dumb AI Chip"
	desc = "An advanced program for countering hostile hackers."
	design_unlocks = list(/datum/research_design/dumb_ai)
	tech_req_all = list(/datum/techprint/energy)
	required_materials = list("plasteel" = 10, "gold" = 5)
	required_reagents = list(/datum/reagent/mercury = 10, /datum/reagent/acid = 15)
	ticks_max = 180
