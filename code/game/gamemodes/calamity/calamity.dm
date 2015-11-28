#define ANTAG_TYPE_RATIO 8

/datum/game_mode/calamity
	name = "Calamity"
	round_description = "This must be a Thursday. You never could get the hang of Thursdays..."
	extended_round_description = "All Hell is about to break loose. Literally every antagonist type may spawn in this round. Hold on tight."
	config_tag = "calamity"
	required_players = 1
	votable = 0
	event_delay_mod_moderate = 0.5
	event_delay_mod_major = 0.75

/datum/game_mode/calamity/create_antagonists()
	var/list/antag_candidates = all_random_antag_types()

	var/grab_antags = round(num_players()/ANTAG_TYPE_RATIO)+1
	while(antag_candidates.len && antag_tags.len < grab_antags)
		var/antag_id = pick(antag_candidates)
		antag_candidates -= antag_id
		antag_tags |= antag_id

	..()

/datum/game_mode/calamity/check_victory()
	world << "<font size = 3><b>This terrible, terrible day has finally ended!</b></font>"

#undef ANTAG_TYPE_RATIO
