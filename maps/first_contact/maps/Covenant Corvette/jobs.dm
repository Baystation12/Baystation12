
/datum/job/covenant
	loadout_allowed = FALSE
	faction_flag = COVENANT
	spawn_faction = "Covenant"
	announced = 0
	create_record = 0

/datum/job/covenant/sangheili_shipmaster
	title = "Sangheili - Shipmaster"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/sangheili/shipmaster
	access = list(240,250)
	spawnpoint_override = "Covenant Base Spawns"
	is_whitelisted = 1

/datum/job/covenant/sangheili_ultra
	title = "Sangheili - Ultra"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/sangheili/ultra
	access = list(240,250)
	spawnpoint_override = "Covenant Base Spawns"
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/sangheili)

/datum/job/covenant/sangheili_major
	title = "Sangheili - Major"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/sangheili/major
	access = list(240,250)
	spawnpoint_override = "Covenant Base Spawns"
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/sangheili)

/datum/job/covenant/sangheili_minor
	title = "Sangheili - Minor"
	total_positions = 2
	spawn_positions = 1
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/sangheili/minor
	access = list(240,250)
	spawnpoint_override = "Covenant Base Spawns"
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/sangheili)

/datum/job/covenant/skirmminor
	title = "T-Voan - Minor"
	total_positions = 2
	spawn_positions = 2
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/skirmisher_minor
	access = list(240,250)
	spawnpoint_override = "Covenant Base Spawns"
	whitelisted_species = list(/datum/species/kig_yar_skirmisher)

/datum/job/covenant/skirmmajor
	title = "T-Voan - Major"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/skirmisher_major
	access = list(240,250)
	spawnpoint_override = "Covenant Base Spawns"
	whitelisted_species = list(/datum/species/kig_yar_skirmisher)

/datum/job/covenant/skirmmurmillo
	title = "T-Voan - Murmillo"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/skirmisher_murmillo
	access = list(240,250)
	spawnpoint_override = "Covenant Base Spawns"
	whitelisted_species = list(/datum/species/kig_yar_skirmisher)

/datum/job/covenant/skirmcommando
	title = "T-Voan - Commando"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/skirmisher_commando
	access = list(240,250)
	spawnpoint_override = "Covenant Base Spawns"
	whitelisted_species = list(/datum/species/kig_yar_skirmisher)

/datum/job/covenant/kigyarminor
	title = "Kig-Yar - Minor"
	total_positions = 12
	spawn_positions = 12
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/kigyarcorvette
	access = list(240,250)
	spawnpoint_override = "Covenant Base Spawns"
	whitelisted_species = list(/datum/species/kig_yar)

/datum/job/covenant/kigyarmajor
	title = "Kig-Yar - Major"
	total_positions = 3
	spawn_positions = 3
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/kigyarcorvette
	access = list(240,250)
	spawnpoint_override = "Covenant Base Spawns"
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/kig_yar)

/datum/job/covenant/kigyarcorvette/captain
	title = "Kig-Yar - Shipmistress"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/kigyarcorvette/captain
	access = list(240,250)
	spawnpoint_override = "Covenant Base Spawns"
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/kig_yar)

/datum/job/covenant/unggoy_minor
	title = "Unggoy - Minor"
	total_positions = 16
	spawn_positions = 16
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/unggoy
	access = list(230,250)
	spawnpoint_override = "Covenant Base Spawns"
	whitelisted_species = list(/datum/species/unggoy)

/datum/job/covenant/unggoy_major
	title = "Unggoy - Major"
	total_positions = 4
	spawn_positions = 4
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/unggoy/major
	access = list(230,250)
	spawnpoint_override = "Covenant Base Spawns"
	whitelisted_species = list(/datum/species/unggoy)