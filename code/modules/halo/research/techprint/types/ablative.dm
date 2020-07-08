
/datum/techprint/ablative
	name = "Ablative materials"
	desc = "A reflective plastalloy that better disperses energy."
	required_materials = list("glass" = 10, "plastic" = 10, "steel" = 10, "plasteel" = 10)
	required_reagents = list(/datum/reagent/lithium = 50)
	ticks_max = 75
	tech_req_all = list(/datum/techprint/energy_two)

/datum/techprint/human_shield_ablative
	name = "Ablative Battle Shield"
	desc = "Energy dispersal plates allows for battlefield use of handheld shields against the Covenant."
	design_unlocks = list(/datum/research_design/shield_ablative)
	required_reagents = list(/datum/reagent/tungsten = 20)
	required_materials = list("glass" = 20, "plastic" = 20, "steel" = 20)
	ticks_max = 225
	tech_req_all = list(/datum/techprint/ablative)

/datum/techprint/ablative_patch
	name = "Ablative Patch"
	desc = "An armour upgrade providing minor resistance to energy or heat based weaponry."
	design_unlocks = list(/datum/research_design/armour_ablative)
	required_materials = list("rglass" = 10)
	required_reagents = list(/datum/reagent/lithium = 10)
	tech_req_all = list(/datum/techprint/ablative, /datum/techprint/compression_two)
	ticks_max = 250
