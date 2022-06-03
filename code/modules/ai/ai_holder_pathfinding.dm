// This handles obtaining a (usually A*) path towards something, such as a target, destination, or leader.
// This interacts heavily with code inside ai_holder_movement.dm

/datum/ai_holder
	// Pathfinding.
	var/use_astar = FALSE				// Do we use the more expensive A* implementation or stick with BYOND's default step_to()?
	var/list/path = list()				// A list of tiles that A* gave us as a solution to reach the target.
	var/list/obstacles = list()			// Things A* will try to avoid.
	var/astar_adjacent_proc = /turf/proc/CardinalTurfsWithAccess // Proc to use when A* pathfinding.  Default makes them bound to cardinals.
	var/failed_steps = 0				// If move_once() fails to move the mob onto the correct tile, this increases. When it reaches 3, the path is recalc'd since they're probably stuck.

// This clears the stored A* path.
/datum/ai_holder/proc/forget_path()
	ai_log("forget_path() : Entering.", AI_LOG_DEBUG)
	if (path_display)
		for (var/turf/T in path)
			T.overlays -= path_overlay
	path.Cut()
	ai_log("forget_path() : Exiting.", AI_LOG_DEBUG)

/datum/ai_holder/proc/give_up_movement()
	ai_log("give_up_movement() : Entering.", AI_LOG_DEBUG)
	forget_path()
	destination = null
	ai_log("give_up_movement() : Exiting.", AI_LOG_DEBUG)

/datum/ai_holder/proc/calculate_path(atom/A, get_to = 1)
	ai_log("calculate_path([A],[get_to]) : Entering.", AI_LOG_DEBUG)
	if (!A)
		ai_log("calculate_path() : Called without an atom. Exiting.",AI_LOG_WARNING)
		return

	if (!use_astar) // If we don't use A* then this is pointless.
		ai_log("calculate_path() : Not using A*, Exiting.", AI_LOG_DEBUG)
		return

	get_path(get_turf(A), get_to)

	ai_log("calculate_path() : Exiting.", AI_LOG_DEBUG)

///A* now, try to a path to a target
/datum/ai_holder/proc/get_path(turf/target,var/get_to = 1, max_distance = world.view*6)
	ai_log("get_path() : Entering.",AI_LOG_DEBUG)
	forget_path()
	var/list/new_path = AStar(get_turf(holder.loc), target, astar_adjacent_proc, /turf/proc/Distance, min_target_dist = get_to, max_node_depth = max_distance, id = holder.IGetID(), exclude = obstacles)

	if (new_path && new_path.len)
		path = new_path
		ai_log("get_path() : Made new path.", AI_LOG_DEBUG)
		if (path_display)
			for(var/turf/T in path)
				T.overlays |= path_overlay
	else
		ai_log("get_path() : Failed to make new path. Exiting.", AI_LOG_DEBUG)
		return 0

	ai_log("get_path() : Exiting.", AI_LOG_DEBUG)
	return path.len