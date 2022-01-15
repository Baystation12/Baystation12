
/datum/research_design/shield_ablative
	name = "Handheld Ablative Shield"
	product_type = /obj/item/weapon/shield/riot/ablative
	build_type = PROTOLATHE
	required_materials = list("plasteel" = 20)
	required_reagents = list(/datum/reagent/tungsten = 15)
	complexity = 15

/obj/item/weapon/shield/riot/ablative
	name = "ablative shield"

/datum/research_design/shield_energy
	name = "Handheld Energy Shield"
	product_type = /obj/item/clothing/gloves/shield_gauntlet/unsc
	build_type = PROTOLATHE
	required_materials = list("plasteel" = 25)
	required_reagents = list(/datum/reagent/tungsten = 20, /datum/reagent/mercury = 20)
	complexity = 20
