
/datum/research_design/armour_fibre
	name = "Synthfibre Armour Upgrade"
	product_type = /obj/item/armour_upgrade/synthfibre
	build_type = PROTOLATHE
	required_materials = list("plasteel" = 10)

/datum/research_design/armour_diamond
	name = "Diamond Armour Upgrade"
	product_type = /obj/item/armour_upgrade/diamond
	build_type = PROTOLATHE
	required_materials = list("diamond" = 1)
	complexity = 5

/datum/research_design/armour_ablative
	name = "Ablative Armour Upgrade"
	product_type = /obj/item/armour_upgrade/ablative
	build_type = PROTOLATHE
	required_materials = list("rglass" = 10)
	required_reagents = list(/datum/reagent/lithium = 10)
	complexity = 8

/datum/research_design/armour_nanolaminate
	name = "Nanolaminate Armour Upgrade"
	product_type = /obj/item/armour_upgrade/nanolaminate
	build_type = PROTOLATHE
	required_materials = list("nanolaminate" = 5)
	complexity = 8
