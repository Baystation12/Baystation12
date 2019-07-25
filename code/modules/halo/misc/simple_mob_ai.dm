
GLOBAL_LIST_EMPTY(assault_targets)

/mob/living/simple_animal/hostile
	var/obj/effect/landmark/assault_target/assault_target
	var/last_assault_target
	var/assault_target_type
	var/target_margin = 0
	var/path_timeout = 0

/obj/effect/landmark/assault_target
	name = "flood assault target marker"
	icon_state = "x3"
	invisibility = INVISIBILITY_SYSTEM

/obj/effect/landmark/assault_target/New()
	. = ..()
	var/list/targets_list = GLOB.assault_targets[src.type]
	if(!targets_list)
		targets_list = list()
		GLOB.assault_targets[src.type] = targets_list

	var/list/zlevel_landmarks = targets_list["[src.z]"]
	if(!zlevel_landmarks)
		zlevel_landmarks = list()
		targets_list["[src.z]"] = zlevel_landmarks

	zlevel_landmarks.Add(src)

/obj/effect/landmark/assault_target/Destroy()
	var/list/zlevel_landmarks = GLOB.assault_targets[src.type]["[src.z]"]
	zlevel_landmarks.Remove(src)
	. = ..()






/* simple_animal code */
/*
this uses very basic pathfinding... there is a more advanced form of pathfinding it could be setup to use called ASTAR (see code\procs\AStar.dm) but it's not necessary...
also using astar would have a performance impact due to eg hordes
*/

/mob/living/simple_animal/hostile/proc/set_assault_target(var/obj/effect/landmark/assault_target/new_assault_target)
	last_assault_target = assault_target
	assault_target = new_assault_target
	if(assault_target)
		target_margin = rand(7,0)

/mob/living/simple_animal/hostile/proc/handle_assault_pathing()

	//do we have a valid assault target?
	if(assault_target && assault_target.loc && assault_target.z == src.z)

		//are we already there?
		if(get_dist(assault_target, src) < target_margin)
			stop_pathing(rand(5,55) SECONDS)
		else
			wander = 0
			stop_automated_movement = 1

			//just path in their direction
			var/turf/target_turf = loc
			var/oldloc = src.loc
			for(var/i = 0 to world.view) //Let's move as far as we can see.
				target_turf = get_step_towards(target_turf,assault_target)
				if(target_turf)
					walk_to(src,target_turf,0,move_to_delay)

			//what about if the movement fails?
			if(src.loc == oldloc)
				//attempt to use basic ss13 pathfinding
				target_turf = loc
				for(var/i = 0 to world.view)
					target_turf = get_step_to(target_turf,assault_target)
					if(target_turf)
						walk_to(src,target_turf,0,move_to_delay)
						sleep(move_to_delay)
				/*else
					//failure: the destination is likely too far away (more than twice world.view ... should be 14 steps)
					//timeout for a longer time
					stop_pathing(1 MINUTE)
					return*/

			if(target_turf)
				dir = get_dir(oldloc, target_turf)
			else
				//we couldn't path to our current assault target, try to find a new one next tick
				stop_pathing(0)

	else if(world.time >= path_timeout)
		//stop pathing if we already are
		stop_pathing(0)

		//identify and pick an assault target
		var/list/possible_targets = GLOB.assault_targets[assault_target_type]
		if(possible_targets)
			var/list/zlevel_targets  = possible_targets["[src.z]"]
			if(zlevel_targets && zlevel_targets.len)
				var/obj/effect/landmark/assault_target/A = pick(zlevel_targets)
				if(A != last_assault_target)
					set_assault_target(A)

/mob/living/simple_animal/hostile/proc/stop_pathing(var/timeout = 10 SECONDS)
	set_assault_target()
	wander = initial(wander)
	stop_automated_movement = initial(stop_automated_movement)
	path_timeout = world.time + timeout
