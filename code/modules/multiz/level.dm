
/*
	A level datum represents one flat zlevel in game memory.
	They are created at authortime and should be placed in the map folder, same file as scene and landmarks will do fine.
	All levels must be unique, never reuse the same one twice
*/
/datum/level
	//Authortime
	//----------------

	var/name = "Space" //Name of the level. This should NOT include the name of the scene, as that will be automatically prepended in most cases
	var/id	=	"unknown_space" //ID of the level, this must be unique, so do include the scene name in this case. this will be used for a landmark to find this level
	var/scene_id = "unknown_location"	//ID of the scene, must be unique, used to link this level to the scene datum
	var/base_type	= /datum/level //The parent/base type of this level. It will be excluded from the all_level_datums list

	var/list/connections = list()
	/*
	This list is crucial, it explains how this level connects to others.
	It is an associative list
	Using the six direction defines in string form as key, and the id of another level as value.
	UP_S = unknown_deck2
	DOWN_S = unknown_deck0
	WEST_S = something
	EAST_S = something
	NORTH_S = something
	SOUTH_S = something

	Only one connection per direction, but its perfectly fine to connect to the same level in multiple directions, there are applications for that.

	At runtime, this list is converted from ids to datum references as the value. key remains unchanged
	*/


	var/sealed = FALSE
	//If false, players will end up floating in space when they fall of the edge
	//If true, players can't walk off the edge of this map unless theres a specific connection.


	//Runtime
	//----------------
	var/z = 0	//Holds the z value associated with this level
	var/datum/scene/scene	//Pointer to the scene datum, this is populated at runtime

//This is called when a landmark for this level does its thing, and AFTER we've been assigned a z number
/datum/level/proc/Initialize()

	//Add it to the global list of all zlevels
	SSmapping.zlevels["[z]"] = src

	//Lets replace the strings in our connections list with datums
	for (var/direction in connections)
		var/name = connections[direction]
		var/datum/level/L = SSmapping.all_level_datums[name]
		connections[direction] = L

	//And add it to the list in the parent scene datum
	scene.levels["[z]"] = src
	scene.level_numbers |= z //There should never be two of these landmarks on the same level, but lets use |= anyway in case someone screwed up


//Called on the origin level when attempting to transition to a different one. Should return true or false only.
//When calling, supply any vars you have data for, an override can use them to figure out what to do
/datum/level/proc/can_leave_level(var/atom/mover = null, var/direction = null,  var/method = ZMOVE_PHASE, var/datum/level/destination = null)
	return TRUE


//Called on the origin level when attempting to transition to a different one. Should return true or false only
//When calling, supply any vars you have data for, an override can use them to figure out what to do
/datum/level/proc/can_enter_level(var/atom/mover = null, var/direction = null,  var/method = ZMOVE_PHASE, var/datum/level/origin = null)
	return TRUE


//Origin is not used in this base class, but it could be used in an override to direct people to a different level based on their exact position
/datum/level/proc/get_connected_level(var/direction, var/atom/origin = null)
	if (direction)
		if (connections["[direction]"])
			return connections["[direction]"]

	if (sealed)
		return null //You're not walking off the edge

	else



//Called on the recieving zlevel when someone moves between levels.  Mover cannot be null
/datum/level/proc/get_landing_point(var/atom/mover, var/direction = null,  var/method = ZMOVE_PHASE, var/datum/level/origin = null)
	var/vector2/destination = new /vector2(mover.x, mover.y)
	if (!mover)
		return null
	if (direction == UP || direction == DOWN)

		return destination
	else
		if (direction == NORTH)
			destination.y = world.maxy - (TRANSITIONEDGE +1)  //Bizarrely coordinates are counted from the topleft corner, so maxy is the bottom of the screen
		else if (direction == SOUTH)
			destination.y = (TRANSITIONEDGE +1)
		else if (direction == EAST)
			destination.x = (TRANSITIONEDGE +1)
		else if (direction == WEST)
			destination.x = world.maxx - (TRANSITIONEDGE +1)
		else
			return null //Should not happen

	return destination





/*--------------------------------------------------------------------------------------------------------------

	Helper Procs:

--------------------------------------------------------------------------------------------------------------*/
/atom/proc/get_level()
	if (z)
		return SSmapping.zlevels["[z]"]
	return null

/proc/get_level_from_z(var/z)
	return SSmapping.zlevels["[z]"]

/proc/can_move_between_levels(var/atom/mover = null, var/direction = null,  var/method = ZMOVE_PHASE, var/datum/level/origin, var/datum/level/destination)
	if (origin.can_leave_level(mover, direction, method, destination) && destination.can_enter_level(mover, direction, method, origin))
		return TRUE
	return FALSE

/proc/get_empty_level()
	if(!SSmapping.empty_levels.len)
		create_empty_level()
	if(SSmapping.empty_levels.len)
		return pick(SSmapping.empty_levels)

	return null

/proc/create_empty_level()
	world.maxz++ //This adds a new level onto the end of the list
	SSmapping.map_index++ //Increment the index
	var/datum/level/newlevel = new()
	newlevel.id += "[newlevel.id]_[SSmapping.map_index]" //The new level uses the default values, but with the map index appended onto the end of the ID
	//This ensures that the id is unique and prevents namespace collisions.
	//All the empty levels will be in the same scene, but not directly connected to each other
	SSmapping.empty_levels += newlevel

/*--------------------------------------------------------------------------------------------------------------

	Generic levels: Useable on multiple maps, so long as only one of those maps is loaded, which it will be

--------------------------------------------------------------------------------------------------------------*/
//extra transit and admin levels can be added if needed by incrementing the number on the end of id
/datum/level/admin
	//Authortime
	//----------------
	name = "" //Name of the level. This should NOT include the name of the scene, as that will be automatically prepended in most cases
	id	=	"admin_level_1" //ID of the level, this must be unique, so do include the scene name in this case. this will be used for a landmark to find this level
	scene_id = "admin_space"	//ID of the scene, must be unique, used to link this level to the scene datum


/datum/level/transit
	//Authortime
	//------------------
	name = "" //The name of the location. This may be shown in interfaces and should be human-readable
	id = "transit_level_1"	  //ID must be unique, landmarks will use it to link levels to this scene datum
	scene_id = "transit_space"