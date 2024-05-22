//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

#define IS_SUBTYPE(child_type, parent_type) (child_type != parent_type && istype(child_type, parent_type))

#define IS_SUBPATH(child_path, parent_path) (child_path != parent_path && ispath(child_path, parent_path))

/proc/is_on_same_plane_or_station(z1, z2)
	if(z1 == z2)
		return 1
	if((z1 in GLOB.using_map.station_levels) &&	(z2 in GLOB.using_map.station_levels))
		return 1
	return 0

/proc/max_default_z_level()
	var/max_z = 0
	for(var/z in GLOB.using_map.station_levels)
		max_z = max(z, max_z)
	for(var/z in GLOB.using_map.admin_levels)
		max_z = max(z, max_z)
	for(var/z in GLOB.using_map.player_levels)
		max_z = max(z, max_z)
	return max_z

/proc/living_observers_present(list/zlevels)
	if(LAZYLEN(zlevels))
		for(var/mob/M in GLOB.player_list) //if a tree ticks on the empty zlevel does it really tick
			if(M.stat != DEAD) //(no it doesn't)
				var/turf/T = get_turf(M)
				if(T && (T.z in zlevels))
					return TRUE
	return FALSE

/proc/get_area_name(N) //get area by its name
	RETURN_TYPE(/area)
	for(var/area/A in world)
		if(A.name == N)
			return A

/proc/get_area_master(O)
	RETURN_TYPE(/area)
	var/area/A = get_area(O)
	if (isarea(A))
		return A

/proc/in_range(atom/source, mob/user)
	if(get_dist(source, user) <= 1)
		return TRUE

	return FALSE //not in range and not telekinetic

// Like view but bypasses luminosity check

/proc/hear(range, atom/source)
	RETURN_TYPE(/list)

	var/lum = source.luminosity
	source.luminosity = 6

	var/list/heard = view(range, source)
	source.luminosity = lum

	return heard

/proc/isStationLevel(level)
	return level in GLOB.using_map.station_levels

/proc/isNotStationLevel(level)
	return !isStationLevel(level)

/proc/isPlayerLevel(level)
	return level in GLOB.using_map.player_levels

/proc/isAdminLevel(level)
	return level in GLOB.using_map.admin_levels

/proc/isNotAdminLevel(level)
	return !isAdminLevel(level)

/proc/isContactLevel(level)
	return level in GLOB.using_map.contact_levels

/proc/isEscapeLevel(level)
	return level in GLOB.using_map.escape_levels

/proc/circlerange(center=usr,radius=3)
	RETURN_TYPE(/list)

	var/turf/centerturf = get_turf(center)
	var/list/turfs = list()
	var/rsq = radius * (radius+0.5)

	for(var/atom/T in range(radius, centerturf))
		var/dx = T.x - centerturf.x
		var/dy = T.y - centerturf.y
		if(dx*dx + dy*dy <= rsq)
			turfs += T

	//turfs += centerturf
	return turfs

/proc/circleview(center=usr,radius=3)
	RETURN_TYPE(/list)

	var/turf/centerturf = get_turf(center)
	var/list/atoms = list()
	var/rsq = radius * (radius+0.5)

	for(var/atom/A in view(radius, centerturf))
		var/dx = A.x - centerturf.x
		var/dy = A.y - centerturf.y
		if(dx*dx + dy*dy <= rsq)
			atoms += A

	//turfs += centerturf
	return atoms

/proc/trange(rad = 0, turf/centre = null) //alternative to range (ONLY processes turfs and thus less intensive)
	RETURN_TYPE(/list)
	if(!centre)
		return

	var/turf/x1y1 = locate(((centre.x-rad)<1 ? 1 : centre.x-rad),((centre.y-rad)<1 ? 1 : centre.y-rad),centre.z)
	var/turf/x2y2 = locate(((centre.x+rad)>world.maxx ? world.maxx : centre.x+rad),((centre.y+rad)>world.maxy ? world.maxy : centre.y+rad),centre.z)
	return block(x1y1,x2y2)

/proc/get_dist_euclidian(atom/Loc1 as turf|mob|obj,atom/Loc2 as turf|mob|obj)
	var/dx = Loc1.x - Loc2.x
	var/dy = Loc1.y - Loc2.y

	var/dist = sqrt(dx**2 + dy**2)

	return dist

/proc/get_bearing(atom/source, atom/destination)
	var/bearing = round(90 - Atan2(destination.x - source.x, destination.y - source.y),5)
	if(bearing < 0)
		bearing += 360
	return bearing

/proc/circlerangeturfs(center=usr,radius=3)
	RETURN_TYPE(/list)
	var/turf/centerturf = get_turf(center)
	. = list()
	if(!centerturf)
		return

	var/rsq = radius * (radius+0.5)

	for(var/turf/T in range(radius, centerturf))
		var/dx = T.x - centerturf.x
		var/dy = T.y - centerturf.y
		if(dx*dx + dy*dy <= rsq)
			. += T

/proc/circleviewturfs(center=usr,radius=3)		//Is there even a diffrence between this proc and circlerangeturfs()?
	RETURN_TYPE(/list)

	var/turf/centerturf = get_turf(center)
	var/list/turfs = list()
	var/rsq = radius * (radius+0.5)

	for(var/turf/T in view(radius, centerturf))
		var/dx = T.x - centerturf.x
		var/dy = T.y - centerturf.y
		if(dx*dx + dy*dy <= rsq)
			turfs += T
	return turfs



//var/debug_mob = 0

// Will recursively loop through an atom's contents and check for mobs, then it will loop through every atom in that atom's contents.
// It will keep doing this until it checks every content possible. This will fix any problems with mobs, that are inside objects,
// being unable to hear people due to being in a box within a bag.

/proc/recursive_content_check(atom/O,  list/L = list(), recursion_limit = 3, client_check = 1, sight_check = 1, include_mobs = 1, include_objects = 1)
	RETURN_TYPE(/list)

	if(!recursion_limit)
		return L

	for(var/I in O.contents)

		if(ismob(I))
			if(!sight_check || isInSight(I, O))
				L |= recursive_content_check(I, L, recursion_limit - 1, client_check, sight_check, include_mobs, include_objects)
				if(include_mobs)
					if(client_check)
						var/mob/M = I
						if(M.client)
							L |= M
					else
						L |= I

		else if(isobj(I))
			if(!sight_check || isInSight(I, O))
				L |= recursive_content_check(I, L, recursion_limit - 1, client_check, sight_check, include_mobs, include_objects)
				if(include_objects)
					L |= I

	return L

// Returns a list of mobs and/or objects in range of R from source. Used in radio and say code.

/proc/get_mobs_or_objects_in_view(R, atom/source, include_mobs = 1, include_objects = 1)
	RETURN_TYPE(/list)

	var/turf/T = get_turf(source)
	var/list/hear = list()

	if(!T)
		return hear

	var/list/range = hear(R, T)

	for(var/I in range)
		if(ismob(I))
			hear |= recursive_content_check(I, hear, 3, 1, 0, include_mobs, include_objects)
			if(include_mobs)
				var/mob/M = I
				if(M.client)
					hear += M
		else if(isobj(I))
			hear |= recursive_content_check(I, hear, 3, 1, 0, include_mobs, include_objects)
			if(include_objects)
				hear += I

	return hear


/proc/get_mobs_in_radio_ranges(list/obj/item/device/radio/radios)
	RETURN_TYPE(/list)

	set background = 1

	. = list()
	// Returns a list of mobs who can hear any of the radios given in @radios
	var/list/speaker_coverage = list()
	for(var/obj/item/device/radio/R in radios)
		if(R)
			//Cyborg checks. Receiving message uses a bit of cyborg's charge.
			var/obj/item/device/radio/borg/BR = R
			if(istype(BR) && BR.myborg)
				var/mob/living/silicon/robot/borg = BR.myborg
				var/datum/robot_component/CO = borg.get_component("radio")
				if(!CO)
					continue //No radio component (Shouldn't happen)
				if(!borg.is_component_functioning("radio") || !borg.cell_use_power(CO.active_usage))
					continue //No power.

			var/turf/speaker = get_turf(R)
			if(speaker)
				for(var/turf/T in hear(R.canhear_range,speaker))
					speaker_coverage[T] = T


	// Try to find all the players who can hear the message
	for (var/mob/M in GLOB.player_list)
		var/turf/ear = get_turf(M)
		if(ear)
			// Ghostship is magic: Ghosts can hear radio chatter from anywhere
			if(speaker_coverage[ear] || (isghost(M) && M.get_preference_value(/datum/client_preference/ghost_radio) == GLOB.PREF_ALL_CHATTER))
				. |= M		// Since we're already looping through mobs, why bother using |= ? This only slows things down.
	return .

/proc/get_mobs_and_objs_in_view_fast(turf/T, range, list/mobs, list/objs, checkghosts = null)

	var/list/hear = list()
	DVIEW(hear, range, T, INVISIBILITY_MAXIMUM)
	var/list/hearturfs = list()

	for(var/atom/movable/AM in hear)
		if(ismob(AM))
			mobs += AM
			hearturfs += get_turf(AM)
		else if(isobj(AM))
			objs += AM
			hearturfs += get_turf(AM)

	for(var/mob/M in GLOB.player_list)
		if(checkghosts && M.stat == DEAD && M.get_preference_value(checkghosts) != GLOB.PREF_NEARBY)
			mobs |= M
		else if(get_turf(M) in hearturfs)
			mobs |= M

	for(var/obj/O in GLOB.listening_objects)
		if(get_turf(O) in hearturfs)
			objs |= O





/proc/inLineOfSight(X1,Y1,X2,Y2,Z=1,PX1=16.5,PY1=16.5,PX2=16.5,PY2=16.5)
	var/turf/T
	if(X1==X2)
		if(Y1==Y2)
			return 1 //Light cannot be blocked on same tile
		else
			var/s = SIMPLE_SIGN(Y2-Y1)
			Y1+=s
			while(Y1!=Y2)
				T=locate(X1,Y1,Z)
				if(T.opacity)
					return 0
				Y1+=s
	else
		var/m=(32*(Y2-Y1)+(PY2-PY1))/(32*(X2-X1)+(PX2-PX1))
		var/b=(Y1+PY1/32-0.015625)-m*(X1+PX1/32-0.015625) //In tiles
		var/signX = SIMPLE_SIGN(X2-X1)
		var/signY = SIMPLE_SIGN(Y2-Y1)
		if(X1<X2)
			b+=m
		while(X1!=X2 || Y1!=Y2)
			if(round(m*X1+b-Y1))
				Y1+=signY //Line exits tile vertically
			else
				X1+=signX //Line exits tile horizontally
			T=locate(X1,Y1,Z)
			if(T.opacity)
				return 0
	return 1

/proc/isInSight(atom/A, atom/B)
	var/turf/Aturf = get_turf(A)
	var/turf/Bturf = get_turf(B)

	if(!Aturf || !Bturf)
		return 0

	if(inLineOfSight(Aturf.x,Aturf.y, Bturf.x,Bturf.y,Aturf.z))
		return 1

	else
		return 0

/proc/get_cardinal_step_away(atom/start, atom/finish) //returns the position of a step from start away from finish, in one of the cardinal directions
	RETURN_TYPE(/turf)
	//returns only NORTH, SOUTH, EAST, or WEST
	var/dx = finish.x - start.x
	var/dy = finish.y - start.y
	if(abs(dy) > abs (dx)) //slope is above 1:1 (move horizontally in a tie)
		if(dy > 0)
			return get_step(start, SOUTH)
		else
			return get_step(start, NORTH)
	else
		if(dx > 0)
			return get_step(start, WEST)
		else
			return get_step(start, EAST)

/proc/get_mob_by_key(key)
	RETURN_TYPE(/mob)
	for(var/mob/M in SSmobs.mob_list)
		if(M.ckey == lowertext(key))
			return M
	return null


// Will return a list of active candidates. It increases the buffer 5 times until it finds a candidate which is active within the buffer.
/proc/get_active_candidates(buffer = 1)
	RETURN_TYPE(/list)

	var/list/candidates = list() //List of candidate KEYS to assume control of the new larva ~Carn
	var/i = 0
	while(length(candidates) <= 0 && i < 5)
		for(var/mob/observer/ghost/G in GLOB.player_list)
			if(((G.client.inactivity/10)/60) <= buffer + i) // the most active players are more likely to become an alien
				if(!(G.mind && G.mind.current && G.mind.current.stat != DEAD))
					candidates += G.key
		i++
	return candidates

/proc/ScreenText(obj/O, maptext="", screen_loc="CENTER-7,CENTER-7", maptext_height=480, maptext_width=480)
	RETURN_TYPE(/obj/screen)
	if(!isobj(O))	O = new /obj/screen/text()
	O.maptext = maptext
	O.maptext_height = maptext_height
	O.maptext_width = maptext_width
	O.screen_loc = screen_loc
	return O

/proc/Show2Group4Delay(obj/O, list/group, delay=0)
	if(!isobj(O))	return
	if(!group)	group = GLOB.clients
	for(var/client/C in group)
		C.screen += O
	if(delay)
		spawn(delay)
			for(var/client/C in group)
				C.screen -= O

/proc/flick_overlay(image/I, list/show_to, duration)
	for(var/client/C in show_to)
		C.images += I
	spawn(duration)
		for(var/client/C in show_to)
			C.images -= I

/datum/projectile_data
	var/src_x
	var/src_y
	var/time
	var/distance
	var/power_x
	var/power_y
	var/dest_x
	var/dest_y

/datum/projectile_data/New(src_x, src_y, time, distance, \
						   power_x, power_y, dest_x, dest_y)
	src.src_x = src_x
	src.src_y = src_y
	src.time = time
	src.distance = distance
	src.power_x = power_x
	src.power_y = power_y
	src.dest_x = dest_x
	src.dest_y = dest_y

/proc/projectile_trajectory(src_x, src_y, rotation, angle, power)
	RETURN_TYPE(/datum/projectile_data)

	// returns the destination (Vx,y) that a projectile shot at [src_x], [src_y], with an angle of [angle],
	// rotated at [rotation] and with the power of [power]
	// Thanks to VistaPOWA for this function

	var/power_x = power * cos(angle)
	var/power_y = power * sin(angle)
	var/time = 2* power_y / 10 //10 = g

	var/distance = time * power_x

	var/dest_x = src_x + distance*sin(rotation);
	var/dest_y = src_y + distance*cos(rotation);

	return new /datum/projectile_data(src_x, src_y, time, distance, power_x, power_y, dest_x, dest_y)

/proc/GetRedPart(hexa)
	return hex2num(copytext(hexa,2,4))

/proc/GetGreenPart(hexa)
	return hex2num(copytext(hexa,4,6))

/proc/GetBluePart(hexa)
	return hex2num(copytext(hexa,6,8))

/proc/GetHexColors(hexa)
	RETURN_TYPE(/list)
	return list(
			GetRedPart(hexa),
			GetGreenPart(hexa),
			GetBluePart(hexa)
		)

/proc/MixColors(list/colors)
	var/list/reds = list()
	var/list/blues = list()
	var/list/greens = list()
	var/list/weights = list()

	for (var/i = 0, ++i <= length(colors))
		reds.Add(GetRedPart(colors[i]))
		blues.Add(GetBluePart(colors[i]))
		greens.Add(GetGreenPart(colors[i]))
		weights.Add(1)

	var/r = mixOneColor(weights, reds)
	var/g = mixOneColor(weights, greens)
	var/b = mixOneColor(weights, blues)
	return rgb(r,g,b)

/proc/mixOneColor(list/weight, list/color)
	if (!weight || !color || length(weight)!=length(color))
		return 0

	var/contents = length(weight)
	var/i

	//normalize weights
	var/listsum = 0
	for(i=1; i<=contents; i++)
		listsum += weight[i]
	for(i=1; i<=contents; i++)
		weight[i] /= listsum

	//mix them
	var/mixedcolor = 0
	for(i=1; i<=contents; i++)
		mixedcolor += weight[i]*color[i]
	mixedcolor = round(mixedcolor)

	//until someone writes a formal proof for this algorithm, let's keep this in
//	if(mixedcolor<0x00 || mixedcolor>0xFF)
//		return 0
	//that's not the kind of operation we are running here, nerd
	mixedcolor=min(max(mixedcolor,0),255)

	return mixedcolor

/**
* Gets the highest and lowest pressures from the tiles in cardinal directions
* around us, then checks the difference.
*/
/proc/getOPressureDifferential(turf/loc)
	var/minp=16777216;
	var/maxp=0;
	for(var/dir in GLOB.cardinal)
		var/turf/simulated/T=get_turf(get_step(loc,dir))
		var/cp=0
		if(T && istype(T) && T.zone)
			var/datum/gas_mixture/environment = T.return_air()
			cp = environment.return_pressure()
		else
			if(istype(T,/turf/simulated))
				continue
		if(cp<minp)minp=cp
		if(cp>maxp)maxp=cp
	return abs(minp-maxp)

/proc/convert_k2c(temp)
	return ((temp - T0C))

/proc/convert_c2k(temp)
	return ((temp + T0C))

/proc/getCardinalAirInfo(turf/loc, list/stats=list("temperature"))
	RETURN_TYPE(/list)
	var/list/temps = new(4)
	for(var/dir in GLOB.cardinal)
		var/direction
		switch(dir)
			if(NORTH)
				direction = 1
			if(SOUTH)
				direction = 2
			if(EAST)
				direction = 3
			if(WEST)
				direction = 4
		var/turf/simulated/T=get_turf(get_step(loc,dir))
		var/list/rstats = new(length(stats))
		if(T && istype(T) && T.zone)
			var/datum/gas_mixture/environment = T.return_air()
			for(var/i=1;i<=length(stats);i++)
				if(stats[i] == "pressure")
					rstats[i] = environment.return_pressure()
				else
					rstats[i] = environment.vars[stats[i]]
		else if(istype(T, /turf/simulated))
			rstats = null // Exclude zone (wall, door, etc).
		else if(istype(T, /turf))
			// Should still work.  (/turf/return_air())
			var/datum/gas_mixture/environment = T.return_air()
			for(var/i=1;i<=length(stats);i++)
				if(stats[i] == "pressure")
					rstats[i] = environment.return_pressure()
				else
					rstats[i] = environment.vars[stats[i]]
		temps[direction] = rstats
	return temps

/proc/MinutesToTicks(minutes)
	return SecondsToTicks(60 * minutes)

/proc/SecondsToTicks(seconds)
	return seconds * 10

/proc/round_is_spooky(spookiness_threshold = config.cult_ghostwriter_req_cultists)
	return (length(GLOB.cult.current_antagonists) > spookiness_threshold)

/proc/getviewsize(view)
	RETURN_TYPE(/list)
	var/viewX
	var/viewY
	if(isnum(view))
		var/totalviewrange = 1 + 2 * view
		viewX = totalviewrange
		viewY = totalviewrange
	else
		var/list/viewrangelist = splittext(view,"x")
		if(length(viewrangelist) != 2)
			stack_trace("For some reason, client view is not represented as standard values or is null: [view]")
			viewX = 19
			viewY = 15

		viewX = text2num(viewrangelist[1])
		viewY = text2num(viewrangelist[2])
	return list(viewX, viewY)

/proc/get_view_size_x(view)
	var/list/view_size = getviewsize(view)
	return view_size[1]

/proc/get_view_size_y(view)
	var/list/view_size = getviewsize(view)
	return view_size[2]

/proc/get_lesser_view_size_component(view)
	var/list/view_size = getviewsize(view)
	return min(view_size[1], view_size[2])

/proc/get_greater_view_size_component(view)
	var/list/view_size = getviewsize(view)
	return max(view_size[1], view_size[2])
