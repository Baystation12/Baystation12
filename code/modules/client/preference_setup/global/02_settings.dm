/datum/preferences
	var/preferences_enabled = null
	var/preferences_disabled = null

/datum/category_item/player_setup_item/player_global/settings
	name = "Settings"
	sort_order = 2

/datum/category_item/player_setup_item/player_global/settings/load_preferences(var/savefile/S)
	S["lastchangelog"]        >> pref.lastchangelog
	S["lastsolchangelog"]     >> pref.lastsolchangelog
	S["default_slot"]	      >> pref.default_slot
	S["preferences"]          >> pref.preferences_enabled
	S["preferences_disabled"] >> pref.preferences_disabled

/datum/category_item/player_setup_item/player_global/settings/save_preferences(var/savefile/S)
	S["lastchangelog"]        << pref.lastchangelog
	S["lastsolchangelog"]     << pref.lastsolchangelog
	S["default_slot"]         << pref.default_slot
	S["preferences"]          << pref.preferences_enabled
	S["preferences_disabled"] << pref.preferences_disabled

/datum/category_item/player_setup_item/player_global/settings/sanitize_preferences()
	// Ensure our preferences are lists.
	if(!istype(pref.preferences_enabled, /list))
		pref.preferences_enabled = list()
	if(!istype(pref.preferences_disabled, /list))
		pref.preferences_disabled = list()

	// Arrange preferences that have never been enabled/disabled.
	var/list/client_preference_keys = list()
	for(var/cp in get_client_preferences())
		var/datum/client_preference/client_pref = cp
		client_preference_keys += client_pref.key
		if((client_pref.key in pref.preferences_enabled) || (client_pref.key in pref.preferences_disabled))
			continue

		if(client_pref.enabled_by_default)
			pref.preferences_enabled += client_pref.key
		else
			pref.preferences_disabled += client_pref.key

	// Clean out preferences that no longer exist.
	for(var/key in pref.preferences_enabled)
		if(!(key in client_preference_keys))
			pref.preferences_enabled -= key
	for(var/key in pref.preferences_disabled)
		if(!(key in client_preference_keys))
			pref.preferences_disabled -= key

	pref.lastchangelog	= sanitize_text(pref.lastchangelog, initial(pref.lastchangelog))
	pref.lastsolchangelog	= sanitize_text(pref.lastsolchangelog, initial(pref.lastsolchangelog))
	pref.default_slot	= sanitize_integer(pref.default_slot, 1, config.character_slots, initial(pref.default_slot))

/datum/category_item/player_setup_item/player_global/settings/content(var/mob/user)
	. = list()
	. += "<b>Preferences</b><br>"
	. += "<table>"
	var/mob/pref_mob = preference_mob()
	for(var/cp in get_client_preferences())
		var/datum/client_preference/client_pref = cp
		if(!client_pref.may_toggle(pref_mob))
			continue

		. += "<tr><td>[client_pref.description]: </td>"
		if(pref_mob.is_preference_enabled(client_pref.key))
			. += "<td><span class='linkOn'><b>[client_pref.enabled_description]</b></span></td> <td><a href='?src=\ref[src];toggle_off=[client_pref.key]'>[client_pref.disabled_description]</a></td>"
		else
			. += "<td><a  href='?src=\ref[src];toggle_on=[client_pref.key]'>[client_pref.enabled_description]</a></td> <td><span class='linkOn'><b>[client_pref.disabled_description]</b></span></td>"
		. += "</tr>"

	. += "</table>"
	return jointext(., "")

/datum/category_item/player_setup_item/player_global/settings/OnTopic(var/href,var/list/href_list, var/mob/user)
	var/mob/pref_mob = preference_mob()
	if(href_list["toggle_on"])
		. = pref_mob.set_preference(href_list["toggle_on"], TRUE)
	else if(href_list["toggle_off"])
		. = pref_mob.set_preference(href_list["toggle_off"], FALSE)
	if(.)
		return TOPIC_REFRESH

	return ..()

/client/proc/is_preference_enabled(var/preference)
	var/datum/client_preference/cp = get_client_preference(preference)
	return cp && (cp.key in prefs.preferences_enabled)

/client/proc/is_preference_disabled(var/preference)
	return !is_preference_enabled(preference)

/client/proc/set_preference(var/preference, var/set_preference)
	var/datum/client_preference/cp = get_client_preference(preference)
	if(!cp)
		return FALSE
	preference = cp.key

	if(set_preference && !(preference in prefs.preferences_enabled))
		return toggle_preference(cp)
	else if(!set_preference && (preference in prefs.preferences_enabled))
		return toggle_preference(cp)

/client/proc/toggle_preference(var/preference, var/set_preference)
	var/datum/client_preference/cp = get_client_preference(preference)
	if(!cp)
		return FALSE
	if(!cp.may_toggle(mob))
		return FALSE
	preference = cp.key

	var/enabled
	if(preference in prefs.preferences_disabled)
		prefs.preferences_enabled  |= preference
		prefs.preferences_disabled -= preference
		enabled = TRUE
		. = TRUE
	else if(preference in prefs.preferences_enabled)
		prefs.preferences_enabled  -= preference
		prefs.preferences_disabled |= preference
		enabled = FALSE
		. = TRUE
	if(.)
		cp.toggled(mob, enabled)

/mob/proc/is_preference_enabled(var/preference)
	if(!client)
		return FALSE
	return client.is_preference_enabled(preference)

/mob/proc/is_preference_disabled(var/preference)
	if(!client)
		return TRUE
	return client.is_preference_disabled(preference)

/mob/proc/set_preference(var/preference, var/set_preference)
	if(!client)
		return FALSE
	if(!client.prefs)
		log_debug("Client prefs found to be null for mob [src] and client [ckey], this should be investigated.")
		return FALSE

	return client.set_preference(preference, set_preference)

/mob/proc/toggle_preference(var/preference)
	if(!client)
		return FALSE
	return client.toggle_preference(preference)
