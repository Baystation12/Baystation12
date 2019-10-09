
/material/glass
	name = MATERIAL_GLASS
	lore_text = "A brittle, transparent material made from molten silicates. It is generally not a liquid."
	stack_type = /obj/item/stack/material/glass
	flags = MATERIAL_BRITTLE
	icon_colour = GLASS_COLOR
	opacity = 0.3
	integrity = 50
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = MATERIAL_RIGID + 10	
	melting_point = T0C + 100
	weight = 14
	brute_armor = 1
	burn_armor = 2
	door_icon_base = "stone"
	table_icon_base = "solid"
	destruction_desc = "shatters"
	window_options = list("One Direction" = 1, "Full Window" = 4, "Windoor" = 5)
	hitsound = 'sound/effects/Glasshit.ogg'
	conductive = 0
	sale_price = 1
	value = 4

/material/glass/proc/is_reinforced()
	return (integrity > 75) //todo

/material/glass/is_brittle()
	return ..() && !is_reinforced()

/material/glass/phoron
	name = MATERIAL_PHORON_GLASS
	lore_text = "An extremely heat-resistant form of glass."
	display_name = "borosilicate glass"
	stack_type = /obj/item/stack/material/glass/phoronglass
	flags = MATERIAL_BRITTLE
	hardness = MATERIAL_HARD
	integrity = 70
	brute_armor = 2
	burn_armor = 5
	melting_point = T0C + 4000
	icon_colour = GLASS_COLOR_PHORON
	stack_origin_tech = list(TECH_MATERIAL = 4)
	wire_product = null
	construction_difficulty = MATERIAL_HARD_DIY
	alloy_product = TRUE
	alloy_materials = list(MATERIAL_SAND = 2500, MATERIAL_PLATINUM = 1250)
	sale_price = 2
	value = 40