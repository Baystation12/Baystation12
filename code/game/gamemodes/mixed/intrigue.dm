/datum/game_mode/intrigue
	name = "Intrigue"
	round_description = "Crewmembers are contacted by external elements while another infiltrates the colony."
	extended_round_description = "Traitors and a ninja spawn during this round."
	config_tag = "intrigue"
	required_players = 15
	required_players_secret = 15
	required_enemies = 4
	end_on_antag_death = 0
	antag_tags = list(MODE_NINJA, MODE_AUTOTRAITOR)
	round_autoantag = 1
	require_all_templates = 1