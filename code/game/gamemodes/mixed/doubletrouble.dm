/datum/game_mode/doubletrouble
	name = "Mercenary & Autotraitor"
	round_description = "An unidentified strike team is en route; meanwhile, unrelated traitorous forces are at play."
	extended_round_description = "Mercenaries and traitors both spawn in this mode."
	config_tag = "doubletrouble"
	required_players = 15
	required_enemies = 5
	end_on_antag_death = FALSE
	antag_tags = list(MODE_MERCENARY, MODE_TRAITOR)
	require_all_templates = TRUE
	latejoin_antag_tags = list(MODE_TRAITOR)