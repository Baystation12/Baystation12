
/datum/job/researcher
	title = "ONI Researcher"
	spawn_faction = "UNSC"
	supervisors = "the ONI Research Director"
	total_positions = 4
	spawn_positions = 4
	account_allowed = 1
	economic_modifier = 0.5
	outfit_type = /decl/hierarchy/outfit/job/facil_researcher
	alt_titles = list("Doctor","Physicist","Botanist","Chemist","Weapons Researcher","Surgeon","Geneticist")
	selection_color = "#008000"
	access = list(access_unsc,access_unsc_bridge,access_unsc_medical,access_unsc_armoury,access_unsc_supplies,access_unsc_oni,access_unsc_cargo)
	spawnpoint_override = "Research Facility Spawn"
	whitelisted_species = list(/datum/species/human)
	loadout_allowed = TRUE
	lace_access = TRUE

/datum/job/researchdirector
	title = "ONI Research Director"
	spawn_faction = "UNSC"
	supervisors = "the directors of ONI Section III"
	total_positions = 1
	spawn_positions = 1
	account_allowed = 1
	economic_modifier = 1
	outfit_type = /decl/hierarchy/outfit/job/researchdirector
	selection_color = "#008000"
	access = list(access_unsc,access_unsc_bridge,access_unsc_medical,access_unsc_armoury,access_unsc_supplies,access_unsc_oni,access_unsc_cargo)
	spawnpoint_override = "Research Facility Director Spawn"
	whitelisted_species = list(/datum/species/human)
	loadout_allowed = TRUE
	lace_access = TRUE

/datum/job/ONIGUARD
	title = "ONI Security Guard"
	spawn_faction = "UNSC"
	supervisors = "the ONI Security Commander"
	total_positions = 8
	spawn_positions = 4
	account_allowed = 1
	economic_modifier = 0.5
	outfit_type = /decl/hierarchy/outfit/job/facil_ONIGUARD
	selection_color = "#008000"
	access = list(310,311)
	spawnpoint_override = "Research Facility Security Spawn"
	whitelisted_species = list(/datum/species/human)
	loadout_allowed = TRUE
	lace_access = TRUE

/datum/job/ONIGUARDS
	title = "ONI Security Commander"
	spawn_faction = "UNSC"
	supervisors = "the ONI Research Director"
	total_positions = 1
	spawn_positions = 1
	account_allowed = 1
	economic_modifier = 0.5
	outfit_type = /decl/hierarchy/outfit/job/facil_ONIGUARDS
	selection_color = "#008000"
	access = list(310,311)
	spawnpoint_override = "Research Facility Security Spawn"
	whitelisted_species = list(/datum/species/human)
	loadout_allowed = TRUE
	lace_access = TRUE
