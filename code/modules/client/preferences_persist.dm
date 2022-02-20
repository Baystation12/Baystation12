#define PREF_SER_VERSION 2

/datum/preferences/proc/get_path(ckey, record_key, extension="json")
	return "data/player_saves/[copytext_char(ckey,1,2)]/[ckey]/[record_key].[extension]"

// Returns null if there's no record file. Crashes on other error conditions.
/datum/preferences/proc/load_pref_record(record_key)
	var/path = get_path(client_ckey, record_key)
	if(!fexists(path))
		return null
	var/text = file2text(path)
	if(text == null)
		CRASH("failed to read [path]")
	var/list/data = json_decode(text)
	if(!istype(data))
		CRASH("failed to decode JSON from [path]")
	return new /datum/pref_record_reader/json_list(data)

/datum/preferences/proc/save_pref_record(record_key, list/data)
	var/path = get_path(client_ckey, record_key)
	var/text = json_encode(data)
	if(text == null)
		CRASH("failed to encode JSON for [path]")

	// Why this dance? If text2file fails, we want to leave the record as it was.

	var/tmp_path = "[path].tmp"
	// If we crashed at the end previously, we'll have a junk tmpfile, which text2file would append to.
	if(fexists(tmp_path))
		if(!fdel(tmp_path))
			CRASH("failed to remove junk existing tmpfile at [tmp_path]")
	if(!text2file(text,tmp_path))
		CRASH("failed to write record to tmpfile at [tmp_path]")
	if(!fcopy(tmp_path, path))
		CRASH("failed to copy tmpfile at [tmp_path] to [path]")
	if(!fdel(tmp_path))
		CRASH("failed to remove tmpfile at [tmp_path]")

/datum/preferences/proc/load_preferences()
	var/datum/pref_record_reader/R = load_pref_record("preferences")
	if(!R)
		R = new /datum/pref_record_reader/null(PREF_SER_VERSION)
	player_setup.load_preferences(R)

/datum/preferences/proc/save_preferences()
	var/datum/pref_record_writer/json_list/W = new(PREF_SER_VERSION)
	player_setup.save_preferences(W)
	save_pref_record("preferences", W.data)

/datum/preferences/proc/get_slot_key(slot)
	return "character_[GLOB.using_map.preferences_key()]_[slot]"

/datum/preferences/proc/load_character(slot)
	if(!slot)
		slot = default_slot

	if(slot != SAVE_RESET) // SAVE_RESET will reset the slot as though it does not exist, but keep the current slot for saving purposes.
		slot = sanitize_integer(slot, 1, config.character_slots, initial(default_slot))
		if(slot != default_slot)
			default_slot = slot
			SScharacter_setup.queue_preferences_save(src)

	if(slot == SAVE_RESET)
		// If we're resetting, set everything to null. Sanitization will clean it up
		var/datum/pref_record_reader/null/R = new(PREF_SER_VERSION)
		player_setup.load_character(R)
	else
		var/datum/pref_record_reader/R = load_pref_record(get_slot_key(slot))
		if(!R)
			R = new /datum/pref_record_reader/null(PREF_SER_VERSION)
		player_setup.load_character(R)

/datum/preferences/proc/save_character(override_key=null)
	var/datum/pref_record_writer/json_list/W = new(PREF_SER_VERSION)
	player_setup.save_character(W)

	var/record_key = override_key || get_slot_key(default_slot)
	save_pref_record(record_key, W.data)

	// Cache the character's name for listing
	LAZYSET(slot_names, record_key, W.data["real_name"])
	SScharacter_setup.queue_preferences_save(src)

/datum/preferences/proc/sanitize_preferences()
	player_setup.sanitize_setup()
	return 1

#undef PREF_SER_VERSION
