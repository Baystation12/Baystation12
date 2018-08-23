GLOBAL_LIST_EMPTY(corvetteodst_crew_spawns)

/datum/spawnpoint/corvetteodst_crew
	display_name = "ODST Corvette Crew"
	restrict_job = list("UNSC Corvette Ship Crew")

/datum/spawnpoint/corvetteodst_crew/New()
	..()
	turfs = GLOB.corvetteodst_crew_spawns

/obj/effect/landmark/start/corvetteodst_crew
	name = "Corvette Crew"

/obj/effect/landmark/start/corvetteodst_crew/New()
	..()
	GLOB.corvetteodst_crew_spawns += loc

GLOBAL_LIST_EMPTY(corvetteodst_captain_spawns)

/datum/spawnpoint/corvetteodst_captain
	display_name = "ODST Corvette Crew Captain"
	restrict_job = list("UNSC Corvette Ship Captain")

/datum/spawnpoint/corvetteodst_captain/New()
	..()
	turfs = GLOB.corvetteodst_captain_spawns

/obj/effect/landmark/start/corvette_captain
	name = "Corvette Crew Captain"

/obj/effect/landmark/start/corvetteodst_captain/New()
	..()
	GLOB.corvetteodst_captain_spawns += loc


GLOBAL_LIST_EMPTY(corvetteodst_odst_spawns)

/datum/spawnpoint/corvetteodst_odst
	display_name = "ODST Spawn"
	restrict_job = list("Rifleman,Field Medic,Sharpshooter,Combat Engineer,CQC Specialist")

/datum/spawnpoint/corvetteodst_odst/New()
	..()
	turfs = GLOB.corvetteodst_odst_spawns

/obj/effect/landmark/start/corvetteodst_odst
	name = "ODST Spawn"

/obj/effect/landmark/start/corvetteodst_odst/New()
	..()
	GLOB.corvette_odst_spawns += loc


GLOBAL_LIST_EMPTY(corvetteodst_ftl_spawns)

/datum/spawnpoint/corvetteodst_ftl
	display_name = "Fireteam Leader Spawn"
	restrict_job = list("Fireteam Leader")

/datum/spawnpoint/corvetteodst_ftl/New()
	..()
	turfs = GLOB.corvetteodst_ftl_spawns

/obj/effect/landmark/start/corvetteodst_ftl
	name = "Fireteam Leader Spawn"

/obj/effect/landmark/start/corvetteodst_ftl/New()
	..()
	GLOB.corvetteodst_ftl_spawns += loc

GLOBAL_LIST_EMPTY(corvetteodst_officer_spawns)

/datum/spawnpoint/corvetteodst_officer
	display_name = "Corvette officer ODST Spawn"
	restrict_job = list("Officer")

/datum/spawnpoint/corvetteodst_officer/New()
	..()
	turfs = GLOB.corvetteodst_officer_spawns

/obj/effect/landmark/start/corvetteodst_officer
	name = "Corvette officer ODST Spawn"

/obj/effect/landmark/start/corvetteodst_officer/New()
	..()
	GLOB.corvetteodst_officer_spawns += loc

/datum/job/odstrifleman
	title = "Rifleman"
	total_positions = 12
	spawn_positions = 12
	outfit_type = /decl/hierarchy/outfit/job/ODSTRifleman
	alt_titles = list("Field Medic","CQC Specialist","Sharpshooter","Combat Engineer")
	selection_color = "#008000"
	faction_flag = ODST
	access = list(142,144,110,309,311)
	spawnpoint_override = "ODST Spawn"
	is_whitelisted = 1

/datum/job/odstfireteamlead
	title = "Fireteam Leader"
	total_positions = 3
	spawn_positions = 3
	outfit_type = /decl/hierarchy/outfit/job/ODSTFireteamLead
	selection_color = "#008000"
	faction_flag = ODSTFTL
	access = list(142,144,110,309,311)
	spawnpoint_override = "Fireteam Leader Spawn"
	is_whitelisted = 1

/datum/job/odstofficercorvette
	title = "Second Lieutenant"
	total_positions = 2
	spawn_positions = 2
	faction_flag = ODSTO
	outfit_type = /decl/hierarchy/outfit/job/ODSTFireteamLead
	selection_color = "#008000"
	access = list(142,144,110,300,306,309,310,311)
	spawnpoint_override = "Corvette officer ODST Spawn"
	is_whitelisted = 1




