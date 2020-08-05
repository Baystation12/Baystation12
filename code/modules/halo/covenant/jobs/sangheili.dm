
/datum/job/covenant/sangheili_shipmaster
	title = "Sangheili Shipmaster"
	department_flag = COM
	total_positions = 1
	spawn_positions = 1
	track_players = TRUE
	outfit_type = /decl/hierarchy/outfit/sangheili/shipmaster
	is_whitelisted = 1
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/sangheili)
	access = list(access_covenant, access_covenant_command, access_covenant_slipspace)
	pop_balance_mult = 3

/datum/job/covenant/sangheili_ultra
	title = "Sangheili Ultra"
	department_flag = COM
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/sangheili/ultra
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/sangheili)
	access = list(access_covenant, access_covenant_command, access_covenant_slipspace)
	pop_balance_mult = 3

/datum/job/covenant/sangheili_honour_guard
	title = "Sangheili Honour Guard"
	total_positions = 0
	spawn_positions = 0
	outfit_type = /decl/hierarchy/outfit/sangheili/honour_guard
	is_whitelisted = TRUE
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/sangheili)
	access = list(access_covenant, access_covenant_command, access_covenant_slipspace)
	pop_balance_mult = 2

/datum/job/covenant/sangheili_major
	title = "Sangheili Major"
	total_positions = 2
	spawn_positions = 2
	open_slot_on_death = TRUE
	department_flag = COM
	outfit_type = /decl/hierarchy/outfit/sangheili/major
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/sangheili)
	access = list(access_covenant, access_covenant_command, access_covenant_slipspace)
	pop_balance_mult = 2

/datum/job/covenant/sangheili_minor
	title = "Sangheili Minor"
	total_positions = 2
	spawn_positions = 2
	outfit_type = /decl/hierarchy/outfit/sangheili/minor
	access = list(access_covenant, access_covenant_command, access_covenant_slipspace)
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/sangheili)
	open_slot_on_death = TRUE //just like brutes, lowest rank of a leader caste can respawn indefinitely although still capped low
	pop_balance_mult = 2


/* Not available during standard play */

/datum/job/covenant/sangheili_ranger
	title = "Sangheili Ranger"
	supervisors = "the Majors"
	outfit_type = /decl/hierarchy/outfit/sangheili/eva
	access = list(access_covenant, access_covenant_command, access_covenant_slipspace)
	total_positions = 1
	spawn_positions = 1
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/sangheili)
	pop_balance_mult = 2

/datum/job/covenant/sangheili_specops
	title = "Special Operations Sangheili"
	supervisors = "the Shipmaster"
	outfit_type = /decl/hierarchy/outfit/sangheili/specops
	access = list(access_covenant, access_covenant_command, access_covenant_slipspace)
	is_whitelisted = TRUE
	spawn_positions = 0
	total_positions = 0
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/sangheili)
	pop_balance_mult = 2

/datum/job/covenant/sangheili_zealot
	title = "Sangheili Zealot"
	total_positions = 0
	spawn_positions = 0
	faction_whitelist = "Covenant"
	outfit_type = /decl/hierarchy/outfit/sangheili/zealot
	whitelisted_species = list(/datum/species/sangheili)
	access = list(access_covenant, access_covenant_command, access_covenant_slipspace)
	pop_balance_mult = 2
