/material/diamond
	name = MATERIAL_DIAMOND
	lore_text = "An extremely hard allotrope of carbon. Valued for its use in industrial tools."
	stack_type = /obj/item/stack/material/diamond
	flags = MATERIAL_UNMELTABLE
	cut_delay = 60
	icon_colour = COLOR_DIAMOND
	opacity = 0.4
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = MATERIAL_VERY_HARD + 20
	brute_armor = 10
	burn_armor = 50		// Diamond walls are immune to fire, therefore it makes sense for them to be almost undamageable by burn damage type.
	stack_origin_tech = list(TECH_MATERIAL = 6)
	conductive = 0
	construction_difficulty = MATERIAL_VERY_HARD_DIY
	ore_name = "rough diamonds"
	ore_compresses_to = MATERIAL_DIAMOND
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_scan_icon = "mineral_rare"
	xarch_source_mineral = GAS_NITROGEN
	ore_icon_overlay = "gems"
	sale_price = 5
	sheet_singular_name = "gem"
	sheet_plural_name = "gems"
	value = 70

/material/diamond/crystal
	name = MATERIAL_CRYSTAL
	hardness = MATERIAL_VERY_HARD
	stack_type = null
	ore_compresses_to = null
	sale_price = null
	hidden_from_codex = TRUE

/material/stone
	name = MATERIAL_SANDSTONE
	lore_text = "A clastic sedimentary rock. The cost of boosting it to orbit is almost universally much higher than the actual value of the material."
	stack_type = /obj/item/stack/material/sandstone
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#d9c179"
	shard_type = SHARD_STONE_PIECE
	weight = 22
	hardness = MATERIAL_HARD - 5
	brute_armor = 3
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	conductive = 0
	construction_difficulty = MATERIAL_NORMAL_DIY
	chem_products = list(
		/datum/reagent/silicon = 20
		)
	sale_price = 1
	value = 4

/material/stone/marble
	name = MATERIAL_MARBLE
	lore_text = "A metamorphic rock largely sourced from Earth. Prized for use in extremely expensive decorative surfaces."
	icon_colour = "#aaaaaa"
	weight = 26
	hardness = MATERIAL_HARD
	brute_armor = 3
	integrity = 201 //hack to stop kitchen benches being flippable, todo: refactor into weight system
	stack_type = /obj/item/stack/material/marble
	construction_difficulty = MATERIAL_HARD_DIY
	chem_products = null
	sale_price = 4
	value = 20

/material/stone/concrete
	name = MATERIAL_CONCRETE
	lore_text = "The most ubiquitous building material of old Earth, now in space. Consists of mineral aggregate bound with some sort of cementing solution."
	stack_type = /obj/item/stack/material/generic/brick
	icon_colour = COLOR_GRAY
	value = 1
	var/image/texture

/material/stone/concrete/New()
	..()
	texture = image('icons/turf/wall_texture.dmi', "concrete")
	texture.blend_mode = BLEND_MULTIPLY

/material/stone/concrete/get_wall_texture()
	return texture
