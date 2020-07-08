
/datum/research_design/plasma_cell
	name = "Plasma cell"
	product_type = /obj/item/unsc_plasma_cell
	build_type = PROTOLATHE
	required_materials = list("osmium-carbide plasteel" = 10, "nanolaminate" = 5)
	required_reagents = list(/datum/reagent/silicon = 10, /datum/reagent/aluminum = 10)
	complexity = 25

/datum/research_design/plasma_charger
	name = "circuitboard (plasma charger)"
	product_type = /obj/item/weapon/circuitboard/plasma_charger
	build_type = IMPRINTER
	required_materials = list("steel" = 2, "glass" = 1)
	required_reagents = list(/datum/reagent/acid/hydrochloric = 20)
	complexity = 25
