//a basic room generator.
//room should assume that (x,y) is the bottom left corner
//TODO make more content!
/datum/random_room
	var/width = 0
	var/height = 0
	var/x = 0
	var/y = 0
	var/list/item_spawns

/datum/random_room/New(_x,_y,_width,_height)
	width = _width
	height = _height
	x = _x
	y = _y

/datum/random_room/proc/apply_to_map(xorigin = 1,yorigin = 1,zorigin = 1)
	return 1

/datum/random_room/proc/apply_loot(xorigin = 1,yorigin = 1,zorigin = 1, type)
	if(!item_spawns || !item_spawns.len)
		return 0
	var/place = pick(item_spawns)
	if(istype(place,/obj)) //we assume what object we get is some sort of container.
		var/obj/O = place
		if(O.contents && prob(O.contents.len * (25 / O.w_class)))
			return 0
		new type(place)
	else if(istype(place,/mob))
		var/mob/M = place
		var/atom/movable/A = new type(M.loc)
		M.equip_to_appropriate_slot(A) //we don't have to check if its an object or not since hte proc in question already does that
	else //its a turf. Put it on it.
		var/turf/T = place
		if(T.density) //under no circumstances place an item in a wall.
			return 0
		new type(place)
	return 1
