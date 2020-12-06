/datum/map
	var/load_legacy_saves = FALSE

/datum/map/proc/character_save_path(var/slot)
	return "/[path]/character[slot]"

/datum/map/proc/character_load_path(var/savefile/S, var/slot)
	var/original_cd = S.cd
	S.cd = "/"
	. = private_use_legacy_saves(S, slot) ? "/character[slot]" : "/[path]/character[slot]"
	S.cd = original_cd // Attempting to make this call as side-effect free as possible

/datum/map/proc/private_use_legacy_saves(var/savefile/S, var/slot)
	if(!load_legacy_saves) // Check if we're bothering with legacy saves at all
		return FALSE
	if(!S.dir.Find(path)) // If we cannot find the map path folder, load the legacy save
		return TRUE
	S.cd = "/[path]" // Finally, if we cannot find the character slot in the map path folder, load the legacy save
	return !S.dir.Find("character[slot]")
