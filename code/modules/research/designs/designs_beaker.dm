/datum/design/item/beaker/AssembleDesignName()
	name = "Beaker prototype ([item_name])"

/datum/design/item/beaker/noreact
	name = "cryostasis"
	desc = "A cryostasis beaker that allows for chemical storage without reactions. Can hold up to 50 units."
	id = "splitbeaker"
	req_tech = list(TECH_MATERIAL = 2)
	materials = list(MATERIAL_STEEL = 3000)
	build_path = /obj/item/reagent_containers/glass/beaker/noreact
	sort_string = "MCAAA"

/datum/design/item/beaker/bluespace
	name = TECH_BLUESPACE
	desc = "A bluespace beaker, which uses experimental technology to prevent its contents from reacting. Can hold up to 300 units."
	id = "bluespacebeaker"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 6)
	materials = list(MATERIAL_STEEL = 3000, MATERIAL_PHORON = 3000, MATERIAL_DIAMOND = 500)
	build_path = /obj/item/reagent_containers/glass/beaker/bluespace
	sort_string = "MCAAB"