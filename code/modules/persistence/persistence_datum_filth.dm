/datum/persistent/filth
	name = "filth"
	entries_expire_at = 5

/datum/persistent/filth/IsValidEntry(atom/entry)
	. = ..() && entry.invisibility == 0

/datum/persistent/filth/CheckTokenSanity(list/tokens)
	return ..() && ispath(tokens["path"])

/datum/persistent/filth/CheckTurfContents(turf/T, list/tokens)
	return !(locate(tokens["path"]) in T)

/datum/persistent/filth/FinalizeTokens(list/tokens)
	. = ..()
	if(.["path"] && !ispath(.["path"]))
		.["path"] = text2path(.["path"])
	. = tokens

/datum/persistent/filth/CreateEntryInstance(turf/creating, list/tokens)
	var/_path = tokens["path"]
	new _path(creating, tokens["age"]+1)

/datum/persistent/filth/GetEntryAge(atom/entry)
	var/obj/decal/cleanable/filth = entry
	return filth.age

/datum/persistent/filth/proc/GetEntryPath(atom/entry)
	var/obj/decal/cleanable/filth = entry
	return filth.generic_filth ? /obj/decal/cleanable/filth : filth.type

/datum/persistent/filth/CompileEntry(atom/entry)
	. = ..()
	.["path"] = "[GetEntryPath(entry)]"
