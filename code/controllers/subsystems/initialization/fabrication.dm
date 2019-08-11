SUBSYSTEM_DEF(fabrication)
	name = "Fabrication"
	flags = SS_NO_FIRE
	init_order = SS_INIT_MISC_LATE
	var/list/recipes =    list()
	var/list/categories = list()

/datum/controller/subsystem/fabrication/Initialize()
	for(var/R in subtypesof(/datum/fabricator_recipe))

		// Create and update recipe datum.
		var/datum/fabricator_recipe/recipe = new R
		var/obj/item/I = new recipe.path
		if(I.matter && !recipe.resources) //This can be overidden in the datums.
			recipe.resources = list()
			for(var/material in I.matter)
				recipe.resources[material] = I.matter[material] * FABRICATOR_EXTRA_COST_FACTOR
		qdel(I)

		// Add to appropriate lists.
		for(var/fab_type in recipe.fabricator_types)
			recipes[fab_type] =    recipes[fab_type]    || list() 
			categories[fab_type] = categories[fab_type] || list() 
			recipes[fab_type]      |= recipe
			categories[fab_type]   |= recipe.category

	. = ..()

/datum/controller/subsystem/fabrication/proc/get_categories(var/fab_type)
	. = categories[fab_type]

/datum/controller/subsystem/fabrication/proc/get_recipes(var/fab_type)
	. = recipes[fab_type]
