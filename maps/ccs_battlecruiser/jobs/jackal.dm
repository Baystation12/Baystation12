
/datum/job/opredflag_jackal
	title = "Kig-Yar"
	faction_flag = COVENANT
	supervisors = "the Elites"
	selection_color = "#9900ff"
	account_allowed = 0               // Does this job type come with a station account?
	outfit_type = /decl/hierarchy/outfit/kigyar
	loadout_allowed = FALSE            // Whether or not loadout equipment is allowed and to be created when joining.
	announced = TRUE                  //If their arrival is announced on radio
	generate_email = 0
	whitelisted_species = list(/datum/species/kig_yar)
	spawn_positions = -1
	total_positions = -1
	track_players = 1

/datum/job/opredflag_skirmisher
	title = "T-Voan Skirmisher"
	faction_flag = COVENANT
	supervisors = "the Elites"
	selection_color = "#9900ff"
	account_allowed = 0               // Does this job type come with a station account?
	outfit_type = /decl/hierarchy/outfit/skirmisher_minor
	loadout_allowed = FALSE            // Whether or not loadout equipment is allowed and to be created when joining.
	announced = TRUE                  //If their arrival is announced on radio
	generate_email = 0
	whitelisted_species = list(/datum/species/kig_yar_skirmisher)
	spawn_positions = -1
	track_players = 1

/datum/job/opredflag_skirmisher/major
	title = "T-Voan Skirmisher Major"
	outfit_type = /decl/hierarchy/outfit/skirmisher_major

/datum/job/opredflag_skirmisher/murmillo
	title = "T-Voan Skirmisher Murmillo"
	outfit_type = /decl/hierarchy/outfit/skirmisher_murmillo

/datum/job/opredflag_skirmisher/commando
	title = "T-Voan Skirmisher Commando"
	outfit_type = /decl/hierarchy/outfit/skirmisher_commando

/datum/job/opredflag_skirmisher/champion
	title = "T-Voan Skirmisher Champion"
	outfit_type = /decl/hierarchy/outfit/skirmisher_champion
