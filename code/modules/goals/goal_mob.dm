/mob/proc/has_personal_goal(goal_type)
	if(mind) return locate(goal_type) in mind.goals

/mob/proc/update_personal_goal(goal_type, progress)
	var/datum/goal/goal = has_personal_goal(goal_type)
	if(goal)
		goal.update_progress(progress)

/mob/verb/show_goals_verb()

	set name = "Show Goals"
	set desc = "Shows your round goals."
	set category = "IC"

	show_goals(TRUE, TRUE)

/mob/proc/show_goals(show_success = FALSE, allow_modification = FALSE)

	if(!mind)
		to_chat(src, SPAN_WARNING("You are mindless and cannot have goals."))
		return

	var/max_goals = 5
	var/datum/department/dept
	if(mind.assigned_job)
		max_goals = mind.assigned_job.max_goals
		if(mind.assigned_job.department_flag && SSgoals.departments["[mind.assigned_job.department_flag]"])
			dept = SSgoals.departments["[mind.assigned_job.department_flag]"]

	//No goals to display
	if(!(allow_modification || LAZYLEN(mind.goals)) && !(dept && LAZYLEN(dept.goals)))
		return

	var/pref_val = get_preference_value(/datum/client_preference/give_personal_goals)
	var/prefs_no_personal_goals = pref_val == GLOB.PREF_NEVER || (pref_val == GLOB.PREF_NON_ANTAG && player_is_antag(mind))
	to_chat(src, "<hr>")
	if(LAZYLEN(mind.goals))
		to_chat(src, SPAN_NOTICE("[FONT_LARGE("<b>This round, you have the following personal goals:</b>")]<br>[jointext(mind.summarize_goals(show_success, allow_modification, mind.current), "<br>")]"))
	else if(prefs_no_personal_goals)
		to_chat(src, SPAN_NOTICE(FONT_LARGE("<b>Your preferences do not allow for personal goals.</b>")))
	else
		to_chat(src, SPAN_NOTICE(FONT_LARGE("<b>You have no personal goals this round.</b>")))
	if(allow_modification && !prefs_no_personal_goals && LAZYLEN(mind.goals) < max_goals)
		to_chat(src, SPAN_NOTICE("<a href='?src=\ref[mind];add_goal=1;add_goal_caller=\ref[mind.current]'>Add Random Goal</a>"))
	if(dept && get_preference_value(/datum/client_preference/show_department_goals) == GLOB.PREF_SHOW)
		if(LAZYLEN(dept.goals))
			to_chat(src, SPAN_NOTICE("<br><br>[FONT_LARGE("<b>This round, [dept.name] has the following departmental goals:</b>")]<br>[jointext(dept.summarize_goals(show_success), "<br>")]"))
		else
			to_chat(src, SPAN_NOTICE("<br><br>[FONT_LARGE("<b>[dept.name] has no departmental goals this round.</b>")]"))

	if(LAZYLEN(mind.goals))
		to_chat(mind.current, SPAN_NOTICE("<br><br>You can check your round goals with the <b>Show Goals</b> verb."))

	to_chat(src, "<hr>")
