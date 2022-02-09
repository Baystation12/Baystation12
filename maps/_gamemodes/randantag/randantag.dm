
/datum/game_mode/randomantag
	name = "Spicy Extended"
	round_description = "It's extended; Act friendly, even when facing covenant forces, but keep an eye out; something, or someone, is acting abnormally!"
	extended_round_description = "A less instant-combat mode. Nomically set within post-war period to justify\
the peaceful(ish) relations between the unsc and covenant forces; but traitors and all sorts of unhappy\
folk will break said peace."
	config_tag = "spicyextended"
	votable = 1
	required_players = 0
	required_enemies = 0
	antag_tags = list()
	antag_scaling_coeff = 8
	end_on_antag_death = 0
	latejoin_antag_tags = list(MODE_TRAITOR,MODE_REVOLUTIONARY,MODE_CHANGELING)
