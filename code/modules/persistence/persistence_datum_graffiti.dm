/datum/persistent/graffiti
	name = "graffiti"
	tokens_per_line = 6
	entries_expire_at = 50
	admin_dat_header_colspan = 4

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
