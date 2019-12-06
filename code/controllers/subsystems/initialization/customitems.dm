SUBSYSTEM_DEF(customitems)
	name = "Custom Items"
	flags = SS_NO_FIRE
	init_order = SS_INIT_MISC_LATE

	var/list/custom_items_by_ckey = list()
	var/list/item_states = list()
	var/list/mob_states =  list()

/datum/controller/subsystem/customitems/Initialize()

	item_states = icon_states(CUSTOM_ITEM_OBJ)
	mob_states =  icon_states(CUSTOM_ITEM_MOB)

	if(!fexists(CUSTOM_ITEM_CONFIG))
		report_progress("Custom item directory [CUSTOM_ITEM_CONFIG] does not exist, no custom items will be loaded.")
		return

	var/dir_count = -1
	var/item_count = 0
	var/list/directories_to_check = list(CUSTOM_ITEM_CONFIG)
	while(length(directories_to_check))
		var/checkdir = directories_to_check[1]
		directories_to_check -= checkdir
		if(checkdir == "[CUSTOM_ITEM_CONFIG]examples/")
			continue
		for(var/checkfile in flist(checkdir))
			checkfile = "[checkdir][checkfile]"
			if(copytext(checkfile, -1) == "/")
				directories_to_check += checkfile
				dir_count++
			else if(copytext(checkfile, -5) == ".json")
				try
					var/datum/custom_item/citem = new(json_decode(file2text(checkfile)))
					var/result = citem.validate()
					if(result)
						crash_with("Invalid custom item [checkfile]: [result]")
					else
						LAZYDISTINCTADD(custom_items_by_ckey[citem.ckey], citem)
						item_count++
				catch(var/exception/e)
					crash_with("Exception loading custom item [checkfile]: [e] on [e.file]:[e.line]")

	report_progress("Loaded [item_count] custom item\s from [dir_count] director[dir_count == 1 ? "y" : "ies"].")
	. = ..()

// Places the item on the target mob.
/datum/controller/subsystem/customitems/proc/place_custom_item(mob/living/carbon/human/M, var/datum/custom_item/citem)
	. = M && citem && citem.spawn_item(get_turf(M))
	if(. && !M.equip_to_appropriate_slot(.) && !M.equip_to_storage(.))
		to_chat(M, SPAN_WARNING("Your custom item, \the [.], could not be placed on your character."))
		QDEL_NULL(.)

//gets the relevant list for the key from the listlist if it exists, check to make sure they are meant to have it and then calls the giving function
/datum/controller/subsystem/customitems/proc/equip_custom_items(mob/living/carbon/human/M)
	var/list/key_list = custom_items_by_ckey[M.ckey]
	if(!length(key_list))
		return
	for(var/datum/custom_item/citem in key_list)
		// Check for requisite ckey and character name.
		if(citem.ckey != M.ckey || lowertext(citem.character_name) != lowertext(M.real_name))
			continue
		// Check for required access.
		var/obj/item/weapon/card/id/current_id = M.wear_id
		if(length(citem.req_access) && (!istype(current_id) || !has_access(current_id.access, citem.req_access)))
			continue
		// Check for required job title.
		if(length(citem.req_titles))
			var/check_title = M.mind.role_alt_title || M.mind.assigned_role
			if(!(check_title in citem.req_titles))
				continue

		// Spawn and equip the item.
		if(ispath(citem.apply_to_target_type))
			var/obj/item/existing_item = (locate(citem.apply_to_target_type) in M.get_contents())
			if(existing_item)
				citem.apply_to_item(existing_item)
				return
		place_custom_item(M,citem)

/datum/custom_item
	var/ckey
	var/character_name
	var/item_icon_state
	var/item_desc
	var/item_name
	var/item_path
	var/apply_to_target_type
	var/list/req_access
	var/list/req_titles
	var/list/additional_data

/datum/custom_item/New(var/list/data)
	ckey                 = ckey(data["ckey"])
	character_name       = lowertext(data["character_name"])
	item_name            = data["item_name"]
	item_desc            = data["item_desc"]
	item_icon_state      = data["item_icon_state"]
	item_path            = text2path(data["item_path"])
	req_access           = data["req_access"]                      || list()
	req_titles           = data["req_titles"]                      || list()
	additional_data      = data["additional_data"]                 || list()
	apply_to_target_type = text2path(data["apply_to_target_type"]) || data["apply_to_target_type"]

/datum/custom_item/proc/validate()
	if(!ispath(item_path, /obj/item))
		return SPAN_WARNING("The given item path is invalid or does not exist.")
	if(apply_to_target_type && !ispath(apply_to_target_type, /obj/item))
		return SPAN_WARNING("The target item path is invalid or does not exist.")
	else if(item_icon_state)
		if(ispath(item_path, /obj/item/device/kit/suit))
			for(var/state in list("[item_icon_state]_suit", "[item_icon_state]_helmet"))
				if(!(state in SScustomitems.item_states))
					return SPAN_WARNING("The given item icon [state] does not exist.")
				if(!(state in SScustomitems.mob_states))
					return SPAN_WARNING("The given mob icon [state] does not exist.")
		else
			for(var/state in list(item_icon_state))
				if(!(state in SScustomitems.item_states))
					return SPAN_WARNING("The given item icon [state] does not exist.")

/datum/custom_item/proc/spawn_item(var/newloc)
	. = new item_path(newloc)
	apply_to_item(.)

/datum/custom_item/proc/apply_to_item(var/obj/item/item)
	. = item.inherit_custom_item_data(src)
