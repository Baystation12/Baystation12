#define CHOICE_RANDOM "Random"
#define CHOICE_NONE "None"

/datum/vote/add_antagonist
	name = "add antagonist"
	result_length = 3
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
	choices += CHOICE_RANDOM
	if(!automatic)
		choices += CHOICE_NONE
	src.automatic = automatic
	..()

/datum/vote/add_antagonist/report_result()
	if((. = ..()) || (result[1] == CHOICE_NONE)) // Failed vote or no antag desired
		antag_add_finished = 1             // So we will never try this again.
		return

	if(result[1] == CHOICE_RANDOM)
		var/list/pick_random = choices.Copy()
		pick_random -= CHOICE_RANDOM
		pick_random -= CHOICE_NONE
		result[1] = pick(pick_random)

	if(GAME_STATE <= RUNLEVEL_LOBBY)
		antag_add_finished = 1
		var/antag_type = GLOB.antag_names_to_ids_[result[1]]
		if(!antag_type)
			return 1
		additional_antag_types |= antag_type
		return

	invoke_async(src, .proc/spawn_antags) //There is a sleep in this proc.

/datum/vote/add_antagonist/proc/spawn_antags()
	var/list/antag_choices = list()
	for(var/antag_type in result)
		antag_choices += GLOB.all_antag_types_[GLOB.antag_names_to_ids_[antag_type]]
	if(SSticker.attempt_late_antag_spawn(antag_choices)) // This takes a while.
		antag_add_finished = 1
		if(automatic)
			if (SSroundend.vote_check)
				SSroundend.vote_check += config.vote_autotransfer_interval
	else
		to_world("<b>No antags were added.</b>")
		if(automatic)
			SSvote.queued_auto_vote = /datum/vote/transfer

#undef CHOICE_RANDOM
#undef CHOICE_NONE
