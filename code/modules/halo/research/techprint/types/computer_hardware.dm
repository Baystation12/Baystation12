//in this file: hardware which requires hybrid tech to unlock
//standard computer hardware is unlocked directly by core computer techprints



/* TABLET PROCESSORS */

/datum/techprint/microprocessor
	name = "Microprocessor"
	desc = "Central component of a tablet computer."
	required_materials = list("gold" = 5)
	required_reagents = list(/datum/reagent/silicate = 5, /datum/reagent/copper = 5, /datum/reagent/acid = 5)
	ticks_max = 60
	design_unlocks = list(/datum/research_design/processor_small)
	tech_req_all = list(/datum/techprint/miniaturisation, /datum/techprint/processing)

/datum/techprint/microprocessor_quantum
	name = "Quantum Microprocessor"
	desc = "Central component of a tablet computer."
	required_materials = list("gold" = 5, "platinum" = 5)
	required_reagents = list(/datum/reagent/silicate = 10, /datum/reagent/copper = 5, /datum/reagent/acid/hydrochloric = 5)
	ticks_max = 60
	design_unlocks = list(/datum/research_design/processor_quantum_small)
	tech_req_all = list(/datum/techprint/miniaturisation_two, /datum/techprint/processing_two)

/datum/techprint/microprocessor_photonic
	name = "Photonic Microprocessor"
	desc = "Central component of a tablet computer."
	required_materials = list("gold" = 5, "platinum" = 5, "osmium" = 5)
	required_reagents = list(/datum/reagent/silicate = 15, /datum/reagent/copper = 5, /datum/reagent/acid/polyacid = 5)
	ticks_max = 60
	design_unlocks = list(/datum/research_design/processor_photonic_small)
	tech_req_all = list(/datum/techprint/miniaturisation_three, /datum/techprint/processing_three)



/* TABLET HARD DRIVES */

/datum/techprint/drive_micro
	name = "micro hard drive"
	desc = "Efficient storage for a tablet computer."
	required_materials = list("plasteel" = 1, "rglass" = 1, "plastic" = 10)
	required_reagents = list(/datum/reagent/acid/hydrochloric = 20)
	ticks_max = 60
	design_unlocks = list(/datum/research_design/drive_micro)
	tech_req_all = list(/datum/techprint/miniaturisation, /datum/techprint/data)

/datum/techprint/drive_small
	name = "small hard drive"
	desc = "Efficient storage for a tablet computer."
	required_materials = list("plasteel" = 1, "rglass" = 1, "plastic" = 10)
	required_reagents = list(/datum/reagent/acid/hydrochloric = 20)
	ticks_max = 60
	design_unlocks = list(/datum/research_design/drive_small)
	tech_req_all = list(/datum/techprint/miniaturisation_two, /datum/techprint/data_two)



/* PORTABLE HARD DRIVES */

/datum/techprint/drive_portable
	name = "basic data crystal"
	desc = "Small crystal with imprinted photonic circuits that can be used to store data. Its capacity is 16 GQ."
	required_materials = list("steel" = 1, "glass" = 1, "plastic" = 5)
	required_reagents = list(/datum/reagent/acid = 20)
	ticks_max = 60
	design_unlocks = list(/datum/research_design/portable_drive)
	tech_req_all = list(/datum/techprint/miniaturisation, /datum/techprint/data)

/datum/techprint/drive_portable_advanced
	name = "advanced data crystal"
	desc = "Small crystal with imprinted high-density photonic circuits that can be used to store data. Its capacity is 64 GQ."
	required_materials = list("plasteel" = 1, "rglass" = 1, "plastic" = 5)
	required_reagents = list(/datum/reagent/acid/hydrochloric = 20)
	ticks_max = 120
	design_unlocks = list(/datum/research_design/portable_drive_advanced)
	tech_req_all = list(/datum/techprint/miniaturisation_two, /datum/techprint/data_two)

/datum/techprint/drive_portable_super
	name = "super data crystal"
	desc = "Small crystal with imprinted ultra-density photonic circuits that can be used to store data. Its capacity is 256 GQ."
	required_materials = list("osmium-carbide plasteel" = 1, "phglass" = 1, "plastic" = 5)
	required_reagents = list(/datum/reagent/nitric_acid = 20)
	ticks_max = 200
	design_unlocks = list(/datum/research_design/portable_drive_super)
	tech_req_all = list(/datum/techprint/miniaturisation_three, /datum/techprint/data_three)



/* REVERSE ENGINEERED TECH */

/datum/techprint/drive_cluser
	name = "cluster hard drive"
	desc = "Possible thanks to breakthroughs in plasma engineering."
	required_materials = list("duridium" = 1, "rphglass" = 1, "plastic" = 10)
	required_reagents = list(/datum/reagent/acid/polyacid = 20)
	ticks_max = 200
	design_unlocks = list(/datum/research_design/drive_cluster)
	tech_req_all = list(/datum/techprint/data_three, /datum/techprint/plasma_storage)
