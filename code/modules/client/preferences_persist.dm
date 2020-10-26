#define PREF_SER_VERSION 1

/datum/preferences/proc/get_path(ckey, record_key, extension="json")
	return "data/player_saves/[copytext(ckey,1,2)]/[ckey]/[record_key].[extension]"

/datum/preferences/proc/load_pref_record(record_key)
	var/path = get_path(client.ckey, record_key)
	if(!fexists(path))
		return null
	var/text = file2text(path)
	return new /datum/pref_record_reader/json_list(json_decode(text))

/datum/preferences/proc/save_pref_record(record_key, list/data)
	var/path = get_path(client.ckey, record_key)
	var/text = json_encode(data)
	fdel(path)
	text2file(text, path)

/datum/preferences/proc/load_preferences()
	var/datum/pref_record_reader/R = load_pref_record("preferences")
	if(!R)
		R = new /datum/pref_record_reader/null(PREF_SER_VERSION)
	player_setup.load_preferences(R)
	return 1

/datum/preferences/proc/save_preferences()
	var/datum/pref_record_writer/json_list/W = new(PREF_SER_VERSION)
	player_setup.save_preferences(W)
	save_pref_record("preferences", W.data)
	return 1

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

	return 1

/datum/preferences/proc/save_character(override_key=null)
	var/datum/pref_record_writer/json_list/W = new(PREF_SER_VERSION)
	player_setup.save_character(W)

	var/record_key = override_key || get_slot_key(default_slot)
	save_pref_record(record_key, W.data)

	// Cache the character's name for listing
	LAZYSET(slot_names, record_key, W.data["real_name"])
	SScharacter_setup.queue_preferences_save(src)
	return 1

/datum/preferences/proc/sanitize_preferences()
	player_setup.sanitize_setup()
	return 1

#undef PREF_SER_VERSION
