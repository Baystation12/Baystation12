/material/plastic
	name = MATERIAL_PLASTIC
	lore_text = "A generic polymeric material. Probably the most flexible and useful substance ever created by human science; mostly used to make disposable cutlery."
	stack_type = /obj/item/stack/material/plastic
	flags = MATERIAL_BRITTLE
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#cccccc"
	hardness = 10
	weight = 5
	melting_point = T0C+371 //assuming heat resistant plastic
	stack_origin_tech = list(TECH_MATERIAL = 3)
	conductive = 0
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

/material/wood
	name = MATERIAL_WOOD
	lore_text = "A fibrous structural material harvested from trees. Don't get a splinter."
	adjective_name = "wooden"
	stack_type = /obj/item/stack/material/wood
	icon_colour = "#824b28"
	integrity = 50
	icon_base = "solid"
	table_icon_base = "solid"
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

/material/cloth //todo
	name = MATERIAL_CLOTH
	stack_origin_tech = list(TECH_MATERIAL = 2)
	door_icon_base = "wood"
	ignition_point = T0C+232
	melting_point = T0C+300
	flags = MATERIAL_PADDING
	brute_armor = 1
	conductive = 0
	stack_type = null
	hidden_from_codex = TRUE

//TODO PLACEHOLDERS:
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

/material/cloth
	name = MATERIAL_COTTON
	display_name ="grey"
	use_name = "grey cloth"
	icon_colour = "#ffffff"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	conductive = 0
	stack_type = null
	hidden_from_codex = TRUE

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
