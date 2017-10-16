/datum/preferences
	var/list/preference_values

/datum/category_item/player_setup_item/player_global/settings
	name = "Settings"
	sort_order = 2

/datum/category_item/player_setup_item/player_global/settings/load_preferences(var/savefile/S)
	from_file(S["lastchangelog"], pref.lastchangelog)
	from_file(S["default_slot"], pref.default_slot)
	from_file(S["preference_values"], pref.preference_values)

/datum/category_item/player_setup_item/player_global/settings/save_preferences(var/savefile/S)
	to_file(S["lastchangelog"], pref.lastchangelog)
	to_file(S["default_slot"], pref.default_slot)
	to_file(S["preference_values"], pref.preference_values)

/datum/category_item/player_setup_item/player_global/settings/update_setup(var/savefile/preferences, var/savefile/character)
	if(preferences["version"] < 16)
		var/list/preferences_enabled
		var/list/preferences_disabled
		from_file(preferences["preferences"], preferences_enabled)
		from_file(preferences["preferences_disabled"], preferences_disabled)

		if(!istype(preferences_enabled))
			preferences_enabled = list()
		if(!istype(preferences_disabled))
			preferences_disabled = list()

		pref.preference_values = list()
		for(var/datum/client_preference/cp in get_client_preferences())
			if(cp.key in preferences_enabled)
				pref.preference_values[cp.key] = cp.options[1] // for the converted preferences, the truthy value is going to be the first one...
			else if(cp.key in preferences_disabled)
				pref.preference_values[cp.key] = cp.options[2] // ...and the falsy value the second
			else
				pref.preference_values[cp.key] = cp.default_value
		return 1

/datum/category_item/player_setup_item/player_global/settings/sanitize_preferences()
	// Ensure our preferences are lists.
	if(!istype(pref.preference_values))
		pref.preference_values = list()

	var/list/client_preference_keys = list()
	for(var/cp in get_client_preferences())
		var/datum/client_preference/client_pref = cp

		client_preference_keys |= client_pref.key

		// if the preference has never been set, or if the player is no longer allowed to set the it, set it to default
		if(!client_pref.may_set(preference_mob()) || !(client_pref.key in pref.preference_values))
			pref.preference_values[client_pref.key] = client_pref.default_value


	// Clean out preferences that no longer exist.
	for(var/key in pref.preference_values)
		if(!(key in client_preference_keys))
			pref.preference_values -= key

	pref.lastchangelog	= sanitize_text(pref.lastchangelog, initial(pref.lastchangelog))
	pref.default_slot	= sanitize_integer(pref.default_slot, 1, config.character_slots, initial(pref.default_slot))

/datum/category_item/player_setup_item/player_global/settings/content(var/mob/user)
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
			. += "<td><a class='[is_selected ? "linkOn" : ""]' href='?src=\ref[src];pref=[client_pref.key];value=[option]'><b>[option]</b></a>"

		. += "</tr>"

	. += "</table>"

	return jointext(., "")

/datum/category_item/player_setup_item/player_global/settings/OnTopic(var/href,var/list/href_list, var/mob/user)
	var/mob/pref_mob = preference_mob()

	if(href_list["pref"] && href_list["value"])
		. = pref_mob.set_preference(href_list["pref"], href_list["value"])

	if(.)
		return TOPIC_REFRESH

	return ..()

/client/proc/get_preference_value(var/preference)
	if(prefs)
		var/datum/client_preference/cp = get_client_preference(preference)
		if(cp)
			return prefs.preference_values[cp.key]
		else
			return null
	else
		log_error("Client is lacking preferences: [log_info_line(src)]")

/client/proc/set_preference(var/preference, var/set_preference)
	var/datum/client_preference/cp = get_client_preference(preference)

	if(!cp)
		return FALSE

	if((prefs.preference_values[cp.key] != set_preference) && (set_preference in cp.options))
		prefs.preference_values[cp.key] = set_preference
		cp.changed(mob, set_preference)
		return TRUE

	return FALSE

/client/proc/cycle_preference(var/preference)
	var/datum/client_preference/cp = get_client_preference(preference)

	if(!cp)
		return FALSE

	var/next_option = next_in_list(prefs.preference_values[cp.key], cp.options)
	return set_preference(preference, next_option)

/mob/proc/get_preference_value(var/preference)
	if(!client)
		var/datum/client_preference/cp = get_client_preference(preference)
		if(cp)
			return cp.default_value
		else
			return null

	return client.get_preference_value(preference)

/mob/proc/set_preference(var/preference, var/set_preference)
	if(!client)
		return FALSE
	if(!client.prefs)
		log_debug("Client prefs found to be null for mob [src] and client [ckey], this should be investigated.")
		return FALSE

	return client.set_preference(preference, set_preference)

/mob/proc/cycle_preference(var/preference)
	if(!client)
		return FALSE
	if(!client.prefs)
		log_debug("Client prefs found to be null for mob [src] and client [ckey], this should be investigated.")
		return FALSE

	return client.cycle_preference(preference)