//making this separate from /obj/effect/landmark until that mess can be dealt with
/obj/effect/shuttle_landmark
	name = "nav point"
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"
	anchored = 1
	unacidable = 1
	simulated = 0
	invisibility = 101

//Can shuttle go here without doing weird stuff?
/obj/effect/shuttle_landmark/proc/free()
	return TRUE 

	//TODO: scan a footprint around the landmark shaped like the shuttle area, for other shuttle areas and the edge of the map
	//Also maybe look for structural turfs with density

/datum/shuttle_destination
	var/name = "nav point"
	var/landmark_tag
	var/obj/effect/shuttle_landmark/landmark
	var/docking_target = null
	var/x_offset = 0
	var/y_offset = 0

/datum/shuttle_destination/New(var/list/init_data)
	for(var/varname in init_data)
		src.vars[varname] = init_data[varname]
