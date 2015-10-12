/datum/game_mode/bughunt
	name = "Bughunt"
	round_description = "A mercenary strike force is approaching the station to eradicate a xenomorph infestation!"
	config_tag = "bughunt"
	required_players = 15
	required_enemies = 1
	end_on_antag_death = 1
	antag_tags = list(MODE_XENOMORPH, MODE_DEATHSQUAD)
	auto_recall_shuttle = 1
	ert_disabled = 1
	require_all_templates = 1
	votable = 0