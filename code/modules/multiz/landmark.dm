/*
	A map data landmark should be mapped into each zlevel on every map. It contains info, entered at authortime, about each level and what it connects to.

	All mapdata landmarks should be UNIQUE. Create a new subtype in code for every level of every map that you make
	(preferably in the map folder to prevent centralised clutter)

	At runtime, each mapdata landmark is converted into a level datum.
	Then scene datums are generated as needed for every named scene
*/
/obj/effect/landmark/map_data
	var/datum/level/zlevel = null
	var/level_id	=	"unknown_deck1"	//A non-human-facing ID. This is used by code to determine which zlevel datum this landmark is for
	//Never use two landmarks with the same level ID

/obj/effect/landmark/map_data/New(turf/loc, var/id_override)
	..()
	if(!istype(loc)) // Using loc.z is safer when using the maploader and New.
		return

	//Used for runtime construction of scenes, zlevels, and landmarks
	if (id_override)
		level_id = id_override


/obj/effect/landmark/map_data/Initialize()
	..()
	create_level(z, level_id) //This proc is in multiz/level.dm
	return INITIALIZE_HINT_QDEL




/*--------------------------------------------------------------------------------------------------------------

	Generic landmarks: Useable on multiple maps, so long as only one of those maps is loaded, which it will be

--------------------------------------------------------------------------------------------------------------*/
/obj/effect/landmark/map_data/admin
	level_id = "admin_level_1"


/obj/effect/landmark/map_data/transit
	level_id = "transit_level_1"

/obj/effect/landmark/map_data/empty_precached
	level_id = "empty_precached"