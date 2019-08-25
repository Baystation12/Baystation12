/obj/item/weapon/tool/saw
	name = "metal saw"
	desc = "For cutting wood and other objects to pieces. Or sawing bones, in case of emergency."
	icon_state = "metal_saw"
	force = WEAPON_FORCE_NORMAL
	throwforce = WEAPON_FORCE_NORMAL
	worksound = WORKSOUND_SIMPLE_SAW
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	throw_speed = 3
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	attack_verb = list("attacked", "slashed", "sawed", "cut")
	sharp = TRUE
	edge = TRUE
	tool_qualities = list(QUALITY_SAWING = 30, QUALITY_CUTTING = 20, QUALITY_WIRE_CUTTING = 20)
	//embed_mult = 1 //Serrated blades catch on bone more easily

/obj/item/weapon/tool/saw/improvised
	name = "choppa"
	desc = "A wicked serrated blade made of whatever nasty sharp things you could find. It would make a pretty decent weapon"
	icon_state = "impro_saw"
	force = WEAPON_FORCE_PAINFULL
	tool_qualities = list(QUALITY_SAWING = 15, QUALITY_CUTTING = 10, QUALITY_WIRE_CUTTING = 10)
	degradation = 0.7

/obj/item/weapon/tool/saw/circular
	name = "circular saw"
	desc = "For heavy duty cutting."
	icon_state = "saw"
	hitsound = WORKSOUND_CIRCULAR_SAW
	worksound = WORKSOUND_CIRCULAR_SAW
	force = WEAPON_FORCE_ROBUST
	matter = list(MATERIAL_STEEL = 1000, MATERIAL_PLASTIC = 600)
	tool_qualities = list(QUALITY_SAWING = 40, QUALITY_CUTTING = 30, QUALITY_WIRE_CUTTING = 30)

	use_power_cost = 0.15
	suitable_cell = /obj/item/weapon/cell

/obj/item/weapon/tool/saw/advanced_circular
	name = "advanced circular saw"
	desc = "You think you can cut anything with it."
	icon_state = "advanced_saw"
	hitsound = WORKSOUND_CIRCULAR_SAW
	worksound = WORKSOUND_CIRCULAR_SAW
	force = WEAPON_FORCE_ROBUST
	matter = list(MATERIAL_STEEL = 1200, MATERIAL_PLASTIC = 800)
	tool_qualities = list(QUALITY_SAWING = 50, QUALITY_CUTTING = 40, QUALITY_WIRE_CUTTING = 40)
	degradation = 0.07
	use_power_cost = 0.22
	suitable_cell = /obj/item/weapon/cell
	max_upgrades = 4

/obj/item/weapon/tool/saw/chain
	name = "chainsaw"
	desc = "You can cut trees, people walls and zombies with it, just watch out for fuel."
	icon_state = "chainsaw"
	hitsound = WORKSOUND_CHAINSAW
	worksound = WORKSOUND_CHAINSAW
	force = WEAPON_FORCE_ROBUST
	matter = list(MATERIAL_STEEL = 3000, MATERIAL_PLASTIC = 3000)
	tool_qualities = list(QUALITY_SAWING = 60, QUALITY_CUTTING = 50, QUALITY_WIRE_CUTTING = 20)
	max_upgrades = 4
	use_fuel_cost = 0.1
	max_fuel = 80
