#define CHOICE_TRANSFER "Initiate crew transfer"
#define CHOICE_EXTEND "Extend the round ([config.vote_autotransfer_interval / 600] minutes)"
#define CHOICE_ADD_ANTAG "Add antagonist"

/datum/vote/transfer
	name = "transfer"
	question = "End the shift?"

/datum/vote/transfer/can_run(mob/creator, automatic)
	if(!(. = ..()))
		return
	if(!evacuation_controller || !evacuation_controller.should_call_autotransfer_vote())
		return FALSE
	if(!automatic && !config.allow_vote_restart && !isadmin(creator))
		return FALSE // Admins and autovotes bypass the config setting.
	if(check_rights(R_INVESTIGATE, 0, creator))
		return //Mods bypass further checks.
	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
	if (!automatic && security_state.current_security_level_is_same_or_higher_than(security_state.high_security_level))
		to_chat(creator, "The current alert status is too high to call for a crew transfer!")
		return FALSE
	if(GAME_STATE <= RUNLEVEL_SETUP)
		to_chat(creator, "The crew transfer button has been disabled!")
		return FALSE

/datum/vote/transfer/setup_vote(mob/creator, automatic)
	choices = list(CHOICE_TRANSFER, CHOICE_EXTEND)
	if (config.allow_extra_antags && SSvote.is_addantag_allowed(creator, automatic))
		choices += CHOICE_ADD_ANTAG
	..()

/datum/vote/transfer/handle_default_votes()
	if(config.vote_no_default)
		return
	var/factor = 0.5
	switch(world.time / (1 MINUTE))
		if(0 to 60)
			factor = 0.5
		if(61 to 120)
			factor = 0.8
		if(121 to 240)
			factor = 1
		if(241 to 300)
			factor = 1.2
		else
			factor = 1.4
	choices[CHOICE_TRANSFER] = round(choices[CHOICE_TRANSFER] * factor)
	to_world("<font color='purple'>Crew Transfer Factor: [factor]</font>")

/datum/vote/transfer/report_result()
	if(..())
		return 1
	if(result[1] == CHOICE_TRANSFER)
		init_autotransfer()
	else if(result[1] == CHOICE_ADD_ANTAG)
		SSvote.queued_auto_vote = /datum/vote/add_antagonist

/datum/vote/transfer/mob_not_participating(mob/user)
	if((. = ..()))
		return
	if(config.vote_no_dead_crew_transfer)
		return !isliving(user) || ismouse(user) || isdrone(user) || user.stat == DEAD

/datum/vote/transfer/check_toggle()
	return config.allow_vote_restart ? "Allowed" : "Disallowed"

/datum/vote/transfer/toggle(mob/user)
	if(isadmin(user))
		config.allow_vote_restart = !config.allow_vote_restart

#undef CHOICE_TRANSFER
#undef CHOICE_EXTEND
#undef CHOICE_ADD_ANTAG
