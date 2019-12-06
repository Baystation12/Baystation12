// This is a set of datums instantiated by SSpersistence.
// They basically just handle loading, processing and saving specific forms
// of persistent data like graffiti and round to round filth.

/datum/persistent
	var/name                     // Unique descriptive name. Used for generating filename.
	var/filename                 // Set at runtime. Full path and .json extension for loading saved data.
	var/entries_expire_at        // Entries are removed if they are older than this number of rounds.
	var/entries_decay_at         // Entries begin to decay if they are older than this number of rounds (if applicable).
	var/entry_decay_weight = 0.5 // A modifier for the rapidity of decay.
	var/has_admin_data           // If set, shows up on the admin persistence panel.

/datum/persistent/New()
	SetFilename()
	..()

/datum/persistent/proc/SetFilename()
	if(name)
		filename = "data/persistent/[lowertext(GLOB.using_map.name)]-[lowertext(name)].json"
	if(!isnull(entries_decay_at) && !isnull(entries_expire_at))
		entries_decay_at = Floor(entries_expire_at * entries_decay_at)

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
	. = list()
	.["x"] =   T.x
	.["y"] =   T.y
	.["z"] =   T.z
	.["age"] = GetEntryAge(entry)

/datum/persistent/proc/FinalizeTokens(var/list/tokens)
	. = tokens

/datum/persistent/proc/Initialize()
	if(fexists(filename))
		var/list/token_sets = json_decode(file2text(filename))
		for(var/tokens in token_sets)
			tokens = FinalizeTokens(tokens)
			if(CheckTokenSanity(tokens))
				ProcessAndApplyTokens(tokens)

/datum/persistent/proc/Shutdown()
	var/list/entries = list()
	for(var/thing in SSpersistence.tracking_values[type])
		if(IsValidEntry(thing))
			entries += list(CompileEntry(thing))
	if(fexists(filename))
		fdel(filename)
	to_file(file(filename), json_encode(entries))

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
