/datum/persistent/graffiti
	name = "graffiti"
	tokens_per_line = 6
	entries_expire_at = 50
	admin_dat_header_colspan = 4
	var/entries_decay_at
	var/const/graffiti_decay_weight = 0.5

/datum/persistent/graffiti/SetFilename()
	filename = "data/persistent/[lowertext(GLOB.using_map.name)]-graffiti.txt"
	entries_decay_at = Floor(entries_expire_at * 0.5)

/datum/persistent/graffiti/LabelTokens(var/list/tokens)
	var/list/labelled_tokens = ..()
	var/entries = LAZYLEN(labelled_tokens)
	labelled_tokens["author"] =  tokens[entries+1]
	labelled_tokens["message"] = tokens[entries+2]
	return labelled_tokens

/datum/persistent/graffiti/GetValidTurf(var/turf/T, var/list/tokens)
	var/turf/checking_turf = ..()
	if(istype(checking_turf) && checking_turf.can_engrave())
		return checking_turf

/datum/persistent/graffiti/CheckTurfContents(var/turf/T, var/list/tokens)
	var/too_much_graffiti = 0
	for(var/obj/effect/decal/writing/W in .)
		too_much_graffiti++
		if(too_much_graffiti >= 5)
			return FALSE
	return TRUE

/datum/persistent/graffiti/ProcessAndApplyTokens(var/list/tokens)

	var/_n =       tokens["age"]
	var/_message = tokens["message"]

	// If it's old enough we start to trim it down and scramble parts.
	if(_n >= entries_decay_at)
		var/decayed_message = ""
		for(var/i = 1 to length(_message))
			var/char = copytext(_message, i, i + 1)
			if(prob(round(_n * graffiti_decay_weight)))
				if(prob(99))
					decayed_message += pick(".",",","-","'","\\","/","\"",":",";")
			else
				decayed_message += char
		_message = decayed_message

	if(length(_message))
		tokens["message"] = _message
		. = ..()

/datum/persistent/graffiti/CreateEntryInstance(var/turf/creating, var/list/tokens)
	new /obj/effect/decal/writing(creating, tokens["age"]+1, tokens["message"], tokens["author"])

/datum/persistent/graffiti/IsValidEntry(var/atom/entry)
	. = ..()
	if(.)
		var/turf/T = entry.loc
		. = T.can_engrave()

/datum/persistent/graffiti/GetEntryAge(var/atom/entry)
	var/obj/effect/decal/writing/save_graffiti = entry
	return save_graffiti.graffiti_age

/datum/persistent/graffiti/CompileEntry(var/atom/entry, var/write_file)
	. = ..()
	var/obj/effect/decal/writing/save_graffiti = entry
	LAZYADD(., "[save_graffiti.author ? save_graffiti.author : "unknown"]")
	LAZYADD(., "[save_graffiti.message]")

/datum/persistent/graffiti/GetAdminDataStringFor(var/thing, var/datum/admins/caller, var/can_modify)
	var/obj/effect/decal/writing/save_graffiti = thing
	if(can_modify)
		. = "<td>[save_graffiti.message]</td><td>[save_graffiti.author]</td><td><a href='byond://?src=\ref[src];caller=\ref[caller];remove_entry=\ref[thing]'>Destroy</a></td><td><a href='byond://?src=\ref[src];caller=\ref[caller];ban_author=[save_graffiti.author]'>Ban Author</a></td>"
	else
		. = "<td colspan = 4>[save_graffiti.message]</td><td>[save_graffiti.author]</td>"
