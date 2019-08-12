
/datum/job/researcher
	title = "ONI Researcher"
	supervisors = "the ONI Research Director"
	total_positions = 2
	spawn_positions = 2
	outfit_type = /decl/hierarchy/outfit/job/facil_researcher
	alt_titles = list("Doctor","Physicist","Botanist","Chemist","Weapons Researcher","Surgeon","Geneticist")
	selection_color = "#008000"
	access = list(310,311)
	spawnpoint_override = "Research Facility Spawn"
	whitelisted_species = list(/datum/species/human)
	loadout_allowed = TRUE

/datum/job/researchdirector
	title = "ONI Research Director"
	supervisors = "the directors of ONI Section III"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/researchdirector
	selection_color = "#008000"
	access = list(310,311)
	spawnpoint_override = "Research Facility Director Spawn"
	whitelisted_species = list(/datum/species/human)
	loadout_allowed = TRUE


/datum/job/ONIGUARD
	title = "ONI Security Guard"
	supervisors = "the ONI Security Commander"
	total_positions = 8
	spawn_positions = 3
	outfit_type = /decl/hierarchy/outfit/job/facil_ONIGUARD
	selection_color = "#008000"
	access = list(311)
	spawnpoint_override = "Research Facility Security Spawn"
	whitelisted_species = list(/datum/species/human)
	loadout_allowed = TRUE

/datum/job/ONIGUARDS
	title = "ONI Security Commander"
	supervisors = "the ONI Research Director"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/facil_ONIGUARDS
	selection_color = "#008000"
	access = list(311)
	spawnpoint_override = "Research Facility Security Spawn"
	whitelisted_species = list(/datum/species/human)
	loadout_allowed = TRUE
