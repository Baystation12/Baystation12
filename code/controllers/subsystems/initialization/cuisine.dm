SUBSYSTEM_DEF(cuisine)
	name = "Cuisine"
	flags = SS_NO_FIRE
	init_order = SS_INIT_MISC_LATE
	var/microwave_maximum_item_storage = 0
	var/list/microwave_recipes = list()
	var/list/microwave_accepts_reagents = list()
	var/list/microwave_accepts_items = list(
		/obj/item/weapon/holder,
		/obj/item/weapon/reagent_containers/food/snacks/grown
	)

/datum/controller/subsystem/cuisine/Initialize()

	for (var/recipe_type in subtypesof(/datum/recipe))
		var/datum/recipe/recipe = new recipe_type
		microwave_recipes += recipe
		for(var/thing in recipe.reagents)
			microwave_accepts_reagents |= thing
		for(var/thing in recipe.items)
			microwave_accepts_items |= thing
		microwave_maximum_item_storage = max(microwave_maximum_item_storage, length(recipe.items))
		
	. = ..()
