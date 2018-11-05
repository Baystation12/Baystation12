
/datum/job/opredflag_jackal
	title = "Kig'Yar"
	faction_flag = COVENANT
	supervisors = "the Elites"
	selection_color = "#9900ff"
	account_allowed = 0               // Does this job type come with a station account?
	outfit_type = /decl/hierarchy/outfit/kigyar
	loadout_allowed = TRUE            // Whether or not loadout equipment is allowed and to be created when joining.
	announced = TRUE                  //If their arrival is announced on radio
	generate_email = 0
	whitelisted_species = list(/datum/species/kig_yar)
	spawn_positions = -1
	track_players = 1
