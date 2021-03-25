
// Basic transit tubes. Straight pieces, curved sections,
//  and basic splits/joins (no routing logic).
// Mappers: you can use "Generate Instances from Icon-states"
//  to get the different pieces.
/obj/structure/transit_tube
	icon = 'icons/obj/pipes/transit_tube.dmi'
	icon_state = "E-W"
	density = TRUE
	layer = ABOVE_HUMAN_LAYER
	anchored = TRUE
	var/list/tube_dirs = null
	var/exit_delay = 2
	var/enter_delay = 1

	// alldirs in global.dm is the same list of directions, but since
	//  the specific order matters to get a usable icon_state, it is
	//  copied here so that, in the unlikely case that alldirs is changed,
	//  this continues to work.
	var/global/list/tube_dir_list = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)


// A place where tube pods stop, and people can get in or out.
// Mappers: use "Generate Instances from Directions" for this
//  one.
/obj/structure/transit_tube/station
	icon = 'icons/obj/pipes/transit_tube_station.dmi'
	icon_state = "closed"
	exit_delay = 2
	enter_delay = 3
	var/pod_moving = 0
	var/automatic_launch_time = 100

	var/const/OPEN_DURATION = 6
	var/const/CLOSE_DURATION = 6



/obj/structure/transit_tube_pod
	icon = 'icons/obj/pipes/transit_tube_pod.dmi'
	icon_state = "pod"
	animate_movement = FORWARD_STEPS
	anchored = TRUE
	density = TRUE
	var/moving = 0
	var/datum/gas_mixture/air_contents = new()



/obj/structure/transit_tube_pod/Destroy()
	for(var/atom/movable/AM in contents)
		AM.dropInto(loc)

	..()



// When destroyed by explosions, properly handle contents.
obj/structure/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/AM in contents)
				AM.dropInto(loc)
				AM.ex_act(severity++)

			qdel(src)
			return
		if(2.0)
			if(prob(50))
				for(var/atom/movable/AM in contents)
					AM.dropInto(loc)
					AM.ex_act(severity++)

				qdel(src)
				return
		if(3.0)
			return



/obj/structure/transit_tube_pod/New(loc)
	..(loc)

	air_contents.adjust_multi(GAS_OXYGEN, MOLES_O2STANDARD * 2, GAS_NITROGEN, MOLES_N2STANDARD)
	air_contents.temperature = T20C

	// Give auto tubes time to align before trying to start moving
	spawn(5)
		follow_tube()



/obj/structure/transit_tube/New(loc)
	..(loc)

	if(tube_dirs == null)
		init_dirs()



/obj/structure/transit_tube/Bumped(mob/AM as mob|obj)
	var/obj/structure/transit_tube/T = locate() in AM.loc
	if(T)
		to_chat(AM, "<span class='warning'>The tube's support pylons block your way.</span>")
		return ..()
	else
		AM.dropInto(loc)
		to_chat(AM, "<span class='info'>You slip under the tube.</span>")

/obj/structure/transit_tube/station/New(loc)
	..(loc)

/obj/structure/transit_tube/station/Bumped(mob/AM as mob|obj)
	if(!pod_moving && icon_state == "open" && istype(AM, /mob))
		for(var/obj/structure/transit_tube_pod/pod in loc)
			if(pod.contents.len)
				to_chat(AM, "<span class='notice'>The pod is already occupied.</span>")
				return
			else if(!pod.moving && (pod.dir in directions()))
				AM.forceMove(pod)

/obj/structure/transit_tube/station/attack_hand(mob/user as mob)
	if(!pod_moving)
		for(var/obj/structure/transit_tube_pod/pod in loc)
			if(!pod.moving && (pod.dir in directions()))
				if(icon_state == "closed")
					open_animation()

				else if(icon_state == "open")
					close_animation()



/obj/structure/transit_tube/station/proc/open_animation()
	if(icon_state == "closed")
		icon_state = "opening"
		spawn(OPEN_DURATION)
			if(icon_state == "opening")
				icon_state = "open"



/obj/structure/transit_tube/station/proc/close_animation()
	if(icon_state == "open")
		icon_state = "closing"
		spawn(CLOSE_DURATION)
			if(icon_state == "closing")
				icon_state = "closed"



/obj/structure/transit_tube/station/proc/launch_pod()
	for(var/obj/structure/transit_tube_pod/pod in loc)
		if(!pod.moving && (pod.dir in directions()))
			spawn(5)
				pod_moving = 1
				close_animation()
				sleep(CLOSE_DURATION + 2)

				//reverse directions for automated cycling
				var/turf/next_loc = get_step(loc, pod.dir)
				var/obj/structure/transit_tube/nexttube
				for(var/obj/structure/transit_tube/tube in next_loc)
					if(tube.has_entrance(pod.dir))
						nexttube = tube
						break
				if(!nexttube)
					pod.set_dir(turn(pod.dir, 180))

				if(icon_state == "closed" && pod)
					pod.follow_tube()

				pod_moving = 0

			return



// Called to check if a pod should stop upon entering this tube.
/obj/structure/transit_tube/proc/should_stop_pod(pod, from_dir)
	return 0



/obj/structure/transit_tube/station/should_stop_pod(pod, from_dir)
	return 1



// Called when a pod stops in this tube section.
/obj/structure/transit_tube/proc/pod_stopped(pod, from_dir)
	return



/obj/structure/transit_tube/station/pod_stopped(obj/structure/transit_tube_pod/pod, from_dir)
	pod_moving = 1
	spawn(5)
		open_animation()
		sleep(OPEN_DURATION + 2)
		pod_moving = 0
		pod.mix_air()

		if(automatic_launch_time)
			var/const/wait_step = 5
			var/i = 0
			while(i < automatic_launch_time)
				sleep(wait_step)
				i += wait_step

				if(pod_moving || icon_state != "open")
					return

			launch_pod()



// Returns a /list of directions this tube section can connect to.
//  Tubes that have some sort of logic or changing direction might
//  override it with additional logic.
/obj/structure/transit_tube/proc/directions()
	return tube_dirs



/obj/structure/transit_tube/proc/has_entrance(from_dir)
	from_dir = turn(from_dir, 180)

	for(var/direction in directions())
		if(direction == from_dir)
			return 1

	return 0



/obj/structure/transit_tube/proc/has_exit(in_dir)
	for(var/direction in directions())
		if(direction == in_dir)
			return 1

	return 0



// Searches for an exit direction within 45 degrees of the
//  specified dir. Returns that direction, or 0 if none match.
/obj/structure/transit_tube/proc/get_exit(in_dir)
	var/near_dir = 0
	var/in_dir_cw = turn(in_dir, -45)
	var/in_dir_ccw = turn(in_dir, 45)

	for(var/direction in directions())
		if(direction == in_dir)
			return direction

		else if(direction == in_dir_cw)
			near_dir = direction

		else if(direction == in_dir_ccw)
			near_dir = direction

	return near_dir



// Return how many BYOND ticks to wait before entering/exiting
//  the tube section. Default action is to return the value of
//  a var, which wouldn't need a proc, but it makes it possible
//  for later tube types to interact in more interesting ways
//  such as being very fast in one direction, but slow in others
/obj/structure/transit_tube/proc/exit_delay(pod, to_dir)
	return exit_delay

/obj/structure/transit_tube/proc/enter_delay(pod, to_dir)
	return enter_delay



/obj/structure/transit_tube_pod/proc/follow_tube()
	if(moving)
		return

	moving = 1

	spawn()
		var/obj/structure/transit_tube/current_tube = null
		var/next_dir
		var/next_loc
		var/last_delay = 0
		var/exit_delay

		for(var/obj/structure/transit_tube/tube in loc)
			if(tube.has_exit(dir))
				current_tube = tube
				break

		while(current_tube)
			next_dir = current_tube.get_exit(dir)

			if(!next_dir)
				break

			exit_delay = current_tube.exit_delay(src, dir)
			last_delay += exit_delay

			sleep(exit_delay)

			next_loc = get_step(loc, next_dir)

			current_tube = null
			for(var/obj/structure/transit_tube/tube in next_loc)
				if(tube.has_entrance(next_dir))
					current_tube = tube
					break

			if(current_tube == null)
				set_dir(next_dir)
				Move(get_step(loc, dir)) // Allow collisions when leaving the tubes.
				break

			last_delay = current_tube.enter_delay(src, next_dir)
			sleep(last_delay)
			set_dir(next_dir)
			forceMove(next_loc) // When moving from one tube to another, skip collision and such.
			set_density(current_tube.density)

			if(current_tube && current_tube.should_stop_pod(src, next_dir))
				current_tube.pod_stopped(src, dir)
				break

		set_density(1)

		// If the pod is no longer in a tube, move in a line until stopped or slowed to a halt.
		//  /turf/inertial_drift appears to only work on mobs, and re-implementing some of the
		//  logic allows a gradual slowdown and eventual stop when passing over non-space turfs.
		if(!current_tube && last_delay <= 10)
			do
				sleep(last_delay)

				if(!istype(loc, /turf/space))
					last_delay++

				if(last_delay > 10)
					break

			while(isturf(loc) && Move(get_step(loc, dir)))

		moving = 0

/obj/structure/transit_tube_pod/return_air()
	return air_contents

/obj/structure/transit_tube_pod/assume_air(datum/gas_mixture/giver)
	return air_contents.merge(giver)

/obj/structure/transit_tube_pod/remove_air(amount)
	return air_contents.remove(amount)

// Called when a pod arrives at, and before a pod departs from a station,
//  giving it a chance to mix its internal air supply with the turf it is
//  currently on.
/obj/structure/transit_tube_pod/proc/mix_air()
	var/datum/gas_mixture/environment = loc.return_air()

	//note that share_ratio assumes both gas mixes have the same volume,
	//so if the volume is changed this may need to be changed as well.
	air_contents.share_ratio(environment, 1)

// When the player moves, check if the pos is currently stopped at a station.
//  if it is, check the direction. If the direction matches the direction of
//  the station, try to exit. If the direction matches one of the station's
//  tube directions, launch the pod in that direction.
/obj/structure/transit_tube_pod/relaymove(mob/mob, direction)
	if(istype(mob, /mob) && mob.client)
		// If the pod is not in a tube at all, you can get out at any time.
		if(!(locate(/obj/structure/transit_tube) in loc))
			var/turf/T = get_turf(src)
			mob.forceMove(T)
			mob.client.Move(get_step(T, direction), direction)

			//if(moving && istype(loc, /turf/space))
				// Todo: If you get out of a moving pod in space, you should move as well.
				//  Same direction as pod? Direcion you moved? Halfway between?

		if(!moving)
			for(var/obj/structure/transit_tube/station/station in loc)
				if(dir in station.directions())
					if(!station.pod_moving)
						if(direction == station.dir)
							if(station.icon_state == "open")
								var/turf/T = get_turf(src)
								mob.forceMove(T)
								mob.client.Move(get_step(T, direction), direction)

							else
								station.open_animation()

						else if(direction in station.directions())
							set_dir(direction)
							station.launch_pod()
					return

			for(var/obj/structure/transit_tube/tube in loc)
				if(dir in tube.directions())
					if(tube.has_exit(direction))
						set_dir(direction)
						return



// Parse the icon_state into a list of directions.
// This means that mappers can use Dream Maker's built in
//  "Generate Instances from Icon-states" option to get all
//  variations. Additionally, as a separate proc, sub-types
//  can handle it more intelligently.
/obj/structure/transit_tube/proc/init_dirs()
	if(icon_state == "auto")
		// Additional delay, for map loading.
		spawn(1)
			init_dirs_automatic()

	else
		tube_dirs = parse_dirs(icon_state)

		if(copytext(icon_state, 1, 3) == "D-" || findtextEx(icon_state, "Pass"))
			set_density(0)



// Tube station directions are simply 90 to either side of
//  the exit.
/obj/structure/transit_tube/station/init_dirs()
	tube_dirs = list(turn(dir, 90), turn(dir, -90))



// Initialize dirs by searching for tubes that do/might connect
//  on nearby turfs. Create corner pieces if nessecary.
// Pick two directions, preferring tubes that already connect
//  to loc, or other auto tubes if there aren't enough connections.
/obj/structure/transit_tube/proc/init_dirs_automatic()
	var/list/connected = list()
	var/list/connected_auto = list()

	for(var/direction in tube_dir_list)
		var/location = get_step(loc, direction)
		for(var/obj/structure/transit_tube/tube in location)
			if(tube.directions() == null && tube.icon_state == "auto")
				connected_auto += direction
				break

			else if(turn(direction, 180) in tube.directions())
				connected += direction
				break

	connected += connected_auto

	tube_dirs = select_automatic_dirs(connected)

	if(length(tube_dirs) == 2 && list_find(tube_dir_list, tube_dirs[1]) > list_find(tube_dir_list, tube_dirs[2]))
		tube_dirs.Swap(1, 2)

	generate_automatic_corners(tube_dirs)
	select_automatic_icon_state(tube_dirs)



// Given a list of directions, look a pair that forms a 180 or
//  135 degree angle, and return a list containing the pair.
//  If none exist, return list(connected[1], turn(connected[1], 180)
/obj/structure/transit_tube/proc/select_automatic_dirs(connected)
	if(length(connected) < 1)
		return list()

	for(var/i = 1, i <= length(connected), i++)
		for(var/j = i + 1, j <= length(connected), j++)
			var/d1 = connected[i]
			var/d2 = connected[j]

			if(d1 == turn(d2, 135) || d1 == turn(d2, 180) || d1 == turn(d2, 225))
				return list(d1, d2)

	return list(connected[1], turn(connected[1], 180))



/obj/structure/transit_tube/proc/select_automatic_icon_state(directions)
	if(length(directions) == 2)
		icon_state = "[dir2text_short(directions[1])]-[dir2text_short(directions[2])]"



// Look for diagonal directions, generate the decorative corners in each.
/obj/structure/transit_tube/proc/generate_automatic_corners(directions)
	for(var/direction in directions)
		if(direction == 5 || direction == 6 || direction == 9 || direction == 10)
			if(direction & NORTH)
				create_automatic_decorative_corner(get_step(loc, NORTH), direction ^ 3)

			else
				create_automatic_decorative_corner(get_step(loc, SOUTH), direction ^ 3)

			if(direction & EAST)
				create_automatic_decorative_corner(get_step(loc, EAST), direction ^ 12)

			else
				create_automatic_decorative_corner(get_step(loc, WEST), direction ^ 12)



// Generate a corner, if one doesn't exist for the direction on the turf.
/obj/structure/transit_tube/proc/create_automatic_decorative_corner(location, direction)
	var/state = "D-[dir2text_short(direction)]"

	for(var/obj/structure/transit_tube/tube in location)
		if(tube.icon_state == state)
			return

	var/obj/structure/transit_tube/tube = new(location)
	tube.icon_state = state
	tube.init_dirs()



// Uses a list() to cache return values. Since they should
//  never be edited directly, all tubes with a certain
//  icon_state can just reference the same list. In theory,
//  reduces memory usage, and improves CPU cache usage.
//  In reality, I don't know if that is quite how BYOND works,
//  but it is probably safer to assume the existence of, and
//  rely on, a sufficiently smart compiler/optimizer.
/obj/structure/transit_tube/proc/parse_dirs(text)
	var/global/list/direction_table = list()

	if(text in direction_table)
		return direction_table[text]

	var/list/split_text = splittext(text, "-")

	// If the first token is D, the icon_state represents
	//  a purely decorative tube, and doesn't actually
	//  connect to anything.
	if(split_text[1] == "D")
		direction_table[text] = list()
		return null

	var/list/directions = list()

	for(var/text_part in split_text)
		var/direction = text2dir_extended(text_part)

		if(direction > 0)
			directions += direction

	direction_table[text] = directions
	return directions



// A copy of text2dir, extended to accept one and two letter
//  directions, and to clearly return 0 otherwise.
/obj/structure/transit_tube/proc/text2dir_extended(direction)
	switch(uppertext(direction))
		if("NORTH", "N")
			return 1
		if("SOUTH", "S")
			return 2
		if("EAST", "E")
			return 4
		if("WEST", "W")
			return 8
		if("NORTHEAST", "NE")
			return 5
		if("NORTHWEST", "NW")
			return 9
		if("SOUTHEAST", "SE")
			return 6
		if("SOUTHWEST", "SW")
			return 10
		else
	return 0



// A copy of dir2text, which returns the short one or two letter
//  directions used in tube icon states.
/obj/structure/transit_tube/proc/dir2text_short(direction)
	switch(direction)
		if(1)
			return "N"
		if(2)
			return "S"
		if(4)
			return "E"
		if(8)
			return "W"
		if(5)
			return "NE"
		if(6)
			return "SE"
		if(9)
			return "NW"
		if(10)
			return "SW"
		else
	return
