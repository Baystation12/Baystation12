/datum/persistent/filth
	name = "filth"
	tokens_per_line = 5
	entries_expire_at = 5

/datum/persistent/filth/LabelTokens(var/list/tokens)
	var/list/labelled_tokens = ..()
	labelled_tokens["path"] = text2path(tokens[LAZYLEN(labelled_tokens)+1])
	return labelled_tokens

/datum/persistent/filth/IsValidEntry(var/atom/entry)
	. = ..() && entry.invisibility == 0

/datum/persistent/filth/CheckTokenSanity(var/list/tokens)
	return ..() && ispath(tokens["path"])

/datum/persistent/filth/CheckTurfContents(var/turf/T, var/list/tokens)
	var/_path = tokens["path"]
	return (locate(_path) in T) ? FALSE : TRUE

/datum/persistent/filth/CreateEntryInstance(var/turf/creating, var/list/tokens)
	var/_path = tokens["path"]
	new _path(creating, tokens["age"]+1)

/datum/persistent/filth/GetEntryAge(var/atom/entry)
	var/obj/effect/decal/cleanable/filth = entry
	return filth.age

/datum/persistent/filth/proc/GetEntryPath(var/atom/entry)
	var/obj/effect/decal/cleanable/filth = entry
	return filth.generic_filth ? /obj/effect/decal/cleanable/filth : filth.type

/datum/persistent/filth/CompileEntry(var/atom/entry)
	. = ..()
	LAZYADD(., "[GetEntryPath(entry)]")
