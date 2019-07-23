/datum/job/geminus_x52/researcher
	title = "X52 Researcher"
	spawn_faction = "x52"
	latejoin_at_spawnpoints = 1
	total_positions = 4
	spawn_positions = 4
	outfit_type = /decl/hierarchy/outfit/job/geminus_x52
	access = list(access_x52)
	selection_color = " #a01b01"
	spawnpoint_override = "X52"
	alt_titles = null
	whitelisted_species = list(/datum/species/human)


/datum/job/geminus_x52/research_director
	title = "X52 Research Director"
	spawn_faction = "x52"
	department_flag = COM
	latejoin_at_spawnpoints = 1
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/geminus_x52_rd
	access = list(access_x52_rd, access_x52)
	selection_color = " #a01b01"
	spawnpoint_override = "X52 RD"
	alt_titles = null
	whitelisted_species = list(/datum/species/human)
