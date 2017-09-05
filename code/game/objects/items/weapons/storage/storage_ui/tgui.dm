/datum/storage_ui/tgui
	var/cached_ui_data

/datum/storage_ui/tgui/ui_host()
	return storage.ui_host()

/datum/storage_ui/tgui/show_to(var/mob/user)
	tg_ui_interact(user)

/datum/storage_ui/tgui/hide_from(var/mob/user)
	tg_ui_interact(user)

/datum/storage_ui/tgui/close_all()
	tgui_process.close_uis(src)

/datum/storage_ui/tgui/on_open(var/mob/user)
	tg_ui_interact(user)

/datum/storage_ui/tgui/on_insertion(var/mob/user)
	cached_ui_data = null
	tg_ui_interact(user)

/datum/storage_ui/tgui/on_post_remove(var/mob/user, var/obj/item/W)
	cached_ui_data = null
	tg_ui_interact(user)

/datum/storage_ui/tgui/tg_ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = tg_physical_state)
	ui = tgui_process.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "storage", storage.name, 340, 440, master_ui, state)
		ui.open()

/datum/storage_ui/tgui/ui_data()
	if(!cached_ui_data)

		var/list/items_by_name_and_type = list()
		for(var/obj/item/W in storage)
			group_by(items_by_name_and_type, "[W.name]§[W.type]", W)

		var/list/item_list = list()
		for(var/name_and_type in items_by_name_and_type)
			var/list/items = items_by_name_and_type[name_and_type]
			var/obj/item/first_item = items[1]
			item_list[++item_list.len] = list("name" = first_item.name, "type" = first_item.type, "amount" = items.len)

		cached_ui_data = list(
			"items" = item_list
		)

	return cached_ui_data

/datum/storage_ui/tgui/ui_act(action, params)
	if(..())
		return TRUE

	if(action == "remove_item")
		if(remove_item_by_name_and_type(params["name"], params["type"]))
			return TRUE

/datum/storage_ui/tgui/proc/remove_item_by_name_and_type(var/name, var/type_name)
	if(!istext(name) || !istext(type_name))
		return FALSE
	var/type = text2path(type_name)
	if(!type)
		return FALSE
	for(var/obj/item/W in storage)
		if(W.name == name && W.type == type)
			if(storage.remove_from_storage(W))
				return TRUE
	return FALSE
