//I'm giving tablet hardware it's own techprints and file here because they are hybrid tech
//therefore a little more complex to research



/* PROCESSORS */

/datum/techprint/microprocessor_quantum
	name = "Quantum Microprocessor"
	desc = "Central component of a tablet computer."
	required_materials = list("gold" = 10)
	required_reagents = list(/datum/reagent/silicate = 10, /datum/reagent/copper = 5, /datum/reagent/acid = 5)
	ticks_max = 60
	design_unlocks = list(/datum/research_design/processor_quantum_small)
	tech_req_all = list(/datum/techprint/miniaturisation_two, /datum/techprint/processing_two)

/datum/techprint/microprocessor_photonic
	name = "Photonic Microprocessor"
	desc = "Central component of a tablet computer."
	required_materials = list("gold" = 10)
	required_reagents = list(/datum/reagent/silicate = 10, /datum/reagent/copper = 5, /datum/reagent/acid = 5)
	ticks_max = 60
	design_unlocks = list(/datum/research_design/processor_photonic_small)
	tech_req_all = list(/datum/techprint/miniaturisation_three, /datum/techprint/processing_three)



/* HARD DRIVES */

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
