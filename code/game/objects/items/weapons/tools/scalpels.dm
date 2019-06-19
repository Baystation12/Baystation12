/obj/item/weapon/tool/scalpel
	name = "scalpel"
	desc = "Cut, cut, and once more cut."
	icon_state = "scalpel_t3"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = WEAPON_FORCE_PAINFULL
	sharp = TRUE
	edge = TRUE
	w_class = ITEM_SIZE_TINY
	worksound = WORKSOUND_HARD_SLASH
	slot_flags = SLOT_EARS
	throw_speed = WEAPON_FORCE_WEAK
	throw_range = 5
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	matter = list(MATERIAL_STEEL = 4)
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	tool_qualities = list(QUALITY_CUTTING = 30, QUALITY_WIRE_CUTTING = 10)

/obj/item/weapon/tool/scalpel/advanced
	name = "advanced scalpel"
	desc = "Made of more expensive materials, sharper and generally more reliable."
	icon_state = "scalpel_t4"
	matter = list(MATERIAL_STEEL = 5)
	tool_qualities = list(QUALITY_CUTTING = 40, QUALITY_WIRE_CUTTING = 10)
	degradation = 0.12
	max_upgrades = 4

/obj/item/weapon/tool/scalpel/laser
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field."
	icon_state = "scalpel_t5"
	damtype = "fire"
	force = WEAPON_FORCE_DANGEROUS
	matter = list(MATERIAL_STEEL = 4, MATERIAL_PLASTIC = 4)
	tool_qualities = list(QUALITY_CUTTING = 50, QUALITY_WIRE_CUTTING = 20, QUALITY_LASER_CUTTING = 40)
	degradation = 0.11
	use_power_cost = 0.12
	suitable_cell = /obj/item/weapon/cell
	max_upgrades = 4


//A makeshift knife, for doing all manner of cutting and stabbing tasks in a half-assed manner
/obj/item/weapon/tool/shiv
	name = "shiv"
	desc = "A pointy piece of glass, abraded to an edge and wrapped in tape for a handle."
	icon_state = "impro_shiv"
	worksound = WORKSOUND_HARD_SLASH
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	matter = list(MATERIAL_GLASS = 1)
	sharp = TRUE
	edge = TRUE
	force = WEAPON_FORCE_NORMAL
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	tool_qualities = list(QUALITY_CUTTING = 15, QUALITY_WIRE_CUTTING = 5, QUALITY_DRILLING = 10)
	degradation = 4 //Gets worse with use