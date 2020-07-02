
/datum/techprint/plastique
	name = "C12 Breaching Charge"
	desc = "Plastic explosives. Easy to use and effective for getting into places."
	design_unlocks = list(/datum/research_design/plastique)
	required_reagents = list(
		/datum/reagent/nitroglycerin = 20,\
		/datum/reagent/toxin/plasticide = 20,\
		/datum/reagent/toxin/phoron = 5)
	ticks_max = 135
	tech_req_all = list(/datum/techprint/fragment)
