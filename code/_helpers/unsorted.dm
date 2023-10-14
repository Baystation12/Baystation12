/*
 * A large number of misc global procs.
 */

/proc/subtypesof(datum/thing)
	RETURN_TYPE(/list)
	if (ispath(thing))
		return typesof(thing) - thing
	if (istype(thing))
		return typesof(thing) - thing.type
	return list()

//Checks if all high bits in req_mask are set in bitfield
#define BIT_TEST_ALL(bitfield, req_mask) ((~(bitfield) & (req_mask)) == 0)

//Inverts the colour of an HTML string
/proc/invertHTML(HTMLstring)

	if (!( istext(HTMLstring) ))
		CRASH("Given non-text argument!")
	else
		if (length(HTMLstring) != 7)
			CRASH("Given non-HTML argument!")
	var/textr = copytext(HTMLstring, 2, 4)
	var/textg = copytext(HTMLstring, 4, 6)
	var/textb = copytext(HTMLstring, 6, 8)
	var/r = hex2num(textr)
	var/g = hex2num(textg)
	var/b = hex2num(textb)
	textr = num2hex(255 - r)
	textg = num2hex(255 - g)
	textb = num2hex(255 - b)
	if (length(textr) < 2)
		textr = text("0[]", textr)
	if (length(textg) < 2)
		textr = text("0[]", textg)
	if (length(textb) < 2)
		textr = text("0[]", textb)
	return text("#[][][]", textr, textg, textb)

//Returns the middle-most value
/proc/dd_range(low, high, num)
	return max(low,min(high,num))

//Returns whether or not A is the middle most value
/proc/InRange(A, lower, upper)
	if(A < lower) return 0
	if(A > upper) return 0
	return 1


/proc/Get_Angle(atom/movable/start,atom/movable/end)//For beams.
	if(!start || !end) return 0
	var/dy
	var/dx
	dy=(32*end.y+end.pixel_y)-(32*start.y+start.pixel_y)
	dx=(32*end.x+end.pixel_x)-(32*start.x+start.pixel_x)
	if(!dy)
		return (dx>=0)?90:270
	.=arctan(dx/dy)
	if(dy<0)
		.+=180
	else if(dx<0)
		.+=360

//Returns location. Returns null if no location was found.
/proc/get_teleport_loc(turf/location,mob/target,distance = 1, density = FALSE, errorx = 0, errory = 0, eoffsetx = 0, eoffsety = 0)
	RETURN_TYPE(/turf)
/*
Location where the teleport begins, target that will teleport, distance to go, density checking 0/1(yes/no).
Random error in tile placement x, error in tile placement y, and block offset.
Block offset tells the proc how to place the box. Behind teleport location, relative to starting location, forward, etc.
Negative values for offset are accepted, think of it in relation to North, -x is west, -y is south. Error defaults to positive.
Turf and target are seperate in case you want to teleport some distance from a turf the target is not standing on or something.
*/

	var/dirx = 0//Generic location finding variable.
	var/diry = 0

	var/xoffset = 0//Generic counter for offset location.
	var/yoffset = 0

	var/b1xerror = 0//Generic placing for point A in box. The lower left.
	var/b1yerror = 0
	var/b2xerror = 0//Generic placing for point B in box. The upper right.
	var/b2yerror = 0

	errorx = abs(errorx)//Error should never be negative.
	errory = abs(errory)
	//var/errorxy = round((errorx+errory)/2)//Used for diagonal boxes.

	switch(target.dir)//This can be done through equations but switch is the simpler method. And works fast to boot.
	//Directs on what values need modifying.
		if(1)//North
			diry+=distance
			yoffset+=eoffsety
			xoffset+=eoffsetx
			b1xerror-=errorx
			b1yerror-=errory
			b2xerror+=errorx
			b2yerror+=errory
		if(2)//South
			diry-=distance
			yoffset-=eoffsety
			xoffset+=eoffsetx
			b1xerror-=errorx
			b1yerror-=errory
			b2xerror+=errorx
			b2yerror+=errory
		if(4)//East
			dirx+=distance
			yoffset+=eoffsetx//Flipped.
			xoffset+=eoffsety
			b1xerror-=errory//Flipped.
			b1yerror-=errorx
			b2xerror+=errory
			b2yerror+=errorx
		if(8)//West
			dirx-=distance
			yoffset-=eoffsetx//Flipped.
			xoffset+=eoffsety
			b1xerror-=errory//Flipped.
			b1yerror-=errorx
			b2xerror+=errory
			b2yerror+=errorx

	var/turf/destination=locate(location.x+dirx,location.y+diry,location.z)

	if(destination)//If there is a destination.
		if(errorx||errory)//If errorx or y were specified.
			var/destination_list[] = list()//To add turfs to list.
			//destination_list = new()
			/*This will draw a block around the target turf, given what the error is.
			Specifying the values above will basically draw a different sort of block.
			If the values are the same, it will be a square. If they are different, it will be a rectengle.
			In either case, it will center based on offset. Offset is position from center.
			Offset always calculates in relation to direction faced. In other words, depending on the direction of the teleport,
			the offset should remain positioned in relation to destination.*/

			var/turf/center = locate((destination.x+xoffset),(destination.y+yoffset),location.z)//So now, find the new center.

			//Now to find a box from center location and make that our destination.
			for(var/turf/T in block(locate(center.x+b1xerror,center.y+b1yerror,location.z), locate(center.x+b2xerror,center.y+b2yerror,location.z) ))
				if(density && T.contains_dense_objects())	continue//If density was specified.
				if(T.x>world.maxx || T.x<1)	continue//Don't want them to teleport off the map.
				if(T.y>world.maxy || T.y<1)	continue
				destination_list += T
			if(length(destination_list))
				destination = pick(destination_list)
			else	return

		else//Same deal here.
			if(density && destination.contains_dense_objects())	return
			if(destination.x>world.maxx || destination.x<1)	return
			if(destination.y>world.maxy || destination.y<1)	return
	else	return

	return destination



/proc/LinkBlocked(turf/A, turf/B)
	if(A == null || B == null) return 1
	var/adir = get_dir(A,B)
	var/rdir = get_dir(B,A)
	if((adir & (NORTH|SOUTH)) && (adir & (EAST|WEST)))	//	diagonal
		var/iStep = get_step(A,adir&(NORTH|SOUTH))
		if(!LinkBlocked(A,iStep) && !LinkBlocked(iStep,B)) return 0

		var/pStep = get_step(A,adir&(EAST|WEST))
		if(!LinkBlocked(A,pStep) && !LinkBlocked(pStep,B)) return 0
		return 1

	if(DirBlocked(A,adir)) return 1
	if(DirBlocked(B,rdir)) return 1
	return 0


/proc/DirBlocked(turf/loc,dir)
	for(var/obj/structure/window/D in loc)
		if(!D.density)			continue
		if(D.dir == SOUTHWEST)	return 1
		if(D.dir == dir)		return 1

	for(var/obj/machinery/door/D in loc)
		if(!D.density)			continue
		if(istype(D, /obj/machinery/door/window))
			if((dir & SOUTH) && (D.dir & (EAST|WEST)))		return 1
			if((dir & EAST ) && (D.dir & (NORTH|SOUTH)))	return 1
		else return 1	// it's a real, air blocking door
	return 0

/proc/TurfBlockedNonWindow(turf/loc)
	for(var/obj/O in loc)
		if(O.density && !istype(O, /obj/structure/window))
			return 1
	return 0

/proc/sign(x)
	return x!=0?x/abs(x):0

/proc/getline(atom/M,atom/N)//Ultra-Fast Bresenham Line-Drawing Algorithm
	RETURN_TYPE(/list)
	var/px=M.x		//starting x
	var/py=M.y
	var/line[] = list(locate(px,py,M.z))
	var/dx=N.x-px	//x distance
	var/dy=N.y-py
	var/dxabs=abs(dx)//Absolute value of x distance
	var/dyabs=abs(dy)
	var/sdx=sign(dx)	//Sign of x distance (+ or -)
	var/sdy=sign(dy)
	var/x=SHIFTR(dxabs, 1)	//Counters for steps taken, setting to distance/2
	var/y=SHIFTR(dyabs, 1)	//Bit-shifting makes me l33t.  It also makes getline() unnessecarrily fast.
	var/j			//Generic integer for counting
	if(dxabs>=dyabs)	//x distance is greater than y
		for(j=0;j<dxabs;j++)//It'll take dxabs steps to get there
			y+=dyabs
			if(y>=dxabs)	//Every dyabs steps, step once in y direction
				y-=dxabs
				py+=sdy
			px+=sdx		//Step on in x direction
			line+=locate(px,py,M.z)//Add the turf to the list
	else
		for(j=0;j<dyabs;j++)
			x+=dxabs
			if(x>=dyabs)
				x-=dyabs
				px+=sdx
			py+=sdy
			line+=locate(px,py,M.z)
	return line

#define LOCATE_COORDS(X, Y, Z) locate(clamp(X, 1, world.maxx), clamp(Y, 1, world.maxy), Z)
/proc/getcircle(turf/center, radius) //Uses a fast Bresenham rasterization algorithm to return the turfs in a thin circle.
	RETURN_TYPE(/list)
	if(!radius) return list(center)

	var/x = 0
	var/y = radius
	var/p = 3 - 2 * radius

	. = list()
	while(y >= x) // only formulate 1/8 of circle

		. += LOCATE_COORDS(center.x - x, center.y - y, center.z) //upper left left
		. += LOCATE_COORDS(center.x - y, center.y - x, center.z) //upper upper left
		. += LOCATE_COORDS(center.x + y, center.y - x, center.z) //upper upper right
		. += LOCATE_COORDS(center.x + x, center.y - y, center.z) //upper right right
		. += LOCATE_COORDS(center.x - x, center.y + y, center.z) //lower left left
		. += LOCATE_COORDS(center.x - y, center.y + x, center.z) //lower lower left
		. += LOCATE_COORDS(center.x + y, center.y + x, center.z) //lower lower right
		. += LOCATE_COORDS(center.x + x, center.y + y, center.z) //lower right right

		if(p < 0)
			p += 4*x++ + 6;
		else
			p += 4*(x++ - y--) + 10;

#undef LOCATE_COORDS

//Returns whether or not a player is a guest using their ckey as an input
/proc/IsGuestKey(key)
	if (findtext(key, "Guest-", 1, 7) != 1) //was findtextEx
		return 0

	var/i = 7, ch, len = length(key)

	if(copytext(key, 7, 8) == "W") //webclient
		i++

	for (, i <= len, ++i)
		ch = text2ascii(key, i)
		if (ch < 48 || ch > 57)
			return 0
	return 1

//Ensure the frequency is within bounds of what it should be sending/recieving at
/proc/sanitize_frequency(f, low = PUBLIC_LOW_FREQ, high = PUBLIC_HIGH_FREQ)
	f = round(f)
	f = max(low, f)
	f = min(high, f)
	if ((f % 2) == 0) //Ensure the last digit is an odd number
		f += 1
	return f

//Turns 1479 into 147.9
/proc/format_frequency(f)
	return "[round(f / 10)].[f % 10]"

//Generalised helper proc for letting mobs rename themselves. Used to be clname() and ainame()
//Last modified by Carn
/mob/proc/rename_self(role, allow_numbers=0)
	spawn(0)
		var/oldname = real_name

		var/time_passed = world.time
		var/newname

		for(var/i=1,i<=3,i++)	//we get 3 attempts to pick a suitable name.
			newname = input(src,"You are \a [role]. Would you like to change your name to something else?", "Name change",oldname) as text
			if((world.time-time_passed)>3000)
				return	//took too long
			newname = sanitizeName(newname, ,allow_numbers)	//returns null if the name doesn't meet some basic requirements. Tidies up a few other things like bad-characters.

			for(var/mob/living/M in GLOB.player_list)
				if(M == src)
					continue
				if(!newname || M.real_name == newname)
					newname = null
					break
			if(newname)
				break	//That's a suitable name!
			to_chat(src, "Sorry, that [role]-name wasn't appropriate, please try another. It's possibly too long/short, has bad characters or is already taken.")

		if(!newname)	//we'll stick with the oldname then
			return

		fully_replace_character_name(newname)

//Picks a string of symbols to display as the law number for hacked or ion laws
/proc/ionnum()
	return "[pick("1","2","3","4","5","6","7","8","9","0")][pick("!","@","#","$","%","^","&","*")][pick("!","@","#","$","%","^","&","*")][pick("!","@","#","$","%","^","&","*")]"

//When an AI is activated, it can choose from a list of non-slaved borgs to have as a slave.
/proc/freeborg(z)
	RETURN_TYPE(/mob/living/silicon/robot)
	var/list/zs = get_valid_silicon_zs(z)

	var/select = null
	var/list/borgs = list()
	for (var/mob/living/silicon/robot/A in GLOB.player_list)
		if (A.stat == 2 || A.connected_ai || A.scrambledcodes || istype(A,/mob/living/silicon/robot/drone) || !(get_z(A) in zs))
			continue
		var/name = "[A.real_name] ([A.modtype] [A.braintype])"
		borgs[name] = A

	if (length(borgs))
		select = input("Unshackled borg signals detected:", "Borg selection", null, null) as null|anything in borgs
		return borgs[select]

//When a borg is activated, it can choose which AI it wants to be slaved to
/proc/active_ais(z)
	RETURN_TYPE(/list)
	var/list/zs = get_valid_silicon_zs(z)

	. = list()
	for(var/mob/living/silicon/ai/A in GLOB.alive_mobs)
		if(A.stat == DEAD || A.control_disabled || !(get_z(A) in zs))
			continue
		. += A
	return .

//Find an active ai with the least borgs. VERBOSE PROCNAME HUH!
/proc/select_active_ai_with_fewest_borgs(z)
	RETURN_TYPE(/mob/living/silicon/ai)
	var/mob/living/silicon/ai/selected
	var/list/active = active_ais(z)
	for(var/mob/living/silicon/ai/A in active)
		if(!selected || (length(selected.connected_robots) > length(A.connected_robots)))
			selected = A

	return selected

/proc/select_active_ai(mob/user, z)
	RETURN_TYPE(/mob/living/silicon/ai)
	var/list/ais = active_ais(z)
	if(length(ais))
		if(user?.client)
			. = input(user,"AI signals detected:", "AI selection") in ais
		else
			. = pick(ais)

/proc/get_valid_silicon_zs(z)
	RETURN_TYPE(/list)
	if(z)
		return GetConnectedZlevels(z)
	return list() //We return an empty list, because we are apparently in nullspace

/proc/get_sorted_mobs()
	RETURN_TYPE(/list)
	var/list/old_list = getmobs()
	var/list/AI_list = list()
	var/list/Dead_list = list()
	var/list/keyclient_list = list()
	var/list/key_list = list()
	var/list/logged_list = list()
	for(var/named in old_list)
		var/mob/M = old_list[named]
		if(issilicon(M))
			AI_list |= M
		else if(isghost(M) || M.stat == DEAD)
			Dead_list |= M
		else if(M.key && M.client)
			keyclient_list |= M
		else if(M.key)
			key_list |= M
		else
			logged_list |= M
		old_list.Remove(named)
	var/list/new_list = list()
	new_list += AI_list
	new_list += keyclient_list
	new_list += key_list
	new_list += logged_list
	new_list += Dead_list
	return new_list

//Returns a list of all mobs with their name
/proc/getmobs()
	RETURN_TYPE(/list)
	var/list/mobs = sortmobs()
	var/list/names = list()
	var/list/creatures = list()
	var/list/namecounts = list()
	for(var/mob/M in mobs)
		var/name = M.name
		if (name in names)
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1
		if (M.real_name && M.real_name != M.name)
			name += " \[[M.real_name]\]"
		if (M.stat == DEAD)
			if(isobserver(M))
				name += " \[observer\]"
			else
				name += " \[dead\]"
		creatures[name] = M

	return creatures

/proc/get_follow_targets()
	RETURN_TYPE(/list)
	return follow_repository.get_follow_targets()

//Orders mobs by type then by name
/proc/sortmobs()
	RETURN_TYPE(/list)
	var/list/moblist = list()
	var/list/sortmob = sortAtom(SSmobs.mob_list)
	for(var/mob/observer/eye/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/silicon/ai/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/silicon/pai/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/silicon/robot/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/carbon/human/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/carbon/brain/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/carbon/alien/M in sortmob)
		moblist.Add(M)
	for(var/mob/observer/ghost/M in sortmob)
		moblist.Add(M)
	for(var/mob/new_player/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/carbon/slime/M in sortmob)
		moblist.Add(M)
	for(var/mob/living/simple_animal/M in sortmob)
		moblist.Add(M)
//	for(var/mob/living/silicon/hivebot/M in world)
//		mob_list.Add(M)
//	for(var/mob/living/silicon/hive_mainframe/M in world)
//		mob_list.Add(M)
	return moblist

//Forces a variable to be posative
/proc/modulus(M)
	if(M >= 0)
		return M
	if(M < 0)
		return -M

// returns the turf located at the map edge in the specified direction relative to A
// used for mass driver
/proc/get_edge_target_turf(atom/A, direction)
	RETURN_TYPE(/turf)
	var/turf/target = locate(A.x, A.y, A.z)
	if(!A || !target)
		return 0
		//since NORTHEAST == NORTH & EAST, etc, doing it this way allows for diagonal mass drivers in the future
		//and isn't really any more complicated

		// Note diagonal directions won't usually be accurate
	if(direction & NORTH)
		target = locate(target.x, world.maxy, target.z)
	if(direction & SOUTH)
		target = locate(target.x, 1, target.z)
	if(direction & EAST)
		target = locate(world.maxx, target.y, target.z)
	if(direction & WEST)
		target = locate(1, target.y, target.z)

	return target

// returns turf relative to A in given direction at set range
// result is bounded to map size
// note range is non-pythagorean
// used for disposal system
/proc/get_ranged_target_turf(atom/A, direction, range)
	RETURN_TYPE(/turf)
	var/x = A.x
	var/y = A.y
	if(direction & NORTH)
		y = min(world.maxy, y + range)
	if(direction & SOUTH)
		y = max(1, y - range)
	if(direction & EAST)
		x = min(world.maxx, x + range)
	if(direction & WEST)
		x = max(1, x - range)

	return locate(x,y,A.z)


// returns turf relative to A offset in dx and dy tiles
// bound to map limits
/proc/get_offset_target_turf(atom/A, dx, dy)
	RETURN_TYPE(/turf)
	var/x = min(world.maxx, max(1, A.x + dx))
	var/y = min(world.maxy, max(1, A.y + dy))
	return locate(x,y,A.z)


//returns random gauss number
/proc/GaussRand(sigma)
	var/x,y,rsq
	do
		x=2*rand()-1
		y=2*rand()-1
		rsq=x*x+y*y
	while(rsq>1 || !rsq)
	return sigma*y*sqrt(-2*log(rsq)/rsq)

//returns random gauss number, rounded to 'roundto'
/proc/GaussRandRound(sigma,roundto)
	return round(GaussRand(sigma),roundto)

/**
 * Retrieves the contents of this atom and all atoms contained within, recursively.
 *
 * **Parameters**:
 * - `searchDepth` (int) - The depth to recursively retrieve contents for.
 *
 * Returns a list of atoms.
 */
/atom/proc/GetAllContents(searchDepth = 5)
	RETURN_TYPE(/list)
	var/list/toReturn = list()

	for(var/atom/part in contents)
		toReturn += part
		if(length(part.contents) && searchDepth)
			toReturn += part.GetAllContents(searchDepth - 1)

	return toReturn

//Step-towards method of determining whether one atom can see another. Similar to viewers()
/proc/can_see(atom/source, atom/target, length=5) // I couldn't be arsed to do actual raycasting :I This is horribly inaccurate.
	var/turf/current = get_turf(source)
	var/turf/target_turf = get_turf(target)
	var/steps = 0

	if(!current || !target_turf)
		return 0

	while(current != target_turf)
		if(steps > length) return 0
		if(current.opacity) return 0
		for(var/atom/A in current)
			if(A.opacity) return 0
		current = get_step_towards(current, target_turf)
		steps++

	return 1

/proc/is_blocked_turf(turf/T)
	var/cant_pass = 0
	if(T.density) cant_pass = 1
	for(var/atom/A in T)
		if(A.density)//&&A.anchored
			cant_pass = 1
	return cant_pass

/proc/get_step_towards2(atom/ref , atom/trg)
	RETURN_TYPE(/turf)
	var/base_dir = get_dir(ref, get_step_towards(ref,trg))
	var/turf/temp = get_step_towards(ref,trg)

	if(is_blocked_turf(temp))
		var/dir_alt1 = turn(base_dir, 90)
		var/dir_alt2 = turn(base_dir, -90)
		var/turf/turf_last1 = temp
		var/turf/turf_last2 = temp
		var/free_tile = null
		var/breakpoint = 0

		while(!free_tile && breakpoint < 10)
			if(!is_blocked_turf(turf_last1))
				free_tile = turf_last1
				break
			if(!is_blocked_turf(turf_last2))
				free_tile = turf_last2
				break
			turf_last1 = get_step(turf_last1,dir_alt1)
			turf_last2 = get_step(turf_last2,dir_alt2)
			breakpoint++

		if(!free_tile) return get_step(ref, base_dir)
		else return get_step_towards(ref,free_tile)

	else return get_step(ref, base_dir)

//Takes: Anything that could possibly have variables and a varname to check.
//Returns: 1 if found, 0 if not.
/proc/hasvar(datum/A, varname)
	return A.vars.Find(varname) != 0

//Takes: Area type as text string or as typepath OR an instance of the area.
//Returns: A list of all areas of that type in the world.
/proc/get_areas(areatype)
	RETURN_TYPE(/list)
	if(!areatype) return null
	if(istext(areatype)) areatype = text2path(areatype)
	if(isarea(areatype))
		var/area/areatemp = areatype
		areatype = areatemp.type

	var/list/areas = list()
	for(var/area/N in world)
		if(istype(N, areatype)) areas += N
	return areas

//Takes: Area type as a typepath OR an instance of the area.
//Returns: A list of all atoms	(objs, turfs, mobs) in areas of that type of that type in the world.
/proc/get_area_all_atoms(areatype)
	RETURN_TYPE(/list)
	if(!areatype)
		return null
	if(isarea(areatype))
		var/area/areatemp = areatype
		areatype = areatemp.type
	if(!ispath(areatype, /area))
		return null

	var/list/atoms = list()
	for(var/area/N in world)
		if(istype(N, areatype))
			for(var/atom/A in N)
				atoms += A
	return atoms

/area/proc/move_contents_to(area/A)
	//Takes: Area.
	//Returns: Nothing.
	//Notes: Attempts to move the contents of one area to another area.
	//       Movement based on lower left corner.

	if(!A || !src) return

	var/list/turfs_src = get_area_turfs("\ref[src]")

	if(!length(turfs_src)) return

	//figure out a suitable origin - this assumes the shuttle areas are the exact same size and shape
	//might be worth doing this with a shuttle core object instead of areas, in the future
	var/src_origin = locate(src.x, src.y, src.z)
	var/trg_origin = locate(A.x, A.y, A.z)

	if(src_origin && trg_origin)
		var/translation = get_turf_translation(src_origin, trg_origin, turfs_src)
		translate_turfs(translation, null)


GLOBAL_LIST_INIT(duplicate_object_disallowed_vars, list(
	"type",
	"loc",
	"locs",
	"vars",
	"parent",
	"parent_type",
	"verbs",
	"ckey",
	"key",
	"group",
	"ai_holder",
	"natural_weapon"
))


/proc/clone_atom(obj/original, copy_vars, atom/loc)
	RETURN_TYPE(/obj)
	if (!original)
		return
	if (loc && !isloc(loc))
		loc = original.loc
	var/obj/result = new original.type (loc)
	if (!copy_vars || !result)
		return result
	var/list/vars = original.vars
	for (var/name in vars)
		if (name in GLOB.duplicate_object_disallowed_vars)
			continue
		if (!issaved(vars[name]))
			continue
		result.vars[name] = vars[name]
	return result


/**
 * Attempts to move the contents, including turfs, of one area to another area.
 * Positioning is based on the lower left corner of both areas.
 * Tiles that do not fit into the new area will not be copied.
 * Source atoms are not modified or deleted.
 * Turfs are created using `ChangeTurf()`.
 * `dir`, `icon`, and `icon_state` are copied. All other vars use the default value for the copied atom.
 * Primarily used for holodecks.
 *
 * **Parameters**:
 * - `target` `/area`. The area to copy src's contents to.
 * - `plating_required` Boolean, default `FALSE`. If set, contents will only be copied to destination tiles that are not the same type as `get_base_area_by_turf()` before calling `ChangeTurf()`.
 *
 * Returns List (`/atom`). A list containing all atoms that were created at the target area during the process.
 */
/area/proc/copy_contents_to(area/target, plating_required)
	RETURN_TYPE(/list)
	if (!target || !src)
		return
	var/list/turfs_src = get_area_turfs(type)
	var/list/turfs_trg = get_area_turfs(target.type)
	var/src_min_x = 0
	var/src_min_y = 0
	for (var/turf/turf in turfs_src)
		if (turf.x < src_min_x || !src_min_x)
			src_min_x = turf.x
		if (turf.y < src_min_y || !src_min_y)
			src_min_y = turf.y
	var/trg_min_x = 0
	var/trg_min_y = 0
	for (var/turf/turf in turfs_trg)
		if (turf.x < trg_min_x || !trg_min_x)
			trg_min_x = turf.x
		if (turf.y < trg_min_y || !trg_min_y)
			trg_min_y = turf.y
	var/list/refined_src = list()
	for (var/turf/turf in turfs_src)
		refined_src[turf] = new /datum/vector2 (turf.x - src_min_x, turf.y - src_min_y)
	var/list/refined_trg = list()
	for (var/turf/turf in turfs_trg)
		refined_trg[turf] = new /datum/vector2 (turf.x - trg_min_x, turf.y - trg_min_y)
	var/list/turfs_to_update = list()
	var/list/copied_movables = list()
	moving:
		for (var/turf/source_turf in refined_src)
			var/datum/vector2/source_position = refined_src[source_turf]
			for (var/turf/target_turf in refined_trg)
				if (source_position ~= refined_trg[target_turf])
					var/old_dir1 = source_turf.dir
					var/old_icon_state1 = source_turf.icon_state
					var/old_icon1 = source_turf.icon
					var/old_underlays = source_turf.underlays.Copy()
					if (plating_required)
						if (istype(target_turf, get_base_turf_by_area(target_turf)))
							continue moving
					var/turf/temp_target_turf = target_turf
					temp_target_turf.ChangeTurf(source_turf.type)
					temp_target_turf.set_dir(old_dir1)
					temp_target_turf.icon_state = old_icon_state1
					temp_target_turf.icon = old_icon1
					temp_target_turf.CopyOverlays(source_turf)
					temp_target_turf.underlays = old_underlays
					for (var/obj/obj in source_turf)
						if (!obj.simulated)
							continue
						copied_movables += clone_atom(obj, TRUE, temp_target_turf)
					for (var/mob/mob in source_turf)
						if (!mob.simulated)
							continue
						copied_movables += clone_atom(mob, TRUE, temp_target_turf)
					turfs_to_update += temp_target_turf
					refined_src -= source_turf
					refined_trg -= target_turf
					continue moving
	for (var/turf/simulated/simulated in turfs_to_update)
		SSair.mark_for_update(simulated)
	return copied_movables


/proc/get_cardinal_dir(atom/A, atom/B)
	var/dx = abs(B.x - A.x)
	var/dy = abs(B.y - A.y)
	return get_dir(A, B) & (rand() * (dx+dy) < dy ? 3 : 12)


/proc/view_or_range(distance = world.view , center = usr , type)
	RETURN_TYPE(/list)
	switch(type)
		if("view")
			. = view(distance,center)
		if("range")
			. = range(distance,center)
	return

/proc/oview_or_orange(distance = world.view , center = usr , type)
	RETURN_TYPE(/list)
	switch(type)
		if("view")
			. = oview(distance,center)
		if("range")
			. = orange(distance,center)
	return

/proc/get_mob_with_client_list()
	RETURN_TYPE(/list)
	var/list/mobs = list()
	for(var/mob/M in SSmobs.mob_list)
		if (M.client)
			mobs += M
	return mobs


/proc/parse_zone(zone)
	if(zone == BP_R_HAND) return "right hand"
	else if (zone == BP_L_HAND) return "left hand"
	else if (zone == BP_L_ARM) return "left arm"
	else if (zone == BP_R_ARM) return "right arm"
	else if (zone == BP_L_LEG) return "left leg"
	else if (zone == BP_R_LEG) return "right leg"
	else if (zone == BP_L_FOOT) return "left foot"
	else if (zone == BP_R_FOOT) return "right foot"
	else if (zone == BP_L_HAND) return "left hand"
	else if (zone == BP_R_HAND) return "right hand"
	else if (zone == BP_L_FOOT) return "left foot"
	else if (zone == BP_R_FOOT) return "right foot"
	else return zone

/proc/get(atom/loc, type)
	while(loc)
		if(istype(loc, type))
			return loc
		loc = loc.loc
	return null

/proc/get_turf_or_move(turf/location)
	RETURN_TYPE(/turf)
	return get_turf(location)


/obj/item/proc/istool()
	return FALSE


/obj/item/stack/cable_coil/istool()
	return TRUE


/obj/item/wrench/istool()
	return TRUE


/obj/item/weldingtool/istool()
	return TRUE


/obj/item/screwdriver/istool()
	return TRUE


/obj/item/wirecutters/istool()
	return TRUE


/obj/item/device/multitool/istool()
	return TRUE


/obj/item/crowbar/istool()
	return TRUE


//Whether or not the given item counts as sharp in terms of dealing damage
/proc/is_sharp(obj/O as obj)
	if (!O) return 0
	if (O.sharp) return 1
	if (O.edge) return 1
	return 0

//Whether or not the given item counts as cutting with an edge in terms of removing limbs
/proc/has_edge(obj/O as obj)
	if (!O) return 0
	if (O.edge) return 1
	return 0


/**
 * For items that can puncture e.g. thick plastic but aren't necessarily sharp.
 *
 * Returns TRUE if the given item is capable of popping things like balloons, inflatable barriers, or cutting police tape. Also used to determine what items can eyestab.
 */
/obj/item/proc/can_puncture()
	if(sharp || puncture) return TRUE
	return FALSE

/obj/item/weldingtool/can_puncture()
	return welding

/obj/item/flame/can_puncture()
	return lit

/obj/item/clothing/mask/smokable/cigarette/can_puncture()
	return lit

//check if mob is lying down on something we can operate him on.
/proc/can_operate(mob/living/carbon/M, mob/living/carbon/user)
	var/turf/T = get_turf(M)
	if(locate(/obj/machinery/optable, T))
		. = TRUE
	if(locate(/obj/structure/bed, T))
		. = TRUE
	if(locate(/obj/structure/roller_bed, T))
		. = TRUE
	if(locate(/obj/structure/table, T))
		. = TRUE
	if(locate(/obj/rune, T))
		. = TRUE

	if(M == user)
		var/hitzone = check_zone(user.zone_sel.selecting)
		var/list/badzones = list(BP_HEAD)
		if(user.hand)
			badzones += BP_L_ARM
			badzones += BP_L_HAND
		else
			badzones += BP_R_ARM
			badzones += BP_R_HAND
		if(hitzone in badzones)
			return FALSE

/proc/reverse_direction(dir)
	switch(dir)
		if(NORTH)
			return SOUTH
		if(NORTHEAST)
			return SOUTHWEST
		if(EAST)
			return WEST
		if(SOUTHEAST)
			return NORTHWEST
		if(SOUTH)
			return NORTH
		if(SOUTHWEST)
			return NORTHEAST
		if(WEST)
			return EAST
		if(NORTHWEST)
			return SOUTHEAST

/*
Checks if that loc and dir has a item on the wall
*/
var/global/list/WALLITEMS = list(
	/obj/machinery/power/apc, /obj/machinery/alarm, /obj/item/device/radio/intercom,
	/obj/structure/extinguisher_cabinet, /obj/structure/reagent_dispensers/peppertank,
	/obj/machinery/status_display, /obj/machinery/requests_console, /obj/machinery/light_switch, /obj/structure/sign,
	/obj/machinery/newscaster, /obj/machinery/firealarm, /obj/structure/noticeboard,
	/obj/item/storage/secure/safe, /obj/machinery/door_timer, /obj/machinery/flasher, /obj/machinery/keycard_auth,
	/obj/item/storage/mirror, /obj/structure/fireaxecabinet, /obj/structure/filingcabinet/wallcabinet
	)
/proc/gotwallitem(loc, dir)
	for(var/obj/O in loc)
		for(var/item in WALLITEMS)
			if(istype(O, item))
				//Direction works sometimes
				if(O.dir == dir)
					return 1

				//Some stuff doesn't use dir properly, so we need to check pixel instead
				switch(dir)
					if(SOUTH)
						if(O.pixel_y > 10)
							return 1
					if(NORTH)
						if(O.pixel_y < -10)
							return 1
					if(WEST)
						if(O.pixel_x > 10)
							return 1
					if(EAST)
						if(O.pixel_x < -10)
							return 1


	//Some stuff is placed directly on the wallturf (signs)
	for(var/obj/O in get_step(loc, dir))
		for(var/item in WALLITEMS)
			if(istype(O, item))
				if(O.pixel_x == 0 && O.pixel_y == 0)
					return 1
	return 0

/proc/format_text(text)
	return replacetext(replacetext(text,"\proper ",""),"\improper ","")

/proc/topic_link(datum/D, arglist, content)
	if(istype(arglist,/list))
		arglist = list2params(arglist)
	return "<a href='?src=\ref[D];[arglist]'>[content]</a>"

/proc/get_random_colour(simple = FALSE, lower = 0, upper = 255)
	var/colour
	if(simple)
		colour = pick(list("FF0000","FF7F00","FFFF00","00FF00","0000FF","4B0082","8F00FF"))
	else
		for(var/i=1;i<=3;i++)
			var/temp_col = "[num2hex(rand(lower,upper))]"
			if(length(temp_col )<2)
				temp_col = "0[temp_col]"
			colour += temp_col
	return "#[colour]"

GLOBAL_DATUM_INIT(dview_mob, /mob/dview, new)

//Version of view() which ignores darkness, because BYOND doesn't have it.
/proc/dview(range = world.view, center, invis_flags = 0)
	RETURN_TYPE(/list)
	if(!center)
		return

	GLOB.dview_mob.loc = center
	GLOB.dview_mob.see_invisible = invis_flags
	. = view(range, GLOB.dview_mob)
	GLOB.dview_mob.loc = null

/mob/dview/Destroy()
	SHOULD_CALL_PARENT(FALSE)
	return QDEL_HINT_LETMELIVE

/**
 * Sets the atom's color and light values to those of `origin`.
 *
 * TODO: Update this to use `set_color()` and `get_color()`.
 *
 * **Parameters**:
 * - `origin` - The atom to copy light and color values from.
 */
/atom/proc/get_light_and_color(atom/origin)
	if(origin)
		color = origin.color
		set_light(origin.light_range, origin.light_power)


// call to generate a stack trace and print to runtime logs
/proc/crash_at(msg, file, line)
	CRASH("%% [file],[line] %% [msg]")


//clicking to move pulled objects onto assignee's turf/loc
/proc/do_pull_click(mob/user, atom/A)
	if(ismob(user.pulling))
		var/mob/M = user.pulling
		var/atom/movable/t = M.pulling
		M.stop_pulling()
		step(user.pulling, get_dir(user.pulling.loc, A))
		M.start_pulling(t)
	else
		step(user.pulling, get_dir(user.pulling.loc, A))

/proc/select_subpath(given_path, within_scope = /atom)
	var/desired_path = input("Enter full or partial typepath.","Typepath","[given_path]") as text|null
	if(!desired_path)
		return

	var/list/types = typesof(within_scope)
	var/list/matches = list()

	for(var/path in types)
		if(findtext("[path]", desired_path))
			matches += path

	if(!length(matches))
		alert("No results found. Sorry.")
		return

	if(length(matches)==1)
		return matches[1]
	else
		return (input("Select a type", "Select Type", matches[1]) as null|anything in matches)
