/datum/game_mode/intrigue
	name = "Ninja & Traitor"
	extended_round_description = "Traitors and a ninja spawn during this round."
	config_tag = "intrigue"
	required_players = 15
	required_enemies = 4
	end_on_antag_death = 0
	antag_tags = list(MODE_NINJA, MODE_TRAITOR)
	require_all_templates = 1
	latejoin_antag_tags = list(MODE_TRAITOR)

/datum/game_mode/intrigue/New()
	..()
	round_description = "Crewmembers are contacted by external elements while another infiltrates \the [station_name()]."
