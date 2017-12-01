/datum/preferences
	var/list/all_underwear
	var/list/all_underwear_metadata

	var/decl/backpack_outfit/backpack
	var/list/backpack_metadata

/datum/category_item/player_setup_item/general/equipment
	name = "Clothing"
	sort_order = 4

	var/static/list/backpacks_by_name

/datum/category_item/player_setup_item/general/equipment/New()
	..()
	if(!backpacks_by_name)
		backpacks_by_name = list()
		var/bos = decls_repository.get_decls_of_subtype(/decl/backpack_outfit)
		for(var/bo in bos)
			var/decl/backpack_outfit/backpack_outfit = bos[bo]
			backpacks_by_name[backpack_outfit.name] = backpack_outfit

/datum/category_item/player_setup_item/general/equipment/load_character(var/savefile/S)
	var/load_backbag

	from_file(S["all_underwear"], pref.all_underwear)
	from_file(S["all_underwear_metadata"], pref.all_underwear_metadata)
	from_file(S["backpack"], load_backbag)
	from_file(S["backpack_metadata"], pref.backpack_metadata)

	pref.backpack = backpacks_by_name[load_backbag] || get_default_outfit_backpack()

/datum/category_item/player_setup_item/general/equipment/save_character(var/savefile/S)
	to_file(S["all_underwear"], pref.all_underwear)
	to_file(S["all_underwear_metadata"], pref.all_underwear_metadata)
	to_file(S["backpack"], pref.backpack.name)
	to_file(S["backpack_metadata"], pref.backpack_metadata)

/datum/category_item/player_setup_item/general/equipment/sanitize_character()
	if(!istype(pref.all_underwear))
		pref.all_underwear = list()

		for(var/datum/category_group/underwear/WRC in GLOB.underwear.categories)
			for(var/datum/category_item/underwear/WRI in WRC.items)
				if(WRI.is_default(pref.gender ? pref.gender : MALE))
					pref.all_underwear[WRC.name] = WRI.name
					break

	if(!istype(pref.all_underwear_metadata))
		pref.all_underwear_metadata = list()

	for(var/underwear_category in pref.all_underwear)
		var/datum/category_group/underwear/UWC = GLOB.underwear.categories_by_name[underwear_category]
		if(!UWC)
			pref.all_underwear -= underwear_category
		else
			var/datum/category_item/underwear/UWI = UWC.items_by_name[pref.all_underwear[underwear_category]]
			if(!UWI)
				pref.all_underwear -= underwear_category

	for(var/underwear_metadata in pref.all_underwear_metadata)
		if(!(underwear_metadata in pref.all_underwear))
			pref.all_underwear_metadata -= underwear_metadata

	if(!pref.backpack || !(pref.backpack.name in backpacks_by_name))
		pref.backpack = get_default_outfit_backpack()

	if(!istype(pref.backpack_metadata))
		pref.backpack_metadata = list()

	for(var/backpack_metadata_name in pref.backpack_metadata)
		if(!(backpack_metadata_name in backpacks_by_name))
			pref.backpack_metadata -= backpack_metadata_name

	for(var/backpack_name in backpacks_by_name)
		var/decl/backpack_outfit/backpack = backpacks_by_name[backpack_name]
		var/list/tweak_metadata = pref.backpack_metadata["[backpack]"]
		if(tweak_metadata)
			for(var/tw in backpack.tweaks)
				var/datum/backpack_tweak/tweak = tw
				var/list/metadata = tweak_metadata["[tweak]"]
				tweak_metadata["[tweak]"] = tweak.validate_metadata(metadata)


/datum/category_item/player_setup_item/general/equipment/content()
	. = list()
	. += "<b>Equipment:</b><br>"
	for(var/datum/category_group/underwear/UWC in GLOB.underwear.categories)
		var/item_name = (pref.all_underwear && pref.all_underwear[UWC.name]) ? pref.all_underwear[UWC.name] : "None"
		. += "[UWC.name]: <a href='?src=\ref[src];change_underwear=[UWC.name]'><b>[item_name]</b></a>"

		var/datum/category_item/underwear/UWI = UWC.items_by_name[item_name]
		if(UWI)
			for(var/datum/gear_tweak/gt in UWI.tweaks)
				. += " <a href='?src=\ref[src];underwear=[UWC.name];tweak=\ref[gt]'>[gt.get_contents(get_underwear_metadata(UWC.name, gt))]</a>"

		. += "<br>"
	. += "Backpack Type: <a href='?src=\ref[src];change_backpack=1'><b>[pref.backpack.name]</b></a>"
	for(var/datum/backpack_tweak/bt in pref.backpack.tweaks)
		. += " <a href='?src=\ref[src];backpack=[pref.backpack.name];tweak=\ref[bt]'>[bt.get_ui_content(get_backpack_metadata(pref.backpack, bt))]</a>"
	. += "<br>"
	return jointext(.,null)

/datum/category_item/player_setup_item/general/equipment/proc/get_underwear_metadata(var/underwear_category, var/datum/gear_tweak/gt)
	var/metadata = pref.all_underwear_metadata[underwear_category]
	if(!metadata)
		metadata = list()
		pref.all_underwear_metadata[underwear_category] = metadata

	var/tweak_data = metadata["[gt]"]
	if(!tweak_data)
		tweak_data = gt.get_default()
		metadata["[gt]"] = tweak_data
	return tweak_data

/datum/category_item/player_setup_item/general/equipment/proc/get_backpack_metadata(var/decl/backpack_outfit/backpack_outfit, var/datum/backpack_tweak/bt)
	var/metadata = pref.backpack_metadata[backpack_outfit.name]
	if(!metadata)
		metadata = list()
		pref.backpack_metadata[backpack_outfit.name] = metadata

	var/tweak_data = metadata["[bt]"]
	if(!tweak_data)
		tweak_data = bt.get_default_metadata()
		metadata["[bt]"] = tweak_data
	return tweak_data

/datum/category_item/player_setup_item/general/equipment/proc/set_underwear_metadata(var/underwear_category, var/datum/gear_tweak/gt, var/new_metadata)
	var/list/metadata = pref.all_underwear_metadata[underwear_category]
	metadata["[gt]"] = new_metadata

/datum/category_item/player_setup_item/general/equipment/proc/set_backpack_metadata(var/decl/backpack_outfit/backpack_outfit, var/datum/backpack_tweak/bt, var/new_metadata)
	var/metadata = pref.backpack_metadata[backpack_outfit.name]
	metadata["[bt]"] = new_metadata

/datum/category_item/player_setup_item/general/equipment/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["change_underwear"])
		var/datum/category_group/underwear/UWC = GLOB.underwear.categories_by_name[href_list["change_underwear"]]
		if(!UWC)
			return TOPIC_NOACTION
		var/datum/category_item/underwear/selected_underwear = input(user, "Choose underwear:", "Character Preference", pref.all_underwear[UWC.name]) as null|anything in UWC.items
		if(selected_underwear && CanUseTopic(user))
			pref.all_underwear[UWC.name] = selected_underwear.name
		return TOPIC_REFRESH_UPDATE_PREVIEW
	else if(href_list["underwear"] && href_list["tweak"])
		var/underwear = href_list["underwear"]
		if(!(underwear in pref.all_underwear))
			return TOPIC_NOACTION
		var/datum/gear_tweak/gt = locate(href_list["tweak"])
		if(!gt)
			return TOPIC_NOACTION
		var/new_metadata = gt.get_metadata(user, get_underwear_metadata(underwear, gt))
		if(new_metadata)
			set_underwear_metadata(underwear, gt, new_metadata)
			return TOPIC_REFRESH_UPDATE_PREVIEW
	else if(href_list["change_backpack"])
		var/new_backpack = input(user, "Choose backpack style:", "Character Preference", pref.backpack) as null|anything in backpacks_by_name
		if(!isnull(new_backpack) && CanUseTopic(user))
			pref.backpack = backpacks_by_name[new_backpack]
			return TOPIC_REFRESH_UPDATE_PREVIEW
	else if(href_list["backpack"] && href_list["tweak"])
		var/backpack_name = href_list["backpack"]
		if(!(backpack_name in backpacks_by_name))
			return TOPIC_NOACTION
		var/decl/backpack_outfit/bo = backpacks_by_name[backpack_name]
		var/datum/backpack_tweak/bt = locate(href_list["tweak"]) in bo.tweaks
		if(!bt)
			return TOPIC_NOACTION
		var/new_metadata = bt.get_metadata(user, get_backpack_metadata(bo, bt))
		if(new_metadata)
			set_backpack_metadata(bo, bt, new_metadata)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	return ..()

/datum/category_item/player_setup_item/general/equipment/update_setup(var/savefile/preferences, var/savefile/character)
	if(preferences["version"]  <= 16)
		var/list/old_index_to_backpack_type = list(
			/decl/backpack_outfit/nothing,
			/decl/backpack_outfit/backpack,
			/decl/backpack_outfit/satchel,
			/decl/backpack_outfit/messenger_bag,
			/decl/backpack_outfit/satchel,
			/decl/backpack_outfit/satchel,
			/decl/backpack_outfit/pocketbook
		)

		var/old_index
		from_file(character["backbag"], old_index)

		if(old_index > 0 && old_index <= old_index_to_backpack_type.len)
			pref.backpack = decls_repository.get_decl(old_index_to_backpack_type[old_index])
		else
			pref.backpack = get_default_outfit_backpack()

		to_file(character["backpack"], pref.backpack.name)
		return 1
