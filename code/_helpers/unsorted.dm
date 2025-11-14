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


/proc/LinkBlocked(turf/A, turf/B)
	if(isnull(A) || isnull(B)) return 1
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

/proc/getline(atom/M,atom/N)//Ultra-Fast Bresenham Line-Drawing Algorithm
	RETURN_TYPE(/list)
	var/px=M.x		//starting x
	var/py=M.y
	var/line = list(locate(px,py,M.z))
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
			p += 4*x++ + 6
		else
			p += 4*(x++ - y--) + 10

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


/// Ensures frequency is a whole odd number between low and high
/proc/sanitize_frequency(frequency, low = PUBLIC_LOW_FREQ, high = PUBLIC_HIGH_FREQ)
	return clamp(floor(frequency), low, high) | 1


// Turns 1479 into 147.9
/proc/format_frequency(f)
	return "[floor(f / 10)].[f % 10]"


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


/proc/get_follow_targets()
	RETURN_TYPE(/list)
	return follow_repository.get_follow_targets()


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


GLOBAL_LIST_AS(duplicate_object_disallowed_vars, list(
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
	"natural_weapon",
	"extensions"
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

/proc/get_mob_with_client_list()
	RETURN_TYPE(/list)
	var/list/mobs = list()
	for(var/mob/M in SSmobs.mob_list)
		if (M.client)
			mobs += M
	return mobs


/proc/parse_zone(zone)
	switch (zone)
		if (BP_R_HAND) return "right hand"
		if (BP_L_HAND) return "left hand"
		if (BP_L_ARM) return "left arm"
		if (BP_R_ARM) return "right arm"
		if (BP_L_LEG) return "left leg"
		if (BP_R_LEG) return "right leg"
		if (BP_L_FOOT) return "left foot"
		if (BP_R_FOOT) return "right foot"
		if (BP_L_HAND) return "left hand"
		if (BP_R_HAND) return "right hand"
		if (BP_L_FOOT) return "left foot"
		if (BP_R_FOOT) return "right foot"
		else return zone


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


/// Tries to collect the wall item for a given wall
/proc/get_wall_item(turf/turf, dir)
	for (var/obj/obj in turf)
		if (~obj.obj_flags & OBJ_FLAG_WALL_MOUNTED)
			continue
		if (obj.dir == dir)
			return obj
		switch (dir)
			if (SOUTH)
				if (obj.pixel_y > 10)
					return obj
			if (NORTH)
				if (obj.pixel_y < -10)
					return obj
			if (WEST)
				if (obj.pixel_x > 10)
					return obj
			if (EAST)
				if (obj.pixel_x < -10)
					return obj
	for (var/obj/obj in get_step(turf, dir))
		if (~obj.obj_flags & OBJ_FLAG_WALL_MOUNTED)
			continue
		if (!obj.pixel_x && !obj.pixel_y)
			return obj


/// Returns a random color hex with rgb parts from min to max. If called without args, picks from presets
/proc/get_random_colour(min, max)
	if (isnull(min))
		return pick("#ff0000", "#ff7f00", "#ffff00", "#00ff00", "#0000ff", "#4b0082", "#8f00ff")
	return rgb(rand(min, max), rand(min, max), rand(min, max))


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
