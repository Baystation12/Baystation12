#define BORDER_CHAR -1
/*basic dungeon algorithm. Based off of http://www.roguebasin.com/index.php?title=Dungeon-Building_Algorithm (specifically the C++ version).
 *The jist of how the dungeon algorithm works is as follows:
 *Corridors and rooms are both considered features of a dungeon.
 *The dungeon continues to spawn rooms and corridors attached to previously created rooms and corridors (by detecting the walls/floors) until the amount of features is equal to a predefined number.
 *This number is calculated at the beginning of the dungeon. I went with limit_x*limit_y/100. It seems to work well.
 *It is supposed to create a 'winding' aspect to the dungeons. It works.... relatively well?

 *THINGS TO KNOW
 *ARTIFACT_TURF_CHAR is used for room walls, used primarily for code used for corridors.
 *ARTIFACT_TURF is used to mark gaps in walls for rooms - this is checked so that we don't have three corridors in a row. This isn't done for corridors so that we can have branching paths.
 *Rooms will generate a room_theme, a datum that points to a few different types to generate the room with.
 *room_themes will also generate stuff inside. This is a random_room datum.

* TODO:
* Make monster spawning from a datum so I can have general 'group spawns'.
*/

/datum/random_map/winding_dungeon
	descriptor = "winding dungeon"
	wall_type = /turf/simulated/mineral
	floor_type = /turf/simulated/floor/tiled
	var/room_wall_type = /turf/simulated/wall
	var/border_wall_type = /turf/unsimulated/mineral

	target_turf_type = /turf/unsimulated/mask

	var/chance_of_room = 65
	var/chance_of_room_empty = 50
	var/chance_of_door = 30
	var/room_size_min = 4
	var/room_size_max = 8
	var/features_multiplier = 0.02
	var/monster_multiplier = 0.007
	var/loot_multiplier = 0.01

	var/first_room_x = 45
	var/first_room_y = 1
	var/first_room_width = 10
	var/first_room_height = 10

	var/monster_faction = "dungeon" //if set, factions of the mobs spawned will be set to this.
	//without this they will attack each other.

	var/list/open_positions = list() //organized as: x:y
	var/list/room_theme_common = list(/datum/room_theme = 10)
	var/list/room_theme_uncommon = list()
	var/list/room_theme_rare = list()
	var/list/monsters_common = list()
	var/list/monsters_uncommon = list()
	var/list/monsters_rare = list()
	var/list/loot_common = list()
	var/list/loot_uncommon = list()
	var/list/loot_rare = list()

	var/list/monster_available = list()//turfs that monsters can spawn on. Pregenerated to guard against lag.

	var/list/rooms = list()
	var/log = 0 //if set will log information to dd
	limit_x = 50
	limit_y = 50

/datum/random_map/winding_dungeon/New(var/seed, var/tx, var/ty, var/tz, var/tlx, var/tly, var/do_not_apply, var/do_not_announce, var/list/variable_list)
	for(var/variable in variable_list)
		if(variable in src.vars)
			src.vars[variable] = variable_list[variable]
	..()

/datum/random_map/winding_dungeon/proc/logging(var/text)
	if(log)
		log_world(text)

/datum/random_map/winding_dungeon/proc/get_appropriate_list(var/list/common, var/list/uncommon, var/list/rare, var/x, var/y)
	var/distance = sqrt((x - round(first_room_x+first_room_width/2)) ** 2 + (y - round(first_room_y+first_room_height/2)) ** 2)
	if(prob(distance))
		if(prob(distance/100) && rare && rare.len)
			logging("Returning rare list.")
			return rare
		else if(uncommon && uncommon.len)
			logging("Returning uncommon list.")
			return uncommon
	logging("Returning common list.")
	return common


/datum/random_map/winding_dungeon/apply_to_map()
	logging("You have [rooms.len] # of rooms")
	for(var/datum/room/R in rooms)
		if(!priority_process)
			sleep(-1)
		R.apply_to_map(origin_x,origin_y,origin_z,src)
	..()
	var/num_of_loot = round(limit_x * limit_y * loot_multiplier)
	logging("Attempting to add [num_of_loot] # of loot")
	var/sanity = 0
	if((loot_common && loot_common.len) || (loot_uncommon && loot_uncommon.len) || (loot_rare && loot_rare.len)) //no monsters no problem
		while(rooms.len && num_of_loot > 0)
			if(!priority_process)
				sleep(-1)
			var/datum/room/R = pick(rooms)
			var/list/loot_list = get_appropriate_list(loot_common, loot_uncommon, loot_rare, round(R.x+R.width/2), round(R.y+R.height/2))
			if(!loot_list || !loot_list.len || R.add_loot(origin_x,origin_y,origin_z,pickweight(loot_list)))
				num_of_loot--
				sanity -= 10 //we hahve success so more tries
				continue
			sanity++
			if(sanity > 100)
				logging("Sanity limit reached on loot spawning #[num_of_loot]")
				num_of_loot = 0

	for(var/datum/room/R in rooms)
		rooms -= R
		qdel(R)

	if((!monsters_common || !monsters_common.len) && (!monsters_uncommon || !monsters_uncommon.len) && (!monsters_rare || !monsters_rare.len)) //no monsters no problem
		logging("No monster lists detected. Not spawning monsters.")
		return

	var/num_of_monsters = round(limit_x * limit_y * monster_multiplier)
	logging("Attempting to add [num_of_monsters] # of monsters")

	while(num_of_monsters > 0)
		if(!priority_process)
			sleep(-1)
		if(!monster_available || !monster_available.len)
			logging("There are no available turfs left.")
			num_of_monsters = 0
			continue
		var/turf/T = pick(monster_available)
		monster_available -= T
		var/list/monster_list = get_appropriate_list(monsters_common, monsters_uncommon, monsters_rare, T.x, T.y)
		if(monster_list && monster_list.len)
			var/type = pickweight(monster_list)
			logging("Generating a monster of type [type] at position ([T.x],[T.y],[origin_z])")
			var/mob/M = new type(T)
			if(monster_faction)
				M.faction = monster_faction
		else
			logging("The monster list is empty.")
		num_of_monsters--

	monster_available = null //Get rid of all the references

/datum/random_map/winding_dungeon/apply_to_turf(var/x, var/y)
	. = ..()
	var/turf/T = locate((origin_x-1)+x,(origin_y-1)+y,origin_z)
	if(T && !T.density)
		var/can = 1
		for(var/atom/movable/M in T)
			if(istype(M,/mob/living) || M.density)
				can = 0
				break
		if(can)
			monster_available += T

/datum/random_map/winding_dungeon/generate_map()
	logging("Winding Dungeon Generation Start")
	//first generate the border
	for(var/xx = 1, xx <= limit_x, xx++)
		map[get_map_cell(xx,1)] = BORDER_CHAR
		map[get_map_cell(xx,limit_y)] = BORDER_CHAR
	for(var/yy = 1, yy < limit_y, yy++)
		map[get_map_cell(1,yy)] = BORDER_CHAR
		map[get_map_cell(limit_x,yy)] = BORDER_CHAR

	var/num_of_features = limit_x * limit_y * features_multiplier
	logging("Number of features: [num_of_features]")
	var/currentFeatures = 1
	var/result = carve_area(first_room_x,first_room_y,first_room_width,first_room_height, FLOOR_CHAR, ARTIFACT_TURF_CHAR)
	logging("First room result: [result ? "Success" : "Failure"]")
	var/sanity = 0
	for(sanity = 0, sanity < 1000, sanity++)
		if(!priority_process)
			sleep(-1)

		if(currentFeatures == num_of_features)
			break
		/* WHAT THIS CODE IS DOING:
		Very basically I'm taking a point off of the coords list and trying to create a room in a certain direction.
		What a lot of this code is doing is figuring out where to put the REAL x and y values so that we are in the bottom left corner
		of the new room for processing.
		*/
		var/newx = 0 //the point where this feature meets another one.
		var/newy = 0
		var/xmod = 0 //the change in x and y determined to be needed
		var/ymod = 0
		var/doorx = 0 //where we put the marker down where things were.
		var/doory = 0
		var/width = 1 //width of room
		var/height = 1 //height of room.
		var/isRoom = 1 //whether we are a room or not
		for(var/testing = 0, testing < 1000, testing++)
			if(open_positions.len)
				var/list/coords = splittext(pick(open_positions), ":") //pop a coord from the list.
				newx = text2num(coords[1])
				newy = text2num(coords[2])
				open_positions -= "[newx]:[newy]"
				logging("Picked coords ([newx],[newy]) from open_positions. Removing it. (length: [open_positions.len])")
			else
				newx = rand(1,limit_x)
				newy = rand(1,limit_y)
				logging("open_positions empty. Using randomly chosen coords ([newx],[newy])")

			//We want to make sure we aren't RIGHT next to another corridor or something.
			if(map[get_map_cell(newx,newy+1)] == ARTIFACT_CHAR || map[get_map_cell(newx-1,newy)] == ARTIFACT_CHAR || map[get_map_cell(newx,newy-1)] == ARTIFACT_CHAR || map[get_map_cell(newx+1,newy)] == ARTIFACT_CHAR)
				logging("Coords ([newx],[newy]) are too close to an ARTIFACT_CHAR position.")
				continue


			//set up our variables.
			width = rand(room_size_min,room_size_max)
			height = rand(room_size_min,room_size_max)
			isRoom = rand(100) <= chance_of_room

			if(map[get_map_cell(newx, newy)] == ARTIFACT_TURF_CHAR || map[get_map_cell(newx, newy)] == CORRIDOR_TURF_CHAR)
				//we are basically checking to see where we're going. Up, right, down or left and finding the bottom left corner.
				if(map[get_map_cell(newx,newy+1)] == FLOOR_CHAR || map[get_map_cell(newx,newy+1)] == CORRIDOR_TURF_CHAR) //0 - down
					logging("This feature is DOWN")
					if(isRoom) //gotta do some math for this one, since the origin is centered.
						xmod = -width/2
					else
						width = 1
						xmod = 0
					ymod = -height //a lot of this will seem nonsense but I swear its not
					doorx = 0
					doory = -1
				else if(map[get_map_cell(newx-1,newy)] == FLOOR_CHAR || map[get_map_cell(newx-1,newy)] == CORRIDOR_TURF_CHAR) //1 - right
					logging("This feature is RIGHT")
					if(isRoom)
						ymod = -height/2
					else
						height = 1
						ymod = 0
					xmod = 1
					doorx = 1
					doory = 0
				else if(map[get_map_cell(newx,newy-1)] == FLOOR_CHAR || map[get_map_cell(newx,newy-1)] == CORRIDOR_TURF_CHAR) //2 - up
					logging("This feature is UP")
					if(isRoom)
						xmod = -width/2
					else
						width = 1
						xmod = 0
					ymod = 1
					doorx = 0
					doory = 1
				else if(map[get_map_cell(newx+1,newy)] == FLOOR_CHAR || map[get_map_cell(newx+1,newy)] == CORRIDOR_TURF_CHAR) // 3 - left
					logging("This feature is LEFT")
					if(isRoom)
						ymod = -height/2
					else
						height = 1
						ymod = 0
					xmod = -width
					doorx = -1
					doory = 0
				else
					continue

			break

		if(sanity < 1000) //If we haven't looped through everything
			logging("Carving out stuff.")
			var/wall_char = (isRoom ? ARTIFACT_TURF_CHAR : CORRIDOR_TURF_CHAR)
			if(!carve_area(round(newx+xmod),round(newy+ymod),width,height,FLOOR_CHAR,wall_char)) //something went bad
				logging("Carving failed at position: ([newx],[newy]) with modifiers ([xmod],[ymod]) and size ([width],[height]). isRoom ([isRoom])")
				continue //so just try again
			currentFeatures++
			if(isRoom)
				logging("Room created at: [newx+xmod], [newy+ymod].")
				map[get_map_cell(newx,newy)] = FLOOR_CHAR
				map[get_map_cell(newx+doorx,newy+doory)] = ARTIFACT_CHAR
				if(rand(0,100) >= chance_of_room_empty)
					var/room_result = create_room_features(round(newx+xmod),round(newy+ymod),width,height)
					logging("Attempted room feature creation: [room_result ? "Success" : "Failure"]")
			else
				logging("Creating corridor.")
				var/door = get_map_cell(newx,newy)
				if(map[door] == ARTIFACT_TURF_CHAR)
					map[door] = ARTIFACT_CHAR
	logging("Map completed. Loops: [sanity], [currentFeatures] out of [num_of_features] created.")
	open_positions.Cut()

/datum/random_map/winding_dungeon/proc/carve_area(var/truex,var/truey,var/width,var/height,var/char, var/wall_char)
	for(var/mode = 0, mode <= 1, mode++)
		for(var/ytemp = truey, ytemp < truey + height, ytemp++)
			if(!mode && (ytemp < 0 || ytemp > limit_y))
				logging("We are beyond our x limits")
				return 0
			for(var/xtemp = truex, xtemp < truex + width, xtemp++)
				if(!mode)
					if(xtemp < 0 || xtemp > limit_x)
						logging("We are beyond our x limits")
						return 0
					if(map[get_map_cell(xtemp,ytemp)] != WALL_CHAR)
						logging("[xtemp],[ytemp] is not equal to WALL_CHAR")
						return 0
				else
					if(wall_char && (ytemp == truey || ytemp == truey + height - 1 || xtemp == truex || xtemp == truex + width - 1))
						map[get_map_cell(xtemp,ytemp)] = wall_char
						if(!("[xtemp]:[ytemp]" in open_positions))
							open_positions += "[xtemp]:[ytemp]"
							logging("Adding \"[xtemp]:[ytemp]\" to open_positions (length: [open_positions.len])")
					else
						map[get_map_cell(xtemp,ytemp)] = char
	return 1

/datum/random_map/winding_dungeon/proc/create_room_features(var/rox,var/roy,var/width,var/height)
	var/list/room_list = get_appropriate_list(room_theme_common, room_theme_uncommon, room_theme_rare, round(rox+width/2), round(roy+height/2))
	var/theme_type = pickweight(room_list)
	if(!theme_type)
		return 0
	var/room_theme = new theme_type(origin_x,origin_y,origin_z)
	var/datum/room/R = new(room_theme,rox,roy,width,height,rand(0,100) <= chance_of_door)
	if(!R)
		return 0
	rooms += R
	return 1

/datum/random_map/winding_dungeon/proc/add_loot(var/xorigin,var/yorigin,var/zorigin,var/type)
	var/datum/room/room = pick(rooms)
	return room.add_loot(type)

/datum/random_map/winding_dungeon/get_appropriate_path(var/value)
	switch(value)
		if(WALL_CHAR)
			return wall_type
		if(ARTIFACT_TURF_CHAR)
			return room_wall_type
		if(BORDER_CHAR)
			return border_wall_type
		else
			return floor_type

/datum/random_map/winding_dungeon/get_map_char(var/value)
	. = ..(value)
	switch(value)
		if(BORDER_CHAR)
			. = "#"