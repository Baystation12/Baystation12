/datum/persistent/filth
	name = "filth"
	tokens_per_line = 5
	entries_expire_at = 5

/datum/persistent/filth/set_filename()
	filename = "data/persistent/[lowertext(GLOB.using_map.name)]-filth.txt"

/datum/persistent/filth/label_tokens(var/list/tokens)
	var/list/labelled_tokens = ..()
	labelled_tokens["path"] = text2path(tokens[LAZYLEN(labelled_tokens)+1])
	return labelled_tokens

/datum/persistent/filth/is_valid_entry(var/atom/entry)
	. = ..() && entry.invisibility == 0

/datum/persistent/filth/check_token_sanity(var/list/tokens)
	return ..() && ispath(tokens["path"])

/datum/persistent/filth/check_turf_contents(var/turf/T, var/list/tokens)
	var/_path = tokens["path"]
	return (locate(_path) in T) ? FALSE : TRUE

/datum/persistent/filth/create_entry_instance(var/turf/creating, var/list/tokens)
	var/_path = tokens["path"]
	new _path(creating, tokens["age"]+1)

/datum/persistent/filth/get_entry_age(var/atom/entry)
	var/obj/effect/decal/cleanable/filth = entry
	return filth.age

/datum/persistent/filth/proc/get_entry_path(var/atom/entry)
	var/obj/effect/decal/cleanable/filth = entry
	return filth.generic_filth ? /obj/effect/decal/cleanable/filth : filth.type

/datum/persistent/filth/compile_entry(var/atom/entry)
	. = ..()
	LAZYADD(., "[get_entry_path(entry)]")
