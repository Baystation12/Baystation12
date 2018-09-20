
/datum/job/Insurrectionist
	title = "Insurrectionist"
	total_positions = 46
	spawnpoint_override = "Insurrectionist"
	selection_color = "#000000"
	faction_flag = INNIE
	supervisors = " the Insurrectionist Leader"
	announced = FALSE
	create_record = 0
	account_allowed = 1
	generate_email = 0

	loadout_allowed = TRUE
	outfit_type = /decl/hierarchy/outfit/job/Insurrectionist

	latejoin_at_spawnpoints = TRUE
	alt_titles = list("Insurrectionist Pilot","Insurrectionist Machine Gunner","Insurrectionist Engineer","Insurrectionist Sharpshooter")

/datum/job/Insurrectionist_leader
	title = "Insurrectionist Leader"
	total_positions = 1
	spawnpoint_override = "Insurrectionist Leader"
	selection_color = "#000000"
	faction_flag = INNIE
	supervisors = " the Insurrection"
	announced = FALSE
	create_record = 0
	account_allowed = 1
	generate_email = 0

	loadout_allowed = TRUE
	outfit_type = /decl/hierarchy/outfit/job/Insurrectionist_leader

	latejoin_at_spawnpoints = TRUE