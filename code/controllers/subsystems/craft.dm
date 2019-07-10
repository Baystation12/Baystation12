SUBSYSTEM_DEF(craft)
	name = "Craft"
	init_order = SS_INIT_CRAFT
	flags = SS_NO_FIRE
	var/list/categories //list of craft_recipe objects(datums)
	var/list/cat_names //list of strings from craft_recipe.category

	var/global/list/current_category = list()
	var/global/list/current_item = list()

/datum/controller/subsystem/craft/Initialize(timeofday)
	categories = list()
	cat_names = list()
	for(var/path in subtypesof(/datum/craft_recipe))
		var/datum/craft_recipe/CR = path
		if(!initial(CR.name))
			continue
		CR = new CR
		cat_names |= CR.category
		if(!CR.steps.len)
			qdel(CR)
		if(!(CR.category in categories))
			categories[CR.category] = list()
		categories[CR.category] += CR
		CHECK_TICK


