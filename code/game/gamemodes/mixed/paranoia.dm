/datum/game_mode/paranoia
	name = "paranoia"
	round_description = "The AI has malfunctioned, and subversive elements infest the crew..."
	extended_round_description = "Rampant AIs, renegades and changelings spawn in this mode."
	config_tag = "paranoia"
	required_players = 2
	required_players_secret = 7
	required_enemies = 1
	end_on_antag_death = 1
	require_all_templates = 1
	votable = 0
	antag_tags = list(MODE_MALFUNCTION, MODE_RENEGADE, MODE_CHANGELING)
