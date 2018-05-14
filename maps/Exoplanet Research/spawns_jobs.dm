GLOBAL_LIST_EMPTY(facil_researcher_spawns)

/datum/spawnpoint/facil_researcher
	display_name =  "Research Facility Spawn"
	restrict_job = list("Researcher")

/datum/spawnpoint/facil_researcher/New()
	..()
	turfs = GLOB.facil_researcher_spawns

/obj/effect/landmark/start/facil_researcher
	name = "Researcher Spawn"

/obj/effect/landmark/start/facil_researcher/New()
	..()
	GLOB.facil_researcher_spawns += loc

/decl/hierarchy/outfit/job/facil_researcher
	name = "Researcher"

	suit = /obj/item/clothing/suit/storage/toggle/labcoat

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/datum/job/researcher
	title = "Researcher"
	total_positions = 6
	spawn_positions = 6
	outfit_type = /decl/hierarchy/outfit/job/facil_researcher
	selection_color = "#667700"
	spawnpoint_override = "Research Facility Spawn"
