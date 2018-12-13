
/datum/job/URF_commando
	title = "URF Commando - Rifleman"
	outfit_type = /decl/hierarchy/outfit/job/URF_commando
	alt_titles = list("URF Commando - Engineer",\
	"URF Commando - Medic",\
	"URF Commando -  CQB",\
	"URF Commando - Sniper")

	total_positions = 8
	spawn_positions = 8
	selection_color = "#0A0A95"
	access = list(252,632)
	spawnpoint_override = "Commando Spawn"
	is_whitelisted = 1

/datum/job/URF_commando_officer
	title = "URF Commando Officer"
	outfit_type = /decl/hierarchy/outfit/job/URF_commando_officer
	alt_titles = list()

	total_positions = 1
	spawn_positions = 1
	selection_color = "#0A0A95"
	access = list(252,632)
	spawnpoint_override = "Commando Officer Spawn"
	is_whitelisted = 1

