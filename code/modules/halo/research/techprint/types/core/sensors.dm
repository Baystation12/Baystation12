
/datum/techprint/sensors
	name = "Sensors I"
	desc = "Detection of exotic energy and matter."
	required_materials = list("silver" = 5)
	required_reagents = list(/datum/reagent/tungsten = 10, /datum/reagent/sodium = 10)
	required_objs = list(/obj/item/crystal/orange)
	ticks_max = 60
	design_unlocks = list(/datum/research_design/basic_sensor, /datum/research_design/nvg, /datum/research_design/oms)

/datum/techprint/sensors_two
	name = "Sensors II"
	desc = "Detection of exotic energy and matter."
	tech_req_all = list(/datum/techprint/sensors)
	required_materials = list("silver" = 10)
	required_reagents = list(/datum/reagent/tungsten = 20, /datum/reagent/sodium = 20)
	required_objs = list(/obj/item/crystal/orange)
	ticks_max = 120
	design_unlocks = list(/datum/research_design/adv_sensor, /datum/research_design/mesons, /datum/research_design/anti_photon_grenade)

/datum/techprint/sensors_three
	name = "Sensors III"
	desc = "Detection of exotic energy and matter."
	tech_req_all = list(/datum/techprint/sensors_two)
	required_materials = list("silver" = 15, "platinum" = 5)
	required_reagents = list(/datum/reagent/tungsten = 30, /datum/reagent/sodium = 30)
	required_objs = list(/obj/item/crystal/orange)
	ticks_max = 300
	design_unlocks = list(/datum/research_design/phasic_sensor, /datum/research_design/thermals)
