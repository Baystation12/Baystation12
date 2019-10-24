/datum/persistent/filth
	name = "filth"
	entries_expire_at = 5

/datum/persistent/filth/IsValidEntry(var/atom/entry)
	. = ..() && entry.invisibility == 0

/datum/persistent/filth/CheckTokenSanity(var/list/tokens)
	return ..() && ispath(tokens["path"])

/datum/persistent/filth/CheckTurfContents(var/turf/T, var/list/tokens)
	return !(locate(tokens["path"]) in T)

/datum/persistent/filth/FinalizeTokens(var/list/tokens)
	. = ..()
	if(.["path"] && !ispath(.["path"]))
		.["path"] = text2path(.["path"])
	. = tokens

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
	.["path"] = "[GetEntryPath(entry)]"
