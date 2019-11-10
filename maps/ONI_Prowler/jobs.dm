/datum/job/ONI_Spartan_II
	title = "Spartan II"
	spawn_faction = "UNSC"
	outfit_type = /decl/hierarchy/outfit/onispartan
	total_positions = 1
	spawn_positions = 1
	account_allowed = 0
	is_whitelisted = 1
	selection_color = "#0A0A95"
	access = list(access_unsc,144,145,110,192,310,311,117,access_unsc_bridge,access_unsc_shuttles,access_unsc_armoury,access_unsc_supplies,access_unsc_officers,access_unsc_marine)
	//spawnpoint_override = "ONI Aegis Spawns"
	whitelisted_species = list(/datum/species/spartan)
	latejoin_at_spawnpoints = 1
	loadout_allowed = TRUE
	lace_access = TRUE

/datum/job/ONI_Spartan_II/equip()
	. = ..()
	var/player_pop = 0
	for(var/client/C in GLOB.clients)
		if(!C.mob)
			continue
		player_pop++
	var/datum/job/to_modify = job_master.occupations_by_title[title]
	to_modify.total_positions = min(round(player_pop/10),3)

/datum/job/ONI_Spartan_II_Commander
	title = "Spartan II Commander"
	spawn_faction = "UNSC"
	outfit_type = /decl/hierarchy/outfit/onispartan
	total_positions = 1
	spawn_positions = 1
	account_allowed = 0
	is_whitelisted = 1
	selection_color = "#0A0A95"
	access = list(access_unsc,144,145,110,192,310,311,117,access_unsc_bridge,access_unsc_shuttles,access_unsc_armoury,access_unsc_supplies,access_unsc_officers,access_unsc_marine)
	//spawnpoint_override = "ONI Aegis Spawns"
	whitelisted_species = list(/datum/species/spartan)
	latejoin_at_spawnpoints = 1
	loadout_allowed = TRUE
	lace_access = TRUE

/datum/job/ONI_Spartan_II_Commander/equip()
	. = ..()
	var/player_pop = 0
	for(var/client/C in GLOB.clients)
		if(!C.mob)
			continue
		player_pop++
	var/datum/job/to_modify = job_master.occupations_by_title["Spartan II"]
	to_modify.total_positions = min(round(player_pop/10),3)