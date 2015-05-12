//switch this out to use a database at some point
//list of ckey/ real_name and item paths
//gives item to specific people when they join if it can
//see config/custom_items.txt how to to add things to it (yes crazy idea i know)
//yes, it has to be an item, you can't pick up nonitems

/var/list/custom_items = list()

/datum/custom_item
	var/assoc_key
	var/character_name
	var/item_icon
	var/item_desc
	var/name = "unnamed item"
	var/item_path = /obj/item
	var/req_access = 0
	var/list/req_titles = list()

/datum/custom_item/proc/spawn_item(var/newloc)
	var/obj/item/citem = new item_path(newloc)
	apply_to_item(citem)
	return citem

/datum/custom_item/proc/apply_to_item(var/obj/item/item)
	if(!item)
		return
	if(name)
		item.name = name
	if(item_desc)
		item.desc = item_desc
	if(item_icon)
		item.icon = 'icons/obj/custom_items.dmi'
		item.icon_override = 'icons/mob/custom_items.dmi'
		item.icon_state = item_icon
	return item

//parses the config file into the above listlist
/hook/startup/proc/loadCustomItems()

	var/datum/custom_item/current_data
	for(var/line in text2list(file2text("config/custom_items.txt"), "\n"))

		line = trim(line)
		if(line == "" || !line || findtext(line, "#", 1, 2) || findtext(line, "}", 1, 2))
			continue

		if(findtext(line, "{", 1, 2) || findtext(line, "}", 1, 2)) // New block!
			if(current_data && current_data.assoc_key)
				if(!custom_items[current_data.assoc_key])
					custom_items[current_data.assoc_key] = list()
				var/list/L = custom_items[current_data.assoc_key]
				L |= current_data
			current_data = null

		var/split = findtext(line,":")
		if(!split)
			continue
		var/field = trim(copytext(line,1,split))
		var/field_data = trim(copytext(line,(split+1)))
		if(!field || !field_data)
			continue

		if(!current_data)
			current_data = new()

		switch(field)
			if("ckey")
				current_data.assoc_key = lowertext(field_data)
			if("character_name")
				current_data.character_name = lowertext(field_data)
			if("item_path")
				current_data.item_path = text2path(field_data)
			if("item_name")
				current_data.name = field_data
			if("item_icon")
				if(field_data in icon_states('icons/obj/custom_items.dmi'))
					current_data.item_icon = field_data
			if("item_desc")
				current_data.item_desc = field_data
			if("req_access")
				current_data.req_access = field_data
			if("req_titles")
				current_data.req_titles = text2list(field_data,", ")

	return 1

//gets the relevant list for the key from the listlist if it exists, check to make sure they are meant to have it and then calls the giving function
/proc/EquipCustomItems(mob/living/carbon/human/M)
	return

	var/list/key_list = custom_items[M.ckey]
	if(!key_list || key_list.len < 1)
		return

	for(var/datum/custom_item/citem in key_list)

		// Check for requisite ckey and character name.
		if(citem.assoc_key != M.ckey || citem.character_name != M.real_name)
			continue

		// Check for required access.
		var/obj/item/weapon/card/id/current_id = M.wear_id
		if(citem.req_access && !(istype(current_id) && (citem.req_access in current_id.access)))
			continue

		// Check for required job title.
		var/has_title
		var/current_title = M.mind.role_alt_title ? M.mind.role_alt_title : M.mind.assigned_role
		for(var/title in citem.req_titles)
			if(title == current_title)
				has_title = 1
				break
		if(!has_title)
			continue

		// ID cards and PDAs are applied directly to the existing object rather than spawned fresh.
		var/obj/item/existing_item
		if(citem.item_path == /obj/item/weapon/card/id && istype(current_id)) //Set earlier.
			existing_item = M.wear_id
		else if(citem.item_path == /obj/item/device/pda)
			existing_item = locate(/obj/item/device/pda) in M.contents

		// Spawn and equip the item.
		if(existing_item)
			citem.apply_to_item(existing_item)
		else
			place_custom_item(M,citem)
		return

// Places the item on the target mob.
/proc/place_custom_item(mob/living/carbon/human/M, var/datum/custom_item/citem)

	if(!citem) return
	var/obj/item/newitem = citem.spawn_item()

	if(M.equip_to_appropriate_slot(newitem))
		return newitem

	if(istype(M.back,/obj/item/weapon/storage))
		var/obj/item/weapon/storage/backpack = M.back
		if(backpack.contents.len < backpack.storage_slots)
			newitem.loc = M.back
			return newitem

	// Try to place it in any item that can store stuff, on the mob.
	for(var/obj/item/weapon/storage/S in M.contents)
		if (S.contents.len < S.storage_slots)
			newitem.loc = S
			return newitem
	newitem.loc = get_turf(M.loc)
	return newitem