/datum/job/UNSC_assault
	title = "ODST Assault Squad Member"
	total_positions = 10
	spawn_positions = 10
	selection_color = "#000000"

	supervisors = "the Squad Leader and Commander"

	outfit_type = /decl/hierarchy/outfit/job/unsc/odst/e5
	whitelisted_species = list(/datum/species/human)

	latejoin_at_spawnpoints = TRUE
	access = list(142,144,110,192,308,309)

/datum/job/UNSC_assault/squad_leader
	title = "ODST Assault Squad Leader"
	head_position = 1
	total_positions = 2
	spawn_positions = 2
	selection_color = "#000000"
	outfit_type = /decl/hierarchy/outfit/job/unsc/odst

	supervisors = "the Commander"

/datum/job/UNSC_assault/commander
	title = "ODST Assault Commander"
	head_position = 1
	total_positions = 1
	spawn_positions = 1
	department_flag = COM
	outfit_type = /decl/hierarchy/outfit/job/unsc/odst/e8

	supervisors = "UNSC HIGHCOM"

	access = list(142,143,144,145,110,192,300,306,308,309)
