#define CHOICE_RESTART "Restart round"
#define CHOICE_CONTINUE "Continue playing"

/datum/vote/restart
	name = "restart"
	choices = list(CHOICE_RESTART, CHOICE_CONTINUE)

/datum/vote/restart/can_run(mob/creator, automatic)
	if(!automatic && !config.allow_vote_restart && !isadmin(creator))
		return FALSE // Admins and autovotes bypass the config setting.
	return ..()

/datum/vote/restart/handle_default_votes()
	var/non_voters = ..()
	choices[CHOICE_CONTINUE] += non_voters

/datum/vote/restart/report_result()
	if(..())
		return 1
	if(result[1] == CHOICE_RESTART)
		SSvote.restart_world()

#undef CHOICE_RESTART
#undef CHOICE_CONTINUE
