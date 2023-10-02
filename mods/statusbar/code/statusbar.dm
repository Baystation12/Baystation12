/datum/client_preference/show_statusbar
	description = "Statusbar"
	key = "show_statusbar"
	options = list(GLOB.PREF_SHOW, GLOB.PREF_HIDE)

/datum/client_preference/show_statusbar/changed(mob/preference_mob, new_value)
	if (new_value == GLOB.PREF_HIDE)
		winset(preference_mob, "mapwindow.statusbar", "is-visible=false")
	else
		winset(preference_mob, "mapwindow.statusbar", "is-visible=true")


/client/verb/toggle_statusbar()
	set name = "Toggle Status Bar"
	set category = "OOC"

	var/is_shown = winget(usr, "mapwindow.statusbar", "is-visible") == "true"

	if (is_shown)
		winset(usr, "mapwindow.statusbar", "is-visible=false")
	else
		winset(usr, "mapwindow.statusbar", "is-visible=true")
