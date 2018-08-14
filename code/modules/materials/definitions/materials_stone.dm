/material/diamond
	name = "diamond"
	stack_type = /obj/item/stack/material/diamond
	flags = MATERIAL_UNMELTABLE
	cut_delay = 60
	icon_colour = "#00ffe1"
	opacity = 0.4
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 100
	brute_armor = 10
	burn_armor = 50		// Diamond walls are immune to fire, therefore it makes sense for them to be almost undamageable by burn damage type.
	stack_origin_tech = list(TECH_MATERIAL = 6)
	conductive = 0
	construction_difficulty = 2
	ore_compresses_to = "diamond"
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_scan_icon = "mineral_rare"
	xarch_source_mineral = "nitrogen"
	ore_icon_overlay = "gems"
	sale_price = 5

/material/diamond/crystal
	name = "crystal"
	hardness = 80
	stack_type = null
	ore_compresses_to = null
	sale_price = null

/material/stone
	name = "sandstone"
	stack_type = /obj/item/stack/material/sandstone
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#d9c179"
	shard_type = SHARD_STONE_PIECE
	weight = 22
	hardness = 55
	brute_armor = 3
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	conductive = 0
	construction_difficulty = 1
	chem_products = list(
		/datum/reagent/silicon = 20
		)
	sale_price = 1

/material/stone/marble
	name = "marble"
	icon_colour = "#aaaaaa"
	weight = 26
	hardness = 60
	brute_armor = 3
	integrity = 201 //hack to stop kitchen benches being flippable, todo: refactor into weight system
	stack_type = /obj/item/stack/material/marble
	chem_products = null
