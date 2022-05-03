/datum/game_mode/pirates
	name = "Raiding Party"
	round_description = "Prepare yourself! An unknown ship is approaching!"
	config_tag = "voxraiders"
	required_players = 15
	required_enemies = 3
	end_on_antag_death = FALSE
	antag_tags = list(MODE_VOXRAIDER, MODE_RAIDER)
	require_all_templates = TRUE

/datum/game_mode/pirates/pre_setup()

	var/datum/antagonist/raiders = antag_templates[2]
	raiders.build_candidate_list(src)

	var/datum/antagonist/vox/vox = antag_templates[1]
	vox.build_candidate_list(src)
	log_debug("Attempting to start Raiding Party gamemode with [vox.candidates.len] whitelisted candidates")
	if (vox.candidates.len >= required_enemies)
		vox.get_starting_locations()
		vox.attempt_spawn()
		antag_templates = list(vox)
	else
		raiders.attempt_spawn()
		antag_templates = list(raiders)

/datum/game_mode/pirates/check_startable(list/lobby_players)
	var/list/ready_players = SSticker.ready_players(lobby_players)
	if (ready_players.len < required_players)
		return "Not enough players. [ready_players.len] ready of the required [required_players]."
	var/list/all_antag_types = GLOB.all_antag_types_
	if(antag_tags?.len)
		var/datum/antagonist/vox/antag_vox = all_antag_types[antag_tags[1]]
		var/list/enemies_vox = antag_vox.pending_antagonists
		if((enemies_vox.len >= required_enemies))
			return FALSE
		var/datum/antagonist/antag_raiders = all_antag_types[antag_tags[2]]
		var/list/enemies_raiders = antag_raiders.pending_antagonists
		if(enemies_raiders.len >= required_enemies)
			return FALSE
		return "Not enough antagonists, [required_enemies] required and [max(enemies_vox.len, enemies_raiders.len)] available."
	else
		return FALSE