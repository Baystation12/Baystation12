/obj/item/weapon/tool/surgicaldrill
	name = "surgical drill"
	desc = "You can drill using this item. You dig?"
	icon_state = "drill"
	hitsound = WORKSOUND_DRIVER_TOOL
	worksound = WORKSOUND_DRIVER_TOOL
	matter = list(MATERIAL_STEEL = 1200, MATERIAL_PLASTIC = 800)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = WEAPON_FORCE_DANGEROUS
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("drilled")
	tool_qualities = list(QUALITY_DRILLING = 30)

	use_power_cost = 0.24
	suitable_cell = /obj/item/weapon/cell


/obj/item/weapon/tool/shiv
	name = "sharv"
	desc = "A pointy piece of glass, abraded to an edge and wrapped in tape for a handle."