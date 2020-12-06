/datum/game_mode/bughunt
	name = "Deathsquad & Xenophage"
	round_description = "A mercenary strike force is approaching to eradicate a xenomorph infestation!"
	extended_round_description = "Mercenaries and xenomorphs spawn in this game mode."
	config_tag = "bughunt"
	required_players = 15
	required_enemies = 1
	end_on_antag_death = FALSE
	antag_tags = list(MODE_XENOMORPH, MODE_DEATHSQUAD)
	require_all_templates = TRUE
	votable = FALSE
	auto_recall_shuttle = TRUE
	ert_disabled = TRUE
