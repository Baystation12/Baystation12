/mob/proc/has_personal_goal(var/goal_type)
	if(mind) return locate(goal_type) in mind.goals

/mob/proc/update_personal_goal(var/goal_type, var/progress)
	var/datum/goal/goal = has_personal_goal(goal_type)
	if(goal)
		goal.update_progress(progress)

/mob/verb/show_goals()

	set name = "Show Goals"
	set desc = "Shows your round goals."
	set category = "IC"

	if(!mind)
		to_chat(src, SPAN_WARNING("You are mindless and cannot have goals."))
		return

	if(LAZYLEN(mind.goals))
		to_chat(src, SPAN_NOTICE("<b>This round, you have the following personal goals:</b><br>[jointext(src.mind.summarize_goals(TRUE), "<br>")]"))
	else
		to_chat(src, SPAN_NOTICE("<b>You have no personal goals this round.</b>"))

	if(mind.assigned_job && mind.assigned_job.department_flag && SSgoals.departments["[mind.assigned_job.department_flag]"])
		var/datum/department/dept = SSgoals.departments["[mind.assigned_job.department_flag]"]
		if(LAZYLEN(dept.goals))
			to_chat(src, SPAN_NOTICE("<b>This round, [dept.name] has the following departmental goals:</b><br>[jointext(dept.summarize_goals(TRUE), "<br>")]"))
		else
			to_chat(src, SPAN_NOTICE("<b>[dept.name] has no departmental goals this round.</b>"))
