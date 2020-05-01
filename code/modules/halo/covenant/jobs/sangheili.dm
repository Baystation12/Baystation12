
/datum/job/covenant/sangheili_shipmaster
	title = "Sangheili Shipmaster"
	total_positions = 1
	spawn_positions = 1
	track_players = 1
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/sangheili/shipmaster
	access = list(240,250)
	is_whitelisted = 1
	whitelisted_species = list(/datum/species/sangheili)
	access = list(access_covenant, access_covenant_command)

/datum/job/covenant/sangheili_ultra
	title = "Sangheili Ultra"
	department_flag = COM
	total_positions = 1
	spawn_positions = 1
	is_whitelisted = 1
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/sangheili/ultra
	access = list(240,250)
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/sangheili)
	access = list(access_covenant, access_covenant_command)

/datum/job/covenant/sangheili_honour_guard
	title = "Sangheili Honour Guard"
	total_positions = 0
	spawn_positions = 1
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/sangheili/honour_guard
	access = list(240,250)
	is_whitelisted = 1
	whitelisted_species = list(/datum/species/sangheili)

/datum/job/covenant/sangheili_major
	title = "Sangheili Major"
	total_positions = 2
	spawn_positions = 2
	open_slot_on_death = 1
	is_whitelisted = 1
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/sangheili/major
	access = list(240,250)
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/sangheili)
	access = list(access_covenant, access_covenant_command)

/datum/job/covenant/sangheili_minor
	title = "Sangheili Minor"
	total_positions = 4
	spawn_positions = 4
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/sangheili/minor
	access = list(240,250)
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/sangheili)



/* Not available during standard play */

/datum/job/covenant/sangheili_ranger
	title = "Sangheili Ranger"
	supervisors = "the Majors"
	outfit_type = /decl/hierarchy/outfit/sangheili/eva
	access = list(access_covenant)
	is_whitelisted = 1
	total_positions = 1
	spawn_positions = 1
	whitelisted_species = list(/datum/species/sangheili)

/datum/job/covenant/sangheili_specops
	title = "Special Operations Sangheili"
	supervisors = "the Shipmaster"
	outfit_type = /decl/hierarchy/outfit/sangheili/specops
	access = list(access_covenant)
	is_whitelisted = 1
	spawn_positions = 0
	total_positions = 0
	whitelisted_species = list(/datum/species/sangheili)

/datum/job/covenant/sangheili_zealot
	title = "Sangheili Zealot"
	total_positions = 0
	spawn_positions = 0
	is_whitelisted = 1
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/sangheili/zealot
	whitelisted_species = list(/datum/species/sangheili)
	access = list(access_covenant, access_covenant_command)
