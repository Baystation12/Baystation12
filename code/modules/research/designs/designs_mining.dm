/datum/design/item/mining/AssembleDesignName()
	..()
	name = "Mining equipment design ([item_name])"

/datum/design/item/mining/jackhammer
	id = "jackhammer"
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 500, MATERIAL_SILVER = 500)
	build_path = /obj/item/pickaxe/jackhammer
	sort_string = "KAAAA"

/datum/design/item/mining/drill
	id = "drill"
	req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 6000, MATERIAL_GLASS = 1000) //expensive, but no need for miners.
	build_path = /obj/item/pickaxe/drill
	sort_string = "KAAAB"

/datum/design/item/mining/plasmacutter
	id = "plasmacutter"
	req_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	materials = list(MATERIAL_STEEL = 1500, MATERIAL_GLASS = 500, MATERIAL_GOLD = 500, MATERIAL_PHORON = 500)
	build_path = /obj/item/gun/energy/plasmacutter
	sort_string = "KAAAC"

/datum/design/item/mining/pick_diamond
	id = "pick_diamond"
	req_tech = list(TECH_MATERIAL = 6)
	materials = list(MATERIAL_DIAMOND = 3000)
	build_path = /obj/item/pickaxe/diamond
	sort_string = "KAAAD"

/datum/design/item/mining/drill_diamond
	id = "drill_diamond"
	req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 4)
	materials = list(MATERIAL_STEEL = 3000, MATERIAL_GLASS = 1000, MATERIAL_DIAMOND = 2000)
	build_path = /obj/item/pickaxe/diamonddrill
	sort_string = "KAAAE"

/datum/design/item/mining/depth_scanner
	desc = "Used to check spatial depth and density of rock outcroppings."
	id = "depth_scanner"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2, TECH_BLUESPACE = 2)
	materials = list(MATERIAL_STEEL = 1000, MATERIAL_GLASS = 500, MATERIAL_ALUMINIUM = 150)
	build_path = /obj/item/device/depth_scanner
	sort_string = "KAAAF"

/datum/design/item/mining/pick_set
	desc = "A rugged case containing a set of standardized picks used in archaeological digs."
	id = "pick_set"
	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2)
	materials = list(MATERIAL_STEEL = 1700, MATERIAL_GLASS = 200, MATERIAL_PLASTIC = 200)
	build_path = /obj/item/storage/excavation
	sort_string = "KAAAG"

/datum/design/item/mining/xeno_drill
	desc = "A miniature excavation tool for precise digging."
	id = "xeno_drill"
	req_tech = 	list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3)
	materials = list(MATERIAL_STEEL = 900, MATERIAL_GLASS = 800, MATERIAL_ALUMINIUM = 200)
	build_path = /obj/item/pickaxe/xeno/drill
	sort_string = "KAAAH"

/datum/design/item/mining/xeno_cutter
	desc = "A plasma fueled laser for precise digging."
	id = "xeno_cutter"
	req_tech = 	list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINEERING = 3, TECH_BLUESPACE = 2)
	materials = list(MATERIAL_STEEL = 1700, MATERIAL_GLASS = 1500, MATERIAL_PLASTIC = 500, MATERIAL_PHORON = 500)
	build_path = /obj/item/pickaxe/xeno/drill/plasma
	sort_string = "KAAAI"
