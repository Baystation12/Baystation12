// Switch this out to use a database at some point. Each ckey is
// associated with a list of custom item datums. When the character
// spawns, the list is checked and all appropriate datums are spawned.
// See config/example/custom_items.txt for a more detailed overview
// of how the config system works.

// CUSTOM ITEM ICONS:
// Inventory icons must be in CUSTOM_ITEM_OBJ with state name [item_icon].
// On-mob icons must be in CUSTOM_ITEM_MOB with state name [item_icon].
// Inhands must be in CUSTOM_ITEM_MOB as [icon_state]_l and [icon_state]_r.

// Kits must have mech icons in CUSTOM_ITEM_OBJ under [kit_icon].
// Broken must be [kit_icon]-broken and open must be [kit_icon]-open.

// Kits must also have hardsuit icons in CUSTOM_ITEM_MOB as [kit_icon]_suit
// and [kit_icon]_helmet, and in CUSTOM_ITEM_OBJ as [kit_icon].

/var/list/custom_items = list()

/datum/custom_item
	var/assoc_key
	var/character_name
	var/inherit_inhands = 1 //if unset, and inhands are not provided, then the inhand overlays will be invisible.
	var/item_icon
	var/item_desc
	var/name
	var/item_path = /obj/item
	var/req_access = 0
	var/list/req_titles = list()
	var/kit_name
	var/kit_desc
	var/kit_icon
	var/additional_data

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
		if(!istype(item))
			item.icon = CUSTOM_ITEM_OBJ
			item.icon_state = item_icon
			return
		else
			if(inherit_inhands)
				apply_inherit_inhands(item)
			else
				item.item_state_slots = null
				item.item_icons = null

			item.icon = CUSTOM_ITEM_OBJ
			item.icon_state = item_icon
			item.item_state = null
			item.icon_override = CUSTOM_ITEM_MOB

		var/obj/item/clothing/under/U = item
		if(istype(U))
			U.worn_state = U.icon_state
			U.update_rolldown_status()

	// Kits are dumb so this is going to have to be hardcoded/snowflake.
	if(istype(item, /obj/item/device/kit))
		var/obj/item/device/kit/K = item
		K.new_name = kit_name
		K.new_desc = kit_desc
		K.new_icon = kit_icon
		K.new_icon_file = CUSTOM_ITEM_OBJ
		if(istype(item, /obj/item/device/kit/paint))
			var/obj/item/device/kit/paint/kit = item
			kit.allowed_types = text2list(additional_data, ", ")
		else if(istype(item, /obj/item/device/kit/suit))
			var/obj/item/device/kit/suit/kit = item
			kit.new_light_overlay = additional_data
			kit.new_mob_icon_file = CUSTOM_ITEM_MOB

	return item

/datum/custom_item/proc/apply_inherit_inhands(var/obj/item/item)
	var/list/new_item_icons = list()
	var/list/new_item_state_slots = list()

	var/list/available_states = icon_states(CUSTOM_ITEM_MOB)

	//If l_hand or r_hand are not present, preserve them using item_icons/item_state_slots
	//Then use icon_override to make every other slot use the custom sprites by default.
	//This has to be done before we touch any of item's vars
	if(!("[item_icon]_l" in available_states))
		new_item_state_slots[slot_l_hand_str] = get_state(item, slot_l_hand_str, "_l")
		new_item_icons[slot_l_hand_str] = get_icon(item, slot_l_hand_str, 'icons/mob/items/lefthand.dmi')
	if(!("[item_icon]_r" in available_states))
		new_item_state_slots[slot_r_hand_str] = get_state(item, slot_r_hand_str, "_r")
		new_item_icons[slot_r_hand_str] = get_icon(item, slot_r_hand_str, 'icons/mob/items/righthand.dmi')

	item.item_state_slots = new_item_state_slots
	item.item_icons = new_item_icons

//this has to mirror the way update_inv_*_hand() selects the state
/datum/custom_item/proc/get_state(var/obj/item/item, var/slot_str, var/hand_str)
	var/t_state
	if(item.item_state_slots && item.item_state_slots[slot_str])
		t_state = item.item_state_slots[slot_str]
	else if(item.item_state)
		t_state = item.item_state
	else
		t_state = item.icon_state
	if(item.icon_override)
		t_state += hand_str
	return t_state

//this has to mirror the way update_inv_*_hand() selects the icon
/datum/custom_item/proc/get_icon(var/obj/item/item, var/slot_str, var/icon/hand_icon)
	var/icon/t_icon
	if(item.icon_override)
		t_icon = item.icon_override
	else if(item.item_icons && (slot_str in item.item_icons))
		t_icon = item.item_icons[slot_str]
	else
		t_icon = hand_icon
	return t_icon

// Parses the config file into the custom_items list.
/hook/startup/proc/load_custom_items()

	var/datum/custom_item/current_data
	for(var/line in text2list(file2text("config/custom_items.txt"), "\n"))

		line = trim(line)
		if(line == "" || !line || findtext(line, "#", 1, 2))
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
				current_data.item_icon = field_data
			if("inherit_inhands")
				current_data.inherit_inhands = text2num(field_data)
			if("item_desc")
				current_data.item_desc = field_data
			if("req_access")
				current_data.req_access = text2num(field_data)
			if("req_titles")
				current_data.req_titles = text2list(field_data,", ")
			if("kit_name")
				current_data.kit_name = field_data
			if("kit_desc")
				current_data.kit_desc = field_data
			if("kit_icon")
				current_data.kit_icon = field_data
			if("additional_data")
				current_data.additional_data = field_data
	return 1

//gets the relevant list for the key from the listlist if it exists, check to make sure they are meant to have it and then calls the giving function
/proc/equip_custom_items(mob/living/carbon/human/M)
	var/list/key_list = custom_items[M.ckey]
	if(!key_list || key_list.len < 1)
		return

	for(var/datum/custom_item/citem in key_list)

		// Check for requisite ckey and character name.
		if((lowertext(citem.assoc_key) != lowertext(M.ckey)) || (lowertext(citem.character_name) != lowertext(M.real_name)))
			continue

		// Check for required access.
		var/obj/item/weapon/card/id/current_id = M.wear_id
		if(citem.req_access && citem.req_access > 0)
			if(!(istype(current_id) && (citem.req_access in current_id.access)))
				continue

		// Check for required job title.
		if(citem.req_titles && citem.req_titles.len > 0)
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

// Places the item on the target mob.
/proc/place_custom_item(mob/living/carbon/human/M, var/datum/custom_item/citem)

	if(!citem) return
	var/obj/item/newitem = citem.spawn_item()

	if(M.equip_to_appropriate_slot(newitem))
		return newitem

	if(M.equip_to_storage(newitem))
		return newitem

	newitem.loc = get_turf(M.loc)
	return newitem
