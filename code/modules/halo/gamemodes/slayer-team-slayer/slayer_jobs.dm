
/datum/job/team_slayer_red
	title = "Red Team Spartan"
	latejoin_at_spawnpoints = 1
	create_record = 0
	account_allowed = 0
	generate_email = 0
	outfit_type = /decl/hierarchy/outfit/slayer/red
	total_positions = -1
	spawn_positions = -1
	track_players = 1
	selection_color = "#ff0000"

/datum/job/team_slayer_blue
	title = "Blue Team Spartan"
	latejoin_at_spawnpoints = 1
	create_record = 0
	account_allowed = 0
	generate_email = 0
	outfit_type = /decl/hierarchy/outfit/slayer/blue
	total_positions = -1
	spawn_positions = -1
	track_players = 1
	selection_color = "#0000ff"

/datum/job/slayer_ffa
	title = "Spartan Slayer"
	//latejoin_at_spawnpoints = 1
	create_record = 0
	account_allowed = 0
	generate_email = 0
	outfit_type = /decl/hierarchy/outfit/slayer
	total_positions = -1
	spawn_positions = -1
	track_players = 1
	selection_color = "#ffff00"

/datum/map/teamslayer_asteroid
	allowed_jobs = list(/datum/job/team_slayer_red, /datum/job/team_slayer_blue, /datum/job/slayer_ffa)
