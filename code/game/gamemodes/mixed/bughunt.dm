/datum/game_mode/bughunt
	name = "Deathsquad & Xenomorph"
	round_description = "A mercenary strike force is approaching to eradicate a xenomorph infestation!"
	extended_round_description = "Mercenaries and xenomorphs spawn in this game mode."
	config_tag = "bughunt"
	required_players = 15
	required_enemies = 1
	end_on_antag_death = 0
	antag_tags = list(MODE_XENOMORPH, MODE_DEATHSQUAD)
	require_all_templates = 1
	votable = 0
	auto_recall_shuttle = 1
	ert_disabled = 1
