
GLOBAL_LIST_EMPTY(unsc_frigate_spawns)

/datum/spawnpoint/unsc_frigate
	display_name = "UNSC Frigate"
	restrict_job = list("Commanding Officer","UNSC Heaven Above ODST Spawn","UNSC Heaven Above ODST Officer Spawn",\
	"Executive Officer","Commander Air Group","Bridge Officer","Crew Chief (flight)",\
	"Flight Mechanic","Crew Chief (logistics)","Logistics Specialist","Marine Company Officer","Marine Company Sergeant",\
	"Marine Squad Leader","Infantry Weapons Officer","Marine","Ground Vehicle Operator","Combat Engineer","Chief Hospital Corpsman",\
	"Hospital Corpsman","Naval Security Master-At-Arms","Naval Security Officer","Operations Supervisor","Operations Specialist",\
	"Wing Commander","Squadron Commander","Pilot","AI","Crew Chief (gunnery)","Gunnery Operator","Crew Chief (technical)","Technician")
	msg = "has arrived on the UNSC Heavens Above"



/datum/spawnpoint/unsc_frigate/New()
	..()
	turfs = GLOB.unsc_frigate_spawns

/obj/effect/landmark/start/unsc_frigate
	name = "UNSC Frigate Spawn"

/obj/effect/landmark/start/unsc_frigate/New()
	..()
	GLOB.unsc_frigate_spawns += loc

//UNSC Heaven Above Command Spawnpoints

//CO

GLOBAL_LIST_EMPTY(Commanding_Officer_spawns)

/datum/spawnpoint/Commanding_Officer
	display_name = "UNSC Commanding Officer Spawn"
	restrict_job = list("Commanding Officer")

/datum/spawnpoint/Commanding_Officer/New()
	..()
	turfs = GLOB.Commanding_Officer_spawns

/obj/effect/landmark/start/Commanding_Officer
	name = "UNSC Commanding Officer Spawn"

/obj/effect/landmark/start/Commanding_Officer/New()
	..()
	GLOB.Commanding_Officer_spawns += loc

//XO

GLOBAL_LIST_EMPTY(Executive_Officer_spawns)

/datum/spawnpoint/Executive_Officer
	display_name = "UNSC Executive Officer Spawn"
	restrict_job = list("Executive Officer")

/datum/spawnpoint/Executive_Officer/New()
	..()
	turfs = GLOB.Executive_Officer_spawns

/obj/effect/landmark/start/Executive_Officer
	name = "UNSC Executive Officer Spawn"

/obj/effect/landmark/start/Executive_Officer/New()
	..()
	GLOB.Executive_Officer_spawns += loc

//CAG

GLOBAL_LIST_EMPTY(Commander_Air_Group_spawns)

/datum/spawnpoint/Commander_Air_Group
	display_name = "UNSC Commander Air Group Spawn"
	restrict_job = list("Commander Air Group")

/datum/spawnpoint/Commander_Air_Group/New()
	..()
	turfs = GLOB.Commander_Air_Group_spawns

/obj/effect/landmark/start/Commander_Air_Group
	name = "UNSC Commander Air Group Spawn"

/obj/effect/landmark/start/Commander_Air_Group/New()
	..()
	GLOB.Commander_Air_Group_spawns += loc

//BO

GLOBAL_LIST_EMPTY(Bridge_Officer_spawns)

/datum/spawnpoint/Bridge_Officer
	display_name = "UNSC Bridge Officer Spawn"
	restrict_job = list("Bridge Officer")

/datum/spawnpoint/Bridge_Officer/New()
	..()
	turfs = GLOB.Bridge_Officer_spawns

/obj/effect/landmark/start/Bridge_Officer
	name = "UNSC Bridge Officer Spawn"

/obj/effect/landmark/start/Bridge_Officer/New()
	..()
	GLOB.Bridge_Officer_spawns += loc

//UNSC Heaven Above Operations Spawnpoints

//Operations Supervisor

GLOBAL_LIST_EMPTY(Operations_Supervisor_spawns)

/datum/spawnpoint/Operations_Supervisor
	display_name = "UNSC Operations Supervisor Spawn"
	restrict_job = list("Operations Supervisor")

/datum/spawnpoint/Operations_Supervisor/New()
	..()
	turfs = GLOB.Operations_Supervisor_spawns

/obj/effect/landmark/start/Operations_Supervisor
	name = "UNSC Operations Supervisor Spawn"

/obj/effect/landmark/start/Operations_Supervisor/New()
	..()
	GLOB.Operations_Supervisor_spawns += loc

//Op-Spec

GLOBAL_LIST_EMPTY(Operations_Specialist_spawns)

/datum/spawnpoint/Operations_Specialist
	display_name = "UNSC Operations Specialist Spawn"
	restrict_job = list("Operations Specialist")

/datum/spawnpoint/Operations_Specialist/New()
	..()
	turfs = GLOB.Operations_Specialist_spawns

/obj/effect/landmark/start/Operations_Specialist
	name = "UNSC Operations Specialist Spawn"

/obj/effect/landmark/start/Operations_Specialist/New()
	..()
	GLOB.Operations_Specialist_spawns += loc

//UNSC Heaven Above Technical Spawnpoints

//Crew Chief (Technical)
GLOBAL_LIST_EMPTY(Crew_Chief_technical_spawns)

/datum/spawnpoint/Crew_Chief_technical
	display_name = "UNSC Crew Chief (technical) Spawn"
	restrict_job = list("Crew Chief (technical)")

/datum/spawnpoint/Crew_Chief_technical/New()
	..()
	turfs = GLOB.Crew_Chief_technical_spawns

/obj/effect/landmark/start/Crew_Chief_technical
	name = "UNSC Crew Chief (technical) Spawn"

/obj/effect/landmark/start/Crew_Chief_technical/New()
	..()
	GLOB.Crew_Chief_technical_spawns += loc

//Technician

GLOBAL_LIST_EMPTY(Technician_spawns)

/datum/spawnpoint/Technician
	display_name = "UNSC Technician Spawn"
	restrict_job = list("Technician")

/datum/spawnpoint/Technician/New()
	..()
	turfs = GLOB.Technician_spawns

/obj/effect/landmark/start/Technician
	name = "UNSC Technician Spawn"

/obj/effect/landmark/start/Technician/New()
	..()
	GLOB.Technician_spawns += loc

//UNSC Heaven Above Naval Security Spawnpoints

//Master At Arms

GLOBAL_LIST_EMPTY(Master_At_Arms_spawns)

/datum/spawnpoint/Master_At_Arms
	display_name = "UNSC Master-At-Arms Spawn"
	restrict_job = list("Master-At-Arms")

/datum/spawnpoint/Master_At_Arms/New()
	..()
	turfs = GLOB.Master_At_Arms_spawns

/obj/effect/landmark/start/Master_At_Arms
	name = "UNSC Master-At-Arms Spawn"

/obj/effect/landmark/start/Master_At_Arms/New()
	..()
	GLOB.Master_At_Arms_spawns += loc

//Naval Security

GLOBAL_LIST_EMPTY(security_spawns)

/datum/spawnpoint/security
	display_name = "UNSC Naval Security Officer Spawn"
	restrict_job = list("Naval Security Officer")

/datum/spawnpoint/security/New()
	..()
	turfs = GLOB.security_spawns

/obj/effect/landmark/start/security
	name = "UNSC Naval Security Officer Spawn"

/obj/effect/landmark/start/security/New()
	..()
	GLOB.security_spawns += loc

//UNSC Heaven Above Tactical Spawnpoints

//Gunnery Crew Chief
GLOBAL_LIST_EMPTY(Crew_Chief_Gunnery_spawns)

/datum/spawnpoint/Crew_Chief_Gunnery
	display_name = "UNSC Crew Chief (gunnery) Spawn"
	restrict_job = list("Crew Chief (gunnery)")

/datum/spawnpoint/security/New()
	..()
	turfs = GLOB.Crew_Chief_Gunnery_spawns

/obj/effect/landmark/start/Crew_Chief_Gunnery
	name = "UNSC Crew Chief (gunnery) Spawn"

/obj/effect/landmark/start/Crew_Chief_Gunnery/New()
	..()
	GLOB.Crew_Chief_Gunnery_spawns += loc

//Gunnery

GLOBAL_LIST_EMPTY(Gunnery_Operator_spawns)

/datum/spawnpoint/Gunnery_Operator
	display_name = "UNSC Gunnery Operator Spawn"
	restrict_job = list("Gunnery Operator")

/datum/spawnpoint/Gunnery_Operator/New()
	..()
	turfs = GLOB.Gunnery_Operator_spawns

/obj/effect/landmark/start/Gunnery_Operator
	name = "UNSC Gunnery Operator Spawn"

/obj/effect/landmark/start/Gunnery_Operator/New()
	..()
	GLOB.Gunnery_Operator_spawns += loc

//UNSC Heaven Above ODST Spawnpoints

GLOBAL_LIST_EMPTY(corvetteodst_odst_spawns)

/datum/spawnpoint/corvetteodst_odst
	display_name = "UNSC Heaven Above ODST Spawn"
	restrict_job = list("Orbital Drop Shock Trooper")

/datum/spawnpoint/corvetteodst_odst/New()
	..()
	turfs = GLOB.corvetteodst_odst_spawns

/obj/effect/landmark/start/corvetteodst_odst
	name = "UNSC Heaven Above ODST Spawn"

/obj/effect/landmark/start/corvetteodst_odst/New()
	..()
	GLOB.corvetteodst_odst_spawns += loc


GLOBAL_LIST_EMPTY(corvetteodst_officer_spawns)

/datum/spawnpoint/corvetteodst_officer
	display_name = "UNSC Heaven Above ODST Officer Spawn"
	restrict_job = list("Orbital Drop Shock Trooper Officer")

/datum/spawnpoint/corvetteodst_officer/New()
	..()
	turfs = GLOB.corvetteodst_officer_spawns

/obj/effect/landmark/start/corvetteodst_officer
	name = "UNSC Heaven Above ODST Officer Spawn"

/obj/effect/landmark/start/corvetteodst_officer/New()
	..()
	GLOB.corvetteodst_officer_spawns += loc
