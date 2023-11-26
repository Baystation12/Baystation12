/datum/preferences/save_pref_record(record_key, list/data)
	var/path = get_path(client_ckey, record_key)
	var/text = json_encode(data)

	if(isnull(text))
		crash_with("Failed to encode JSON for [path]")
		return

	var/error = rustg_file_write(text, path)
	if (error)
		crash_with(error)
