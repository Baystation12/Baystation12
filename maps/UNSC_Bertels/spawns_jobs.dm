GLOBAL_LIST_EMPTY(corvetteodst_crewmedical_spawns)

/datum/spawnpoint/corvetteodst_crewmedical
	display_name = "UNSC Ship Medical Staff Spawn"
	restrict_job = list("UNSC Ship Hospital Corpsman")

/datum/spawnpoint/corvetteodst_crewmedical/New()
	..()
	turfs = GLOB.corvetteodst_crewmedical_spawns

/obj/effect/landmark/start/corvetteodst_crewmedical
	name = "UNSC Ship Medical Staff Spawn"

/obj/effect/landmark/start/corvetteodst_crewmedical/New()
	..()
	GLOB.corvetteodst_crewmedical_spawns += loc

GLOBAL_LIST_EMPTY(corvetteodst_crew_spawns)

/datum/spawnpoint/corvetteodst_crew
	display_name = "UNSC Ship Crew Spawn"
	restrict_job = list("UNSC Ship Crew")

/datum/spawnpoint/corvetteodst_crew/New()
	..()
	turfs = GLOB.corvetteodst_crew_spawns

/obj/effect/landmark/start/corvetteodst_crew
	name = "UNSC Ship Crew Spawn"

/obj/effect/landmark/start/corvetteodst_crew/New()
	..()
	GLOB.corvetteodst_crew_spawns += loc


GLOBAL_LIST_EMPTY(corvetteodst_captain_spawns)

/datum/spawnpoint/corvetteodst_captain
	display_name = "UNSC Ship CO Spawn"
	restrict_job = list("UNSC Ship Commanding Officer")

/datum/spawnpoint/corvetteodst_captain/New()
	..()
	turfs = GLOB.corvetteodst_captain_spawns

/obj/effect/landmark/start/corvetteodst_captain
	name = "UNSC Ship CO Spawn"

/obj/effect/landmark/start/corvetteodst_captain/New()
	..()
	GLOB.corvetteodst_captain_spawns += loc

GLOBAL_LIST_EMPTY(corvetteodst_xo_spawns)

/datum/spawnpoint/corvetteodst_xo
	display_name = "UNSC Ship XO Spawn"
	restrict_job = list("UNSC Ship Executive Officer")

/datum/spawnpoint/corvetteodst_xo/New()
	..()
	turfs = GLOB.corvetteodst_xo_spawns

/obj/effect/landmark/start/corvetteodst_xo
	name = "UNSC Ship XO Spawn"

/obj/effect/landmark/start/corvetteodst_xo/New()
	..()
	GLOB.corvetteodst_xo_spawns += loc


//UNSC Ship Marine Spawnpoints

GLOBAL_LIST_EMPTY(corvetteodst_marine_spawns)

/datum/spawnpoint/corvetteodst_marine
	display_name = "UNSC Ship Marine Spawn"
	restrict_job = list("UNSC Marine")

/datum/spawnpoint/corvetteodst_marine/New()
	..()
	turfs = GLOB.corvetteodst_marine_spawns

/obj/effect/landmark/start/corvetteodst_marine
	name = "UNSC Ship Marine Spawn"

/obj/effect/landmark/start/corvetteodst_marine/New()
	..()
	GLOB.corvetteodst_marine_spawns += loc

GLOBAL_LIST_EMPTY(corvetteodst_marineplatoon_spawns)

/datum/spawnpoint/corvetteodst_marineplatoon
	display_name = "UNSC Ship Marine Platoon Leader Spawn"
	restrict_job = list("UNSC Marine Platoon Leader")

/datum/spawnpoint/corvetteodst_marineplatoon/New()
	..()
	turfs = GLOB.corvetteodst_marineplatoon_spawns

/obj/effect/landmark/start/corvetteodst_marineplatoon
	name = "UNSC Ship Marine Platoon Leader Spawn"

/obj/effect/landmark/start/corvetteodst_marineplatoon/New()
	..()
	GLOB.corvetteodst_marineplatoon_spawns += loc



//UNSC Ship ODST Spawnpoints
/*
GLOBAL_LIST_EMPTY(corvetteodst_odst_spawns)

/datum/spawnpoint/corvetteodst_odst
	display_name = "UNSC Ship ODST Spawn"
	restrict_job = list("Orbital Drop Shock Trooper")

/datum/spawnpoint/corvetteodst_odst/New()
	..()
	turfs = GLOB.corvetteodst_odst_spawns

/obj/effect/landmark/start/corvetteodst_odst
	name = "UNSC Ship ODST Spawn"

/obj/effect/landmark/start/corvetteodst_odst/New()
	..()
	GLOB.corvetteodst_odst_spawns += loc


GLOBAL_LIST_EMPTY(corvetteodst_ftl_spawns)


GLOBAL_LIST_EMPTY(corvetteodst_officer_spawns)

/datum/spawnpoint/corvetteodst_officer
	display_name = "UNSC Ship ODST Officer Spawn"
	restrict_job = list("Orbital Drop Shock Trooper Officer")

/datum/spawnpoint/corvetteodst_officer/New()
	..()
	turfs = GLOB.corvetteodst_officer_spawns

/obj/effect/landmark/start/corvetteodst_officer
	name = "UNSC Ship ODST Officer Spawn"

/obj/effect/landmark/start/corvetteodst_officer/New()
	..()
	GLOB.corvetteodst_officer_spawns += loc
*/
