/datum/goal/ambition
	can_reroll = FALSE

/datum/goal/ambition/New()
	..()
	if(owner)
		SSgoals.ambitions[owner] = src

/datum/goal/ambition/Destroy()
	SSgoals.ambitions -= owner
	. = ..()

/datum/goal/ambition/get_success_string()
	return ""

/datum/goal/ambition/summarize(show_success = FALSE, allow_modification = FALSE, mob/caller)
	. = SPAN_DANGER(..(show_success))
