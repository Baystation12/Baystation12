/datum/department
	var/name
	var/flag
	var/list/goals
	var/min_goals = 1
	var/max_goals = 2

/datum/department/proc/Initialize()
	if(!name || !flag || length(goals) <= 0)
		return
	var/list/possible_goals = goals.Copy()
	goals.Cut()
	var/goals_to_pick = min(length(possible_goals), rand(min_goals, max_goals))
	while(goals_to_pick && length(possible_goals))
		var/goal = pick_n_take(possible_goals)
		var/datum/goal/deptgoal = new goal(src)
		if(deptgoal.is_valid())
			LAZYADD(goals, deptgoal)
			goals_to_pick--
		else
			qdel(deptgoal)

/datum/department/proc/summarize_goals(show_success = FALSE)
	. = list()
	for(var/i = 1 to length(goals))
		var/datum/goal/goal = goals[i]
		. += "[i]. [goal.summarize(show_success)]"

/datum/department/proc/update_progress(goal_type, progress)
	var/datum/goal/goal = locate(goal_type) in goals
	if(goal)
		goal.update_progress(progress)
