/datum/preferences
	var/preferences = null

/datum/category_item/player_setup_item/player_global/settings
	name = "Settings"
	sort_order = 2

/datum/category_item/player_setup_item/player_global/settings/load_preferences(var/savefile/S)
	S["lastchangelog"]	>> pref.lastchangelog
	S["default_slot"]	>> pref.default_slot
	S["preferences"]	>> pref.preferences

/datum/category_item/player_setup_item/player_global/settings/save_preferences(var/savefile/S)
	S["lastchangelog"]	<< pref.lastchangelog
	S["default_slot"]	<< pref.default_slot
	S["preferences"]	<< pref.preferences

/datum/category_item/player_setup_item/player_global/settings/sanitize_preferences()
	var/mob/pref_mob = preference_mob()
	if(!istype(pref.preferences, /list))
		pref.preferences = list()
		for(var/cp in get_client_preferences())
			var/datum/client_preference/client_pref = cp
			if(!client_pref.enabled_by_default || !client_pref.may_toggle(pref_mob))
				continue
			pref.preferences += client_pref.key

	pref.lastchangelog	= sanitize_text(pref.lastchangelog, initial(pref.lastchangelog))
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
			. += "<td><b>[client_pref.enabled_description]</b></td> <td><a href='?src=\ref[src];toggle_off=[client_pref.key]'>[client_pref.disabled_description]</a></td>"
		else
			. += "<td><a  href='?src=\ref[src];toggle_on=[client_pref.key]'>[client_pref.enabled_description]</a></td> <td><b>[client_pref.disabled_description]</b></td>"
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
	if(ispath(preference))
		var/datum/client_preference/cp = get_client_preference_by_type(preference)
		preference = cp.key

	return (preference in prefs.preferences)

/client/proc/set_preference(var/preference, var/set_preference)
	var/datum/client_preference/cp
	if(ispath(preference))
		cp = get_client_preference_by_type(preference)
	else
		cp = get_client_preference_by_key(preference)

	if(!cp)
		return FALSE

	var/enabled
	if(set_preference && !(preference in prefs.preferences))
		prefs.preferences += preference
		enabled = TRUE
		. = TRUE
	else if(!set_preference && (preference in prefs.preferences))
		prefs.preferences -= preference
		enabled = FALSE
		. = TRUE
	if(.)
		cp.toggled(mob, enabled)

/mob/proc/is_preference_enabled(var/preference)
	if(!client)
		return FALSE
	return client.is_preference_enabled(preference)

/mob/proc/set_preference(var/preference, var/set_preference)
	if(!client)
		return FALSE
	if(!client.prefs)
		log_debug("Client prefs found to be null for mob [src] and client [ckey], this should be investigated.")
		return FALSE

	return client.set_preference(preference, set_preference)
