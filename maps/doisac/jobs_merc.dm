


/*
Clanless runt
*/
/datum/job/packwar_runt
	title = "clanless Jiralhanae"
	spawn_faction = "Covenant"
	supervisors = "whoever is strongest, or whoever feeds and pays you"
	selection_color = "#888888"
	account_allowed = 0
	outfit_type = /decl/hierarchy/outfit/jiralhanae
	loadout_allowed = FALSE
	announced = FALSE
	generate_email = 0
	whitelisted_species = list(/datum/species/brutes)
	spawn_positions = -1
	total_positions = -1
	track_players = 1
	latejoin_at_spawnpoints = 1



/*
Mercenaries
*/

/datum/job/packwar_merc
	var/current_merc_price = 0
	var/available_hires = 0
	latejoin_at_spawnpoints = 1
	var/spawn_controller_type = /obj/effect/landmark/mercspawn/boulder
	var/obj/effect/landmark/mercspawn/spawn_controller

/datum/job/packwar_merc/New()
	. = ..()
	spawn_controller = locate(spawn_controller_type) in world

/datum/job/packwar_merc/assign_player(var/datum/mind/new_mind)
	. = ..()
	if(spawn_controller)
		spawn_controller.merc_has_spawned()

/*
Skirmisher Mercenaries
*/

/datum/job/packwar_merc/skirmisher
	title = "Boulder Clan Mercenary - T-Vaoan Murmillo"
	supervisors = "Boulder Clan Captains and the Chieftain"
	selection_color = "#993300"
	outfit_type = /decl/hierarchy/outfit/skirmisher_murmillo/merc_boulder

	spawn_faction = "Covenant"
	account_allowed = 0
	loadout_allowed = FALSE
	announced = FALSE
	generate_email = 0
	whitelisted_species = list(/datum/species/kig_yar_skirmisher)
	spawn_positions = 0
	total_positions = 0
	track_players = 1

	current_merc_price = 300

/datum/job/packwar_merc/skirmisher/ram
	title = "Ram Clan Mercenary - T-Vaoan Murmillo"
	supervisors = "Ram Clan Captains and the Chieftain"
	selection_color = "#337700"
	spawn_controller_type = /obj/effect/landmark/mercspawn/ram
	outfit_type = /decl/hierarchy/outfit/skirmisher_murmillo/merc_ram

/datum/job/packwar_merc/skirmisher/champion
	title = "Boulder Clan Mercenary - T-Vaoan Champion"
	supervisors = "Boulder Clan Captains and the Chieftain"
	selection_color = "#993300"
	outfit_type = /decl/hierarchy/outfit/skirmisher_champion/merc_boulder

	current_merc_price = 400

/datum/job/packwar_merc/skirmisher/champion/ram
	title = "Ram Clan Mercenary - T-Vaoan Champion"
	supervisors = "Ram Clan Captains and the Chieftain"
	selection_color = "#337700"
	spawn_controller_type = /obj/effect/landmark/mercspawn/ram
	outfit_type = /decl/hierarchy/outfit/skirmisher_champion/merc_ram



/*
Jackal Mercenaries
*/

/datum/job/packwar_merc/jackal
	title = "Boulder Clan Mercenary - Ruutian Defender"
	supervisors = "Boulder Clan Captains and the Chieftain"
	selection_color = "#993300"
	outfit_type = /decl/hierarchy/outfit/kigyar/merc_boulder

	spawn_faction = "Covenant"
	account_allowed = 0
	loadout_allowed = FALSE
	announced = FALSE
	generate_email = 0
	whitelisted_species = list(/datum/species/kig_yar)
	spawn_positions = 0
	total_positions = 0
	track_players = 1

	current_merc_price = 100

/datum/job/packwar_merc/jackal/ram
	title = "Ram Clan Mercenary - Ruutian Defender"
	supervisors = "Ram Clan Captains and the Chieftain"
	selection_color = "#337700"
	spawn_controller_type = /obj/effect/landmark/mercspawn/ram
	outfit_type = /decl/hierarchy/outfit/kigyar/merc_ram

/datum/job/packwar_merc/jackal/sniper
	title = "Boulder Clan Mercenary - Ruutian Sniper"
	supervisors = "Boulder Clan Captains and the Chieftain"
	selection_color = "#993300"
	outfit_type = /decl/hierarchy/outfit/kigyar/marksman_beamrifle/merc_boulder

	current_merc_price = 200

/datum/job/packwar_merc/jackal/sniper/ram
	title = "Ram Clan Mercenary - Ruutian Sniper"
	supervisors = "Ram Clan Captains and the Chieftain"
	selection_color = "#337700"
	outfit_type = /decl/hierarchy/outfit/kigyar/marksman_beamrifle/merc_ram
	spawn_controller_type = /obj/effect/landmark/mercspawn/ram
