
/datum/job/covenant/kigyarminor
	title = "Kig-Yar"
	total_positions = -1
	spawn_positions = -1
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/kigyar
	access = list(240,250)
	whitelisted_species = list(/datum/species/kig_yar)

/datum/job/covenant/kigyar_marksman
	title = "Kig-Yar Marksman"
	total_positions = 3
	spawn_positions = 3
	selection_color = "#800080"
	is_whitelisted = 1
	outfit_type = /decl/hierarchy/outfit/kigyar/marksman
	access = list(240,250)
	whitelisted_species = list(/datum/species/kig_yar)

/datum/job/covenant/kigyar_sniper
	title = "Kig-Yar Sniper"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#800080"
	is_whitelisted = 1
	outfit_type = /decl/hierarchy/outfit/kigyar/marksman_beamrifle
	access = list(240,250)
	whitelisted_species = list(/datum/species/kig_yar)
/*
/datum/job/covenant/kigyarcorvette/captain
	title = "Kig-Yar Shipmistress"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#800080"
	outfit_type = /decl/hierarchy/outfit/kigyarcorvette/captain
	access = list(240,250)
	faction_whitelist = "Covenant"
	whitelisted_species = list(/datum/species/kig_yar)
*/