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
	var/admin_dat_header_colspan = 2

/datum/persistent/New()
	SetFilename()
	..()

/datum/persistent/proc/SetFilename()
	return

/datum/persistent/proc/LabelTokens(var/list/tokens)
	var/list/labelled_tokens = list()
	labelled_tokens["x"] = text2num(tokens[1])
	labelled_tokens["y"] = text2num(tokens[2])
	labelled_tokens["z"] = text2num(tokens[3])
	labelled_tokens["age"] = text2num(tokens[4])
	return labelled_tokens

/datum/persistent/proc/GetValidTurf(var/turf/T, var/list/tokens)
	if(T && CheckTurfContents(T, tokens))
		return T

/datum/persistent/proc/CheckTurfContents(var/turf/T, var/list/tokens)
	return TRUE

/datum/persistent/proc/CheckTokenSanity(var/list/tokens)
	return ( \
		!isnull(tokens["x"]) && \
		!isnull(tokens["y"]) && \
		!isnull(tokens["z"]) && \
		!isnull(tokens["age"]) && \
		tokens["age"] <= entries_expire_at \
	)

/datum/persistent/proc/CreateEntryInstance(var/turf/creating, var/list/tokens)
	return

/datum/persistent/proc/ProcessAndApplyTokens(var/list/tokens)
	var/_z = tokens["z"]
	if(_z in GLOB.using_map.station_levels)
		. = GetValidTurf(locate(tokens["x"], tokens["y"], _z), tokens)
		if(.)
			CreateEntryInstance(., tokens)

/datum/persistent/proc/IsValidEntry(var/atom/entry)
	return ( \
		istype(entry) && \
		GetEntryAge(entry) <= entries_expire_at && \
		istype(entry.loc, /turf) && \
		(entry.z in GLOB.using_map.station_levels) \
	)

/datum/persistent/proc/GetEntryAge(var/atom/entry)
	return 0

/datum/persistent/proc/CompileEntry(var/atom/entry)
	. = list(
		entry.x,
		entry.y,
		entry.z,
		GetEntryAge(entry)
	)

/datum/persistent/proc/Initialize()
	if(fexists(filename))
		for(var/entry_line in file2list(filename, file_line_split_character))
			if(!entry_line)
				continue
			var/list/tokens = splittext(entry_line, file_entry_split_character)
			if(LAZYLEN(tokens) < tokens_per_line)
				continue
			tokens = LabelTokens(tokens)
			if(!CheckTokenSanity(tokens))
				continue
			ProcessAndApplyTokens(tokens)

/datum/persistent/proc/Shutdown()
	if(fexists(filename))
		fdel(filename)
	var/write_file = file(filename)
	for(var/thing in SSpersistence.tracking_values[type])
		if(IsValidEntry(thing))
			var/list/entry = CompileEntry(thing)
			if(LAZYLEN(entry) == tokens_per_line)
				to_file(write_file, jointext(entry, file_entry_split_character))

/datum/persistent/proc/RemoveValue(var/value)
	qdel(value)

/datum/persistent/proc/GetAdminSummary(var/datum/admins/caller, var/can_modify)
	. = list("<table><tr><td colspan = [admin_dat_header_colspan]><b>[name]</b></td></tr>")
	for(var/thing in SSpersistence.tracking_values[type])
		. += "<tr>[GetAdminDataStringFor(thing, caller, can_modify)]</tr>"
	. += "</table>"

/datum/persistent/proc/GetAdminDataStringFor(var/thing, var/datum/admins/caller, var/can_modify)
	if(can_modify)
		. = "<td>[thing]</td><td><a href='byond://?src=\ref[src];caller=\ref[caller];remove_entry=\ref[thing]'>Destroy</a></td>"
	else
		. = "<td colspan = 2>[thing]</td>"

/datum/persistent/Topic(var/href, var/href_list)
	. = ..()
	if(!.)
		var/datum/admins/caller = locate(href_list["caller"])
		if(!istype(caller))
			return TOPIC_HANDLED
		if(href_list["remove_entry"])
			var/datum/value = locate(href_list["remove_entry"])
			if(istype(value))
				RemoveValue(value)
				. = TRUE
		if(.)
			caller.view_persistent_data()
