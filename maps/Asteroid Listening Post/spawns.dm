GLOBAL_LIST_EMPTY(listen_staff_spawns)

/datum/spawnpoint/listen_staff
	display_name =  "Listening Post Spawn"
	restrict_job = list("Insurrectionist","URF Commando")

/datum/spawnpoint/listen_staff/New()
	..()
	turfs = GLOB.listen_staff_spawns

/obj/effect/landmark/start/listen_staff
	name = "Listening Post Technician"

/obj/effect/landmark/start/listen_staff/New()
	..()
	GLOB.listen_staff_spawns += loc

GLOBAL_LIST_EMPTY(listen_staffl_spawns)

/datum/spawnpoint/listen_staffl
	display_name =  "Listening Post Commander Spawn"
	restrict_job = list("Insurrectionist Commander","URF Commando Officer")

/datum/spawnpoint/listen_staffl/New()
	..()
	turfs = GLOB.listen_staffl_spawns

/obj/effect/landmark/start/listen_staffl
	name = "Listening Post Commander"

/obj/effect/landmark/start/listen_staffl/New()
	..()
	GLOB.listen_staffl_spawns += loc

