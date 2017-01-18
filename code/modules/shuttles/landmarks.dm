//making this separate from /obj/effect/landmark until that mess can be dealt with
/obj/effect/shuttle_nav
	name = "nav point"
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"
	anchored = 1
	unacidable = 1
	simulated = 0
	invisibility = 101

//Can shuttle go here without doing weird stuff?
/obj/effect/shuttle_nav/proc/free()
	return TRUE 

	//TODO: scan a footprint around the landmark shaped like the shuttle area, for other shuttle areas and the edge of the map
	//Also maybe look for structural turfs with density

/datum/shuttle_nav
	var/name
	var/nav_tag
	var/obj/effect/shuttle_nav/landmark
	var/docking_target = null
	var/x_offset = 0
	var/y_offset = 0