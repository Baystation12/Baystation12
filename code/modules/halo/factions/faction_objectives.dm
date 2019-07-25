
/datum/faction/proc/setup_faction_objectives(var/list/objective_types)
	for(var/objective_type in objective_types)
		var/datum/objective/objective = new objective_type()
		objective.my_faction = src
		all_objectives.Add(objective)
		max_points += objective.get_win_points()
		if(!objective.find_target())
			objectives_without_targets.Add(objective)
		objective.update_score_desc()
