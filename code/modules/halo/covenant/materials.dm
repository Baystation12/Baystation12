


/* NANOLAMINATE */

/material/nanolaminate
	name = "nanolaminate"
	display_name = "nanolaminate"

	shard_can_repair = 0 //I doubt you can melt nanolaminate with a hand welder.

	icon_base = "nanolaminate"
	//door_icon_base = "nanolaminate"
	icon_reinf = "reinf_over"
	stack_origin_tech = list(TECH_MATERIAL = 5)

	cut_delay = 45 SECONDS

	melting_point = 17273

	brute_armor = 15
	burn_armor = 10 //Not as defensive when burn applied.

	integrity = 1800

	explosion_resistance = 30

	stack_type = /obj/item/stack/material/nanolaminate

	hardness = 80
	weight = 25

/material/nanolaminate/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("nanolaminate floor tile", /obj/item/stack/tile/covenant, 1, 4, 20)
	recipes += new/datum/stack_recipe("[display_name] barricade", /obj/structure/destructible/covenant_barricade, 5, one_per_turf = 2, on_floor = 1, time = 50)

/obj/item/stack/material/nanolaminate
	name = "nanolaminate"
	singular_name = "nanolaminate sheets"
	icon = 'code/modules/halo/covenant/materials.dmi'
	icon_state = "nanolaminate"
	default_type = "nanolaminate"
	amount = 1
	max_amount = 50
	material = /material/nanolaminate
	stacktype = /obj/item/stack/material/nanolaminate

/obj/item/stack/material/nanolaminate/ten
	amount = 10

/obj/item/stack/material/nanolaminate/fifty
	amount = 50

/ore/corundum
	name = "corundum"
	display_name = "corundite"
	alloy = 1
	result_amount = 1
	spread_chance = 20
	ore = /obj/item/weapon/ore/corundum
	scan_icon = "mineral_rare"

//techwalled
/*
/datum/alloy/nanolaminate
	metaltag = "nanolaminate"
	requires = list(
		"corundum" = 1,
		"carbon" = 1,
		"mhydrogen" = 1
		)
	product_mod = 0.3
	product = /obj/item/stack/material/nanolaminate
	*/



/* DURIDIUM */

/material/duridium
	name = "duridium"
	display_name = "refined duridium"

	shard_can_repair = 0 //I doubt you can melt nanolaminate with a hand welder.
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	door_icon_base = "stone"
	stack_origin_tech = list(TECH_MATERIAL = 5)

	cut_delay = 120

	melting_point = 17273

	brute_armor = 15
	burn_armor = 10 //Not as defensive when burn applied.

	integrity = 600

	explosion_resistance = 50

	stack_type = /obj/item/stack/material/duridium

	hardness = 80
	weight = 25

/obj/item/stack/material/duridium
	name = "refined duridium"
	icon = 'code/modules/halo/covenant/materials.dmi'
	icon_state = "duridium"
	default_type = "duridium"

/obj/item/stack/material/duridium/ten
	amount = 10

/obj/item/stack/material/duridium/fifty
	amount = 50

/ore/duridium
	name = "duridium"
	display_name = "duridium"
	smelts_to = "duridium"
	ore = /obj/item/weapon/ore/duridium
	scan_icon = "mineral_uncommon"
	result_amount = 2
	spread_chance = 10

//techwalled
/*
/datum/alloy/duridium
	metaltag = "duridium"
	requires = list(
		"duridium" = 1,
		"carbon" = 1,
		"iron" = 1
		)
	product_mod = 0.5
	product = /obj/item/stack/material/duridium
*/


/* KEMOCITE */

/material/kemocite
	name = "kemocite"
	display_name = "compressed kemocite"
	shard_can_repair = 0 //I doubt you can melt nanolaminate with a hand welder.
	icon_base = "stone"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	stack_type = /obj/item/stack/material/kemocite
	icon_reinf = "reinf_stone"
	door_icon_base = "stone"

/obj/item/stack/material/kemocite
	name = "compressed kemocite"
	singular_name = "compressed kemocite ingots"
	icon = 'code/modules/halo/covenant/materials.dmi'
	icon_state = "kemocite_ingot"
	default_type = "kemocite"
	amount = 1
	max_amount = 50
	material = /material/kemocite
	stacktype = /obj/item/stack/material/kemocite

/obj/item/stack/material/kemocite/ten
	amount = 10

/obj/item/stack/material/kemocite/fifty
	amount = 50

/ore/kemocite
	name = "kemocite"
	display_name = "kemocite"
	compresses_to = "kemocite"
	result_amount = 2
	spread_chance = 10
	ore = /obj/item/weapon/ore/kemocite
	scan_icon = "mineral_rare"



/* DRONE BIOMASS */

/material/drone_biomass
	name = "drone biomass"
	display_name = "drone biomass"
	icon_base = "diona"
