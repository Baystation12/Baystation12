
/datum/job/covenant
	loadout_allowed = FALSE

/datum/job/covenant/sangheili_ultra
	title = "Sangheili - Ultra"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/sangheilicorvette/sangheili_ultra
	access = list(240,250)
	spawnpoint_override = "Sangheili Corvette Spawn"
	faction_whitelist = "Covenant"

/datum/job/covenant/sangheili_major
	title = "Sangheili - Major"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/sangheilicorvette/sangheili_major
	access = list(240,250)
	spawnpoint_override = "Sangheili Corvette Spawn"
	faction_whitelist = "Covenant"

/datum/job/covenant/sangheili_minor
	title = "Sangheili - Minor"
	total_positions = 2
	spawn_positions = 1
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/sangheilicorvette/sangheili_minor
	access = list(240,250)
	spawnpoint_override = "Sangheili Corvette Spawn"
	faction_whitelist = "Covenant"

/datum/job/covenant/skirmminor
	title = "T-Voan - Minor"
	total_positions = 2
	spawn_positions = 2
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/skirmisher_minor
	access = list(240,250)
	spawnpoint_override = "Kig-Yar Corvette Spawn"
	whitelisted_species = list(/datum/species/kig_yar_skirmisher)

/datum/job/covenant/skirmmajor
	title = "T-Voan - Major"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/skirmisher_major
	access = list(240,250)
	spawnpoint_override = "Kig-Yar Corvette Spawn"
	whitelisted_species = list(/datum/species/kig_yar_skirmisher)

/datum/job/covenant/skirmmurmillo
	title = "T-Voan - Murmillo"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/skirmisher_murmillo
	access = list(240,250)
	spawnpoint_override = "Kig-Yar Corvette Spawn"
	whitelisted_species = list(/datum/species/kig_yar_skirmisher)

/datum/job/covenant/skirmcommando
	title = "T-Voan - Commando"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/skirmisher_commando
	access = list(240,250)
	spawnpoint_override = "Kig-Yar Corvette Spawn"
	whitelisted_species = list(/datum/species/kig_yar_skirmisher)

/datum/job/covenant/kigyarminor
	title = "Kig-Yar - Minor"
	total_positions = 12
	spawn_positions = 12
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/kigyarcorvette
	access = list(240,250)
	spawnpoint_override = "Kig-Yar Corvette Spawn"

/datum/job/covenant/kigyarmajor
	title = "Kig-Yar - Major"
	total_positions = 3
	spawn_positions = 3
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/kigyarcorvette
	access = list(240,250)
	spawnpoint_override = "Kig-Yar Corvette Spawn"
	faction_whitelist = "Covenant"


/datum/job/covenant/kigyarcorvette/captain
	title = "Kig-Yar - Shipmistress"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/kigyarcorvette/captain
	access = list(240,250)
	spawnpoint_override = "Kig-Yar Corvette Spawn"
	faction_whitelist = "Covenant"

/datum/job/covenant/unggoy_minor
	title = "Unggoy - Minor"
	total_positions = 16
	spawn_positions = 16
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/unggoycorvette/minor
	access = list(230,250)
	spawnpoint_override = "Unggoy Corvette Spawn"

/datum/job/covenant/unggoy_major
	title = "Unggoy - Major"
	total_positions = 4
	spawn_positions = 4
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/unggoycorvette/major
	access = list(230,250)
	spawnpoint_override = "Unggoy Corvette Spawn"
