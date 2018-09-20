/datum/job/UNSC_assault
	title = "ODST Assault Squad Member"
	total_positions = 40
	selection_color = "#000000"

	supervisors = "the ODST Assault Team Lead and the ODST Assault Squad Lead"

	create_record = 0
	account_allowed = 0
	generate_email = 0

	loadout_allowed = FALSE
	outfit_type = /decl/hierarchy/outfit/job/UNSC_Assault

	latejoin_at_spawnpoints = TRUE
	access = list(142,144,110,192,308,309)

/datum/job/UNSC_Squad_Lead
	title = "ODST Assault Squad Lead"
	head_position = 1
	total_positions = 4
	selection_color = "#000000"

	supervisors = "the ODST Assault Team Lead"

	create_record = 0
	account_allowed = 0
	generate_email = 0

	loadout_allowed = FALSE
	announced = FALSE
	outfit_type = /decl/hierarchy/outfit/job/UNSC_Assault

	latejoin_at_spawnpoints = TRUE
	access = list(142,144,110,192,308,309)

/datum/job/UNSC_Team_Lead
	title = "ODST Assault Team Lead"
	head_position = 1
	total_positions = 2
	selection_color = "#000000"

	create_record = 0
	account_allowed = 0
	generate_email = 0

	loadout_allowed = FALSE
	announced = FALSE
	outfit_type = /decl/hierarchy/outfit/job/UNSC_Assault

	latejoin_at_spawnpoints = TRUE
	access = list(142,143,144,145,110,192,300,306,308,309)
