
/datum/job/Insurrectionist
	title = "Insurrectionist"
	total_positions = -1
	spawn_positions = -1
	selection_color = "#000000"
	spawn_faction = "Insurrection"
	supervisors = " the Insurrectionist Leader"
	announced = FALSE
	create_record = 0
	account_allowed = 1
	generate_email = 0

	loadout_allowed = TRUE
	outfit_type = /decl/hierarchy/outfit/job/Insurrectionist
	whitelisted_species = list(/datum/species/human)

	latejoin_at_spawnpoints = TRUE
	alt_titles = list("Insurrectionist Pilot","Insurrectionist Machine Gunner","Insurrectionist Engineer","Insurrectionist Sharpshooter")

/datum/job/Insurrectionist_leader
	title = "Insurrectionist Leader"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#000000"
	spawn_faction = "Insurrection"
	supervisors = " the Insurrection"
	announced = FALSE
	create_record = 0
	account_allowed = 1
	generate_email = 0

	loadout_allowed = TRUE
	outfit_type = /decl/hierarchy/outfit/job/Insurrectionist_leader
	whitelisted_species = list(/datum/species/human)

	latejoin_at_spawnpoints = TRUE