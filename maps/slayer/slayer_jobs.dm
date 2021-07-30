
/datum/job/team_slayer_red
	title = "Red Team Spartan"
	latejoin_at_spawnpoints = 1
	create_record = 0
	account_allowed = 0
	generate_email = 0
	outfit_type = /decl/hierarchy/outfit/spartan_two/red_team
	total_positions = -1
	spawn_positions = -1
	track_players = 1
	selection_color = "#ff0000"
	whitelisted_species = list(/datum/species/spartan)

/datum/job/team_slayer_blue
	title = "Blue Team Spartan"
	latejoin_at_spawnpoints = 1
	create_record = 0
	account_allowed = 0
	generate_email = 0
	outfit_type = /decl/hierarchy/outfit/spartan_two/blue_team
	total_positions = -1
	spawn_positions = -1
	track_players = 1
	selection_color = "#0000ff"
	whitelisted_species = list(/datum/species/spartan)

/datum/job/slayer_ffa
	title = "Spartan Slayer"
	create_record = 0
	account_allowed = 0
	generate_email = 0
	outfit_type = /decl/hierarchy/outfit/spartan_two/red_team
	total_positions = -1
	spawn_positions = -1
	track_players = 1
	selection_color = "#66ff00"
	whitelisted_species = list(/datum/species/spartan)

/datum/job/team_slayer_covenant
	title = "Team Elites"
	create_record = 0
	account_allowed = 0
	generate_email = 0
	outfit_type = /decl/hierarchy/outfit/sangheili/ultra/slayer
	total_positions = -1
	spawn_positions = -1
	track_players = 1
	selection_color = "#6600dd"
	whitelisted_species = list(/datum/species/sangheili)

/datum/job/team_slayer_spartan
	title = "Team Spartans"
	create_record = 0
	account_allowed = 0
	generate_email = 0
	outfit_type = /decl/hierarchy/outfit/spartan_two/red_team
	total_positions = -1
	spawn_positions = -1
	track_players = 1
	selection_color = "#334400"
	whitelisted_species = list(/datum/species/spartan)

/datum/map/teamslayer_asteroid
	allowed_jobs = list(/datum/job/team_slayer_red, /datum/job/team_slayer_blue, /datum/job/slayer_ffa,/datum/job/team_slayer_spartan,/datum/job/team_slayer_covenant)
