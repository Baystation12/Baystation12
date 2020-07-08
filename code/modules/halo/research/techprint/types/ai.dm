
/datum/techprint/dumb_ai
	name = "Security AI"
	desc = "An advanced program for countering hostile hackers."
	design_unlocks = list(/datum/research_design/dumb_ai)
	tech_req_all = list(/datum/techprint/processing, /datum/techprint/data)
	required_materials = list("plasteel" = 10, "gold" = 5)
	required_reagents = list(/datum/reagent/acid = 15)
	ticks_max = 180

/datum/techprint/personal_ai
	name = "Companion AI"
	desc = "A personal AI companion and chatbot to provide you company."
	design_unlocks = list(/datum/research_design/paicard)
	tech_req_all = list(/datum/techprint/processing, /datum/techprint/data)
	required_materials = list("plasteel" = 10, "gold" = 5)
	required_reagents = list(/datum/reagent/acid = 15)
	ticks_max = 200

/datum/techprint/intelicard
	name = "AI Intelicard"
	desc = "Highly advanced device capable of storing smart AI."
	design_unlocks = list(/datum/research_design/intelicard)
	tech_req_all = list(/datum/techprint/processing_two, /datum/techprint/data_two)
	required_materials = list("plasteel" = 20, "gold" = 10, "diamond" = 1)
	required_reagents = list(/datum/reagent/acid/hydrochloric = 15)
	ticks_max = 220
/*
/datum/techprint/ai_core
	name = "AI Core"
	desc = "A next generation smart AI"
	design_unlocks = list(/datum/research_design/ai_core)
	tech_req_all = list(/datum/techprint/processing_three, /datum/techprint/data_three)
	required_materials = list("osmium-carbide plasteel" = 20, "gold" = 10, "silver" = 10, "diamond" = 1)
	required_reagents = list(/datum/reagent/acid/polyacid = 15)
	ticks_max = 300
*/