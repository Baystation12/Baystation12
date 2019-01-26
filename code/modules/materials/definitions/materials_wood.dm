/material/wood
	name = MATERIAL_WOOD
	lore_text = "A fibrous structural material harvested from an indeterminable plant. Don't get a splinter."
	adjective_name = "wooden"
	stack_type = /obj/item/stack/material/wood
	icon_colour = WOOD_COLOR_GENERIC
	integrity = 50
	icon_base = "solid"
	table_icon_base = "wood"
	explosion_resistance = 2
	shard_type = SHARD_SPLINTER
	shard_can_repair = 0 // you can't weld splinters back into planks
	hardness = 15
	brute_armor = 1
	weight = 18
	melting_point = T0C+300 //okay, not melting in this case, but hot enough to destroy wood
	ignition_point = T0C+288
	stack_origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	dooropen_noise = 'sound/effects/doorcreaky.ogg'
	door_icon_base = "wood"
	destruction_desc = "splinters"
	sheet_singular_name = "plank"
	sheet_plural_name = "planks"
	hitsound = 'sound/effects/woodhit.ogg'
	conductive = 0
	construction_difficulty = 1
	chem_products = list(
				/datum/reagent/carbon = 10,
				/datum/reagent/water = 5
				)
	sale_price = 1

/material/wood/holographic
	name = "holo" + MATERIAL_WOOD
	display_name = "wood"
	stack_type = null
	shard_type = SHARD_NONE
	sale_price = null
	hidden_from_codex = TRUE

/material/wood/fancy
	name = "fancy wood" //giving unique name for sanity - type is only for assigning stuff - do not use
	lore_text = "A piece of fine wood, prized for its beautiful grain and colour."
	construction_difficulty = 3
	sale_price = 3

/material/wood/fancy/mahogany
	name = MATERIAL_MAHOGANY
	adjective_name = MATERIAL_MAHOGANY
	icon_colour = WOOD_COLOR_RICH

/material/wood/fancy/maple
	name = MATERIAL_MAPLE
	adjective_name = MATERIAL_MAPLE
	icon_colour = WOOD_COLOR_PALE

/material/wood/fancy/ebony
	name = MATERIAL_EBONY
	adjective_name = MATERIAL_EBONY
	icon_colour = WOOD_COLOR_BLACK
	weight = 22
	sale_price = 4

/material/wood/fancy/walnut
	name = MATERIAL_WALNUT
	adjective_name = MATERIAL_WALNUT
	icon_colour = WOOD_COLOR_CHOCOLATE