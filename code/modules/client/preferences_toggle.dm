var/list/client_preference_stats_

/proc/client_preference_stats_for_usr(var/mob/user = usr)
	. = list()
	if(!user)
		return
	if(!client_preference_stats_)
		client_preference_stats_ = list()
		for(var/datum/client_preference/client_pref in get_client_preferences())
			client_preference_stats_[client_pref.description] = new /stat_client_preference(null, client_pref)

	for(var/client_pref_description in client_preference_stats_)
		var/stat_client_preference/scp = client_preference_stats_[client_pref_description]
		if(scp.client_preference.may_toggle(user))
			scp.update_name(user)
			.[client_pref_description] = scp

/client/verb/toggle_preference_verb(var/client_pref_name in client_preference_stats_for_usr())
	set name = "Toggle Preference"
	set desc = "Toggles the selected preference."
	set category = "OOC"

	var/list/client_stats = client_preference_stats_for_usr()
	var/stat_client_preference/scp = client_stats[client_pref_name]
	if(istype(scp))
		scp.Click()

/client/Stat()
	. = ..()
	if(!mob || !statpanel("Preferences"))
		return
	var/list/preferences = client_preference_stats_for_usr(mob)
	for(var/client_preference_description in preferences)
		var/stat_client_preference/scp = client_preference_stats_[client_preference_description]
		stat(scp.client_preference.description, scp)

/stat_client_preference
	parent_type = /atom/movable
	simulated = 0
	var/datum/client_preference/client_preference

/stat_client_preference/New(var/loc, var/preference)
	client_preference = preference
	name = "[usr.is_preference_enabled(client_preference) ? client_preference.enabled_description : client_preference.disabled_description]"
	..()

/stat_client_preference/Destroy()
	client_preference = null
	. = ..()

/stat_client_preference/Click()
	if(!usr.client)
		return
	if(!usr.toggle_preference(client_preference))
		return
	usr.client.prefs.save_preferences()
	to_chat(usr, "[client_preference.description]: [usr.is_preference_enabled(client_preference) ? client_preference.enabled_description : client_preference.disabled_description]")

/stat_client_preference/proc/update_name(var/mob/user)
	name = "[user.is_preference_enabled(client_preference) ? client_preference.enabled_description : client_preference.disabled_description]"
