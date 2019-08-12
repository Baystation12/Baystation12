SUBSYSTEM_DEF(fabrication)
	name = "Fabrication"
	flags = SS_NO_FIRE
	init_order = SS_INIT_MISC_LATE
	var/list/recipes =    list()
	var/list/categories = list()

/datum/controller/subsystem/fabrication/Initialize()
	for(var/R in subtypesof(/datum/fabricator_recipe))
		var/datum/fabricator_recipe/recipe = new R
		for(var/fab_type in recipe.fabricator_types)
			LAZYADD(recipes[fab_type], recipe)
			LAZYDISTINCTADD(categories[fab_type], recipe.category)
	. = ..()

/datum/controller/subsystem/fabrication/proc/get_categories(var/fab_type)
	. = categories[fab_type]

/datum/controller/subsystem/fabrication/proc/get_recipes(var/fab_type)
	. = recipes[fab_type]
