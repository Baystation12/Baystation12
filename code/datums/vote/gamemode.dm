/datum/vote/gamemode
	name = "game mode"
	additional_header = "<th>Required Players / Antags</th>"
	win_x = 500
	win_y = 800
	result_length = 3

/datum/vote/gamemode/can_run(mob/creator, automatic)
	if(!automatic && (!config.allow_vote_mode || !isadmin(creator)))
		return FALSE // Admins and autovotes bypass the config setting.
	if(GAME_STATE >= RUNLEVEL_GAME)
		return FALSE
	return ..()

/datum/vote/gamemode/Process()
	if(GAME_STATE >= RUNLEVEL_GAME)
		to_world("<b>Voting aborted due to game start.</b>")
		return VOTE_PROCESS_ABORT
	return ..()


/datum/vote/gamemode/setup_vote(mob/creator, automatic)
	..()
	var/list/lobby_players = SSticker.lobby_players()
	log_debug("MODE VOTE: Lobby Players: [lobby_players.len]")
	var/list/skipped = list()
	for (var/tag in config.votable_modes)
		var/datum/game_mode/mode = config.gamemode_cache[tag]
		var/cause = mode.check_votable(lobby_players)
		if (cause)
			skipped[tag] = cause
			continue
		choices += tag
	log_debug("MODE VOTE: Non-Votable Modes: [json_encode(skipped)]")
	for (var/tag in choices)
		var/datum/game_mode/mode = config.gamemode_cache[tag]
		var/text = " / <span style='color:red;font-weight:bold'>[mode.required_enemies]</span>"
		additional_text[tag] = "<td align='center'><span style='font-weight:bold'>[mode.required_players]</span> [text]</td>"
		display_choices[tag] = capitalize(mode.name)
	if (!config.secret_disabled)
		display_choices["secret"] = "Secret"
		choices += "secret"
	log_debug("MODE VOTE: Votable Modes: [json_encode(choices)]")


/datum/vote/gamemode/handle_default_votes()
	var/non_voters = ..()
	if(SSticker.master_mode in choices)
		choices[SSticker.master_mode] += non_voters


/datum/vote/gamemode/report_result()
	if(!SSticker.round_progressing) //Unpause any holds. If the vote failed, SSticker is responsible for fielding the result.
		SSticker.round_progressing = 1
		to_world("<font color='red'><b>The round will start soon.</b></font>")
	if(..())
		SSticker.gamemode_vote_results = list() //This signals to SSticker that the vote is over but there were no winners.
		return 1
	if(SSticker.master_mode != result[1])
		world.save_mode(result[1])
		if(SSticker.mode)
			SSvote.restart_world() //This is legacy behavior for votes after the mode is set, e.g. if an admin halts the ticker and holds another vote before gamestart.
			return                 //Potenitally the new vote after restart can then be cancelled, to use this vote's result.
		SSticker.master_mode = result[1]
	SSticker.gamemode_vote_results = result.Copy()

/datum/vote/gamemode/check_toggle()
	return config.allow_vote_mode ? "Allowed" : "Disallowed"

/datum/vote/gamemode/toggle(mob/user)
	if(isadmin(user))
		config.allow_vote_mode = !config.allow_vote_mode
