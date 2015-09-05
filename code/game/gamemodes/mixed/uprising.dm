/datum/game_mode/uprising
	name = "uprising"
	config_tag = "uprising"
	round_description = "Some crewmembers are attempting to start a revolution while a cult plots in the shadows!"
	extended_round_description = "Cultists and revolutionaries spawn in this round."
	required_players = 15
	required_players_secret = 15
	required_enemies = 3
	end_on_antag_death = 1
	antag_tags = list(MODE_REVOLUTIONARY, MODE_LOYALIST, MODE_CULTIST)
	require_all_templates = 1
	votable = 0