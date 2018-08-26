
GLOBAL_LIST_EMPTY(corvetteodst_odst_spawns)

/datum/spawnpoint/corvetteodst_odst
	display_name = "ODST Spawn"
	restrict_job = list("Orbital Drop Shock Trooper")

/datum/spawnpoint/corvetteodst_odst/New()
	..()
	turfs = GLOB.corvetteodst_odst_spawns

/obj/effect/landmark/start/corvetteodst_odst
	name = "ODST Spawn"

/obj/effect/landmark/start/corvetteodst_odst/New()
	..()
	GLOB.corvetteodst_odst_spawns += loc


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
	restrict_job = list("Orbital Drop Shock Trooper Officer")

/datum/spawnpoint/corvetteodst_officer/New()
	..()
	turfs = GLOB.corvetteodst_officer_spawns

/obj/effect/landmark/start/corvetteodst_officer
	name = "Corvette officer ODST Spawn"

/obj/effect/landmark/start/corvetteodst_officer/New()
	..()
	GLOB.corvetteodst_officer_spawns += loc

/datum/job/ODST
	title = "Orbital Drop Shock Trooper"
	total_positions = 15
	spawn_positions = 15
	outfit_type = /decl/hierarchy/outfit/job/facil_ODST
	alt_titles = list("Private First Class"= /decl/hierarchy/outfit/job/ODSTCQC,
	"Lance Corporal"= /decl/hierarchy/outfit/job/ODSTengineer,
	"Corporal"= /decl/hierarchy/outfit/job/facil_ODST,
	"Petty Officer Third Class"= /decl/hierarchy/outfit/job/ODSTMedic,
	"Sergeant"= /decl/hierarchy/outfit/job/ODSTSharpshooter,
	"Staff Sergeant"= /decl/hierarchy/outfit/job/ODSTstaffsergeant,
	"Gunnery Sergeant"= /decl/hierarchy/outfit/job/ODSTgunnerysergeant,
	"Master Sergeant" = /decl/hierarchy/outfit/job/ODSTFireteamLead)

	selection_color = "#008000"
	access = list(142,144,110,309,311)
	spawnpoint_override = "ODST Rifleman Spawn"
	is_whitelisted = 1

/datum/job/ODSTO
	title = "Orbital Drop Shock Trooper Officer"
	total_positions = 2
	spawn_positions = 2
	outfit_type = /decl/hierarchy/outfit/job/ODSTsecondlieutenant
	alt_titles = list("Second Lieutenant" = /decl/hierarchy/outfit/job/ODSTsecondlieutenant,
	"First Lieutenant" = /decl/hierarchy/outfit/job/ODSTfirstlieutenant,
	"Captain" = /decl/hierarchy/outfit/job/ODSTcaptain,
	"Major" = /decl/hierarchy/outfit/job/ODSTmajor,
	"Lieutenant Colonel" = /decl/hierarchy/outfit/job/ODSTltcolonel,
	"Colonel" = /decl/hierarchy/outfit/job/ODSTcolonel)
	selection_color = "#008000"
	access = list(142,144,110,300,306,309,310,311)
	spawnpoint_override = "ODST Squad Leader Spawn"
	is_whitelisted = 1



