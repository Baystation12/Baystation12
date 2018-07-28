/material/pitchblende
	name = "pitchblende"
	stack_type = null
	icon_colour = "#917d1a"
	ore_smelts_to = "uranium"
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

/material/graphene
	name = "graphene"
	stack_type = null
	icon_colour = "#444444"
	ore_smelts_to = "plastic"
	ore_name = "graphene"
	ore_smelts_to = "plastic"
	ore_result_amount = 5
	ore_spread_chance = 25
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"

/material/sand
	name = "sand"
	stack_type = null
	icon_colour = "#e2dbb5"
	ore_smelts_to = "glass"
	ore_compresses_to = "sandstone"
	ore_name = "sand"
	ore_icon_overlay = "dust"

/material/phoron
	name = "phoron"
	stack_type = /obj/item/stack/material/phoron
	ignition_point = PHORON_MINIMUM_BURN_TEMPERATURE
	icon_base = "stone"
	table_icon_base = "stone"
	icon_colour = "#e37108"
	shard_type = SHARD_SHARD
	hardness = 30
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_PHORON = 2)
	door_icon_base = "stone"
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"
	is_fusion_fuel = 1
	chem_products = list(
				/datum/reagent/toxin/phoron = 20
				)
	construction_difficulty = 2
	ore_name = "phoron"
	ore_compresses_to = "phoron"
	ore_result_amount = 5
	ore_spread_chance = 25
	ore_scan_icon = "mineral_uncommon"
	xarch_ages = list(
		"thousand" = 999,
		"million" = 999,
		"billion" = 13,
		"billion_lower" = 10
		)
	xarch_source_mineral = "phoron"
	ore_icon_overlay = "gems"

/material/phoron/supermatter
	name = "supermatter"
	icon_colour = "#ffff00"
	radioactivity = 20
	stack_origin_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 6, TECH_PHORON = 4)
	stack_type = null
	luminescence = 3
	ore_compresses_to = null

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
		target_tile.assume_gas("phoron", phoronToDeduce, 200+T0C)
		spawn (0)
			target_tile.hotspot_expose(temperature, 400)
	return round(totalPhoron/100)
