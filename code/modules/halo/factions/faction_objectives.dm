
/datum/faction/proc/setup_faction_objectives(var/list/objective_types)
	for(var/objective_type in objective_types)
		var/datum/objective/objective = new objective_type()
		all_objectives.Add(objective)
		max_points += objective.get_win_points()
		objective.find_target()

		/*
		//these ones might not be able to do all their setup prior to round start
		if(objective.find_specific_target)
			objectives_specific_target.Add(objective)

		//these objectives are affected when a ship goes into slipspace and despawns
		if(objective.slipspace_affected)
			objectives_slipspace_affected.Add(objective)
		*/
