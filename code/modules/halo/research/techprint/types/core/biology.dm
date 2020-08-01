
/datum/techprint/biology
	name = "Xenobiology I"
	desc = "Alien organisms, organic chemistry and strange new lifeforms."
	required_materials = list("uranium" = 1)
	required_objs = list(/obj/item/weapon/ore/corundum)
	required_reagents = list(/datum/reagent/phosphorus = 5, /datum/reagent/ethanol = 5, /datum/reagent/potassium = 5)
	ticks_max = 60
	design_unlocks = list(/datum/research_design/implant_adrenaline)
	tech_req_one = list(\
		/datum/techprint/autopsy/human,\
		/datum/techprint/autopsy/ruuhtian,\
		/datum/techprint/autopsy/tvoan,\
		/datum/techprint/autopsy/unggoy,\
		/datum/techprint/autopsy/yanmee)

/datum/techprint/biology_two
	name = "Xenobiology II"
	desc = "Alien organisms, organic chemistry and strange new lifeforms."
	tech_req_all = list(/datum/techprint/biology)
	required_materials = list("uranium" = 3)
	required_objs = list(/obj/item/weapon/ore/corundum)
	required_reagents = list(/datum/reagent/phosphorus = 10, /datum/reagent/ethanol = 10, /datum/reagent/potassium = 10)
	ticks_max = 120
	design_unlocks = list(/datum/research_design/implant_chem)
	tech_req_one = list(\
		/datum/techprint/autopsy/sangheili,\
		/datum/techprint/autopsy/jiralhanae)

/datum/techprint/biology_three
	name = "Xenobiology III"
	desc = "Alien organisms, organic chemistry and strange new lifeforms."
	tech_req_all = list(/datum/techprint/biology_two)
	required_materials = list("uranium" = 5)
	required_objs = list(/obj/item/weapon/ore/corundum)
	required_reagents = list(/datum/reagent/phosphorus = 20, /datum/reagent/ethanol = 20, /datum/reagent/potassium = 20)
	ticks_max = 300
	tech_req_all = list(\
		/datum/techprint/autopsy/sangheili,\
		/datum/techprint/autopsy/jiralhanae)
