/datum/vote/end_round
	name = "end round"
	question = "End the round?"
	choices = list("End the Round", "Continue Playing")

/datum/vote/end_round/can_run(mob/creator, automatic)
	if(GAME_STATE !=  RUNLEVEL_GAME)
		return FALSE
	if(automatic || check_rights(R_SERVER, 0, creator))
		return TRUE

/datum/vote/end_round/report_result()
	if(..())
		return 1
	if(result[1] == "End the Round")
		SSticker.forced_end = TRUE
