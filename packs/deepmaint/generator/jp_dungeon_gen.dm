/*
	This* datum is the heart of the generator. It provides the interface - you create a
	jp_DungeonGenerator object, twiddle some parameters, call a procedure, and then grab
	the results.
*/
/**
	Below this comment is a pinnacle of sorcery unearthed from ancient era of byond.
	Proceed with caution, for you may not comprehed whatever the fuck this is.
	I sure don't. Original code by http://www.byond.com/members/Jp
	Adapted for Eris and more modern byond versions by me.
	Quite a bit was modified/removed/re-done.
	Pathing was made strict/all objects here are subtype of obj/procedural.

- Nestor/drexample (full permission to bug me if you have questions or code suggestions)
*/
/obj/procedural/jp_DungeonGenerator

	///One corner of the rectangle the algorithm is allowed to modify
	var/turf/corner1
	///The other corner of the rectangle the algorithm is allowed to modify
	var/turf/corner2

	///The list of rooms the algorithm may place
	var/list/allowedRooms

	///Whether the algorithm should just use AABB collision detection between rooms, or use the slower version with no false positives
	var/doAccurateRoomPlacementCheck = FALSE
	///Whether the algorithm should find any already extant open regions in the area it is working on, and incorporate them into the dungeon being generated
	var/usePreexistingRegions = FALSE

	///The type used for open floors placed in corridors
	var/floortype
	///Either a single type, or a list of types that are considered 'walls' for the purpose of this algorithm
	var/list/walltype

	///The upper limit of the number of 'rooms' placed in the dungeon. NOT GUARANTEED TO BE REACHED
	var/numRooms
	///The upper limit on the number of extra paths placed beyond those required to ensure connectivity. NOT GUARANTEED TO BE REACHED
	var/numExtraPaths
	///The number of do-nothing iterations before the generator gives up with an error.
	var/maximumIterations = 120
	///The minimum 'size' passed to rooms.
	var/roomMinSize
	///The maximum 'size' passed to rooms.
	var/roomMaxSize
	///The absolute maximum length paths are allowed to be.
	var/maxPathLength
	///The absolute minimum length paths are allowed to be.
	var/minPathLength
	///The absolute minimum length of a long path
	var/minLongPathLength
	///The chance of terminating a path when it's found a valid endpoint, as a percentage
	var/pathEndChance
	///The chance that any given path will be designated 'long'
	var/longPathChance
	///The default width of paths connecting the rooms
	var/pathWidth = 2
	///Chance to spawn a light during path generation
	var/lightSpawnChance = 0

	///Internal list. No touching, unless you really know what you're doing.
	var/list/border_turfs

	///Internal list, used for pre-existing region stuff
	var/list/examined

	var/list/path_turfs = list()

	///The number of rooms the generator managed to place
	var/out_numRooms
	///The total number of paths the generator managed to place. This includes those required for reachability as well as 'extra' paths, as well as all long paths.
	var/out_numPaths
	///The number of long paths the generator managed to place. This includes those required for reachability, as well as 'extra' paths.
	var/out_numLongPaths
	///0 if no error, positive value if a fatal error occured, negative value if something potentially bad but not fatal happened
	var/out_error
	///How long it took, in ms. May be negative if the generator runs 'over' midnight that is, starts in one day, ends in another.
	var/out_time
	///What seed was used to power the RNG for the dungeon.
	var/out_seed
	///The jp_DungeonRegion object that we were left with after all the rooms were connected
	var/obj/procedural/jp_DungeonRegion/out_region

	///A list containing all the jp_dungeonroom datums placed on the map
	var/list/obj/procedural/jp_dungeonroom/out_rooms


	///The allowed-rooms list is empty or bad.
	var/const/ERROR_NO_ROOMS = 1
	///The area that the generator is allowed to work on was specified badly
	var/const/ERROR_BAD_AREA = 2
	///The type used for walls wasn't specified
	var/const/ERROR_NO_WALLTYPE = 3
	///The type used for floors wasn't specified
	var/const/ERROR_NO_FLOORTYPE = 4
	///The number of rooms to draw was a bad number
	var/const/ERROR_NUMROOMS_BAD = 5
	///The number of extra paths to draw was a bad number
	var/const/ERROR_NUMEXTRAPATHS_BAD = 6
	///The specified room sizes (either max or min) include a bad number
	var/const/ERROR_ROOM_SIZE_BAD = 7
	///The specified path lengths (either max or min) include a bad number
	var/const/ERROR_PATH_LENGTH_BAD = 8
	///The pathend chance is a bad number
	var/const/ERROR_PATHENDCHANCE_BAD = 9
	///The chance of getting a long path was a bad number
	var/const/ERROR_LONGPATHCHANCE_BAD = 10

	///Parameters were fine, but maximum iterations was reached while placing rooms. This is not necessarily a fatal error condition - it just means not all the rooms you specified may have been placed. This error may be masked by errors further along in the process.
	var/const/ERROR_MAX_ITERATIONS_ROOMS = -1
	///Parameters were fine, but maximum iterations was reached while ensuring connectivity. If you get this error, there are /no/ guarantees about reachability - indeed, you may end up with a dungeon where no room is reachable from any other room.
	var/const/ERROR_MAX_ITERATIONS_CONNECTIVITY = 11
	///Parameters were fine, but maximum iterations was reached while placing extra paths after connectivity was ensured. The dungeon should be fine, all the rooms should be reachable, but it may be less interesting. Or you may just have asked to place too many extra paths.
	var/const/ERROR_MAX_ITERATIONS_EXTRAPATHS = -2

	///Everything was fine, but you forgot to include submaps for rooms that try to load them.
	var/const/ERROR_NO_SUBMAPS = 12


	/***********************************************************************************
	 *	Internal procedures. Might be useful if you're writing a /jp_dungeonroom datum.*
	 *	Probably not useful if you just want to make a simple dungeon				   *
	 ***********************************************************************************/

/obj/procedural/jp_DungeonGenerator/proc/updateWallConnections()
	for(var/turf/simulated/wall/W in border_turfs)
		W.update_connections(1)

/**
	Returns a list of turfs adjacent to the turf 't'. The definition of 'adjacent'
	may depend on various properties set - at the moment, it is limited to the turfs
	in the four cardinal directions.
*/
/obj/procedural/jp_DungeonGenerator/proc/getAdjacent(turf/t)
	//Doesn't just go list(get_step(blah blah), get_step(blah blah) etc. because that could return null if on the border of the map
	.=list()
	var/k = get_step(t,NORTH)
	if(k).+=k
	k = get_step(t,SOUTH)
	if(k).+=k
	k = get_step(t,EAST)
	if(k).+=k
	k = get_step(t,WEST)
	if(k).+=k


/**
	Same as above, but skips X tiles from original one
*/
/obj/procedural/jp_DungeonGenerator/proc/getAdjacentFurther(turf/t, num = 1)
	//Doesn't just go list(get_step(blah blah), get_step(blah blah) etc. because that could return null if on the border of the map
	.=list()
	var/counter = num
	var/k = null
	k = get_step(t,NORTH)
	while(counter > 0)
		if(k)
			k = get_step(k,NORTH)
			counter--
		else
			k = null
			break;
	if(k)
		.+=k
	counter = num
	k = get_step(t,SOUTH)
	while(counter > 0)
		if(k)
			k = get_step(k,SOUTH)
			counter--
		else
			k = null
			break;
	if(k)
		.+=k
	counter = num
	k = get_step(t,EAST)
	while(counter > 0)
		if(k)
			k = get_step(k,EAST)
			counter--
		else
			k = null
			break;
	if(k)
		.+=k
	counter = num
	k = get_step(t,WEST)
	while(counter > 0)
		if(k)
			k = get_step(k,WEST)
			counter--
		else
			k = null
			break;
	if(k)
		.+=k

/**

	Post-initializes all submaps

*/
/obj/procedural/jp_DungeonGenerator/proc/initializeSubmaps()
	var/singleton/map_template/init_template = new /singleton/map_template/deepmaint_template/room
	var/list/bounds = list(1.#INF, 1.#INF, 1.#INF, -1.#INF, -1.#INF, -1.#INF)
	bounds[MAP_MINX] = 1
	bounds[MAP_MINY] = world.maxy
	bounds[MAP_MINZ] = (get_turf(loc)).z
	bounds[MAP_MAXX] = world.maxx
	bounds[MAP_MAXY] = 1
	bounds[MAP_MAXZ] = (get_turf(loc)).z
	init_template.preload_size()

/**
	Returns 'true' if l is a list, false otherwise
*/

/***********************************************************************************
 *	External procedures, intended to be used by user code.						   *
 ***********************************************************************************/

/**
	Returns a string representation of the error you pass into it.
	So you'd call g.errString(g.out_error)
*/
/obj/procedural/jp_DungeonGenerator/proc/errString(e)
	switch(e)
		if(0) return "No error"
		if(ERROR_NO_ROOMS) return "The allowedRooms list was either empty, or an illegal value"
		if(ERROR_BAD_AREA) return "The area that the generator is allowed to work on was either empty, or crossed a z-level"
		if(ERROR_NO_WALLTYPE) return "The types that are walls were either not specified, or weren't a typepath or list of typepaths"
		if(ERROR_NO_FLOORTYPE) return "The type used for floors either wasn't specified, or wasn't a typepath"
		if(ERROR_NUMROOMS_BAD) return "The number of rooms to place was either negative, or not an integer"
		if(ERROR_NUMEXTRAPATHS_BAD) return "The number of extra paths to place was either negative, or not an integer"
		if(ERROR_ROOM_SIZE_BAD) return "One of the minimum and maximum room sizes was negative, or not an integer. Alternatively, the minimum room size was larger than the maximum room size"
		if(ERROR_PATH_LENGTH_BAD) return "One of the path-length parameters was negative, or not an integer. Alternatively, either minimum path length or minimum long path length was larger than maximum path length"
		if(ERROR_PATHENDCHANCE_BAD) return "The pathend chance was either less than 0 or greater than 100"
		if(ERROR_LONGPATHCHANCE_BAD) return "The long-path chance was either less than 0, or greater than 100"
		if(ERROR_MAX_ITERATIONS_ROOMS) return "Maximum iterations was reached while placing rooms on the map. The number of rooms you specified may not have been placed. The dungeon should still be usable"
		if(ERROR_MAX_ITERATIONS_CONNECTIVITY) return "Maximum iterations was reached while ensuring connectivity. No guarantees can be made about reachability. This dungeon is likely unusable"
		if(ERROR_MAX_ITERATIONS_EXTRAPATHS) return "Maximum iterations was reached while placing extra paths. The number of extra paths you specified may not have been placed. The dungeon should still be usable"
		if(ERROR_NO_SUBMAPS) return "No submaps were provided for room types that require to load them."

/**
	Sets the number of rooms that will be placed in the dungeon to 'r'.
	Positive integers only
*/
/obj/procedural/jp_DungeonGenerator/proc/setNumRooms(r)
	numRooms = r

/**
	Sets the width of paths generated.
	Positive and negative integers work.
	(negatives invert the way square that sets width of the path is calculated)
*/

/obj/procedural/jp_DungeonGenerator/proc/setPathWidth(r)
	pathWidth = r

/**
	Returns the number of rooms that will be placed in the dungeon
*/
/obj/procedural/jp_DungeonGenerator/proc/getNumRooms()
	return numRooms

/**
	Sets the number of 'extra' paths that will be placed in the dungeon - 'extra'
	in that they aren't required to ensure reachability
*/
/obj/procedural/jp_DungeonGenerator/proc/setExtraPaths(p)
	numExtraPaths = p

	/**
		Returns the number of extra paths that will be placed in the dungeon
	*/
/obj/procedural/jp_DungeonGenerator/proc/getExtraPaths()
	return numExtraPaths

	/**
		Sets the maximum number of do-nothing loops that can occur in a row before the
		generator gives up and does something else.
	*/
/obj/procedural/jp_DungeonGenerator/proc/setMaximumIterations(i)
	maximumIterations = i

	/**
		Gets the maximum number of do-nothing loops that can occur in a row
	*/
/obj/procedural/jp_DungeonGenerator/proc/getMaximumIterations()
	return maximumIterations

	/**
		Sets and gets the maximum and minimum sizes used for rooms placed on the dungeon.
		m must be a positive integer.
	*/
/obj/procedural/jp_DungeonGenerator/proc/setRoomMinSize(m, typepath="")
	roomMinSize = m
/obj/procedural/jp_DungeonGenerator/proc/getRoomMinSize(typepath="")
	return roomMinSize
/obj/procedural/jp_DungeonGenerator/proc/setRoomMaxSize(m, typepath="")
	roomMaxSize = m
/obj/procedural/jp_DungeonGenerator/proc/getRoomMaxSize(typepath="")
	return roomMaxSize


/**
	Sets and gets the maximum and minimum lengths used for paths drawn between rooms
	in the dungeon, including 'long' paths (Which are required to be of a certain length)
	m must be a positive integer.
*/
/obj/procedural/jp_DungeonGenerator/proc/setMaxPathLength(m)
	maxPathLength = m
/obj/procedural/jp_DungeonGenerator/proc/setMinPathLength(m)
	minPathLength = m
/obj/procedural/jp_DungeonGenerator/proc/setMinLongPathLength(m)
	minLongPathLength = m
/obj/procedural/jp_DungeonGenerator/proc/getMaxPathLength()
	return maxPathLength
/obj/procedural/jp_DungeonGenerator/proc/getMinPathLength()
	return minPathLength
/obj/procedural/jp_DungeonGenerator/proc/getMinLongPathLength()
	return minLongPathLength

/**
	Sets and gets the chance of a path ending when it finds a suitable end turf.
	c must be a number between 0 and 100, inclusive
*/
/obj/procedural/jp_DungeonGenerator/proc/setPathEndChance(c)
	pathEndChance = c
/obj/procedural/jp_DungeonGenerator/proc/getPathEndChance()
	return pathEndChance

/**
	Sets and gets the chance of a path being designated a 'long' path, which has
	a different minimum length to a regular path. c must be a number between 0
	and 100, inclusive.
*/
/obj/procedural/jp_DungeonGenerator/proc/setLongPathChance(c)
	longPathChance = c
/obj/procedural/jp_DungeonGenerator/proc/getLongPathChance()
	return longPathChance

/**
	Sets the area that the generator is allowed to touch. This is required to be a
	rectangle. The parameters 'c1' and 'c2' specify the corners of the rectangle. They
	can be any two opposite corners. The generator does /not/ work over z-levels.
*/
/obj/procedural/jp_DungeonGenerator/proc/setArea(turf/c1, turf/c2)
	corner1 = c1
	corner2 = c2

/**
	Returns a list containing two of the corners of the area the generator is allowed to touch.
	Returns a list of nulls if the area isn't specified
*/
/obj/procedural/jp_DungeonGenerator/proc/getArea()
	return list(corner1, corner2)

/**
	Returns the smallest x-value that the generator is allowed to touch.
	Returns null if the area isn't specified.
*/
/obj/procedural/jp_DungeonGenerator/proc/getMinX()
	if(!corner1||!corner2) return null
	return min(corner1.x, corner2.x)

/**
	Returns the largest x-value that the generator is allowed to touch
	Returns null if the area isn't specified.
*/
/obj/procedural/jp_DungeonGenerator/proc/getMaxX()
	if(!corner1||!corner2) return null
	return max(corner1.x, corner2.x)

/**
	Returns the smallest y-value that the generator is allowed to touch.
	Returns null if the area isn't specified.
*/
/obj/procedural/jp_DungeonGenerator/proc/getMinY()
	if(!corner1||!corner2) return null
	return min(corner1.y, corner2.y)

/**
	Returns the largest y-value that the generator is allowed to touch
	Returns null if the area isn't specified.
*/
/obj/procedural/jp_DungeonGenerator/proc/getMaxY()
	if(!corner1||!corner2) return null
	return max(corner1.y, corner2.y)

/**
	Returns the Z-level that the generator operates on
	Returns null if the area isn't specified.
*/
/obj/procedural/jp_DungeonGenerator/proc/getZ()
	if(!corner1||!corner2) return null
	return corner1.z

/**
	Sets the list of jp_dungeonrooms allowed in this dungeon to 'l'.
	'l' should be a list of types.
*/
/obj/procedural/jp_DungeonGenerator/proc/setAllowedRooms(list/l)
	allowedRooms = list()
	for(var/k in l)	allowedRooms["[k]"] = new /obj/procedural/jp_dungeonroomEntry/(k)

/**
	Adds the type 'r' to the list of allowed jp_dungeonrooms. Will create
	the list if it doesn't exist yet.
*/
/obj/procedural/jp_DungeonGenerator/proc/addAllowedRoom(r, maxsize=-1, minsize=-1, required=-1, maxnum=-1)
	if(!allowedRooms) allowedRooms = list()
	allowedRooms["[r]"] = new /obj/procedural/jp_dungeonroomEntry/(r, maxsize, minsize, required, maxnum)

/**
	Removes the type 'r' from the list of allowed jp_dungeonrooms. Will create
	the list if it doesn't exist yet.
*/
/obj/procedural/jp_DungeonGenerator/proc/removeAllowedRoom(r)
	allowedRooms["[r]"] = null
	if(!allowedRooms || !length(allowedRooms)) allowedRooms = null

/**
	Returns the list of allowed jp_dungeonrooms. This may be null, if the list is empty
*/
/obj/procedural/jp_DungeonGenerator/proc/getAllowedRooms()
	if(!allowedRooms) return null
	var/list/l = list()
	for(var/k in allowedRooms) l+=text2path(k)
	return l

/**
	Sets the accurate room placement check to 'b'.
*/
/obj/procedural/jp_DungeonGenerator/proc/setDoAccurateRoomPlacementCheck(b)
	doAccurateRoomPlacementCheck = b

/**
	Gets the current value of the accurate room placement check
*/
/obj/procedural/jp_DungeonGenerator/proc/getDoAccurateRoomPlacementCheck()
	return doAccurateRoomPlacementCheck


/**
	Sets the use-preexisting-regions check to 'b'
*/
/obj/procedural/jp_DungeonGenerator/proc/setUsePreexistingRegions(b)
	usePreexistingRegions = b

/**
	Gets the current value of the use-preexisting-regions check
*/
/obj/procedural/jp_DungeonGenerator/proc/getUsePreexistingRegions()
	return usePreexistingRegions

/**
	Sets the type used for floors - both in corridors, and in some rooms - to 'f'
*/
/obj/procedural/jp_DungeonGenerator/proc/setFloorType(f)
	floortype = f

/**
	Gets the type used for floors.
*/
/obj/procedural/jp_DungeonGenerator/proc/getFloorType()
	return floortype

/**
	Sets the type/s detected as 'wall' to either the typepath 'w' or
	the list of typepaths 'w'
*/
/obj/procedural/jp_DungeonGenerator/proc/setWallType(w)
	walltype = w

/**
	Adds the typepath 'w' to the list of types considered walls.
*/
/obj/procedural/jp_DungeonGenerator/proc/addWallType(w)
	if(!walltype) walltype = list()
	if(!islist(walltype)) walltype = list(walltype)
	walltype+=w

/**
	Removes 'w' from the list of types considered walls
*/
/obj/procedural/jp_DungeonGenerator/proc/removeWallType(w)
	if(!islist(walltype))
		if(walltype==w) walltype = null
		return
	walltype-=w

/**
	Gets the types considered walls. This may be null, a typepath, or a list of typepaths
*/
/obj/procedural/jp_DungeonGenerator/proc/getWallType()
	return walltype


/obj/procedural/jp_DungeonGenerator/proc/getNeighboringRegions(list/R)
	var/list/regs = list()
	if(length(R) == 1)
		regs += R[1]
		regs += R[1]
		return regs
	var/obj/procedural/jp_DungeonRegion/r1 = pick(R)
	regs += r1
	var/obj/procedural/jp_DungeonRegion/r2 = null
	var/r_distance = 127 // At this time, get_dist() never returns a value greater than 127 - thank you, byond, very cool.
	for(var/obj/procedural/jp_DungeonRegion/region in R)
		if(r1 == region)
			continue
		var/dist = get_dist(r1.center, region.center)
		if(dist < r_distance)
			r2 = region
			r_distance = dist

	if(r2)
		regs += r2
		return regs

	else
		regs += pick(R)
		return regs




/**
	Actually goes out on a limb and generates the dungeon. This procedure runs in the
	background, because it's very slow. The various out_ variables will be updated after
	the generator has finished running. I suggest spawn()ing off the call to the generator.

	After this procedure finishes executing, you should have a beautiful shiny dungeon,
	with all rooms reachable from all other rooms. If you don't, first check the parameters
	you've passed to the generator - if you've set the number of rooms to 0, or haven't set
	it, you may not get the results you expect. If the parameters you've passed seem fine,
	and you've written your own /jp_dungeonroom object, it might be a good idea to check whether'
	or not you meet all the assumptions my code makes about jp_dungeonroom objects. There should
	be a reasonably complete list in the helpfile. If that doesn't help you out, contact me in
	some way - you may have found a bug, or an assumption I haven't documented, or I can show
	you where you've gone wrong.
*/
/obj/procedural/jp_DungeonGenerator/proc/generate(seed=null)
	set background = 1
	if(!check_params()) return
	out_numPaths = 0
	out_numLongPaths = 0

	var/tempseed = rand(-65535, 65535)
	var/numits
	var/paths
	var/obj/procedural/jp_dungeonroomEntry/nextentry
	var/obj/procedural/jp_dungeonroom/nextroom
	var/list/obj/procedural/jp_dungeonroom/rooms = list()
	var/list/obj/procedural/jp_DungeonRegion/regions = list()
	var/list/obj/procedural/jp_dungeonroomEntry/required = list()
	var/turf/nextloc

	var/minx
	var/maxx
	var/miny
	var/maxy
	var/z

	var/obj/procedural/jp_DungeonRegion/region1
	var/obj/procedural/jp_DungeonRegion/region2

	var/timer = world.timeofday

	if(isnull(seed))
		out_seed = rand(-65535, 65535)
		rand_seed(out_seed)
	else
		out_seed = seed
		rand_seed(seed)


	z = corner1.z
	minx = min(corner1.x, corner2.x) + roomMaxSize + 1
	maxx = max(corner1.x, corner2.x) - roomMaxSize - 1
	miny = min(corner1.y, corner2.y) + roomMaxSize + 1
	maxy = max(corner1.y, corner2.y) - roomMaxSize - 1

	if(minx>maxx || miny>maxy)
		out_error = ERROR_BAD_AREA
		return

	if(usePreexistingRegions)
		examined = list()
		for(var/turf/t in block(locate(getMinX(), getMinY(), getZ()), locate(getMaxX(), getMaxY(), getZ())))
			if(!t.is_wall()) if(!(t in examined)) rooms+=regionCreate(t)

	for(var/k in allowedRooms)
		nextentry = allowedRooms[k]
		if(nextentry.required>0) required+=nextentry

	var/rooms_placed = 0
	while(rooms_placed<numRooms)
		if(numits>maximumIterations)
			out_error=ERROR_MAX_ITERATIONS_ROOMS
			break

		nextloc = locate(rand(minx, maxx), rand(miny, maxy), z)

		if(!length(required)) nextentry = allowedRooms[pick(allowedRooms)]
		else
			nextentry = required[1]
			if(nextentry.count>=nextentry.required)
				required-=nextentry
				continue
		if(nextentry.maxnum>-1 && nextentry.count>=nextentry.maxnum) continue
		nextroom = new nextentry.roomtype(rand((nextentry.minsize<0)?(roomMinSize):(nextentry.minsize), (nextentry.maxsize<0)?(roomMaxSize):(nextentry.maxsize)), nextloc, src)
		numits++
		if(!nextroom.ok()) continue
		if(!rooms || !intersects(nextroom, rooms))
			nextroom.place()
			numits=0
			rooms+=nextroom
			rooms_placed++
			nextentry.count++
			sleep(1)

	border_turfs = list()

	for(var/obj/procedural/jp_dungeonroom/r in rooms)
		if(!r.doesMultiborder())
			if(length(r.border) == 0)
				continue
			var/obj/procedural/jp_DungeonRegion/reg = new /obj/procedural/jp_DungeonRegion(src)
			reg.addTurfs(r.getTurfs(), 1)
			reg.addBorder(r.getBorder())
			reg.center = r.centre
			regions+=reg
			border_turfs+=reg.getBorder()
		else
			for(var/l in r.getMultiborder())
				var/obj/procedural/jp_DungeonRegion/reg = new /obj/procedural/jp_DungeonRegion(src)
				reg.addTurfs(r.getTurfs(), 1)
				reg.addBorder(l)
				reg.center = r.centre
				regions+=reg
				border_turfs+=l

	for(var/turf/t in border_turfs)
		for(var/turf/t2 in range(t, 1))
			if(t2.is_wall()&&!(t2 in border_turfs))
				for(var/turf/t3 in range(t2, 1))
					if(!t3.is_wall())
						border_turfs+=t2
						break

	numits = 0
	paths = numExtraPaths

	while(length(regions)>1 || paths>0)
		if(numits>maximumIterations)
			if(length(regions)>1) out_error = ERROR_MAX_ITERATIONS_CONNECTIVITY
			else out_error = ERROR_MAX_ITERATIONS_EXTRAPATHS
			break
		numits++
		var/list/neighbors = getNeighboringRegions(regions)
		region1 = neighbors[1]
		region2 = neighbors[2]

		if(region1==region2)
			if(length(regions)>1)
				continue

		var/list/regBord = region1.getBorder()
		if(!length(regBord))
			regions -= region1
			continue

		var/list/turf/path = getPath(region1, region2, regions)

		if(!path || !length(path)) continue

		numits = 0

		if(region1==region2) if(length(regions)<=1) paths--

		for(var/turf/t in path)
			path-=t
			t.ChangeTurf(floortype)
			path+= t
			path_turfs += t

		region1.addTurfs(path)

		if(region1!=region2)
			region1.addTurfs(region2.getTurfs(), 1)
			region1.addBorder(region2.getBorder())
			regions-=region2

		for(var/turf/t in region1.getBorder()) if(!(t in border_turfs)) border_turfs+=t
		for(var/turf/t in path)	for(var/turf/t2 in range(t, 1))	if(!(t2 in border_turfs)) border_turfs+=t2

	for(var/obj/procedural/jp_dungeonroom/r in rooms)
		r.finalise()

	initializeSubmaps()
	updateWallConnections()

	out_time = (world.timeofday-timer)
	out_rooms = rooms
	out_region = region1
	out_numRooms = length(out_rooms)
	rand_seed(tempseed)








/***********************************************************************************
 *	The remaining procedures are seriously internal, and I strongly suggest not    *
 *  touching them unless you're certain you know what you're doing. That includes  *
 *  calling them, unless you've figured out what the side-effects and assumptions  *
 *  of the procedure are. These may not work except in the context of a generate() *
 *  call.
 ***********************************************************************************/

/obj/procedural/jp_DungeonGenerator/proc/regionCreate(turf/t)
	var/size
	var/centre
	var/minx=t.x
	var/miny=t.y
	var/maxx=t.x
	var/maxy=t.y
	var/obj/procedural/jp_dungeonroom/preexist/r
	var/list/border = list()
	var/list/turfs = list()
	var/list/walls = list()
	var/list/next = list(t)

	while(length(next)>=1)
		var/turf/nt = next[length(next)]

		next-=nt
		examined+=nt
		if(nt.x<getMinX() || nt.x>getMaxX() || nt.y<getMinY() || nt.y>getMaxY()) continue
		if(nt.is_wall())
			border+=nt
			continue

		if(nt.x<minx) minx=nt.x
		if(nt.x>maxx) maxx=nt.x
		if(nt.y<miny) miny=nt.y
		if(nt.y>maxy) maxy=nt.y
		if(!nt.density)
			turfs+=nt
			for(var/turf/t2 in getAdjacent(nt))	if(!((t2 in border) || (t2 in turfs))) next+=t2
		else
			walls+=nt

	size = max(maxy-miny, maxx-minx)
	size/=2
	size = round(size+0.4, 1)
	centre = locate(minx+size, miny+size, getZ())

	r = new /obj/procedural/jp_dungeonroom/preexist(size, centre, src)
	r.setBorder(border)
	r.setTurfs(turfs)
	r.setWalls(walls)

	return r

/**
	Checks if two jp_dungeonrooms are too close to each other
*/
/obj/procedural/jp_DungeonGenerator/proc/intersects(obj/procedural/jp_dungeonroom/newroom, list/obj/procedural/jp_dungeonroom/rooms)
	for(var/obj/procedural/jp_dungeonroom/r in rooms)
		. = newroom.getSize() + r.getSize() + 2
		if((. > abs(newroom.getX() - r.getX())) && (. > abs(newroom.getY() - r.getY())))
			if(!doAccurateRoomPlacementCheck) return TRUE
			if(!(newroom.doesAccurate() && r.doesAccurate())) return TRUE

			var/intx1=-1
			var/intx2=-1
			var/inty1=-1
			var/inty2=-1

			var/rx1 = r.getX()-r.getSize()-1
			var/rx2 = r.getX()+r.getSize()+1
			var/sx1 = newroom.getX()-newroom.getSize()-1
			var/sx2 = newroom.getX()+newroom.getSize()+1

			var/ry1 = r.getY()-r.getSize()-1
			var/ry2 = r.getY()+r.getSize()+1
			var/sy1 = newroom.getY()-newroom.getSize()-1
			var/sy2 = newroom.getY()+newroom.getSize()+1

			if(rx1>=sx1 && rx1<=sx2) intx1 = rx1
			if(rx2>=sx1 && rx2<=sx2)
				if(intx1<0) intx1=rx2
				else intx2 = rx2
			if(sx1>rx1 && sx1<rx2)
				if(intx1<0) intx1 = sx1
				else intx2 = sx1
			if(sx2>rx1 && sx2<rx2)
				if(intx1<0) intx1 = sx2
				else intx2 = sx2

			if(ry1>=sy1 && ry1<=sy2) inty1 = ry1
			if(ry2>=sy1 && ry2<=sy2)
				if(inty1<0) inty1=ry2
				else inty2 = ry2
			if(sy1>ry1 && sy1<ry2)
				if(inty1<0) inty1 = sy1
				else inty2 = sy1
			if(sy2>ry1 && sy2<ry2)
				if(inty1<0) inty1 = sy2
				else inty2 = sy2

			for(var/turf/t in block(locate(intx1, inty1, getZ()), locate(intx2, inty2, getZ())))
				var/ret = (t in newroom.getTurfs()) + (t in newroom.getBorder()) + (t in newroom.getWalls()) + (t in r.getTurfs()) + (t in r.getBorder()) + (t in r.getWalls())
				if(ret>1) return TRUE
	return FALSE
/**
	Returns an X by X square of turfs with initial turf being in bottom right
*/

/obj/procedural/jp_DungeonGenerator/proc/GetSquare(turf/T, side_size = 2)
	var/list/square_turfs = list()
	for(var/turf/N in block(T,locate(T.x + side_size - 1, T.y + side_size - 1, T.z)))
		square_turfs += N
	return square_turfs

/**
	Constructs a path between two jp_DungeonRegions.
*/
/obj/procedural/jp_DungeonGenerator/proc/getPath(obj/procedural/jp_DungeonRegion/region1, obj/procedural/jp_DungeonRegion/region2)
	set background = 1
	//We pick our start on the border of our first room
	var/turf/start = pick(region1.getBorder())
	var/turf/end
	var/long = FALSE
	var/minlength = minPathLength
	if(prob(longPathChance))
		minlength=minLongPathLength
		long = TRUE

	//We exclude all other border turfs of other rooms, minus our targets, and where we start
	var/list/borders=list()
	borders.Add(border_turfs)
	borders.Remove(region2.getBorder())

	borders-=start

	var/list/turf/previous = list()
	var/list/turf/done = list(start)
	var/list/turf/next = getAdjacent(start)
	var/list/turf/cost = list("\ref[start]"=0)

	if(minlength<=0)
		if(start in region2.getBorder()) //We've somehow managed to link the two rooms in a single turf
			out_numPaths++
			if(long) out_numLongPaths++
			end = start
			return retPath(end, previous, pathWidth, start, end)

	next-=borders
	for(var/turf/t in next)
		if(!t.is_wall()) next-=t
		previous["\ref[t]"] = start
		cost["\ref[t]"]=1

	if(!length(next)) return list() //We've somehow found a route that can not be continued.
	var/check_tick_in = 3
	while(1)
		check_tick_in = check_tick_in - 1
		var/turf/min
		var/mincost = maxPathLength

		for(var/turf/t in next)
			if((cost["\ref[t]"]<mincost) || (cost["\ref[t]"]==mincost && prob(50)))
				min = t
				mincost=cost["\ref[t]"]

		if(!min) return list() //We've managed to outgrow our cost

		done += min
		next -= min

		if(min in region2.getBorder()) //We've reached our destination
			if(mincost>minlength && prob(pathEndChance))
				out_numPaths++
				if(long) out_numLongPaths++
				end = min
				break
			else
				continue

		for(var/turf/t in getAdjacent(min))
			var/stop_looking = FALSE
			for(var/turf/t1 in GetSquare(t, pathWidth + 1))
				if(!(t1.is_wall() && !(t1 in borders)))
					stop_looking = TRUE
					break
			if(stop_looking)
				continue
			if(!(t in done) && !(t in next))
				next+=t
				previous["\ref[t]"] = min
				cost["\ref[t]"] = mincost+1

		if(!check_tick_in)
			check_tick_in = 3
			CHECK_TICK
	return retPath(end, previous, pathWidth, start, end)

/obj/procedural/jp_DungeonGenerator/proc/retPath(list/end, list/previous, pathWidth, turf/start, turf/end)
	var/list/ret = list()
	ret += GetSquare(end, pathWidth)
	var/turf/last = end
	while(1)
		if(last==start) break
		ret+= GetSquare(previous["\ref[last]"], pathWidth)
		last=previous["\ref[last]"]

	return ret

/obj/procedural/jp_DungeonGenerator/proc/check_params()
	if(!islist(allowedRooms) || length(allowedRooms)<=0)
		out_error = ERROR_NO_ROOMS
		return 0

	if(!corner1 || !corner2 || corner1.z!=corner2.z)
		out_error = ERROR_BAD_AREA
		return 0

	if(!walltype || (islist(walltype) && length(walltype)<=0))
		out_error = ERROR_NO_WALLTYPE
		return 0

	if(islist(walltype))
		for(var/k in walltype)
			if(!ispath(k))
				out_error = ERROR_NO_WALLTYPE
				return 0
	else
		if(!ispath(walltype))
			out_error = ERROR_NO_WALLTYPE
			return 0

	if(!floortype || !ispath(floortype))
		out_error = ERROR_NO_FLOORTYPE
		return 0

	if(numRooms<0 || round(numRooms)!=numRooms)
		out_error = ERROR_NUMROOMS_BAD
		return 0

	if(numExtraPaths<0 || round(numExtraPaths)!=numExtraPaths)
		out_error = ERROR_NUMEXTRAPATHS_BAD
		return 0

	if(roomMinSize>roomMaxSize || roomMinSize<0 || roomMaxSize<0 || round(roomMinSize)!=roomMinSize || round(roomMaxSize)!=roomMaxSize)
		out_error = ERROR_ROOM_SIZE_BAD
		return 0

	if(minPathLength>maxPathLength || minLongPathLength>maxPathLength || minPathLength<0 || maxPathLength<0 || minLongPathLength<0 || round(minPathLength)!=minPathLength || round(maxPathLength)!=maxPathLength || round(minLongPathLength)!=minLongPathLength)
		out_error = ERROR_PATH_LENGTH_BAD
		return 0

	if(pathEndChance<0 || pathEndChance>100)
		out_error = ERROR_PATHENDCHANCE_BAD
		return 0

	if(longPathChance<0 || longPathChance>100)
		out_error = ERROR_LONGPATHCHANCE_BAD
		return 0

	return 1

/**
Seriously internal. No touching, unless you really know what you're doing. It's highly
unlikely that you'll need to modify this
*/
/obj/procedural/jp_dungeonroomEntry

	var/roomtype //The typepath of the room this is an entry for
	var/maxsize //The maximum size of the room. -1 for default.
	var/minsize //The minimum size of the room. -1 for default

	var/required //The number of rooms of this type that must be placed in the dungeon. 0 for no requirement.
	var/maxnum //The maximum number of rooms of this type that can be placed in the dungeon. -1 for no limit
	var/count //The number of rooms that have been placed. Used to ensure compliance with maxnum.

/obj/procedural/jp_dungeonroomEntry/New(roomtype_n, maxsize_n=-1, minsize_n=-1, required_n=-1, maxnum_n=-1)
	roomtype = roomtype_n
	maxsize = maxsize_n
	minsize = minsize_n
	required = required_n
	maxnum = maxnum_n
	..()

/**
This object is used to represent a 'region' in the dungeon - a set of contiguous floor turfs,
along with the walls that border them. This object is used extensively by the generator, and
has several assumptions embedded in it - think carefully before making changes
*/
/obj/procedural/jp_DungeonRegion
	var/obj/procedural/jp_DungeonGenerator/gen //A reference to the jp_DungeonGenerator using us
	var/list/turf/contained = list() //A list of the floors contained by the region
	var/list/turf/border = list() //A list of the walls bordering the floors of this region
	var/turf/center //Center of this region's room

/**
Make a new jp_DungeonRegion, and set its reference to its generator object
*/
/obj/procedural/jp_DungeonRegion/New(obj/procedural/jp_DungeonGenerator/g)
	gen = g
	..()

/**
	Add a list of turfs to the region, optionally without adding the walls around
	them to the list of borders
*/
/obj/procedural/jp_DungeonRegion/proc/addTurfs(list/turf/l, noborder=0)
	for(var/turf/t in l)
		if(t in border) border-=t
		if(!(t in contained))
			contained+=t
			if(!noborder)
				for(var/turf/t2 in gen.getAdjacent(t))
					if(t2.is_wall() && !(t2 in border)) border+=t2

/**
	Adds a list of turfs to the border of the region.
*/
/obj/procedural/jp_DungeonRegion/proc/addBorder(list/turf/l)
	for(var/turf/t in l) if(!(t in border)) border+=t

/**
	Returns the list of floors in this region
*/
/obj/procedural/jp_DungeonRegion/proc/getTurfs()
	return contained

/**
	Returns the list of walls bordering the floors in this region
*/
/obj/procedural/jp_DungeonRegion/proc/getBorder()
	return border

/**
These objects are used to represent a 'room' - a distinct part of the dungeon
that is placed at the start, and then linked together. You will quite likely
want to create new jp_dungeonrooms. Consult the helpfile for more information
*/
/obj/procedural/jp_dungeonroom
	///The centrepoint of the room
	var/turf/centre
	///The size of the room. IMPORTANT: ROOMS MAY NOT TOUCH TURFS OUTSIDE range(centre, size). TURFS INSIDE range(centre,size) MAY BE DEALT WITH AS YOU WILL
	var/size
	///A reference to the generator using this room
	var/obj/procedural/jp_DungeonGenerator/gen

	///The submap for this room
	var/singleton/map_template/my_map = null
	///The list of turfs in this room. That should include internal walls.
	var/list/turfs = list()
	///The list of walls bordering this room. Anything in this list could be knocked down in order to make a path into the room
	var/list/border = list()
	///The list of walls bordering the room that aren't used for connections into the room. Should include every wall turf next to a floor turf. May include turfs up to range(centre, size+1)
	var/list/walls = list()
	///Only used by rooms that have disjoint sets of borders. A list of lists of turfs. The sub-lists are treated like the border turf list
	var/list/multiborder = list()

/**
Make a new jp_dungeonroom, size 's', centre 'c', generator 'g'
*/
/obj/procedural/jp_dungeonroom/New(s, turf/c, obj/procedural/jp_DungeonGenerator/g)
	size = s
	centre = c
	gen = g
	..()


/**
	Get various pieces of information about the centrepoint of this room
*/
/obj/procedural/jp_dungeonroom/proc/getCentre()
	return centre
/obj/procedural/jp_dungeonroom/proc/getX()
	return centre.x
/obj/procedural/jp_dungeonroom/proc/getY()
	return centre.y
/obj/procedural/jp_dungeonroom/proc/getZ()
	return centre.z

/**
	Get the size of this room
*/
/obj/procedural/jp_dungeonroom/proc/getSize()
	return size

/**
	Actually place the room on the dungeon. place() is one of the few procedures allowed
	to actually modify turfs in the dungeon - do NOT change turfs outside of place() or
	finalise(). This is called /before/ paths are placed, and may be called /before/ any
	other rooms are placed. If you would like to pretty the room up after basic dungeon
	geometry is done and dusted, use 'finalise()'
*/
/obj/procedural/jp_dungeonroom/proc/place()
	return

/**
	Called on every room after everything has been generated. Use it to pretty up the
	room, or what-have-you. finalise() is the only other jp_dungeonroom procedure that
	is allowed to modify turfs in the dungeon.
*/
/obj/procedural/jp_dungeonroom/proc/finalise()
	return

/**
	Return the border walls of this room.
*/
/obj/procedural/jp_dungeonroom/proc/getBorder()
	return border

/**
	Return the turfs inside of this room
*/
/obj/procedural/jp_dungeonroom/proc/getTurfs()
	return turfs

/obj/procedural/jp_dungeonroom/proc/getMultiborder()
	return multiborder

/obj/procedural/jp_dungeonroom/proc/getWalls()
	return walls

/**
	Returns true if the room is okay to be placed here, false otherwise
*/
/obj/procedural/jp_dungeonroom/proc/ok()
	return TRUE

/obj/procedural/jp_dungeonroom/proc/doesAccurate()
	return FALSE

/obj/procedural/jp_dungeonroom/proc/doesMultiborder()
	return FALSE

/obj/procedural/jp_dungeonroom/proc/doesSubmaps()
	return FALSE

/obj/procedural/jp_dungeonroom/preexist
	name = "template"

/obj/procedural/jp_dungeonroom/preexist/proc/setBorder(list/l)
		border = l

/obj/procedural/jp_dungeonroom/preexist/proc/setTurfs(list/l)
		turfs = l

/obj/procedural/jp_dungeonroom/preexist/proc/setWalls(list/l)
		walls = l

/obj/procedural/jp_dungeonroom/preexist/doesAccurate()
	return TRUE

/**
Class for a simple square room, size*2+1 by size*2+1 units. Border is all turfs adjacent
to the floor that return true from is_wall().
*/
/obj/procedural/jp_dungeonroom/preexist/square
	name = "square"

/obj/procedural/jp_dungeonroom/preexist/square/doesAccurate()
	return TRUE

/obj/procedural/jp_dungeonroom/preexist/square/proc/getCorners()
	var/bordersize = size + 1
	var/turf/c1 = locate(centre.x + bordersize , centre.y + bordersize, centre.z)
	var/turf/c2 = locate(centre.x - bordersize, centre.y - bordersize, centre.z)
	var/turf/c3 = locate(centre.x + bordersize, centre.y - bordersize, centre.z)
	var/turf/c4 = locate(centre.x - bordersize, centre.y + bordersize, centre.z)
	return list(gen.getAdjacent(c1), gen.getAdjacent(c2), gen.getAdjacent(c3), gen.getAdjacent(c4))

/obj/procedural/jp_dungeonroom/preexist/square/New()
	..()

	for(var/turf/t in range(centre, size)) turfs += t

	for(var/turf/t in turfs)
		for(var/turf/t2 in gen.getAdjacent(t))
			if(t2 in turfs)
				continue
			if(t2.is_wall() && !(t2 in border))
				border += t2

	border -= getCorners() //If the path width is more than 1, the corner and path connection looks really ugly

/obj/procedural/jp_dungeonroom/preexist/square/place()
	for(var/turf/t in turfs)
		turfs -=t
		t.ChangeTurf(gen.floortype)
		turfs += t

/**
A simple circle of radius 'size' units. Border is all turfs adjacent to the floor that
return true from is_wall()
*/
/obj/procedural/jp_dungeonroom/preexist/circle
	name = "round square"

/obj/procedural/jp_dungeonroom/preexist/circle/doesAccurate()
	return TRUE

/obj/procedural/jp_dungeonroom/preexist/circle/New()
	..()
	var/radsqr = size*size

	for(var/turf/t in range(centre, size))
		var/ti = t.x-getX()
		var/tj = t.y-getY()

		if(ti*ti + tj*tj>radsqr) continue

		turfs += t



	for(var/turf/t in turfs)
		for(var/turf/t2 in gen.getAdjacent(t))
			if(t2 in turfs)
				continue
			if(t2.is_wall() && !(t2 in border))
				border+=t2

/obj/procedural/jp_dungeonroom/preexist/circle/place()
	for(var/turf/t in turfs)
		turfs-=t
		turfs+=new gen.floortype(t)

/**
A giant plus sign, with arms of length size*2 + 1. Border is the turfs on the 'end' of
the arms of the plus sign - there are only four.
*/
/obj/procedural/jp_dungeonroom/preexist/cross
	name = "cross"

/obj/procedural/jp_dungeonroom/preexist/cross/doesAccurate()
	return TRUE

/obj/procedural/jp_dungeonroom/preexist/cross/New()
	..()
	for(var/turf/t in range(centre, size))
		if(t.x == getX() || t.y == getY())
			turfs += t

	for(var/turf/t in range(centre, size+1))
		if(t in turfs) continue
		if(t.is_wall() && (t.x == getX() || t.y == getY()))
			border+=t

/obj/procedural/jp_dungeonroom/preexist/cross/place()
	for(var/turf/t in turfs)
		turfs-=t
		turfs+=new gen.floortype(t)


/obj/procedural/jp_dungeonroom/preexist/deadend
	name = "deadend"

/obj/procedural/jp_dungeonroom/preexist/deadend/place()
	centre=new gen.floortype(centre)
	turfs+=centre
	border+=pick(gen.getAdjacent(centre))

/**
	Same as square, but loads a submap out of allowed list
*/
/obj/procedural/jp_dungeonroom/preexist/square/submap
	name = "submap square"


/obj/procedural/jp_dungeonroom/preexist/square/submap/doesSubmaps()
	return TRUE

/obj/procedural/jp_dungeonroom/preexist/square/submap/finalise()
	if(length(border) < 1)
		testing("ROOM [my_map.name] HAS NO BORDERS! at [centre.x], [centre.y]!")
	if(my_map)
		my_map.load(centre, centered = TRUE)
	else
		gen.out_error = gen.ERROR_NO_SUBMAPS
