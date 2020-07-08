
/datum/techprint/energy
	name = "Energy Storage I"
	desc = "Store and discharge larger amounts of energy."
	required_materials = list("glass" = 10)
	required_reagents = list(/datum/reagent/toxin/phoron = 10, /datum/reagent/radium = 10)
	ticks_max = 60
	design_unlocks = list(/datum/research_design/basic_capacitor)

/datum/techprint/energy_two
	name = "Energy Storage II"
	desc = "Store and discharge larger amounts of energy."
	tech_req_all = list(/datum/techprint/energy)
	required_materials = list("glass" = 20, "phoron" = 10)
	required_reagents = list(/datum/reagent/toxin/phoron = 20, /datum/reagent/radium = 20)
	ticks_max = 120
	design_unlocks = list(/datum/research_design/adv_capacitor)

/datum/techprint/energy_three
	name = "Energy Storage III"
	desc = "Store and discharge larger amounts of energy."
	tech_req_all = list(/datum/techprint/energy_two)
	required_materials = list("glass" = 30, "phoron" = 10, "kemocite" = 10)
	required_reagents = list(/datum/reagent/toxin/phoron = 30, /datum/reagent/radium = 30)
	ticks_max = 300
	design_unlocks = list(/datum/research_design/super_capacitor)
