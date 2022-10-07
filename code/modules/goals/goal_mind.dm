/datum/mind
	var/list/goals

/datum/mind/proc/show_roundend_summary(var/department_goals)
	if(current)
		if(department_goals && current.get_preference_value(/datum/client_preference/show_department_goals) == GLOB.PREF_SHOW)
			to_chat(current, SPAN_NOTICE(department_goals))
		if(LAZYLEN(goals))
			to_chat(current, SPAN_NOTICE("<br><br><b>В этой смене вы имели следующие личные цели:</b><br>[jointext(summarize_goals(TRUE), "<br>")]"))

/datum/mind/proc/summarize_goals(var/show_success = FALSE, var/allow_modification = FALSE, var/mob/caller)
	. = list()
	if(LAZYLEN(goals))
		for(var/i = 1 to LAZYLEN(goals))
			var/datum/goal/goal = goals[i]
			. += "[i]. [goal.summarize(show_success, allow_modification, caller)]"

// Create and display personal goals for this round.
/datum/mind/proc/generate_goals(datum/job/job, adding_goals, add_amount, is_spawning, bypass_goal_checks)

	if(!adding_goals)
		goals = null

	var/list/available_goals = SSgoals.global_personal_goals ? SSgoals.global_personal_goals.Copy() : list()

	if(ishuman(current))
		var/mob/living/carbon/human/H = current
		for(var/token in H.cultural_info)
			var/decl/cultural_info/culture = H.get_cultural_value(token)
			var/list/new_goals = culture.get_possible_personal_goals(job ? job.department_flag : null)
			if(LAZYLEN(new_goals))
				available_goals |= new_goals

	var/min_goals = 0
	var/max_goals = 5
	if(job)
		min_goals = job.min_goals
		max_goals = job.max_goals
		if(LAZYLEN(job.possible_goals))
			available_goals |= job.possible_goals

	if(isnull(add_amount))
		add_amount = rand(min_goals, max_goals)

	if (!bypass_goal_checks)
		add_amount = min(max(0, max_goals - LAZYLEN(goals)), add_amount)
		if(add_amount <= 0)
			if(!is_spawning)
				to_chat(src.current, SPAN_WARNING("Your job doesn't allow for any more distractions."))
			return FALSE

		var/pref_val = current.get_preference_value(/datum/client_preference/give_personal_goals)
		if (pref_val == GLOB.PREF_NEVER || (pref_val == GLOB.PREF_NON_ANTAG && player_is_antag(src)))
			if(!is_spawning)
				to_chat(src.current, SPAN_WARNING("Your preferences do not allow you to add random goals."))
			return FALSE

	if(LAZYLEN(goals))
		for (var/datum/goal/mind_goal in goals)
			LAZYREMOVE(available_goals, mind_goal.type)
		if(!LAZYLEN(available_goals))
			if(!is_spawning)
				to_chat(src.current, SPAN_WARNING("There are no more goals available."))
			return FALSE

	for(var/i = 1 to min(LAZYLEN(available_goals), add_amount))
		var/goal = pick_n_take(available_goals)
		new goal(src)
	return TRUE

/datum/mind/proc/delete_goal(datum/job/job, datum/goal/goal, override_min_goals)
	var/min_goals = job ? job.min_goals : 1

	if(!override_min_goals && LAZYLEN(goals) == min_goals)
		to_chat(src.current, SPAN_WARNING("Your job needs you to have at least [min_goals] distraction\s."))
		return FALSE
	else
		qdel(goal)
		return TRUE
