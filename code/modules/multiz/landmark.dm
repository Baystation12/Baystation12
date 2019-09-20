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
	find_and_set_level()
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/map_data/proc/find_level()
	var/datum/level/l = SSmapping.all_level_datums[level_id]
	if (istype(l))
		//We have found the right level
		zlevel = l
		return

	log_world("ERROR: Landmark located at [jumplink(src)] could not find level datum matching id [level_id]")

/obj/effect/landmark/map_data/proc/set_level()
	if (!zlevel)
		return

	//Set the Zvalue
	zlevel.z = src.z

	//Add it to the global list of all zlevels
	SSmapping.zlevels["[zlevel.z]"] = zlevel

	//And add it to the list in the parent scene datum
	var/datum/scene/S = zlevel.scene
	S.levels["[zlevel.z]"] = level
	S.level_numbers |= zlevel.z //There should never be two of these landmarks on the same level, but lets use |= anyway in case someone screwed up

/obj/effect/landmark/map_data/proc/find_and_set_level()
	find_level()
	set_level()



/*--------------------------------------------------------------------------------------------------------------

	Generic landmarks: Useable on multiple maps, so long as only one of those maps is loaded, which it will be

--------------------------------------------------------------------------------------------------------------*/
/obj/effect/landmark/map_data/admin
	level_id = "admin_level_1"


/obj/effect/landmark/map_data/transit
	level_id = "transit_level_1"