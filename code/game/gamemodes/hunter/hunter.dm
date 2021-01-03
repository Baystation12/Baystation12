/datum/game_mode/hunter
	name = "Hunter"
	round_description = "A bounty hunter team is trying to claim a target from the crew!"
	extended_round_description = "todo"
	config_tag = "hunter"
	required_players = 1
	required_enemies = 1
	end_on_antag_death = FALSE
	antag_tags = list(MODE_HUNTER, MODE_HUNTER_TARGET)
	require_all_templates = TRUE
	votable = TRUE

/datum/game_mode/hunter/declare_completion()
	return GLOB.hunters.declare_completion()
