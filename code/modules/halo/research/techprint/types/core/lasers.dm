
/datum/techprint/lasers
	name = "Directed Energy I"
	desc = "The technology to channel high power laser beams."
	required_materials = list("glass" = 20)
	required_reagents = list(/datum/reagent/phosphorus = 10, /datum/reagent/silicate = 10)
	required_objs = list(/obj/item/crystal/pink)
	ticks_max = 60
	design_unlocks = list(/datum/research_design/basic_micro_laser)

/datum/techprint/lasers_two
	name = "Directed Energy II"
	desc = "The technology to channel high power laser beams."
	tech_req_all = list(/datum/techprint/lasers)
	required_materials = list("glass" = 10, "phglass" = 10, "diamond" = 1)
	required_reagents = list(/datum/reagent/phosphorus = 20, /datum/reagent/silicate = 20)
	required_objs = list(/obj/item/crystal/pink)
	ticks_max = 120
	design_unlocks = list(/datum/research_design/high_micro_laser)

/datum/techprint/lasers_three
	name = "Directed Energy III"
	desc = "The technology to channel high power laser beams."
	tech_req_all = list(/datum/techprint/lasers_two)
	required_materials = list("phglass" = 20, "diamond" = 5)
	required_reagents = list(/datum/reagent/phosphorus = 30, /datum/reagent/silicate = 30)
	required_objs = list(/obj/item/crystal/pink)
	ticks_max = 300
	design_unlocks = list(/datum/research_design/ultra_micro_laser)
