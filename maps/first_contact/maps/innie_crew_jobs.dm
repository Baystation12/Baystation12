
/datum/job/ship_crew_innie
	title = "Insurrectionist Ship Crew"
	total_positions = 6
	spawn_positions = 6
	access = list(632)
	outfit_type = /decl/hierarchy/outfit/job/innie_crewmember
	selection_color = "#ff0000"
	spawnpoint_override = "Innie Base Spawns"

/datum/job/ship_cap_innie
	title = "Insurrectionist Ship Captain"
	total_positions = 1
	spawn_positions = 1
	access = list(632,633)
	outfit_type = /decl/hierarchy/outfit/job/innie_crew_captain
	selection_color = "#ff0000"
	spawnpoint_override = "Innie Base Spawns"
