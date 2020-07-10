
/datum/techprint/data
	name = "Data Storage I"
	desc = "Improved compression algorithms and storage mediums."
	required_materials = list("gold" = 10)
	required_reagents = list(/datum/reagent/silicate = 10, /datum/reagent/copper = 5, /datum/reagent/acid = 5)
	ticks_max = 60
	design_unlocks = list(/datum/research_design/drive)

/datum/techprint/data_two
	name = "Data Storage II"
	desc = "Improved compression algorithms and storage mediums."
	tech_req_all = list(/datum/techprint/data)
	required_materials = list("gold" = 20)
	required_reagents = list(/datum/reagent/silicate = 20, /datum/reagent/copper = 10, /datum/reagent/acid = 10)
	ticks_max = 120
	design_unlocks = list(/datum/research_design/drive_advanced, /datum/research_design/portable_drive_advanced)

/datum/techprint/data_three
	name = "Data Storage III"
	desc = "Improved compression algorithms and storage mediums."
	tech_req_all = list(/datum/techprint/data_two)
	required_materials = list("gold" = 30, "osmium" = 5)
	required_reagents = list(/datum/reagent/silicate = 30, /datum/reagent/copper = 15, /datum/reagent/acid = 10)
	ticks_max = 300
	design_unlocks = list(/datum/research_design/drive_super, /datum/research_design/portable_drive_super)
