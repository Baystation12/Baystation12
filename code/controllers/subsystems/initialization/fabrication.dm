SUBSYSTEM_DEF(fabrication)
	name = "Fabrication"
	flags = SS_NO_FIRE
	init_order = SS_INIT_MISC_LATE

	/**
	 * List of lists(Strings => Paths - Subtypes of `/datum/fabricator_recipe`). Global list of fabricator recipes. Set during `Initialize()`.
	 *
	 * Example formatting:
	 * ```dm
	 * 	list(
	 * 		"general" = list(
	 * 			/datum/fabricator_recipe/A,
	 * 			/datum/fabricator_recipe/B
	 * 		),
	 * 		"microlathe" = list(
	 * 			/datum/fabricator_recipe/C,
	 * 			/datum/fabricator_recipe/D
	 * 		)
	 * 	)
	 * ```
	 */
	var/static/list/recipes = list()

	/**
	 * List of lists (Strings => Strings). Global list of recipe categories. These are pulled from the recipes provided in `recipes`. Set during `Initialize()`.
	 *
	 * Example formatting:
	 * ```dm
	 * 	list(
	 * 		"general" = list(
	 * 			"Arms and Ammunition",
	 * 			"Devices and Components"
	 * 		),
	 * 		"microlathe" = list(
	 * 			"Cutlery",
	 * 			"Drinking Glasses"
	 * 		)
	 * 	)
	 * ```
	 */
	var/static/list/categories = list()

	/**
	 * List of lists (Paths (`/obj/item`) => Paths (`/singleting/crafting_stage`)). Global list of crafting stages. These are pulled from each crafting stage's `begins_with_object_type` var. Set during `Initialize()`.
	 */
	var/static/list/stages_by_type = list()


/datum/controller/subsystem/fabrication/UpdateStat(time)
	return


/datum/controller/subsystem/fabrication/Initialize(start_uptime)
	for (var/datum/fabricator_recipe/recipe as anything in subtypesof(/datum/fabricator_recipe))
		recipe = new recipe
		if (!recipe.name)
			continue
		for (var/type in recipe.fabricator_types)
			if (!recipes[type])
				recipes[type] = list()
			recipes[type] += recipe
			if (!categories[type])
				categories[type] = list()
			categories[type] |= recipe.category
	var/list/stages = GET_SINGLETON_SUBTYPE_MAP(/singleton/crafting_stage)
	for (var/id in stages)
		var/singleton/crafting_stage/stage = stages[id]
		var/type = stage.begins_with_object_type
		if (!ispath(type))
			continue
		if (!stages_by_type[type])
			stages_by_type[type] = list()
		stages_by_type[type] |= stage


/**
 * Retrieves a list of categories for the given root type.
 *
 * **Parameters**:
 * - `type` - The root type to fetch from the `categories` list.
 *
 * Returns list of strings. The categories associated with the given root type.
 */
/datum/controller/subsystem/fabrication/proc/get_categories(type)
	return categories[type]


/**
 * Retrieves a list of recipes for the given root type.
 *
 * **Parameters**:
 * - `type` - The root type to fetch from the `recipes` list.
 *
 * Returns list of paths (`/datum/fabricator_recipe`). The recipes associated with the given root type.
 */
/datum/controller/subsystem/fabrication/proc/get_recipes(type)
	return recipes[type]


/**
 * Retrieves a list of crafting stages for the given type path.
 *
 * **Parameters**:
 * - `type` - The object type path to fetch from the `stages_by_type` list.
 *
 * Returns list of paths (`/singleton/crafting_stage`). The initial crafting stages with the given type set as their `begins_with_object_type`.
 */
/datum/controller/subsystem/fabrication/proc/find_crafting_recipes(type)
	if (isnull(stages_by_type[type]))
		stages_by_type[type] = FALSE
		for (var/match in stages_by_type)
			if (ispath(type, match))
				stages_by_type[type] = stages_by_type[match]
				break
	return stages_by_type[type]


/**
 * Attempts to start a crafting stage using the target and tool.
 *
 * **Parameters**:
 * - `target` - The target object. This will be compared with `begins_with_object_type` from crafting stages.
 * - `tool` - The item being used. This will be compared with `completion_trigger_type` from crafting stages.
 * - `user` - The mob performing the interaction.
 *
 * Has no return value.
 */
/datum/controller/subsystem/fabrication/proc/try_craft_with(obj/item/target, obj/item/tool, mob/user)
	var/turf/turf = get_turf(target)
	if (!turf)
		return
	var/list/stages = SSfabrication.find_crafting_recipes(target.type)
	for (var/singleton/crafting_stage/stage in stages)
		if (stage.can_begin_with(target) && stage.is_appropriate_tool(tool))
			var/obj/item/crafting_holder/crafting = new (turf, stage, target, tool, user)
			if (stage.progress_to(tool, user, crafting))
				return crafting
			qdel(crafting)
