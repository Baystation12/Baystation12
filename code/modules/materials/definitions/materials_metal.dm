/material/uranium
	name = MATERIAL_URANIUM
	stack_type = /obj/item/stack/material/uranium
	radioactivity = 12
	icon_base = "stone"
	door_icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#007a00"
	weight = 22
	stack_origin_tech = list(TECH_MATERIAL = 5)
	chem_products = list(
				/datum/reagent/uranium = 20
				)
	construction_difficulty = 2
	sale_price = 2

/material/gold
	name = MATERIAL_GOLD
	stack_type = /obj/item/stack/material/gold
	icon_colour = "#ffcc33"
	weight = 25
	hardness = 25
	integrity = 100
	stack_origin_tech = list(TECH_MATERIAL = 4)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	chem_products = list(
				/datum/reagent/gold = 20
				)
	construction_difficulty = 1
	ore_smelts_to = MATERIAL_GOLD
	ore_result_amount = 5
	ore_name = "native gold"
	ore_spread_chance = 10
	ore_scan_icon = "mineral_uncommon"
	xarch_ages = list(
		"thousand" = 999,
		"million" = 999,
		"billion" = 4,
		"billion_lower" = 3
		)
	ore_icon_overlay = "nugget"
	sale_price = 3

/material/gold/bronze //placeholder for ashtrays
	name = MATERIAL_BRONZE
	icon_colour = "#edd12f"
	construction_difficulty = 1
	ore_smelts_to = null
	ore_compresses_to = null
	sale_price = null

/material/copper
	name = MATERIAL_COPPER
	icon_colour = "#b87333"
	weight = 15
	hardness = 30
	stack_origin_tech = list(TECH_MATERIAL = 2)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	chem_products = list(
		/datum/reagent/copper = 12,
		/datum/reagent/silver = 8
		)
	construction_difficulty = 1
	ore_smelts_to = MATERIAL_COPPER
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = "tetrahedrite"
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "shiny"
	sale_price = 1

/material/silver
	name = MATERIAL_SILVER
	stack_type = /obj/item/stack/material/silver
	icon_colour = "#d1e6e3"
	weight = 22
	hardness = 50
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	chem_products = list(
				/datum/reagent/silver = 20
				)
	construction_difficulty = 1
	ore_smelts_to = MATERIAL_SILVER
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = "native silver"
	ore_scan_icon = "mineral_uncommon"
	ore_icon_overlay = "shiny"
	sale_price = 2

/material/steel
	name = MATERIAL_STEEL
	stack_type = /obj/item/stack/material/steel
	integrity = 150
	brute_armor = 5
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#666666"
	hitsound = 'sound/weapons/smash.ogg'
	chem_products = list(
				/datum/reagent/iron = 15,
				/datum/reagent/carbon = 5
				)
	alloy_materials = list(MATERIAL_HEMATITE = 1875, MATERIAL_GRAPHENE = 1875)
	alloy_product = TRUE
	sale_price = 1
	ore_smelts_to = MATERIAL_STEEL

/material/steel/holographic
	name = "holo" + MATERIAL_STEEL
	display_name = MATERIAL_STEEL
	stack_type = null
	shard_type = SHARD_NONE
	conductive = 0
	alloy_materials = null
	alloy_product = FALSE
	sale_price = null

/material/plasteel
	name = MATERIAL_PLASTEEL
	stack_type = /obj/item/stack/material/plasteel
	integrity = 400
	melting_point = 6000
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#777777"
	explosion_resistance = 25
	brute_armor = 6
	burn_armor = 10
	hardness = 80
	weight = 23
	stack_origin_tech = list(TECH_MATERIAL = 2)
	hitsound = 'sound/weapons/smash.ogg'
	construction_difficulty = 1
	alloy_materials = list(MATERIAL_STEEL = 2500, MATERIAL_PLATINUM = 1250)
	alloy_product = TRUE
	sale_price = 2
	ore_smelts_to = MATERIAL_PLASTEEL

/material/plasteel/titanium
	name = MATERIAL_TITANIUM
	brute_armor = 10
	burn_armor = 8
	integrity = 200
	melting_point = 3000
	weight = 18
	stack_type = null
	icon_base = "metal"
	door_icon_base = "metal"
	icon_colour = "#d1e6e3"
	icon_reinf = "reinf_metal"
	construction_difficulty = 1
	alloy_materials = null
	alloy_product = FALSE

/material/plasteel/ocp
	name = MATERIAL_OSMIUM_CARBIDE_PLASTEEL
	stack_type = /obj/item/stack/material/ocp
	integrity = 200
	melting_point = 12000
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#9bc6f2"
	brute_armor = 4
	burn_armor = 20
	weight = 27
	stack_origin_tech = list(TECH_MATERIAL = 3)
	alloy_materials = list(MATERIAL_PLASTEEL = 7500, MATERIAL_OSMIUM = 3750)
	construction_difficulty = 2
	alloy_product = TRUE
	sale_price = 3

/material/osmium
	name = MATERIAL_OSMIUM
	stack_type = /obj/item/stack/material/osmium
	icon_colour = "#9999ff"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	construction_difficulty = 1
	sale_price = 3
	ore_smelts_to = MATERIAL_OSMIUM

/material/tritium
	name = MATERIAL_TRITIUM
	stack_type = /obj/item/stack/material/tritium
	icon_colour = "#777777"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1
	construction_difficulty = 2

/material/deuterium
	name = MATERIAL_DEUTERIUM
	stack_type = /obj/item/stack/material/deuterium
	icon_colour = "#999999"
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1
	construction_difficulty = 2

/material/mhydrogen
	name = MATERIAL_HYDROGEN
	display_name = "metallic hydrogen"
	stack_type = /obj/item/stack/material/mhydrogen
	icon_colour = "#e6c5de"
	stack_origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 6, TECH_MAGNET = 5)
	is_fusion_fuel = 1
	chem_products = list(
				/datum/reagent/hydrazine = 20
				)
	construction_difficulty = 2
	ore_smelts_to = MATERIAL_TRITIUM
	ore_compresses_to = MATERIAL_HYDROGEN
	ore_name = "raw hydrogen"
	ore_scan_icon = "mineral_rare"
	ore_icon_overlay = "gems"
	sale_price = 5

/material/platinum
	name = MATERIAL_PLATINUM
	stack_type = /obj/item/stack/material/platinum
	icon_colour = "#9999ff"
	weight = 27
	stack_origin_tech = list(TECH_MATERIAL = 2)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	construction_difficulty = 1
	ore_smelts_to = MATERIAL_PLATINUM
	ore_compresses_to = MATERIAL_OSMIUM
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = "raw platinum"
	ore_scan_icon = "mineral_rare"
	ore_icon_overlay = "shiny"
	sale_price = 5

/material/iron
	name = MATERIAL_IRON
	stack_type = /obj/item/stack/material/iron
	icon_colour = "#5c5454"
	weight = 22
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	hitsound = 'sound/weapons/smash.ogg'
	chem_products = list(
				/datum/reagent/iron = 20
				)
	sale_price = 1

// Adminspawn only, do not let anyone get this.
/material/voxalloy
	name = MATERIAL_VOX
	display_name = "durable alloy"
	stack_type = null
	icon_colour = "#6c7364"
	integrity = 1200
	melting_point = 6000       // Hull plating.
	explosion_resistance = 200 // Hull plating.
	hardness = 500
	weight = 500
	construction_difficulty = 1

// Likewise.
/material/voxalloy/elevatorium
	name = MATERIAL_ELEVATORIUM
	display_name = "elevator panelling"
	icon_colour = "#666666"
	construction_difficulty = 2

/material/aliumium
	name = MATERIAL_ALIUMIUM
	display_name = "alien alloy"
	stack_type = null
	icon_base = "jaggy"
	door_icon_base = "metal"
	icon_reinf = "reinf_metal"
	hitsound = 'sound/weapons/smash.ogg'
	sheet_singular_name = "chunk"
	sheet_plural_name = "chunks"
	stack_type = /obj/item/stack/material/aliumium
	construction_difficulty = 2

/material/aliumium/New()
	icon_base = "metal"
	icon_colour = rgb(rand(10,150),rand(10,150),rand(10,150))
	explosion_resistance = rand(25,40)
	brute_armor = rand(10,20)
	burn_armor = rand(10,20)
	hardness = rand(15,100)
	integrity = rand(200,400)
	melting_point = rand(400,10000)
	..()

/material/aliumium/place_dismantled_girder(var/turf/target, var/material/reinf_material)
	return

/material/hematite
	name = MATERIAL_HEMATITE
	stack_type = null
	icon_colour = "#aa6666"
	ore_smelts_to = MATERIAL_IRON
	ore_result_amount = 5
	ore_spread_chance = 25
	ore_scan_icon = "mineral_common"
	ore_name = "hematite"
	ore_icon_overlay = "lump"
	sale_price = 1
