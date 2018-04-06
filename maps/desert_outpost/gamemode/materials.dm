
#if !defined(MATERIAL_RECIPES_OVERRIDE)
	#define MATERIAL_RECIPES_OVERRIDE 1

/material/proc/get_recipes()
	if(!recipes)
		generate_recipes()
	return recipes

/material/proc/generate_recipes()
	recipes = list()

/material/steel/generate_recipes()
	recipes = list()

	recipes += new/datum/stack_recipe("[display_name] blade", /obj/item/weapon/material/butterflyblade, 6, time = 20, one_per_turf = 0, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("metal rod", /obj/item/stack/rods, 1, 2, 60)
	recipes += new/datum/stack_recipe("table frame", /obj/structure/table, 1, time = 10, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("rack", /obj/structure/table/rack, 1, time = 5, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("closet", /obj/structure/closet, 2, time = 15, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("grenade casing", /obj/item/weapon/grenade/chem_grenade)
	recipes += new/datum/stack_recipe("metal crate", /obj/structure/closet/crate, 10, time = 50, one_per_turf = 1)
	recipes += new/datum/stack_recipe("metal barrel", /obj/structure/barrel, 10, time = 50, one_per_turf = 1)
	recipes += new/datum/stack_recipe("barbed wire coil", /obj/item/stack/barbedwire, time = 30)
	recipes += new/datum/stack_recipe("tank trap", /obj/structure/tanktrap, 4, one_per_turf = 1, on_floor = 1, time = 50)


/material/stone/generate_recipes()
	recipes = list()

	recipes += new/datum/stack_recipe("planting bed", /obj/machinery/portable_atmospherics/hydroponics/soil, 3, time = 10, one_per_turf = 1, on_floor = 1)


/material/plastic/generate_recipes()
	recipes = list()

	recipes += new/datum/stack_recipe("plastic crate", /obj/structure/closet/crate/plastic, 10, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("plastic bag", /obj/item/weapon/storage/bag/plasticbag, 3, on_floor = 1)
	recipes += new/datum/stack_recipe("blood pack", /obj/item/weapon/reagent_containers/blood/empty, 4, on_floor = 0)


/material/wood/generate_recipes()
	recipes = list()

	recipes += new/datum/stack_recipe("crossbow frame", /obj/item/weapon/crossbowframe, 5, time = 25, one_per_turf = 0, on_floor = 0)
	recipes += new/datum/stack_recipe("coffin", /obj/structure/closet/coffin, 5, time = 15, one_per_turf = 1, on_floor = 1)
	recipes += new/datum/stack_recipe("zip gun frame", /obj/item/weapon/zipgunframe, 5)
	recipes += new/datum/stack_recipe("coilgun stock", /obj/item/weapon/coilgun_assembly, 5)
	recipes += new/datum/stack_recipe("knife grip", /obj/item/weapon/material/butterflyhandle, 4, time = 20, one_per_turf = 0, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("[display_name] door", /obj/machinery/door/unpowered/simple, 10, time = 50, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("[display_name] barricade", /obj/structure/barricade, 5, time = 50, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")

/material/cloth/generate_recipes()
	recipes = list()

	recipes += new/datum/stack_recipe("empty sandbags", /obj/item/empty_sandbags, 1, time = 30)

#else

	#warn Recipes conflict, unable to use stranded gamemode recipes

#endif