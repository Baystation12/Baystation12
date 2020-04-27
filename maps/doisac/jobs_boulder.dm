
/datum/job/packwar_chieftain_boulder
	title = "Boulder Clan Chieftain"
	spawn_faction = "Covenant"
	supervisors = "the Gods themselves"
	selection_color = "#993300"
	account_allowed = 0
	outfit_type = /decl/hierarchy/outfit/jiralhanae_boulderclan/chieftain
	loadout_allowed = FALSE
	announced = FALSE
	generate_email = 0
	whitelisted_species = list(/datum/species/brutes)
	latejoin_at_spawnpoints = 1
	spawn_positions = 1
	total_positions = 1
	track_players = 1

/datum/job/packwar_chieftain_boulder/assign_player(var/datum/mind/new_mind)
	. = ..()
	if(istype(ticker.mode, /datum/game_mode/packwar))
		var/datum/game_mode/packwar/P = ticker.mode
		P.boulder_chief_mind = new_mind

/datum/job/packwar_captain_boulder
	title = "Boulder Clan Captain"
	spawn_faction = "Covenant"
	supervisors = "the Boulder Clan chieftain"
	selection_color = "#337700"
	account_allowed = 0
	outfit_type = /decl/hierarchy/outfit/jiralhanae_boulderclan/captain
	loadout_allowed = FALSE
	announced = FALSE
	generate_email = 0
	whitelisted_species = list(/datum/species/brutes)
	latejoin_at_spawnpoints = 1
	spawn_positions = 2
	total_positions = 2
	track_players = 1

/datum/job/packwar_major_boulder
	title = "Boulder Clan Major"
	spawn_faction = "Covenant"
	supervisors = "the Boulder Clan captains and chieftain"
	selection_color = "#993300"
	account_allowed = 0
	outfit_type = /decl/hierarchy/outfit/jiralhanae_boulderclan/major
	loadout_allowed = FALSE
	announced = FALSE
	generate_email = 0
	whitelisted_species = list(/datum/species/brutes)
	latejoin_at_spawnpoints = 1
	spawn_positions = 3
	total_positions = 3
	track_players = 1

/datum/job/packwar_minor_boulder
	title = "Boulder Clan Warrior"
	spawn_faction = "Covenant"
	supervisors = "the Boulder Clan majors, captains and chieftain"
	selection_color = "#993300"
	account_allowed = 0
	outfit_type = /decl/hierarchy/outfit/jiralhanae_boulderclan
	loadout_allowed = FALSE
	announced = FALSE
	generate_email = 0
	whitelisted_species = list(/datum/species/brutes)
	latejoin_at_spawnpoints = 1
	spawn_positions = -1
	total_positions = -1
	track_players = 1

/datum/job/packwar_thrall_boulder
	title = "Boulder Clan Unggoy Thrall"
	spawn_faction = "Covenant"
	supervisors = "everyone"
	selection_color = "#993300"
	account_allowed = 0               // Does this job type come with a station account?
	outfit_type = /decl/hierarchy/outfit/unggoy_thrall/boulderclan
	loadout_allowed = FALSE            // Whether or not loadout equipment is allowed and to be created when joining.
	announced = FALSE                  //If their arrival is announced on radio
	generate_email = 0
	whitelisted_species = list(/datum/species/unggoy)
	latejoin_at_spawnpoints = 1
	spawn_positions = -1
	total_positions = -1
	track_players = 1
