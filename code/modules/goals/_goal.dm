/datum/goal
	var/description
	var/owner
	var/completion_message
	var/failure_message
	var/can_reroll = TRUE
	var/can_abandon = TRUE

/datum/goal/New(_owner)
	owner = _owner
	GLOB.destroyed_event.register(owner, src, TYPE_PROC_REF(/datum, qdel_self))
	if(istype(owner, /datum/mind))
		var/datum/mind/mind = owner
		LAZYADD(mind.goals, src)
	update_strings()

/datum/goal/Destroy()
	GLOB.destroyed_event.unregister(owner, src)
	if(owner)
		if(istype(owner, /datum/mind))
			var/datum/mind/mind = owner
			LAZYREMOVE(mind.goals, src)
		owner = null
	. = ..()

/datum/goal/proc/summarize(show_success = FALSE, allow_modification = FALSE, mob/caller)
	. = "[description][get_summary_value()]"
	if(show_success)
		. += get_success_string()
	if(allow_modification)
		if(can_abandon) . += " (<a href='?src=\ref[owner];abandon_goal=\ref[src];abandon_goal_caller=\ref[caller]'>Abandon</a>)"
		if(can_reroll)  . += " (<a href='?src=\ref[owner];reroll_goal=\ref[src];reroll_goal_caller=\ref[caller]'>Reroll</a>)"

/datum/goal/proc/get_success_string()
	return check_success() ? " <b>[SPAN_COLOR("green", "Success!")]</b>" : " <b>[SPAN_COLOR("red", "Failure.")]</b>"

/datum/goal/proc/get_summary_value()
	return

/datum/goal/proc/update_strings()
	return

/datum/goal/proc/update_progress(progress)
	return

/datum/goal/proc/check_success()
	return TRUE

/datum/goal/proc/try_initialize()
	return TRUE

/datum/goal/proc/on_completion()
	if(completion_message && check_success())
		if(istype(owner, /datum/mind))
			var/datum/mind/mind = owner
			to_chat(mind.current, SPAN_COLOR("green", "<b>[completion_message]</b>"))

/datum/goal/proc/on_failure()
	if(failure_message && !check_success() && istype(owner, /datum/mind))
		var/datum/mind/mind = owner
		to_chat(mind.current, SPAN_DANGER(failure_message))

/datum/goal/proc/is_valid()
	return TRUE
