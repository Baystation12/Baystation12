/datum/codex_category/recipes
	name = "Recipes"
	desc = "Recipes for a variety of reagents."

/datum/codex_category/recipes/Initialize()
	for(var/datum/microwave_recipe/recipe in GLOB.microwave_recipes)
		if(recipe.hidden_from_codex || !recipe.result_path)
			continue

		var/mechanics_text = ""
		if (recipe.mechanics_text)
			mechanics_text = "[recipe.mechanics_text]<br><br>"
		mechanics_text += "This recipe requires the following ingredients:<br><ul>"
		for (var/datum/reagent/reagent as anything in recipe.required_reagents)
			mechanics_text += "<li>[recipe.required_reagents[reagent]]u [initial(reagent.name)]</li>"
		for (var/obj/item/item as anything in recipe.required_items)
			mechanics_text += "<li>\a [initial(item.name)]</li>"
		for (var/tag in recipe.required_produce)
			mechanics_text += "<li>[recipe.required_produce[tag]] [tag]\s</li>"
		mechanics_text += "</ul>"
		var/atom/movable/recipe_product = recipe.result_path
		mechanics_text += "<br>This recipe takes [ceil(recipe.time/10)] second\s to cook in a microwave and creates \a [initial(recipe_product.name)]."
		var/lore_text = recipe.lore_text
		if(!lore_text)
			lore_text = initial(recipe_product.desc)
		var/recipe_name = recipe.display_name
		if(!recipe_name)
			recipe_name = sanitize(initial(recipe_product.name))

		var/datum/codex_entry/entry = new(                   \
		 _display_name =       "[recipe_name] (recipe)",     \
		 _associated_strings = list(lowertext(recipe_name)), \
		 _lore_text =          lore_text,                    \
		 _mechanics_text =     mechanics_text,               \
		 _antag_text =         recipe.antag_text             \
		)
		entry.update_links()
		SScodex.add_entry_by_string(entry.display_name, entry)
		items += entry.display_name
	..()
