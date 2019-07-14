/mob/living
	var/datum/nano_module/craft/CM

//this one is called when you need just a regular CM, without strick tab opened
/mob/living/verb/craft_menu()
	set name = "Craft Menu"
	set category = "IC"
	src.open_craft_menu()

//this is called when you use any proc and not verb, like atack_self and want to give tab name to be opened
/mob/living/proc/open_craft_menu(category = null)
	if(!CM)
		CM = new(src)
	CM.set_category(category, src)
	CM.ui_interact(src)

/datum/nano_module/craft
	name = "Craft menu"
	available_to_ai = FALSE

/datum/nano_module/craft/proc/get_category(mob/mob)
	var/ckey = mob.ckey
	if(!(ckey in SScraft.current_category))
		SScraft.current_category[ckey] = SScraft.cat_names[1]
	return SScraft.current_category[ckey]

/datum/nano_module/craft/proc/set_category(category, mob/mob)
	if(!category || !(category in SScraft.cat_names))
		return FALSE
	SScraft.current_category[mob.ckey] = category
	set_item(null, usr)
	return TRUE

/datum/nano_module/craft/proc/get_item(mob/mob)
	return (mob.ckey in SScraft.current_item) ? SScraft.current_item[mob.ckey] : null

/datum/nano_module/craft/proc/set_item(item_ref, mob/mob)
	SScraft.current_item[mob.ckey] = locate(item_ref)

/datum/nano_module/craft/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = TRUE, var/datum/topic_state/state = GLOB.default_state)
	if(usr.incapacitated())
		return

	var/list/data = list()
	var/curr_category = get_category(usr)

	data["is_admin"] = check_rights(show_msg = FALSE)
	data["categories"] = SScraft.cat_names
	data["cur_category"] = curr_category
	var/datum/craft_recipe/CR = get_item(usr)
	data["cur_item"] = null

	if(CR)
		data["cur_item"] = list(
			"name" = CR.name,
			"icon" = getAtomCacheFilename(CR.result),
			"ref"  = "\ref[CR]",
			"desc" = CR.get_description(),
			"steps" = CR.get_step_descriptions()
		)
	var/list/items = list()
	for(var/datum/craft_recipe/recipe in SScraft.categories[curr_category])
		items += list(list(
			"name" = capitalize(recipe.name),
			"ref" = "\ref[recipe]"
		))
	data["items"] = items


	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "craft.tmpl", "[src]", 800, 450, state = state)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/craft/Topic(href, href_list)
	if(..())
		return TRUE

	if(usr.incapacitated())
		return

	if(href_list["build"])
		var/datum/craft_recipe/CR = locate(href_list["build"])
		CR.try_build(usr)
	else if(href_list["view_vars"] && check_rights())
		usr.client.debug_variables(locate(href_list["view_vars"]))
	else if(href_list["category"])
		set_category(href_list["category"], usr)
		SSnano.update_uis(src)
	else if(href_list["item"])
		set_item(href_list["item"], usr)
		SSnano.update_uis(src)