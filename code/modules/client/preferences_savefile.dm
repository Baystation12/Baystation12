#define SAVEFILE_VERSION_MIN	8
#define SAVEFILE_VERSION_MAX	13

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
	load_prefs(S)
	loaded_preferences = S
	return 1

/datum/preferences/proc/save_preferences()
	if(!path)				return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/"

	S["version"] << SAVEFILE_VERSION_MAX
	save_prefs(S)
	loaded_preferences = S
	return 1

/datum/preferences/proc/load_character(slot)
	if(!path)				return 0
	if(!fexists(path))		return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/"
	if(!slot)	slot = default_slot

	if(slot != SAVE_RESET) // SAVE_RESET will reset the slot as though it does not exist, but keep the current slot for saving purposes.
		slot = sanitize_integer(slot, 1, config.character_slots, initial(default_slot))
		if(slot != default_slot)
			default_slot = slot
			S["default_slot"] << slot
	else
		S["default_slot"] << default_slot

	if(slot != SAVE_RESET)
		S.cd = GLOB.using_map.character_load_path(S, slot)
		load_char(S)
	else
		load_char(S)
		S.cd = GLOB.using_map.character_load_path(S, default_slot)

	loaded_character = S
	sanitize_char()
	return 1

/datum/preferences/proc/save_character()
	if(!path)				return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = GLOB.using_map.character_save_path(default_slot)

	S["version"] << SAVEFILE_VERSION_MAX
	save_char(S)
	loaded_character = S
	return S

/datum/preferences/proc/sanitize_preferences()
	sanitize_prefs()
	return 1

/datum/preferences/proc/update_setup(var/savefile/preferences, var/savefile/character)
	if(!preferences || !character)
		return 0
	return update_setup(preferences, character)

#undef SAVEFILE_VERSION_MAX
#undef SAVEFILE_VERSION_MIN
