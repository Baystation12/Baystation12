
/datum/job/unsc/crew
	title = "UNSC Station Crew"
	fallback_spawnpoint = null
	outfit_type = /decl/hierarchy/outfit/job/unsc
	total_positions = 1
	spawn_positions = 1
	open_slot_on_death = 1
	alt_titles = list(\
	"UNSC Logistics" = /decl/hierarchy/outfit/job/unsc/logistics,
	"UNSC Technician" = /decl/hierarchy/outfit/job/unsc/technician,
	"UNSC Gunner" = /decl/hierarchy/outfit/job/unsc/gunner,
	"UNSC Pilot" = /decl/hierarchy/outfit/job/unsc/pilot,
	"UNSC Bridge Crew" = /decl/hierarchy/outfit/job/unsc/bridge,
	"UNSC Operations" = /decl/hierarchy/outfit/job/unsc/science,
	"UNSC Helmsman" = /decl/hierarchy/outfit/job/unsc/helm)

/datum/job/unsc/medical
	title = "UNSC Station Medic"
	fallback_spawnpoint = null
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/unsc/medic
