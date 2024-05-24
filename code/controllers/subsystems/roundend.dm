SUBSYSTEM_DEF(roundend)
	name = "Round End"
	wait = 30 SECONDS
	flags = SS_BACKGROUND
	runlevels = RUNLEVEL_GAME

	/// The time in minutes when the round will be ended.
	var/static/max_length

	/**
	* The time after no players are alive in the round at which the game ends.
	* Reset by new living players existing. If falsy, this behavior is disabled.
	*/
	var/static/empty_timeout

	/// The next time in minutes to start a round end vote.
	var/static/vote_check

	/// The cached duration to the next vote.
	var/static/vote_cache


/datum/controller/subsystem/roundend/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	if (GAME_STATE < RUNLEVEL_POSTGAME)
		var/round_time = round_duration_in_ticks / 600
		var/show_max
		if (max_length)
			show_max = max(round(max_length - round_time, 0.1), 0)
		var/show_vote
		if (vote_check)
			show_vote = max(round(vote_check - round_time, 0.1), 0)
		var/show_empty
		if (empty_timeout)
			show_empty = "Players Alive"
			if (empty_timeout != POSITIVE_INFINITY)
				show_empty = "[max(round(empty_timeout - round_time, 0.1), 0)]m"
		return ..({"\n\
			Max Time: [isnull(show_max) ? "Off" : "[show_max]m"]\n\
			Next Vote: [isnull(show_vote) ? "Off" : "[show_vote]m"]\n\
			Empty End: [isnull(show_empty) ? "Off" : "[show_empty]"]\
		"})
	else
		return ..("Game Finished")


/datum/controller/subsystem/roundend/Initialize(start_uptime)
	max_length = config.maximum_round_length
	vote_check = config.vote_autotransfer_initial
	if (config.empty_round_timeout)
		empty_timeout = POSITIVE_INFINITY


/datum/controller/subsystem/roundend/fire(resumed, no_mc_tick)
	var/time = round_duration_in_ticks / (1 MINUTE)
	if (max_length && time > max_length)
		if (evacuation_controller.is_idle())
			init_autotransfer()
		return
	if (empty_timeout)
		if (length(GLOB.living_players))
			empty_timeout = POSITIVE_INFINITY
		else if (empty_timeout == POSITIVE_INFINITY)
			empty_timeout = time + config.empty_round_timeout
		else if (time > empty_timeout)
			SSticker.forced_end = TRUE
			return
	if (vote_check)
		vote_cache = round(max(vote_check - time, 0), 0.1)
		if (vote_cache > 0)
			return
		SSvote.initiate_vote(/datum/vote/transfer, null, TRUE)
		if (config.vote_autotransfer_interval)
			vote_check += config.vote_autotransfer_interval
		else
			vote_check = 0
