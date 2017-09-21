/datum/preferences/proc/load_prefs(var/savefile/S)
	S["UI_style"]		>> UI_style
	S["UI_style_color"]	>> UI_style_color
	S["UI_style_alpha"]	>> UI_style_alpha
	S["ooccolor"]		>> ooccolor
	S["clientfps"]		>> clientfps
	S["lastchangelog"]        >> lastchangelog
	S["default_slot"]	      >> default_slot
	S["preferences"]          >> preferences_enabled
	S["preferences_disabled"] >> preferences_disabled
	S["language_prefixes"]	>> language_prefixes
	if(!candidate)
		candidate = new()

	if(!preference_mob())
		return

	candidate.savefile_load(preference_mob())
	S["ignored_players"]	>> ignored_players

/datum/preferences/proc/save_prefs(var/savefile/S)
	S["UI_style"]		<< UI_style
	S["UI_style_color"]	<< UI_style_color
	S["UI_style_alpha"]	<< UI_style_alpha
	S["ooccolor"]		<< ooccolor
	S["clientfps"]		<< clientfps
	S["lastchangelog"]        << lastchangelog
	S["default_slot"]         << default_slot
	S["preferences"]          << preferences_enabled
	S["preferences_disabled"] << preferences_disabled
	S["language_prefixes"]	<< language_prefixes
	if(!candidate)
		return

	if(!preference_mob())
		return

	candidate.savefile_save(preference_mob())
	S["ignored_players"]	<< ignored_players


/datum/preferences/proc/sanitize_prefs()

	UI_style		= sanitize_inlist(UI_style, all_ui_styles, initial(UI_style))
	UI_style_color	= sanitize_hexcolor(UI_style_color, initial(UI_style_color))
	UI_style_alpha	= sanitize_integer(UI_style_alpha, 0, 255, initial(UI_style_alpha))
	ooccolor		= sanitize_hexcolor(ooccolor, initial(ooccolor))
	clientfps	    = sanitize_integer(clientfps, CLIENT_MIN_FPS, CLIENT_MAX_FPS, initial(clientfps))
	// Ensure our preferences are lists.
	if(!istype(preferences_enabled, /list))
		preferences_enabled = list()
	if(!istype(preferences_disabled, /list))
		preferences_disabled = list()

	// Arrange preferences that have never been enabled/disabled.
	var/list/client_preference_keys = list()
	for(var/cp in get_client_preferences())
		var/datum/client_preference/client_pref = cp
		client_preference_keys += client_pref.key
		if((client_pref.key in preferences_enabled) || (client_pref.key in preferences_disabled))
			continue

		if(client_pref.enabled_by_default)
			preferences_enabled += client_pref.key
		else
			preferences_disabled += client_pref.key

	// Clean out preferences that no longer exist.
	for(var/key in preferences_enabled)
		if(!(key in client_preference_keys))
			preferences_enabled -= key
	for(var/key in preferences_disabled)
		if(!(key in client_preference_keys))
			preferences_disabled -= key

	lastchangelog	= sanitize_text(lastchangelog, initial(lastchangelog))
	default_slot	= sanitize_integer(default_slot, 1, config.character_slots, initial(default_slot))

	if(isnull(language_prefixes) || !language_prefixes.len)
		language_prefixes = config.language_prefixes.Copy()
	if(!islist(ignored_players))
		ignored_players = list()
