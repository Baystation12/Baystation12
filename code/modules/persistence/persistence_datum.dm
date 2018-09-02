// This is a set of datums instantiated by SSpersistence.
// They basically just handle loading, processing and saving specific forms
// of persistent data like graffiti and round to round filth.

/datum/persistent
	var/name
	var/filename
	var/tokens_per_line
	var/entries_expire_at
	var/file_entry_split_character = "\t"
	var/file_line_split_character =  "\n"

/datum/persistent/New()
	set_filename()
	..()

/datum/persistent/proc/set_filename()
	return

/datum/persistent/proc/label_tokens(var/list/tokens)
	var/list/labelled_tokens = list()
	labelled_tokens["x"] = text2num(tokens[1])
	labelled_tokens["y"] = text2num(tokens[2])
	labelled_tokens["z"] = text2num(tokens[3])
	labelled_tokens["age"] = text2num(tokens[4])
	return labelled_tokens

/datum/persistent/proc/get_valid_turf(var/turf/T, var/list/tokens)
	if(T && check_turf_contents(T, tokens))
		return T

/datum/persistent/proc/check_turf_contents(var/turf/T, var/list/tokens)
	return TRUE

/datum/persistent/proc/check_token_sanity(var/list/tokens)
	return ( \
		!isnull(tokens["x"]) && \
		!isnull(tokens["y"]) && \
		!isnull(tokens["z"]) && \
		!isnull(tokens["age"]) && \
		tokens["age"] <= entries_expire_at \
	)

/datum/persistent/proc/create_entry_instance(var/turf/creating, var/list/tokens)
	return

/datum/persistent/proc/process_and_apply_tokens(var/list/tokens)
	var/_z = tokens["z"]
	if(_z in GLOB.using_map.station_levels)
		. = get_valid_turf(locate(tokens["x"], tokens["y"], _z), tokens)
		if(.)
			create_entry_instance(., tokens)

/datum/persistent/proc/is_valid_entry(var/atom/entry)
	return ( \
		istype(entry) && \
		get_entry_age(entry) <= entries_expire_at && \
		istype(entry.loc, /turf) && \
		(entry.z in GLOB.using_map.station_levels) \
	)

/datum/persistent/proc/get_entry_age(var/atom/entry)
	return 0

/datum/persistent/proc/compile_entry(var/atom/entry)
	. = list(
		entry.x,
		entry.y,
		entry.z,
		get_entry_age(entry)
	)

/datum/persistent/proc/Initialize()
	if(fexists(filename))
		for(var/entry_line in file2list(filename, file_line_split_character))
			if(!entry_line)
				continue
			var/list/tokens = splittext(entry_line, file_entry_split_character)
			if(LAZYLEN(tokens) < tokens_per_line)
				continue
			tokens = label_tokens(tokens)
			if(!check_token_sanity(tokens))
				continue
			process_and_apply_tokens(tokens)

/datum/persistent/proc/Shutdown()
	if(fexists(filename))
		fdel(filename)
	var/write_file = file(filename)
	for(var/thing in SSpersistence.tracking_values[type])
		if(is_valid_entry(thing))
			var/list/entry = compile_entry(thing)
			if(LAZYLEN(entry) == tokens_per_line)
				to_file(write_file, jointext(entry, file_entry_split_character))
