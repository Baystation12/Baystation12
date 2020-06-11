
/datum/job/covenant/brute_captain
	title = "Jiralhanae Captain"
	department_flag = COM
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/jiralhanae/covenant/captain
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/brutes)
	access = list(access_covenant, access_covenant_command)

/datum/job/covenant/brute_major
	title = "Jiralhanae Major"
	total_positions = 2
	spawn_positions = 2
	open_slot_on_death = 1
	outfit_type = /decl/hierarchy/outfit/jiralhanae/covenant/major
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/brutes)
	access = list(access_covenant, access_covenant_command)

/datum/job/covenant/brute_minor
	title = "Jiralhanae Minor"
	total_positions = -1
	spawn_positions = -1
	outfit_type = /decl/hierarchy/outfit/jiralhanae/covenant/minor
	access = list(240,250)
	whitelisted_species = list(/datum/species/brutes)
