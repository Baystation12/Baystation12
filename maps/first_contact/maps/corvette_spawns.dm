GLOBAL_LIST_EMPTY(corvette_crew_spawns)

/datum/spawnpoint/corvette_crew
	display_name = "Corvette Crew"
	restrict_job = list("UNSC Corvette Ship Crew")

/datum/spawnpoint/corvette_crew/New()
	..()
	turfs = GLOB.corvette_crew_spawns

/obj/effect/landmark/start/corvette_crew
	name = "Corvette Crew"

/obj/effect/landmark/start/corvette_crew/New()
	..()
	GLOB.corvette_crew_spawns += loc

GLOBAL_LIST_EMPTY(corvette_captain_spawns)

/datum/spawnpoint/corvette_captain
	display_name = "Corvette Crew Captain"
	restrict_job = list("UNSC Corvette Ship Captain")

/datum/spawnpoint/corvette_captain/New()
	..()
	turfs = GLOB.corvette_captain_spawns

/obj/effect/landmark/start/corvette_captain
	name = "Corvette Crew Captain"

/obj/effect/landmark/start/corvette_captain/New()
	..()
	GLOB.corvette_captain_spawns += loc
