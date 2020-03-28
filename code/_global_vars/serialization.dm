GLOBAL_LIST_INIT(saved_vars, initialize_saved_vars())
GLOBAL_LIST_INIT(blacklisted_vars, list("is_processing", "vars", "active_timers", "weakref", "extensions", "type", "parent_type"))

/proc/initialize_saved_vars()
	. = list()

	// Stats
	var/loaded_types = 0
	var/loaded_vars = 0

	// Actual serialization
	for(var/saved_var in json_decode(file2text('./saved_vars.json')))
		if(!saved_var["path"])
			continue
		if(!saved_var["vars"] || !length(saved_var["vars"]))
			continue
		var/path = text2path(saved_var["path"])
		var/subtypes = subtypesof(path)
		loaded_types += length(subtypes) + 1
		for(var/v in saved_var["vars"])
			LAZYDISTINCTADD(.[path], v)
			loaded_vars++
			for(var/subtype in subtypes)
				LAZYDISTINCTADD(.[subtype], v)

	to_world_log("Successfully loaded [loaded_types] serialized types, and [loaded_vars] variables.")

