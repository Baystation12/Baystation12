
/datum/research_design/emp_grenade
	name = "EMP Grenade"
	product_type = /obj/item/weapon/grenade/empgrenade
	build_type = PROTOLATHE
	required_materials = list("steel" = 10)
	required_reagents = list(/datum/reagent/uranium = 20, /datum/reagent/silver = 20)
	complexity = 8

/datum/research_design/anti_photon_grenade
	name = "Anti-Photon Grenade"
	product_type = /obj/item/weapon/grenade/anti_photon
	build_type = PROTOLATHE
	required_materials = list("steel" = 10)
	required_reagents = list(/datum/reagent/mercury = 20, /datum/reagent/phosphorus = 20)
	complexity = 8

/datum/research_design/high_yield_frag
	name = "High Yield Fragmentation Grenade"
	product_type = /obj/item/weapon/grenade/frag/high_yield
	build_type = PROTOLATHE
	required_materials = list("plasteel" = 20)
	required_reagents = list(/datum/reagent/copper = 20)
	complexity = 5
