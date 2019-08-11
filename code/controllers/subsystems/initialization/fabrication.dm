SUBSYSTEM_DEF(fabrication)
	name = "Fabrication"
	flags = SS_NO_FIRE
	init_order = SS_INIT_MISC
	var/list/recipes =    list()
	var/list/categories = list()

/datum/controller/subsystem/fabrication/Initialize()
	for(var/R in typesof(/datum/fabricator_recipe)-/datum/fabricator_recipe)
		var/datum/fabricator_recipe/recipe = new R
		recipes += recipe
		categories |= recipe.category
		var/obj/item/I = new recipe.path
		if(I.matter && !recipe.resources) //This can be overidden in the datums.
			recipe.resources = list()
			for(var/material in I.matter)
				recipe.resources[material] = I.matter[material] * FABRICATOR_EXTRA_COST_FACTOR
		qdel(I)
	. = ..()

/datum/controller/subsystem/fabrication/proc/get_categories(var/fabricator_type)
	. = categories | "All"

/datum/controller/subsystem/fabrication/proc/get_recipes(var/fabricator_type)
	. = recipes | "All"
