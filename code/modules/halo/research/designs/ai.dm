
/datum/research_design/paicard
	name = "'pAI', personal artificial intelligence device"
	required_materials = list("glass" = 50, DEFAULT_WALL_MATERIAL = 50)
	build_type = PROTOLATHE
	product_type = /obj/item/device/paicard
	required_reagents = list(/datum/reagent/mercury = 10, /datum/reagent/acid = 15)

/datum/research_design/dumb_ai
	name = "Dumb AI Chip"
	product_type = /obj/item/dumb_ai_chip
	build_type = PROTOLATHE
	required_materials = list("plasteel" = 10, "glass" = 20, "gold" = 5, "silver" = 5)
	required_reagents = list(/datum/reagent/mercury = 10, /datum/reagent/nitric_acid = 15)
	complexity = 20

/datum/research_design/intelicard
	name = "intelicard"
	product_type = /obj/item/weapon/aicard
	build_type = PROTOLATHE
	required_materials = list("plasteel" = 20, "glass" = 50, "gold" = 10, "diamond" = 1)
	required_reagents = list(/datum/reagent/mercury = 10, /datum/reagent/acid/hydrochloric = 15)
	complexity = 50
/*
/datum/research_design/ai_core
	name = "Smart AI Core"
	//product_type = /obj/item/dumb_ai_chip
	build_type = PROTOLATHE
	required_materials = list("osmium-carbide plasteel" = 10, "phglass" = 50, "duridium" = 5, "diamond" = 1)
	required_reagents = list(/datum/reagent/mercury = 10, /datum/reagent/acid/polyacid = 15)
	complexity = 100
*/