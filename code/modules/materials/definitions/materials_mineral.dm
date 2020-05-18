/material/pitchblende
	name = MATERIAL_PITCHBLENDE
	ore_compresses_to = MATERIAL_PITCHBLENDE
	icon_colour = "#917d1a"
	ore_smelts_to = MATERIAL_URANIUM
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = "pitchblende"
	ore_scan_icon = "mineral_uncommon"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	xarch_ages = list(
		"thousand" = 999,
		"million" = 704
		)
	xarch_source_mineral = "potassium"
	ore_icon_overlay = "nugget"
	chem_products = list(
		/datum/reagent/radium = 10,
		/datum/reagent/uranium = 10
		)
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	sale_price = 2

/material/graphite
	name = MATERIAL_GRAPHITE
	ore_compresses_to = MATERIAL_GRAPHITE
	icon_colour = "#444444"
	ore_smelts_to = MATERIAL_PLASTIC
	ore_name = "graphite"
	ore_smelts_to = MATERIAL_PLASTIC
	ore_result_amount = 5
	ore_spread_chance = 25
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	chem_products = list(
		/datum/reagent/carbon = 15,
		/datum/reagent/acetone = 5
		)
	sale_price = 1

/material/quartz
	name = MATERIAL_QUARTZ
	ore_compresses_to = MATERIAL_QUARTZ
	ore_name = "quartz"
	opacity = 0.5
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#effffe"
	chem_products = list(
		/datum/reagent/silicon = 20
		)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	sale_price = 2

/material/pyrite
	name = MATERIAL_PYRITE
	ore_name = "pyrite"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#ccc9a3"
	chem_products = list(
		/datum/reagent/sulfur = 15,
		/datum/reagent/iron = 5
		)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	ore_compresses_to = MATERIAL_PYRITE
	sale_price = 2

/material/spodumene
	name = MATERIAL_SPODUMENE
	ore_compresses_to = MATERIAL_SPODUMENE
	ore_name = "spodumene"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#e5becb"
	chem_products = list(
		/datum/reagent/lithium = 20
		)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	sale_price = 2

/material/cinnabar
	name = MATERIAL_CINNABAR
	ore_compresses_to = MATERIAL_CINNABAR
	ore_name = "cinnabar"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#e54e4e"
	chem_products = list(
		/datum/reagent/mercury  = 20
	)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	sale_price = 2

/material/phosphorite
	name = MATERIAL_PHOSPHORITE
	ore_compresses_to = MATERIAL_PHOSPHORITE
	ore_name = "phosphorite"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#acad95"
	chem_products = list(
		/datum/reagent/phosphorus = 20
	)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	sale_price = 2

/material/rocksalt
	name = MATERIAL_ROCK_SALT
	ore_compresses_to = MATERIAL_ROCK_SALT
	ore_name = "rock salt"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#d1c0bc"
	chem_products = list(
		/datum/reagent/sodium = 20
	)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	sale_price = 2

/material/potash
	name = MATERIAL_POTASH
	ore_compresses_to = MATERIAL_POTASH
	ore_name = "potash"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#b77464"
	chem_products = list(
		/datum/reagent/potassium = 20
		)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	sale_price = 2

/material/bauxite
	name = MATERIAL_BAUXITE
	ore_name = "bauxite"
	ore_result_amount = 10
	ore_spread_chance = 10
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	icon_colour = "#d8ad97"
	chem_products = list(
		/datum/reagent/aluminium = 15
		)
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	ore_smelts_to = MATERIAL_ALUMINIUM
	ore_compresses_to = MATERIAL_BAUXITE
	sale_price = 1

/material/sand
	name = MATERIAL_SAND
	stack_type = null
	icon_colour = "#e2dbb5"
	ore_smelts_to = MATERIAL_GLASS
	ore_compresses_to = MATERIAL_SANDSTONE
	ore_name = "sand"
	ore_icon_overlay = "dust"
	chem_products = list(
		/datum/reagent/silicon = 20
		)

/material/phoron
	name = MATERIAL_PHORON
	stack_type = /obj/item/stack/material/phoron
	ignition_point = PHORON_MINIMUM_BURN_TEMPERATURE
	icon_base = "stone"
	table_icon_base = "stone"
	icon_colour = "#e37108"
	shard_type = SHARD_SHARD
	hardness = MATERIAL_RIGID
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_PHORON = 2)
	door_icon_base = "stone"
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"
	is_fusion_fuel = 1
	chem_products = list(
		/datum/reagent/toxin/phoron = 20
		)
	construction_difficulty = MATERIAL_HARD_DIY
	ore_name = "phoron"
	ore_compresses_to = MATERIAL_PHORON
	ore_result_amount = 5
	ore_spread_chance = 25
	ore_scan_icon = "mineral_uncommon"
	xarch_ages = list(
		"thousand" = 999,
		"million" = 999,
		"billion" = 13,
		"billion_lower" = 10
		)
	xarch_source_mineral = MATERIAL_PHORON
	ore_icon_overlay = "gems"
	sale_price = 5
	value = 200

/material/phoron/supermatter
	name = MATERIAL_SUPERMATTER
	lore_text = "Hypercrystalline supermatter is a subset of non-baryonic 'exotic' matter. It is found mostly in the heart of large stars, and features heavily in bluespace technology."
	icon_colour = "#ffff00"
	radioactivity = 20
	stack_origin_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 6, TECH_PHORON = 4)
	stack_type = null
	luminescence = 3
	ore_compresses_to = null
	sale_price = null

//Controls phoron and phoron based objects reaction to being in a turf over 200c -- Phoron's flashpoint.
/material/phoron/combustion_effect(var/turf/T, var/temperature, var/effect_multiplier)
	if(isnull(ignition_point))
		return 0
	if(temperature < ignition_point)
		return 0
	var/totalPhoron = 0
	for(var/turf/simulated/floor/target_tile in range(2,T))
		var/phoronToDeduce = (temperature/30) * effect_multiplier
		totalPhoron += phoronToDeduce
		target_tile.assume_gas(GAS_PHORON, phoronToDeduce, 200+T0C)
		spawn (0)
			target_tile.hotspot_expose(temperature, 400)
	return round(totalPhoron/100)
