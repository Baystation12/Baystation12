
/datum/job/covenant/unggoy_minor
	title = "Unggoy Minor"
	total_positions = -1
	spawn_positions = -1
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/unggoy
	whitelisted_species = list(/datum/species/unggoy)
	pop_balance_mult = 0.5

/datum/job/covenant/unggoy_major
	title = "Unggoy Major"
	total_positions = 4
	spawn_positions = 4
	open_slot_on_death = 1
	outfit_type = /decl/hierarchy/outfit/unggoy/major
	whitelisted_species = list(/datum/species/unggoy)
	pop_balance_mult = 0.5

/datum/job/covenant/unggoy_ultra
	title = "Unggoy Ultra"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/unggoy/ultra
	access = list(access_covenant, access_covenant_command, access_covenant_slipspace)
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/unggoy)
	pop_balance_mult = 0.5

/datum/job/covenant/unggoy_heavy
	title = "Unggoy Heavy"
	total_positions = 1
	spawn_positions = 1
	open_slot_on_death = 1
	outfit_type = /decl/hierarchy/outfit/unggoy/heavy
	access = list(access_covenant, access_covenant_command, access_covenant_slipspace)
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/unggoy)
	pop_balance_mult = 0.5

/datum/job/covenant/unggoy_deacon
	title = "Unggoy Deacon"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/unggoy/deacon
	access = list(access_covenant, access_covenant_command, access_covenant_slipspace)
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/unggoy)
	pop_balance_mult = 0.5



/* Not available during standard play */

/datum/job/covenant/unggoy_specops
	title = "Special Operations Unggoy"
	supervisors = "the Elites"
	outfit_type = /decl/hierarchy/outfit/unggoy/specops
	access = list(access_covenant, access_covenant_command, access_covenant_slipspace)
	spawn_positions = 0
	total_positions = 0
	faction_whitelist = "Covenant"

/datum/job/covenant/unggoy_honour_guard
	title = "Honour Guard Unggoy"
	supervisors = "the Elites"
	outfit_type = /decl/hierarchy/outfit/unggoy/honour_guard
	access = list(access_covenant, access_covenant_command, access_covenant_slipspace)
	spawn_positions = 0
	total_positions = 0
	faction_whitelist = "Covenant"
