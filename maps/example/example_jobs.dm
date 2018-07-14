GLOBAL_LIST_EMPTY(example_spawns)

/datum/spawnpoint/example
	display_name =  "Test Spawn"
	restrict_job = list("Test Officer")

/datum/spawnpoint/example/New()
	..()
	turfs = GLOB.example_spawns

/obj/effect/landmark/start/example
	name = "Test Spawn"

/obj/effect/landmark/start/example/New()
	..()
	GLOB.example_spawns += loc


/datum/job/example
	title = "Test Officer"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#008000"
	access = list(142,110,300,306,309,310,311)
	spawnpoint_override = "Test Spawn"
	is_whitelisted = 1

