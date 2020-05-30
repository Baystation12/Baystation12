


/* Simple Mob Pathing */

GLOBAL_LIST_EMPTY(assault_targets)

/mob/living/simple_animal/hostile
	var/obj/effect/landmark/assault_target/assault_target
	var/last_assault_target
	var/assault_target_type
	var/path_timeout = 0

/obj/effect/landmark/assault_target
	name = "assault target marker"
	icon = 'code/modules/halo/misc/ai_tokens.dmi'
	invisibility = INVISIBILITY_SYSTEM
	var/tracking_level

/obj/effect/landmark/assault_target/covenant
	name = "covenant assault target"
	icon_state = "covenant"

/obj/effect/landmark/assault_target/unsc
	name = "unsc assault target"
	icon_state = "unsc"

/obj/effect/landmark/assault_target/New()
	. = ..()

	//store ourselves for easy reference
	var/list/targets_list = GLOB.assault_targets[src.type]
	if(!targets_list)
		targets_list = list()
		GLOB.assault_targets[src.type] = targets_list

	//note this isn't true multiz support, it just allows mob tracking
	//tracked mobs moving to a different zlevel will just confuse simple mobs for a while before another one will be chosen
	tracking_level = src.z
	if(src.z == 0)
		tracking_level = src.loc.z
	var/list/zlevel_landmarks = targets_list["[tracking_level]"]
	if(!zlevel_landmarks)
		zlevel_landmarks = list()
		targets_list["[tracking_level]"] = zlevel_landmarks

	zlevel_landmarks.Add(src)

/obj/effect/landmark/assault_target/Destroy()
	var/list/zlevel_landmarks = GLOB.assault_targets[src.type]["[tracking_level]"]
	zlevel_landmarks.Remove(src)
	. = ..()






/* simple_animal code */
/*
this uses very basic pathfinding... there is a more advanced form of pathfinding it could be setup to use called ASTAR (see code\procs\AStar.dm) but it's not necessary...
also using astar would have a performance impact due to eg hordes
*/

/mob/living/simple_animal/hostile/proc/set_assault_target(var/obj/effect/landmark/assault_target/new_assault_target)
	if(assault_target)
		last_assault_target = assault_target
	assault_target = new_assault_target
	walk(src, 0)

/mob/living/simple_animal/hostile
	var/turf/previous_turf
	var/timeout_check = 0

/mob/living/simple_animal/hostile/proc/handle_assault_pathing()

	//check if we are stuck
	if(src.loc == previous_turf)
		timeout_check++
		if(timeout_check > 2)
			stop_pathing()

	//do we have a valid assault target?
	var/turf/assault_turf
	if(assault_target)
		assault_turf = get_turf(assault_target)

	//do we have a valid target?
	if(assault_turf && assault_turf.z == src.z)

		//are we already there?
		if(get_dist(assault_turf, src) < src.see_in_dark)
			//hang around here for a minute before moving
			stop_pathing(1 MINUTE)
		else
			//head straight to the target
			wander = 0
			stop_automated_movement = 1

			var/turf/target_turf = src.loc

			//if we are close, use dumb SS13 pathfinding
			//get_step_to() has a distance limit of 2 * world.view, greater than that returns null
			if(get_dist(loc, assault_turf) <= world.view)
				for(var/i = 0 to world.view)
					//Let's move as far as we can see.
					var/turf/next_turf = get_step_to(target_turf, assault_turf)
					if(next_turf)
						target_turf = next_turf
					else
						break
			else
				//use even dumber pathfinding by heading in it's general direction
				target_turf = get_step_towards(src.loc, assault_turf)

			if(target_turf == src.loc)
				target_turf = null

			if(target_turf)
				//this calls the walk proc every process() tick, which will be redundant
				//it will be safer this way though given the crude pathfinding algorithm
				dir = get_dir(src.loc, target_turf)
				walk_to(src,target_turf,0,move_to_delay)
				path_timeout = world.time + move_to_delay
			else
				//we couldn't path to our current assault target, try to find a new one next tick
				stop_pathing(0)

	else if(world.time >= path_timeout)
		//we don't have a valid assault target so immediately stop pathing to it
		stop_pathing(0)

		//identify and pick a new assault target
		var/list/possible_targets = GLOB.assault_targets[assault_target_type]
		if(possible_targets)
			var/list/zlevel_targets  = possible_targets["[src.z]"]
			if(zlevel_targets)
				if(zlevel_targets.len > 1)
					var/obj/effect/landmark/assault_target/A = pick(\
						zlevel_targets.len > 1 ? zlevel_targets - last_assault_target : zlevel_targets)
					set_assault_target(A)
				else if(zlevel_targets.len == 1)
					set_assault_target(zlevel_targets[1])

	previous_turf = src.loc

/mob/living/simple_animal/hostile/proc/stop_pathing(var/timeout = 10 SECONDS)
	set_assault_target()
	wander = initial(wander)
	stop_automated_movement = initial(stop_automated_movement)
	path_timeout = world.time + timeout



/* Follow Leader Commands */

/mob/living/simple_animal
	//Simple Command Stuff//
	var/mob/leader_follow
	var/hold_fire = FALSE

/mob/living/simple_animal/proc/handle_leader_pathing()
	if(leader_follow)
		if(get_dist(loc,leader_follow.loc) < world.view*2 && loc != leader_follow.loc)//A bit higher than a single screen
			if(istype(loc,/obj/vehicles))
				var/obj/vehicles/v = loc
				v.exit_vehicle(src,1)
			walk_to(src,pick(trange(2,leader_follow.loc)-leader_follow.loc),1,move_to_delay)
			if(istype(leader_follow.loc,/obj/vehicles))
				var/obj/vehicles/v = leader_follow.loc
				if(v.Adjacent(src))
					for(var/seat in list("gunner","driver","passenger"))
						if(!v.enter_as_position(src,seat))
							v.visible_message("<span class = 'notice'>[name] fails to enter [v.name]'s [seat] seat.</span>")
						else
							v.visible_message("<span class = 'notice'>[name] enters [v.name]'s [seat] seat.</span>")
							return 1
					set_leader(null)
		else
			if(leader_follow && loc != leader_follow.loc)
				set_leader(null)
			walk(src,0)
		return 0

/mob/living/simple_animal/can_swap_with(var/mob/living/tmob)
	//just in case
	. = ..()

	//allow swapping between friendly faction members heading in different directions
	//this should prevent them getting "stuck" on each other when pathing together as a group
	if(tmob.faction == src.faction && src.dir != tmob.dir)
		return 1