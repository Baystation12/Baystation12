
/datum/job/covenant/skirmminor
	title = "T-Vaoan Skirmisher"
	total_positions = -1
	spawn_positions = -1
	outfit_type = /decl/hierarchy/outfit/skirmisher_minor
	access = list(access_covenant)
	whitelisted_species = list(/datum/species/kig_yar_skirmisher)

/datum/job/covenant/skirmmajor
	title = "T-Vaoan Major"
	total_positions = 2
	spawn_positions = 2
	faction_whitelist = "Covenant"
	outfit_type = /decl/hierarchy/outfit/skirmisher_major
	access = list(access_covenant, access_covenant_command)
	whitelisted_species = list(/datum/species/kig_yar_skirmisher)

/datum/job/covenant/skirmmurmillo
	title = "T-Vaoan Murmillo"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/skirmisher_murmillo
	access = list(access_covenant, access_covenant_command, access_covenant_slipspace)
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/kig_yar_skirmisher)

/datum/job/covenant/skirmcommando
	title = "T-Vaoan Commando"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/skirmisher_commando
	access = list(access_covenant, access_covenant_command, access_covenant_slipspace)
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/kig_yar_skirmisher)

/datum/job/covenant/skirmchampion
	title = "T-Vaoan Champion"
	total_positions = 0
	spawn_positions = 0
	outfit_type = /decl/hierarchy/outfit/skirmisher_champion
	access = list(access_covenant, access_covenant_command, access_covenant_slipspace)
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/kig_yar_skirmisher)
