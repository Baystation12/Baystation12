/datum/goal
	var/description
	var/owner
	var/completion_message
	var/can_reroll = TRUE
	var/can_abandon = TRUE

/datum/goal/New(var/_owner)
	owner = _owner
	GLOB.destroyed_event.register(owner, src, /datum/proc/qdel_self)
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

/datum/goal/proc/summarize(var/show_success = FALSE, var/allow_modification = FALSE, var/datum/admins/admin, var/position = 1)
	. = "[description][get_summary_value()]"
	if(show_success)
		. += get_success_string()
	if(allow_modification)
		if(can_abandon) . += " (<a href='?src=\ref[owner];admin=\ref[admin];abandon_goal=[position]'>Abandon</a>)"
		if(can_reroll)  . += " (<a href='?src=\ref[owner];admin=\ref[admin];reroll_goal=[position]'>Reroll</a>)"

/datum/goal/proc/get_success_string()
	return check_success() ? " <b><font color='green'>Success!</font></b>" : " <b><font color='red'>Failure.</font></b>"

/datum/goal/proc/get_summary_value()
	return

/datum/goal/proc/update_strings()
	return

/datum/goal/proc/update_progress(var/progress)
	return

/datum/goal/proc/check_success()
	return TRUE

/datum/goal/proc/on_completion()
	if(completion_message && check_success())
		if(istype(owner, /datum/mind))
			var/datum/mind/mind = owner
			to_chat(mind.current, "<font color='green'><b>[completion_message]</b></font>")
