/datum/vote/add_antagonist
	name = "add antagonist"
	var/automatic = 0 //Handled slightly differently.

/datum/vote/add_antagonist/can_run(mob/creator, automatic)
	if(!(. = ..()))
		return
	if(!SSvote.is_addantag_allowed(creator, automatic)) //This handles the config setting and admin checking.
		return FALSE

/datum/vote/add_antagonist/setup_vote(mob/creator, automatic)
	var/list/all_antag_types = GLOB.all_antag_types_
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		if(!(antag.id in additional_antag_types) && antag.is_votable())
			choices += antag.role_text
	choices += "Random"
	if(!automatic)
		choices += "None"
	src.automatic = automatic
	..()

/datum/vote/add_antagonist/report_result()
	if((. = ..()) || (result[1] == "None")) // Failed vote or no antag desired
		antag_add_finished = 1             // So we will never try this again.
		return

	if(result[1] == "Random")
		var/list/pick_random = choices.Copy()
		pick_random -= "Random"
		pick_random -= "None"
		result[1] = pick(pick_random)

	if(GAME_STATE <= RUNLEVEL_LOBBY)
		antag_add_finished = 1
		var/antag_type = GLOB.antag_names_to_ids_[result[1]]
		if(!antag_type)
			return 1
		additional_antag_types |= antag_type
		return

	INVOKE_ASYNC(src, .proc/spawn_antags) //There is a sleep in this proc.

/datum/vote/add_antagonist/proc/spawn_antags()
	var/list/antag_choices = list()
	for(var/antag_type in result)
		antag_choices += GLOB.all_antag_types_[antag_type]
	if(SSticker.attempt_late_antag_spawn(antag_choices)) // This takes a while.
		antag_add_finished = 1
		if(automatic)
			// the buffer will already have half an hour added to it, so we'll give it one more
			transfer_controller.timerbuffer += config.vote_autotransfer_interval
	else
		to_world("<b>No antags were added.</b>")
		if(automatic)
			SSvote.queued_auto_vote = /datum/vote/transfer