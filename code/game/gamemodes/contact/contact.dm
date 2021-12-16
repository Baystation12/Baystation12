/datum/game_mode/contact
	name = "Contact"
	round_description = "Something is onboard!"
	extended_round_description = "The facility has been infiltrated by <b>something<b> beyond the knowledge of any race. Have fun dealing with it!"
	config_tag = "contact"

	required_players = 0 //6
	required_enemies = 0 //2
	end_on_antag_death = FALSE
	antag_tags = list(
		MODE_EXOPHAGE,
		MODE_RENEGADE
	)

	//Amp it up
	event_delay_mod_moderate = 0.5
	event_delay_mod_major = 0.3
