/datum/game_mode/infestation
	name = "Borer, Changeling & Xenophage"
	round_description = "There's something in the walls!"
	extended_round_description = "Two alien antagonists (Xenophages, Cortical Borers or Changelings) may spawn during this round."
	config_tag = "infestation"
	required_players = 15
	required_enemies = 5
	end_on_antag_death = 0
	antag_tags = list(MODE_BORER, MODE_XENOMORPH, MODE_CHANGELING)
	require_all_templates = 1
	votable = 0

/datum/game_mode/infestation/create_antagonists()
	// Two of the three.
	antag_tags -= pick(antag_tags)
	..()
