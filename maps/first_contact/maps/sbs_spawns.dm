GLOBAL_LIST_EMPTY(civ_crew_spawns)

/datum/spawnpoint/civ_crew
	display_name = "Civillian Ship Crew"
	restrict_job = list("Civillian Ship Crew")

/datum/spawnpoint/civ_crew/New()
	..()
	turfs = GLOB.civ_crew_spawns

/obj/effect/landmark/start/civ_crew
	name = "Civillian Ship Captain"

/obj/effect/landmark/start/civ_crew/New()
	..()
	GLOB.civ_crew_spawns += loc

GLOBAL_LIST_EMPTY(ship_cap_civ_spawns)

/datum/spawnpoint/ship_cap_civ
	display_name = "Civ Ship Cap Crew"
	restrict_job = list("Civillian Ship Captain")

/datum/spawnpoint/ship_cap_civ/New()
	..()
	turfs = GLOB.ship_cap_civ_spawns

/obj/effect/landmark/start/ship_cap_civ
	name = "Civ Ship Cap Crew"

/obj/effect/landmark/start/ship_cap_civ/New()
	..()
	GLOB.ship_cap_civ_spawns += loc

