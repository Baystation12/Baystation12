/datum/mind
	var/list/goals

/datum/mind/proc/show_roundend_summary(var/department_goals)
	if(department_goals && current.get_preference_value(/datum/client_preference/show_department_goals) == GLOB.PREF_SHOW) 
		to_chat(current, SPAN_NOTICE(department_goals))
	if(LAZYLEN(goals))
		to_chat(current, SPAN_NOTICE("<br><br><b>You had the following personal goals this round:</b><br>[jointext(summarize_goals(TRUE), "<br>")]"))

/datum/mind/proc/summarize_goals(var/show_success = FALSE)
	. = list()
	if(LAZYLEN(goals))
		for(var/i = 1 to LAZYLEN(goals))
			var/datum/goal/goal = goals[i]
			. += "[i]. [goal.summarize(show_success)]"

// Create and display personal goals for this round.
/datum/mind/proc/generate_goals(var/datum/job/job)

	goals = null
	var/has_goals = FALSE
	var/pref_val = current.get_preference_value(/datum/client_preference/give_personal_goals)
	if(pref_val != GLOB.PREF_NEVER && (pref_val != GLOB.PREF_NON_ANTAG || player_is_antag(src)))
		var/list/available_goals = SSgoals.global_personal_goals ? SSgoals.global_personal_goals.Copy() : list()
		if(ishuman(current))
			var/mob/living/carbon/human/H = current
			for(var/token in H.cultural_info)
				var/decl/cultural_info/culture = H.get_cultural_value(token)
				var/list/new_goals = culture.get_possible_personal_goals(job ? job.department_flag : null)
				if(LAZYLEN(new_goals))
					available_goals |= new_goals

		var/min_goals = 1
		var/max_goals = 3
		if(job && LAZYLEN(job.possible_goals))
			available_goals |= job.possible_goals
			min_goals = job.min_goals
			max_goals = job.max_goals
		for(var/i = 1 to min(LAZYLEN(available_goals), rand(min_goals, max_goals)))
			var/goal = pick_n_take(available_goals)
			new goal(src)

		if(LAZYLEN(goals))
			to_chat(current, SPAN_NOTICE("<br><br><b>This round, you have the following personal goals:</b><br>[jointext(summarize_goals(), "<br>")]"))
			has_goals = TRUE
		else
			to_chat(current, SPAN_NOTICE("<br><br><b>You have no personal goals this round.</b>"))

	// Display previously generated departmental goals for this round.
	if(job && job.department_flag && SSgoals.departments["[job.department_flag]"])
		var/datum/department/dept = SSgoals.departments["[job.department_flag]"]
		if(LAZYLEN(dept.goals))
			to_chat(current, SPAN_NOTICE("<br><br><b>This round, [dept.name] has the following departmental goals:</b><br>[jointext(dept.summarize_goals(), "<br>")]"))
			has_goals = TRUE
		else
			to_chat(current, SPAN_NOTICE("<br><br><b>[dept.name] has no departmental goals this round.</b>"))

	if(has_goals)
		to_chat(current, SPAN_NOTICE("<br><br>You can check your round goals with the <b>Show Goals</b> verb.<br>"))
