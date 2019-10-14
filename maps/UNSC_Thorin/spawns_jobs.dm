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


GLOBAL_LIST_EMPTY(corvette_odst_spawns)

/datum/spawnpoint/corvette_odst
	display_name = "ODST Rifleman Spawn"
	restrict_job = list("Orbital Drop Shock Trooper")

/datum/spawnpoint/corvette_odst/New()
	..()
	turfs = GLOB.corvette_odst_spawns

/obj/effect/landmark/start/corvette_odst
	name = "ODST Rifleman Spawn"

/obj/effect/landmark/start/corvette_odst/New()
	..()
	GLOB.corvette_odst_spawns += loc


GLOBAL_LIST_EMPTY(corvette_odsto_spawns)

/datum/spawnpoint/corvette_odsto
	display_name = "ODST Squad Leader Spawn"
	restrict_job = list("Orbital Drop Shock Trooper Officer")

/datum/spawnpoint/corvette_odsto/New()
	..()
	turfs = GLOB.corvette_odsto_spawns

/obj/effect/landmark/start/corvette_odsto
	name = "ODST Squad Leader Spawn"

/obj/effect/landmark/start/corvette_odsto/New()
	..()
	GLOB.corvette_odsto_spawns += loc

GLOBAL_LIST_EMPTY(corvette_marine_spawns)

/datum/spawnpoint/corvette_marine
	display_name = "Corvette Marine Spawn"
	restrict_job = list("UNSC Marine")

/datum/spawnpoint/corvette_marine/New()
	..()
	turfs = GLOB.corvette_marine_spawns

/obj/effect/landmark/start/corvette_marine
	name = "Corvette Marine Spawn"

/obj/effect/landmark/start/corvette_marine/New()
	..()
	GLOB.corvette_marine_spawns += loc