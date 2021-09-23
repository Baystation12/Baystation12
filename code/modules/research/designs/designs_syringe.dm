/datum/design/item/syringe/AssembleDesignName()
	name = "Syringe prototype ([item_name])"

/datum/design/item/syringe/noreactsyringe
	name = "Cryo Syringe"
	desc = "An advanced syringe that stops reagents inside from reacting. It can hold up to 20 units."
	id = "noreactsyringe"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 4)
	materials = list(MATERIAL_GLASS = 2000, MATERIAL_GOLD = 1000, MATERIAL_PLASTIC = 500)
	build_path = /obj/item/reagent_containers/syringe/noreact
	sort_string = "MCAAC"

/datum/design/item/syringe/bluespacesyringe
	name = "Bluespace Syringe"
	desc = "An advanced syringe that can hold 60 units of chemicals."
	id = "bluespacesyringe"
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(MATERIAL_GLASS = 2000, MATERIAL_PHORON = 1000, MATERIAL_DIAMOND = 1000)
	build_path = /obj/item/reagent_containers/syringe/bluespace
	sort_string = "MCAAD"