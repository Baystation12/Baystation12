
/datum/job/opredflag_cov/elite
	title = "Sangheili Minor"
	faction_flag = COVENANT
	supervisors = "the Sangheili Majors"
	selection_color = "#9900ff"
	account_allowed = 0               // Does this job type come with a station account?
	outfit_type = /decl/hierarchy/outfit/sangheili/minor
	loadout_allowed = FALSE            // Whether or not loadout equipment is allowed and to be created when joining.
	announced = TRUE                  //If their arrival is announced on radio
	generate_email = 0
	whitelisted_species = list(/datum/species/sangheili)
	total_positions = 10
	spawn_positions = 10
	track_players = 1

/datum/job/opredflag_cov/elite/major
	title = "Sangheili Major"
	supervisors = "the Shipmaster"
	outfit_type = /decl/hierarchy/outfit/sangheili/major
	open_slot_on_death = 1
	total_positions = 4
	spawn_positions = 4

/datum/job/opredflag_cov/elite/ultra
	title = "Sangheili Ultra"
	supervisors = "the Shipmaster"
	outfit_type = /decl/hierarchy/outfit/sangheili/ultra
	open_slot_on_death = 1
	total_positions = 2
	spawn_positions = 2

/datum/job/opredflag_cov/elite/shipmaster
	title = "Sangheili Shipmaster"
	supervisors = "the Prophets"
	outfit_type = /decl/hierarchy/outfit/sangheili/zealot
	total_positions = 1
	spawn_positions = 1

/datum/job/opredflag_cov/elite/zealot
	title = "Sangheili Zealot"
	supervisors = "the Prophets"
	outfit_type = /decl/hierarchy/outfit/sangheili/zealot
	open_slot_on_death = 1
	total_positions = 2
	spawn_positions = 2

/datum/job/opredflag_cov/elite/ranger
	title = "Sangheili Ranger"
	supervisors = "the Majors"
	outfit_type = /decl/hierarchy/outfit/sangheili/eva
	open_slot_on_death = 1
	total_positions = 3
	spawn_positions = 3

/datum/job/opredflag_cov/elite/specops
	title = "Special Operations Sangheili"
	supervisors = "the Shipmaster"
	outfit_type = /decl/hierarchy/outfit/sangheili/specops
	open_slot_on_death = 1
	spawn_positions = 1
