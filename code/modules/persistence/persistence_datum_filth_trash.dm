/datum/persistent/filth/trash
	name = "trash"

/datum/persistent/filth/trash/set_filename()
	filename = "data/persistent/[lowertext(GLOB.using_map.name)]-trash.txt"

/datum/persistent/filth/trash/check_turf_contents(var/turf/T, var/list/tokens)
	var/too_much_trash = 0
	for(var/obj/item/trash/trash in T)
		too_much_trash++
		if(too_much_trash >= 5)
			return FALSE
	return TRUE

/datum/persistent/filth/trash/get_entry_age(var/atom/entry)
	var/obj/item/trash/trash = entry
	return trash.age

/datum/persistent/filth/trash/get_entry_path(var/atom/entry)
	return entry.type
