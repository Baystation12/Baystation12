/material/plastic
	name = MATERIAL_PLASTIC
	lore_text = "A generic polymeric material. Probably the most flexible and useful substance ever created by human science; mostly used to make disposable cutlery."
	stack_type = /obj/item/stack/material/plastic
	flags = MATERIAL_BRITTLE
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = COLOR_WHITE
	hardness = 10
	weight = 5
	melting_point = T0C+371 //assuming heat resistant plastic
	stack_origin_tech = list(TECH_MATERIAL = 3)
	conductive = 0
	construction_difficulty = MATERIAL_NORMAL_DIY
	chem_products = list(
				/datum/reagent/toxin/plasticide = 20
				)
	sale_price = 1

/material/plastic/holographic
	name = "holo" + MATERIAL_PLASTIC
	display_name = MATERIAL_PLASTIC
	stack_type = null
	shard_type = SHARD_NONE
	sale_price = null
	hidden_from_codex = TRUE

/material/cardboard
	name = MATERIAL_CARDBOARD
	lore_text = "What with the difficulties presented by growing plants in orbit, a stock of cardboard in space is probably more valuable than gold."
	stack_type = /obj/item/stack/material/cardboard
	flags = MATERIAL_BRITTLE
	integrity = 10
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#aaaaaa"
	hardness = 1
	brute_armor = 1
	weight = 1
	ignition_point = T0C+232 //"the temperature at which book-paper catches fire, and burns." close enough
	melting_point = T0C+232 //temperature at which cardboard walls would be destroyed
	stack_origin_tech = list(TECH_MATERIAL = 1)
	door_icon_base = "wood"
	destruction_desc = "crumples"
	conductive = 0
	value = 0

/material/cloth //todo
	name = MATERIAL_CLOTH
	display_name ="cotton"
	use_name = "cotton"
	icon_colour = "#ffffff"
	stack_origin_tech = list(TECH_MATERIAL = 2)
	door_icon_base = "wood"
	ignition_point = T0C+232
	melting_point = T0C+300
	flags = MATERIAL_PADDING
	brute_armor = 1
	conductive = 0
	stack_type = null
	hidden_from_codex = TRUE
	construction_difficulty = MATERIAL_NORMAL_DIY

/material/cloth/carpet
	name = "carpet"
	display_name = "red"
	use_name = "red upholstery"
	icon_colour = "#9d2300"
	sheet_singular_name = "tile"
	sheet_plural_name = "tiles"

/material/cloth/yellow
	name = "yellow"
	display_name ="yellow"
	use_name = "yellow cloth"
	icon_colour = "#ffbf00"

/material/cloth/teal
	name = "teal"
	display_name = "teal"
	use_name = "teal cloth"
	icon_colour = "#00e1ff"

/material/cloth/black
	name = "black"
	display_name = "black"
	use_name = "black cloth"
	icon_colour = "#505050"

/material/cloth/green
	name = "green"
	display_name = "green"
	use_name = "green cloth"
	icon_colour = "#b7f27d"

/material/cloth/puple
	name = "purple"
	display_name = "purple"
	use_name = "purple cloth"
	icon_colour = "#9933ff"

/material/cloth/blue
	name = "blue"
	display_name = "blue"
	use_name = "blue cloth"
	icon_colour = "#46698c"

/material/cloth/beige
	name = "beige"
	display_name = "beige"
	use_name = "beige cloth"
	icon_colour = "#ceb689"

/material/cloth/lime
	name = "lime"
	display_name = "lime"
	use_name = "lime cloth"
	icon_colour = "#62e36c"

/material/leather
	name = MATERIAL_LEATHER
	icon_colour = "#5c4831"
	stack_origin_tech = list(TECH_MATERIAL = 2)
	flags = MATERIAL_PADDING
	ignition_point = T0C+300
	melting_point = T0C+300
	conductive = 0
	stack_type = null
	hidden_from_codex = TRUE
	construction_difficulty = MATERIAL_NORMAL_DIY
	value = 3

/material/carpet
	name = MATERIAL_CARPET
	display_name = "red"
	use_name = "red upholstery"
	icon_colour = "#9d2300"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	sheet_singular_name = "tile"
	sheet_plural_name = "tiles"
	conductive = 0
	stack_type = null
	construction_difficulty = MATERIAL_NORMAL_DIY