/datum/design/item/mining
	category_items = "Mining"

/datum/design/item/mining/jackhammer
	id = "jackhammer"
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 500, "silver" = 500)
	build_path = /obj/item/weapon/pickaxe/jackhammer
	sort_string = "KAAAA"

/datum/design/item/mining/drill
	id = "drill"
	req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 1000) //expensive, but no need for miners.
	build_path = /obj/item/weapon/pickaxe/drill
	sort_string = "KAAAB"

/datum/design/item/mining/plasmacutter
	id = "plasmacutter"
	req_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 1500, "glass" = 500, "gold" = 500, "phoron" = 500)
	build_path = /obj/item/weapon/gun/energy/plasmacutter
	sort_string = "KAAAC"

/datum/design/item/mining/pick_diamond
	id = "pick_diamond"
	req_tech = list(TECH_MATERIAL = 6)
	materials = list("diamond" = 3000)
	build_path = /obj/item/weapon/pickaxe/diamond
	sort_string = "KAAAD"

/datum/design/item/mining/drill_diamond
	id = "drill_diamond"
	req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "glass" = 1000, "diamond" = 2000)
	build_path = /obj/item/weapon/pickaxe/diamonddrill
	sort_string = "KAAAE"

/datum/design/item/mining/depth_scanner
	desc = "Used to check spatial depth and density of rock outcroppings."
	id = "depth_scanner"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2, TECH_BLUESPACE = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 1000,"glass" = 1000)
	build_path = /obj/item/device/depth_scanner
	sort_string = "KAAAF"

/datum/design/item/mining/ano_scanner
	name = "Alden-Saraspova counter"
	id = "ano_scanner"
	desc = "Aids in triangulation of exotic particles."
	req_tech = list(TECH_BLUESPACE = 3, TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 10000,"glass" = 5000)
	build_path = /obj/item/device/ano_scanner
	sort_string = "VAEAA"