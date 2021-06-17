/datum/persistent/graffiti
	name = "graffiti"
	entries_expire_at = 50
	has_admin_data = TRUE

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
	.["author"] =  save_graffiti.author || "unknown"
	.["message"] = save_graffiti.message

/datum/persistent/graffiti/GetAdminDataStringFor(var/thing, var/can_modify, var/mob/user)
	var/obj/effect/decal/writing/save_graffiti = thing
	if(can_modify)
		. = "<td colspan = 2>[save_graffiti.message]</td><td>[save_graffiti.author]</td><td><a href='byond://?src=\ref[src];caller=\ref[user];remove_entry=\ref[thing]'>Destroy</a></td>"
	else
		. = "<td colspan = 3>[save_graffiti.message]</td><td>[save_graffiti.author]</td>"
