// This is a set of datums instantiated by SSpersistence.
// They basically just handle loading, processing and saving specific forms
// of persistent data like graffiti and round to round filth.

/datum/persistent
	var/name
	var/filename
	var/tokens_per_line
	var/entries_expire_at
	var/entries_decay_at
	var/entry_decay_weight = 0.5
	var/file_entry_split_character = "\t"
	var/file_entry_substitute_character = " "
	var/file_line_split_character =  "\n"
	var/has_admin_data

/datum/persistent/New()
	SetFilename()
	..()

/datum/persistent/proc/SetFilename()
	if(name)
		filename = "data/persistent/[lowertext(GLOB.using_map.name)]-[lowertext(name)].txt"
	if(!isnull(entries_decay_at) && !isnull(entries_expire_at))
		entries_decay_at = Floor(entries_expire_at * entries_decay_at)

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

	// If it's old enough we start to trim down any textual information and scramble strings.
	if(tokens["message"] && !isnull(entries_decay_at) && !isnull(entry_decay_weight))
		var/_n =       tokens["age"]
		var/_message = tokens["message"]
		if(_n >= entries_decay_at)
			var/decayed_message = ""
			for(var/i = 1 to length(_message))
				var/char = copytext(_message, i, i + 1)
				if(prob(round(_n * entry_decay_weight)))
					if(prob(99))
						decayed_message += pick(".",",","-","'","\\","/","\"",":",";")
				else
					decayed_message += char
			_message = decayed_message
		if(length(_message))
			tokens["message"] = _message
		else
			return

	var/_z = tokens["z"]
	if(_z in GLOB.using_map.station_levels)
		. = GetValidTurf(locate(tokens["x"], tokens["y"], _z), tokens)
		if(.)
			CreateEntryInstance(., tokens)

/datum/persistent/proc/IsValidEntry(var/atom/entry)
	if(!istype(entry))
		return FALSE
	if(GetEntryAge(entry) >= entries_expire_at)
		return FALSE
	var/turf/T = get_turf(entry)
	if(!T || !(T.z in GLOB.using_map.station_levels) )
		return FALSE
	var/area/A = get_area(T)
	if(!A || (A.area_flags & AREA_FLAG_IS_NOT_PERSISTENT))
		return FALSE
	return TRUE

/datum/persistent/proc/GetEntryAge(var/atom/entry)
	return 0

/datum/persistent/proc/CompileEntry(var/atom/entry)
	var/turf/T = get_turf(entry)
	. = list(
		T.x,
		T.y,
		T.z,
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
				for(var/i = 1 to LAZYLEN(entry))
					if(istext(entry[i]))
						entry[i] = replacetext(entry[i], file_entry_split_character, file_entry_substitute_character)
				to_file(write_file, jointext(entry, file_entry_split_character))

/datum/persistent/proc/RemoveValue(var/atom/value)
	qdel(value)

/datum/persistent/proc/GetAdminSummary(var/mob/user, var/can_modify)
	. = list("<tr><td colspan = 4><b>[capitalize(name)]</b></td></tr>")
	. += "<tr><td colspan = 4><hr></td></tr>"
	for(var/thing in SSpersistence.tracking_values[type])
		. += "<tr>[GetAdminDataStringFor(thing, can_modify, user)]</tr>"
	. += "<tr><td colspan = 4><hr></td></tr>"


/datum/persistent/proc/GetAdminDataStringFor(var/thing, var/can_modify, var/mob/user)
	if(can_modify)
		. = "<td colspan = 3>[thing]</td><td><a href='byond://?src=\ref[src];caller=\ref[user];remove_entry=\ref[thing]'>Destroy</a></td>"
	else
		. = "<td colspan = 4>[thing]</td>"

/datum/persistent/Topic(var/href, var/href_list)
	. = ..()
	if(!.)
		if(href_list["remove_entry"])
			var/datum/value = locate(href_list["remove_entry"])
			if(istype(value))
				RemoveValue(value)
				. = TRUE
		if(.)
			var/mob/user = locate(href_list["caller"])
			if(user)
				SSpersistence.show_info(user)
