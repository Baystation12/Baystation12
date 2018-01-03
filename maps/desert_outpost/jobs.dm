
/datum/map/desert_outpost
	allowed_jobs = list(/datum/job/stranded_unsc_marine, /datum/job/stranded_unsc_tech, /datum/job/stranded_unsc_medic, /datum/job/stranded_unsc_crew, /datum/job/stranded_unsc_civ)

	allowed_spawns = list("Crash Site")

	default_spawn = "Crash Site"

/datum/map/crashsite_zeta
	allowed_jobs = list(/datum/job/stranded_unsc_marine, /datum/job/stranded_unsc_tech, /datum/job/stranded_unsc_medic, /datum/job/stranded_unsc_crew, /datum/job/stranded_unsc_civ)

	allowed_spawns = list("Crash Site")

	default_spawn = "Crash Site"

/datum/job/stranded_unsc_marine
	title = "UNSC marine survivor"
	outfit_type = /decl/hierarchy/outfit/job/stranded_unsc/marine
	latejoin_at_spawnpoints = 0
	create_record = 0
	account_allowed = 0
	generate_email = 0
	total_positions = -1
	spawn_positions = -1
	track_players = 1
	selection_color = "#667700"
	spawn_faction = "UNSC"

/datum/job/stranded_unsc_tech
	title = "UNSC technician survivor"
	outfit_type = /decl/hierarchy/outfit/job/stranded_unsc/tech
	latejoin_at_spawnpoints = 0
	create_record = 0
	account_allowed = 0
	generate_email = 0
	total_positions = -1
	spawn_positions = -1
	track_players = 1
	selection_color = "#ff8800"
	spawn_faction = "UNSC"

/datum/job/stranded_unsc_medic
	title = "UNSC corpsman survivor"
	outfit_type = /decl/hierarchy/outfit/job/stranded_unsc/medic
	latejoin_at_spawnpoints = 0
	create_record = 0
	account_allowed = 0
	generate_email = 0
	total_positions = -1
	spawn_positions = -1
	track_players = 1
	selection_color = "#3300ff"
	spawn_faction = "UNSC"

/datum/job/stranded_unsc_crew
	title = "UNSC crewman survivor"
	outfit_type = /decl/hierarchy/outfit/job/stranded_unsc/crew
	latejoin_at_spawnpoints = 0
	create_record = 0
	account_allowed = 0
	generate_email = 0
	total_positions = -1
	spawn_positions = -1
	track_players = 1
	selection_color = "#996600"
	spawn_faction = "UNSC"

/datum/job/stranded_unsc_civ
	title = "UEG colonist survivor"
	outfit_type = /decl/hierarchy/outfit/job/stranded_unsc/civ
	latejoin_at_spawnpoints = 0
	create_record = 0
	account_allowed = 0
	generate_email = 0
	total_positions = -1
	spawn_positions = -1
	track_players = 1
	selection_color = "#00aa00"
	spawn_faction = "UNSC"
