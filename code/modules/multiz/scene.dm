/*
	Scene datums should be defined at authortime, one for each vessel, planet, asteroid, etc. Each cluster of levels that makes a physical location
	They should be defined inside the map folder

*/
/datum/scene
	//Authortime
	//------------------
	var/name = "Unknown Location" //The name of the location. This may be shown in interfaces and should be human-readable
	var/id = "unknown_location"	  //ID must be unique, landmarks will use it to link levels to this scene datum

	//Runtime
	//------------------
	var/list/levels = list()	//Populated at runtime, this contains all the zlevels associated with this scene.
		//It is an associative list in the format "number" = leveldatum.

	var/list/level_numbers = list()
		//This is a NON associative list containing only the raw z numbers of zlevels which are in this scene

/*--------------------------------------------------------------------------------------------------------------

	Helper Procs:
--------------------------------------------------------------------------------------------------------------*/
/atom/proc/get_scene()
	var/datum/level/L = get_level()
	return L.scene

/proc/get_scene_from_z(var/z)
	var/datum/level/L = get_level_from_z(z)
	if (istype(L))
		return L.scene

/*--------------------------------------------------------------------------------------------------------------

	Generic scenes: Useable on multiple maps, so long as only one of those maps is loaded, which it will be

--------------------------------------------------------------------------------------------------------------*/
/datum/scene/adminspace
	//Authortime
	//------------------
	name = "Unknown Sector" //The name of the location. This may be shown in interfaces and should be human-readable
	id = "admin_space"	  //ID must be unique, landmarks will use it to link levels to this scene datum


/datum/scene/transit
	//Authortime
	//------------------
	name = "In transit" //The name of the location. This may be shown in interfaces and should be human-readable
	id = "transit_space"	  //ID must be unique, landmarks will use it to link levels to this scene datum


//The overmap level/scene is assigned through code in overmap/sectors.dm
/datum/scene/overmap
	name = "Overmap"
	id = "overmap"