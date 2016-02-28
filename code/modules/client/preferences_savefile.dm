#define SAVEFILE_VERSION_MIN	8
#define SAVEFILE_VERSION_MAX	12

/datum/preferences/proc/load_path(ckey,filename="preferences.sav")
	if(!ckey)	return
	path = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename]"
	savefile_version = SAVEFILE_VERSION_MAX

/datum/preferences/proc/load_preferences()
	if(!path)				return 0
	if(!fexists(path))		return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/"

	S["version"] >> savefile_version
	/*
<<<<<<< HEAD
	//Conversion
	if(!savefile_version || !isnum(savefile_version) || savefile_version < SAVEFILE_VERSION_MIN || savefile_version > SAVEFILE_VERSION_MAX)
		if(!savefile_update())  //handles updates
			savefile_version = SAVEFILE_VERSION_MAX
			save_preferences()
			save_character()
			return 0

	//general preferences
	S["ooccolor"]			>> ooccolor
	S["lastchangelog"]		>> lastchangelog
	S["UI_style"]			>> UI_style
	S["be_special"]			>> be_special
	S["default_slot"]		>> default_slot
	S["toggles"]			>> toggles
	S["UI_style_color"]		>> UI_style_color
	S["UI_style_alpha"]		>> UI_style_alpha
	S["interface_lang"]		>> interface_lang

	//Sanitize
	ooccolor		= sanitize_hexcolor(ooccolor, initial(ooccolor))
	lastchangelog	= sanitize_text(lastchangelog, initial(lastchangelog))
	UI_style		= sanitize_inlist(UI_style, list("White", "Midnight","Orange","old"), initial(UI_style))
	be_special		= sanitize_integer(be_special, 0, 65535, initial(be_special))
	default_slot	= sanitize_integer(default_slot, 1, config.character_slots, initial(default_slot))
	toggles			= sanitize_integer(toggles, 0, 65535, initial(toggles))
	UI_style_color	= sanitize_hexcolor(UI_style_color, initial(UI_style_color))
	UI_style_alpha	= sanitize_integer(UI_style_alpha, 0, 255, initial(UI_style_alpha))
	interface_lang	= sanitize_text(interface_lang, initial(interface_lang))

=======
*/
	player_setup.load_preferences(S)
	loaded_preferences = S
	return 1

/datum/preferences/proc/save_preferences()
	if(!path)				return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/"
/*
<<<<<<< HEAD
	S["version"] << savefile_version

	//general preferences
	S["ooccolor"]			<< ooccolor
	S["lastchangelog"]		<< lastchangelog
	S["UI_style"]			<< UI_style
	S["be_special"]			<< be_special
	S["default_slot"]		<< default_slot
	S["toggles"]			<< toggles
	S["interface_lang"]		<< interface_lang

=======
*/
	S["version"] << SAVEFILE_VERSION_MAX
	player_setup.save_preferences(S)
	loaded_preferences = S
	return 1

/datum/preferences/proc/load_character(slot)
	if(!path)				return 0
	if(!fexists(path))		return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/"
	if(!slot)	slot = default_slot
	slot = sanitize_integer(slot, 1, config.character_slots, initial(default_slot))
	if(slot != default_slot)
		default_slot = slot
		S["default_slot"] << slot
	S.cd = "/character[slot]"

	player_setup.load_character(S)
	loaded_character = S
	return 1

/datum/preferences/proc/save_character()
	if(!path)				return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/character[default_slot]"

	S["version"] << SAVEFILE_VERSION_MAX
	player_setup.save_character(S)
	loaded_character = S
	return S

/datum/preferences/proc/sanitize_preferences()
	player_setup.sanitize_setup()
	return 1

/datum/preferences/proc/update_setup(var/savefile/preferences, var/savefile/character)
	if(!preferences || !character)
		return 0
	return player_setup.update_setup(preferences, character)

#undef SAVEFILE_VERSION_MAX
#undef SAVEFILE_VERSION_MIN
