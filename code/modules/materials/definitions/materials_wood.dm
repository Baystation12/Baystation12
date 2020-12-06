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
	icon_colour = WOOD_COLOR_CHOCOLATE //the very concept of wood should be brown
	display_name = "wood"
	stack_type = null
	shard_type = SHARD_NONE
	sale_price = null
	hidden_from_codex = TRUE

/material/wood/mahogany
	name = MATERIAL_MAHOGANY
	lore_text = "Mahogany is prized for its beautiful grain and rich colour, and as such is typically used for fine furniture and cabinetry."
	adjective_name = MATERIAL_MAHOGANY
	icon_colour = WOOD_COLOR_RICH
	construction_difficulty = 2
	sale_price = 3

/material/wood/maple
	name = MATERIAL_MAPLE
	lore_text = "Owing to its fast growth and ease of working, silver maple is a popular wood for flooring and furniture."
	adjective_name = MATERIAL_MAPLE
	icon_colour = WOOD_COLOR_PALE

/material/wood/ebony
	name = MATERIAL_EBONY
	lore_text = "Ebony is the name for a group of dark coloured, extremely dense, and fine grained hardwoods. \
				Despite gene modification to produce larger source trees and ample land to plant them on, \
				genuine ebony remains a luxury for the very wealthy thanks to the price fixing efforts of intergalactic luxuries cartels. \
				Most people will only ever touch ebony in small items, such as chess pieces, or the accent pieces of a fine musical instrument."
	adjective_name = MATERIAL_EBONY
	icon_colour = WOOD_COLOR_BLACK
	weight = 22
	construction_difficulty = 4
	sale_price = 4

/material/wood/walnut
	name = MATERIAL_WALNUT
	lore_text = "Walnut is a dense hardwood that polishes to a very fine finish. \
				Walnut is especially favoured for construction of figurines (where it contrasts with lighter coloured woods) and tables. \
				The ultimate aspiration of many professionals is an office with a vintage walnut desk, the bigger and heavier the better."
	adjective_name = MATERIAL_WALNUT
	icon_colour = WOOD_COLOR_CHOCOLATE
	weight = 20
	construction_difficulty = 2
	sale_price = 2