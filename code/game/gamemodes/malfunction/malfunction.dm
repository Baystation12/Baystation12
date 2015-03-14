/datum/game_mode/malfunction
	name = "AI malfunction"
	round_description = "The AI on the satellite has malfunctioned and must be destroyed."
	extended_round_description = "The AI will attempt to hack the APCs around the station in order to speed up its ability to take over all systems and activate the station self-destruct. The AI core is heavily protected by turrets and reinforced walls."
	uplink_welcome = "Crazy AI Uplink Console:"
	config_tag = "malfunction"
	required_players = 2
	required_players_secret = 15
	required_enemies = 1
	end_on_antag_death = 1
	auto_recall_shuttle = 1
	antag_tag = MODE_MALFUNCTION


/datum/game_mode/malfunction/process()
	malf.tick()


/datum/game_mode/malfunction/check_finished()
	if (malf.station_captured && !malf.can_nuke)
		return 1
	for(var/datum/antagonist/antag in antag_templates)
		if(antag && !antag.antags_are_dead())
			return ..()
	malf.revealed = 0
	return ..() //check for shuttle and nuke

