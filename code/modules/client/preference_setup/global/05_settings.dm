/datum/preferences
	var/list/preference_values

/datum/category_item/player_setup_item/player_global/settings
	name = "Settings"
	sort_order = 5

/datum/category_item/player_setup_item/player_global/settings/load_preferences(datum/pref_record_reader/R)
	pref.lastchangelog = R.read("lastchangelog")
	pref.default_slot = R.read("default_slot")
	pref.slot_names = R.read("slot_names")
	pref.preference_values = R.read("preference_values")
	pref.use_slot_priority_list = R.read("use_preference_slots")
	var/list/slot_data = R.read("preference_slots")
	for(var/slot_id in slot_data)
		var/datum/preferences_slot/new_slot = new()
		new_slot.slot = text2num(slot_id)
		pref.slot_priority_list.Add(new_slot)

/datum/category_item/player_setup_item/player_global/settings/save_preferences(datum/pref_record_writer/W)
	W.write("lastchangelog", pref.lastchangelog)
	W.write("default_slot", pref.default_slot)
	W.write("slot_names", pref.slot_names)
	W.write("preference_values", pref.preference_values)
	W.write("use_preference_slots", pref.use_slot_priority_list)
	var/list/slot_data = list()
	for(var/datum/preferences_slot/slot in pref.slot_priority_list)
		slot_data.Add("[slot.slot]")
	W.write("preference_slots", slot_data)

/datum/category_item/player_setup_item/player_global/settings/sanitize_preferences()
	// Ensure our preferences are lists.
	if(!istype(pref.preference_values))
		pref.preference_values = list()
	if(!istype(pref.slot_names))
		pref.slot_names = list()

	var/list/client_preference_keys = list()
	for(var/cp in get_client_preferences())
		var/datum/client_preference/client_pref = cp
		client_preference_keys |= client_pref.key
		// if the preference has never been set, or if the player is no longer allowed to set the it, set it to default
		var/mob/mob = preference_mob()
		if(!client_pref.may_set(pref.client) || !(client_pref.key in pref.preference_values))
			pref.preference_values[client_pref.key] = client_pref.default_value
		client_pref.started(mob, pref.preference_values[client_pref.key])

	// Clean out preferences that no longer exist.
	for(var/key in pref.preference_values)
		if(!(key in client_preference_keys))
			pref.preference_values -= key

	for(var/i = length(pref.slot_priority_list), i>=1, i--)
		var/datum/preferences_slot/slot = pref.slot_priority_list[i]
		if(!istype(slot, /datum/preferences_slot) || !slot.slot)
			pref.slot_priority_list.Remove(slot)

	if(length(pref.slot_priority_list) > config.maximum_queued_characters)
		pref.slot_priority_list.Cut(config.maximum_queued_characters + 1, length(pref.slot_priority_list))

	if(!length(pref.slot_priority_list))
		var/datum/preferences_slot/slot = new()
		slot.slot = pref.default_slot
		pref.slot_priority_list.Add(slot)
		pref.load_slot(slot)

	pref.use_slot_priority_list = config.maximum_queued_characters > 1 ? pref.use_slot_priority_list : FALSE

	pref.lastchangelog	= sanitize_text(pref.lastchangelog, initial(pref.lastchangelog))
	pref.default_slot	= sanitize_integer(pref.default_slot, 1, config.character_slots, initial(pref.default_slot))

/datum/category_item/player_setup_item/player_global/settings/content(mob/user)
	. = list()
	. += "<b>Preferences</b><br>"
	. += "<table>"

	var/mob/pref_mob = preference_mob()
	for(var/cp in get_client_preferences())
		var/datum/client_preference/client_pref = cp

		if(!client_pref.may_set(pref_mob))
			continue

		. += "<tr><td>[client_pref.description]: </td>"

		var/selected_option = pref_mob.get_preference_value(client_pref.key)
		for(var/option in client_pref.options)
			var/is_selected = selected_option == option
			. += "<td><a class='[is_selected ? "linkOn" : ""]' href='byond://?src=\ref[src];pref=[client_pref.key];value=[option]'><b>[option]</b></a>"

		. += "</tr>"

	. += "</table>"

	return jointext(., null)

/datum/category_item/player_setup_item/player_global/settings/OnTopic(href,list/href_list, mob/user)
	var/mob/pref_mob = preference_mob()

	if(href_list["pref"] && href_list["value"])
		. = pref_mob.set_preference(href_list["pref"], href_list["value"])

	if(.)
		return TOPIC_REFRESH

	return ..()

/client/proc/get_preference_value(preference)
	if(prefs)
		var/datum/client_preference/cp = get_client_preference(preference)
		if(cp && prefs.preference_values)
			return prefs.preference_values[cp.key]
		else
			return null

/client/proc/set_preference(preference, set_preference)
	var/datum/client_preference/cp = get_client_preference(preference)

	if(!cp)
		return FALSE

	if((prefs.preference_values[cp.key] != set_preference) && (set_preference in cp.options))
		prefs.preference_values[cp.key] = set_preference
		cp.changed(mob, set_preference)
		return TRUE

	return FALSE

/client/proc/cycle_preference(preference)
	var/datum/client_preference/cp = get_client_preference(preference)

	if(!cp)
		return FALSE

	var/next_option = next_in_list(prefs.preference_values[cp.key], cp.options)
	return set_preference(preference, next_option)

/mob/proc/get_preference_value(preference)
	if(!client)
		var/datum/client_preference/cp = get_client_preference(preference)
		if(cp)
			return cp.default_value
		else
			return null

	return client.get_preference_value(preference)

/mob/proc/set_preference(preference, set_preference)
	if(!client)
		return FALSE
	if(!client.prefs)
		log_debug("Client prefs found to be null for mob [src] and client [ckey], this should be investigated.")
		return FALSE

	return client.set_preference(preference, set_preference)

/mob/proc/cycle_preference(preference)
	if(!client)
		return FALSE
	if(!client.prefs)
		log_debug("Client prefs found to be null for mob [src] and client [ckey], this should be investigated.")
		return FALSE

	return client.cycle_preference(preference)
