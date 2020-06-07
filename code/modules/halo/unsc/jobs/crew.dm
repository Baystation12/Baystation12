
/datum/job/unsc/crew
	title = "UNSC Crew"
	fallback_spawnpoint = null
	outfit_type = /decl/hierarchy/outfit/job/unsc
	alt_titles = list(\
	"UNSC Janitor" = /decl/hierarchy/outfit/job/unsc/janitor,
	"UNSC Logistics" = /decl/hierarchy/outfit/job/unsc/logistics,
	"UNSC Technician" = /decl/hierarchy/outfit/job/unsc/technician,
	"UNSC Gunner" = /decl/hierarchy/outfit/job/unsc/gunner,
	"UNSC Pilot" = /decl/hierarchy/outfit/job/unsc/pilot,
	"UNSC Bridge Crew" = /decl/hierarchy/outfit/job/unsc/bridge,
	"UNSC Operations" = /decl/hierarchy/outfit/job/unsc/science,
	"UNSC Helmsman" = /decl/hierarchy/outfit/job/unsc/helm)

/datum/job/unsc/medical
	title = "UNSC Medic"
	fallback_spawnpoint = null
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/unsc/medic
