
/datum/job/stranded
	total_positions = -1
	spawn_positions = -1
	track_players = 1
	latejoin_at_spawnpoints = 0
	spawn_faction = "UNSC"
	whitelisted_species = list(/datum/species/human)
	loadout_allowed = TRUE

/datum/job/stranded/unsc_marine
	title = "UNSC marine survivor"
	outfit_type = /decl/hierarchy/outfit/job/stranded_unsc/marine
	selection_color = "#667700"

/datum/job/stranded/unsc_tech
	title = "UNSC technician survivor"
	outfit_type = /decl/hierarchy/outfit/job/stranded_unsc/tech
	selection_color = "#ff8800"

/datum/job/stranded/unsc_medic
	title = "UNSC corpsman survivor"
	outfit_type = /decl/hierarchy/outfit/job/stranded_unsc/medic
	selection_color = "#3300ff"

/datum/job/stranded/unsc_crew
	title = "UNSC crewman survivor"
	outfit_type = /decl/hierarchy/outfit/job/stranded_unsc/crew
	selection_color = "#996600"

/datum/job/stranded/unsc_civ
	title = "UEG colonist survivor"
	outfit_type = /decl/hierarchy/outfit/job/stranded_unsc/civ
	selection_color = "#00aa00"
