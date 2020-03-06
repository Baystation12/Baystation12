


/* RESTART */

/datum/vote/restart
	name = "restart"
	choices = list("Restart Round","Continue Playing")

/datum/vote/restart/Initialize()
	..()

	if(!config.allow_vote_restart)
		disabled = 1
		disable_reason = "disabled in config"

/datum/vote/restart/calculate_result()
	if(!config.vote_no_default)
		var/non_voters = (GLOB.clients.len - total_votes)
		choices["Continue Playing"] += non_voters

	.  = ..()

/datum/vote/restart/do_result()
	. = ..()

	if(.[1] == "Restart Round")
		to_world("<span class='danger'>>World restarting due to vote...</span>")

		feedback_set_details("end_error","restart vote")
		if(blackbox)	blackbox.save_all_data_to_sql()
		sleep(50)
		log_game("Rebooting due to restart vote")
		world.Reboot()



/* GAMEMODE */

/datum/vote/gamemode
	name = "gamemode"
	delay_round_start = 1
	additional_text_title = "Required Players"
	var/pregame_vote = 0
	var/list/gamemode_names = list()

/datum/vote/gamemode/Initialize()
	InitGamemodes()

	..()

/datum/vote/gamemode/proc/InitGamemodes()

	for (var/F in config.votable_modes)
		var/datum/game_mode/M = gamemode_cache[F]
		if(!M)
			continue
		if(M.name == "extended" && !config.allow_extended_vote)
			continue
		gamemode_names[M.config_tag] = capitalize(M.name) //It's ugly to put this here but it works
		additional_text.Add("<td align = 'center'>[M.required_players]</td>")
		choices.Add(F)

	//gamemode_names["secret"] = "Secret"
	//gamemode_names["random"] = "Random"
	choices.Add("secret")
	choices.Add("random")
	additional_text.Add("<td align = 'center'>???</td>")
	additional_text.Add("<td align = 'center'>???</td>")

	reset_choices()

	if(!config.allow_vote_mode)
		disabled = 1
		disable_reason = "disabled in config"

/datum/vote/gamemode/initiate_vote(initiator, var/automatic = 0)

	//have to put this here as the list of gamemodes is not setup when vote/Initialize() is called at roundstart
	if(!choices.len)
		InitGamemodes()

	.  = ..()

	if(.)
		if(ticker.current_state <= GAME_STATE_SETTING_UP)
			pregame_vote = 1

/datum/vote/gamemode/process()
	. = ..()

	// No more change mode votes after the game has started.
	// 3 is GAME_STATE_PLAYING, but that #define is undefined for some reason
	if(pregame_vote && ticker.current_state >= GAME_STATE_SETTING_UP)
		to_world("<span class='danger'>Voting aborted due to game start.</span>")

		end_vote(1)
		return

/datum/vote/gamemode/calculate_result()
	if(!config.vote_no_default)
		var/non_voters = (GLOB.clients.len - total_votes)
		if(master_mode in choices)
			choices[master_mode] += non_voters

	. = ..()

/datum/vote/gamemode/do_result()
	. = ..()

	if(master_mode != .[1])
		world.save_mode(.[1])
	secondary_mode = .[2]
	tertiary_mode = .[3]

	if(ticker.current_state == GAME_STATE_PREGAME)
		master_mode = .[1]
		to_world("<span class='danger'>The round will start soon.</span>")
	else
		to_world("<span class='danger'>The gamemode vote result will apply next round.</span>")

	/*if(round_started)
		feedback_set_details("end_error","restart vote")
		to_world("<span class='danger'>World restarting due to vote...</span>")
		if(blackbox)	blackbox.save_all_data_to_sql()
		sleep(50)
		log_game("Rebooting due to restart vote")
		world.Reboot()*/

/datum/vote/gamemode/announce_vote(var/announce_text)
	. = ..()

	if(ticker.current_state == GAME_STATE_PREGAME)
		to_world("<span class='notice'>Round start has been delayed.</span>")

/datum/vote/gamemode/reset()
	. = ..()
	pregame_vote = 0



/* END ROUND EARLY */
//a generic replacement for crew transfer vote, use this instead
/datum/vote/end_round_early
	name = "end_round_early"
	question = "End the round early?"
	choices = list("End Round Early", "Continue The Round")

/datum/vote/end_round_early/Initialize()
	..()

	if(!config.allow_vote_restart)
		disabled = 1
		disable_reason = "disabled in config"

/datum/vote/end_round_early/calculate_result()
	//default-vote for everyone who didn't vote
	if(!config.vote_no_default)
		var/non_voters = (GLOB.clients.len - total_votes)
		if(non_voters > 0)
			var/factor = 0.5
			switch(world.time / (10 * 60)) // minutes
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
			choices["End Round Early"] = round(choices["End Round Early"] * factor)
			to_world("<font color='purple'>Time multiplier factor: [factor]</font>")
	. = ..()

/datum/vote/end_round_early/do_result()
	. = ..()

	if(.[1] == "End Round Early")
		ticker.mode.declare_completion()
		evacuation_controller.finish_evacuation()



/* CREW TRANSFER */
//don't use this, we're not on a single ship or station any more
/datum/vote/crew_transfer
	name = "crew_transfer"
	question = "End the shift?"
	choices = list("Initiate Crew Transfer", "Continue The Round")

/datum/vote/crew_transfer/Initialize()
	..()

	if(!config.allow_vote_restart)
		disabled = 1
		disable_reason = "disabled in config"

/datum/vote/crew_transfer/initiate_vote(var/initiator_key, var/automatic = 0)
	if(check_rights(R_ADMIN|R_MOD, 0) || automatic)
		if (config.allow_extra_antags && !antag_add_finished)
			choices.Add("Add Antagonist")
	else
		if (get_security_level() == "red" || get_security_level() == "delta")
			to_chat(initiator_key, "The current alert status is too high to call for a crew transfer!")
			return 0
		if(ticker.current_state <= GAME_STATE_SETTING_UP)
			return 0
			to_chat(initiator_key, "The crew transfer button has been disabled!")
		choices.Add("Initiate Crew Transfer", "Continue The Round")
		if (config.allow_extra_antags && vote.is_addantag_allowed(1))
			choices.Add("Add Antagonist")

	. = ..()

/datum/vote/crew_transfer/do_result()
	. = ..()

	if(.[1] == "Initiate Crew Transfer")
		init_autotransfer()

	else if(.[1] == "Add Antagonist")
		spawn(10)
			vote.autoaddantag()

/datum/vote/crew_transfer/calculate_result()
	//default-vote for everyone who didn't vote
	if(!config.vote_no_default)
		var/non_voters = (GLOB.clients.len - total_votes)
		if(non_voters > 0)
			var/factor = 0.5
			switch(world.time / (10 * 60)) // minutes
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
			choices["Initiate Crew Transfer"] = round(choices["Initiate Crew Transfer"] * factor)
			to_world("<font color='purple'>Crew Transfer Factor: [factor]</font>")
	. = ..()



/* ADD ANTAGONIST */

/datum/vote/add_antagonist
	name = "add_antagonist"
	var/auto_add_antag = 0

/datum/vote/add_antagonist/Initialize()
	..()

	if(!config.allow_extra_antags)
		disabled = 1
		disable_reason = "disabled in config"

/datum/vote/add_antagonist/do_result()
	antag_add_finished = 1

	. = ..()

	if(isnull(.[1]) || .[1] == "None")
		antag_add_finished = 1
	else
		choices -= "Random"
		if(!auto_add_antag)
			choices -= "None"
		for(var/i = 1, i <= length(.), i++)
			if(.[i] == "Random")
				.[i] = pick(choices)
				to_world("<span class'notice'>The random antag in [i]\th place is [.[i]].</span>")

		var/antag_type = antag_names_to_ids()[.[1]]
		if(ticker.current_state < GAME_STATE_SETTING_UP)
			additional_antag_types |= antag_type
		else
			spawn(0) // break off so we don't hang the vote process
				var/list/antag_choices = list(all_antag_types()[antag_type], all_antag_types()[antag_names_to_ids()[.[2]]], all_antag_types()[antag_names_to_ids()[.[3]]])
				if(ticker.attempt_late_antag_spawn(antag_choices))
					antag_add_finished = 1
					if(auto_add_antag)
						auto_add_antag = 0
						// the buffer will already have an hour added to it, so we'll give it one more
						transfer_controller.timerbuffer = transfer_controller.timerbuffer + config.vote_autotransfer_interval
				else
					to_world("<span class='notice'>No antags were added.</span>")

					if(auto_add_antag)
						auto_add_antag = 0
						spawn(10)
							vote.autotransfer()

/datum/vote/add_antagonist/initiate_vote(var/vote_type, var/initiator_key, var/automatic = 0)
	if(!vote.is_addantag_allowed(automatic))
		if(!automatic)
			to_chat(usr, "The add antagonist vote is unavailable at this time. The game may not have started yet, the game mode may disallow adding antagonists, or you don't have required permissions.")
		return 0

	if(!config.allow_extra_antags)
		return 0
	var/list/all_antag_types = all_antag_types()
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		if(!(antag.id in additional_antag_types) && antag.is_votable())
			choices.Add(antag.role_text)
	choices.Add("Random")
	if(!auto_add_antag)
		choices.Add("None")



/* MAP */

/datum/vote/mapswitch
	name = "mapswitch"
	var/status_quo = "Do not switch"
	var/list/map_options = list()

/datum/vote/mapswitch/Initialize()
	. = ..()

	if(!config.allow_map_switching)
		disabled = 1
		disable_reason = "disabled in config"

/datum/vote/mapswitch/initiate_vote(var/initiator_key, var/automatic = 0)
	choices = list()
	var/list/Lines = file2list("switchable_maps")

	if(!Lines)
		to_world("ERROR: unable to find \'switchable_maps\'")

	for(var/t in Lines)
		if(t)
			choices.Add(t)
	choices.Add(status_quo)
	reset_choices()

	. = ..()

/datum/vote/mapswitch/do_result()
	. = ..()

	var/new_map = .[1]
	if(new_map == status_quo)
		return

	to_world("<span class='danger'>>World restarting to \'[new_map]\' map due to mapswitch vote...</span>")
	feedback_set_details("end_error","map vote")
	log_game("Rebooting due to mapswitch vote")

	sleep(50)
	switch_maps(new_map)



/* CUSTOM */

/datum/vote/custom
	name = "custom"
	disabled = 1
	disable_reason = "Admin only"

/datum/vote/custom/get_announce_text(var/automatic, var/initiator)
	. = ..(automatic, initiator)
	. += "\n[question]"

/datum/vote/custom/update_question()
	question = sanitizeSafe(input(usr,"What is the vote for?") as text|null)
	if(!question)
		return 0

	for(var/i=1,i<=10,i++)
		var/option = capitalize(sanitize(input(usr,"Please enter an option or hit cancel to finish") as text|null))
		if(!option || !usr.client)	break
		choices.Add(option)

	if(choices.len)
		reset_choices()
	else
		question = null

	return choices.len > 0

/datum/vote/custom/reset()
	choices.Cut()
	choices_weights.Cut()

	. = ..()
