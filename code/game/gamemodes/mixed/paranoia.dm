/datum/game_mode/paranoia
	name = "Changeling, Malf & Renegade"
	round_description = "The AI has malfunctioned, and subversive elements infest the crew..."
	extended_round_description = "Rampant AIs, renegades and changelings spawn in this mode."
	config_tag = "paranoia"
	required_players = 15
	required_enemies = 1
	end_on_antag_death = 0
	antag_tags = list(MODE_MALFUNCTION, MODE_RENEGADE, MODE_CHANGELING)
	require_all_templates = 1
	votable = 0
