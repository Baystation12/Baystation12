
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

GLOBAL_LIST_EMPTY(unsc_security_spawns)

/datum/spawnpoint/unsc_security
	display_name = "UNSC Naval Security Officer Spawn"
	restrict_job = list("Naval Security Officer")

/datum/spawnpoint/unsc_security/New()
	..()
	turfs = GLOB.unsc_security_spawns

/obj/effect/landmark/start/unsc_security
	name = "UNSC Naval Security Officer Spawn"

/obj/effect/landmark/start/unsc_security/New()
	..()
	GLOB.unsc_security_spawns += loc

//UNSC Heaven Above Tactical Spawnpoints

//Gunnery Crew Chief
GLOBAL_LIST_EMPTY(gunnery_chief_spawns)

/datum/spawnpoint/gunnery_chief
	display_name = "UNSC Crew Chief (gunnery) Spawn"
	restrict_job = list("Crew Chief (gunnery)")

/datum/spawnpoint/gunnery_chief/New()
	..()
	turfs = GLOB.gunnery_chief_spawns

/obj/effect/landmark/start/gunnery_chief
	name = "UNSC Crew Chief (gunnery) Spawn"

/obj/effect/landmark/start/gunnery_chief/New()
	..()
	GLOB.gunnery_chief_spawns += loc

//Gunnery

GLOBAL_LIST_EMPTY(gunnery_spawns)

/datum/spawnpoint/gunnery
	display_name = "UNSC Gunnery Operator Spawn"
	restrict_job = list("Gunnery Operator")

/datum/spawnpoint/gunnery/New()
	..()
	turfs = GLOB.gunnery_spawns

/obj/effect/landmark/start/gunnery
	name = "UNSC Gunnery Operator Spawn"

/obj/effect/landmark/start/gunnery/New()
	..()
	GLOB.gunnery_spawns += loc

//UNSC Heaven Above Pilot Spawnpoints

//Wing Commander

GLOBAL_LIST_EMPTY(Wing_Commander_spawns)

/datum/spawnpoint/Wing_Commander
	display_name = "UNSC Wing Commander Spawn"
	restrict_job = list("Wing Commander")

/datum/spawnpoint/Wing_Commander/New()
	..()
	turfs = GLOB.Wing_Commander_spawns

/obj/effect/landmark/start/Wing_Commander
	name = "UNSC Wing Commander Spawn"

/obj/effect/landmark/start/Wing_Commander/New()
	..()
	GLOB.Wing_Commander_spawns += loc

//Squadron Commander

GLOBAL_LIST_EMPTY(Squadron_Commander_spawns)

/datum/spawnpoint/Squadron_Commander
	display_name = "UNSC Squadron Commander Spawn"
	restrict_job = list("Squadron Commander")

/datum/spawnpoint/Squadron_Commander/New()
	..()
	turfs = GLOB.Squadron_Commander_spawns

/obj/effect/landmark/start/Squadron_Commander
	name = "UNSC Squadron Commander Spawn"

/obj/effect/landmark/start/Squadron_Commander/New()
	..()
	GLOB.Squadron_Commander_spawns += loc

//Pilot

GLOBAL_LIST_EMPTY(Pilot_spawns)

/datum/spawnpoint/Pilot
	display_name = "UNSC Pilot Spawn"
	restrict_job = list("Pilot")

/datum/spawnpoint/Pilot/New()
	..()
	turfs = GLOB.Pilot_spawns

/obj/effect/landmark/start/Pilot
	name = "UNSC Pilot Spawn"

/obj/effect/landmark/start/Pilot/New()
	..()
	GLOB.Pilot_spawns += loc

//UNSC Heaven Above Flight Spawns

//Crew Chief (Flight)

GLOBAL_LIST_EMPTY(mechanic_chief_spawns)

/datum/spawnpoint/mechanic_chief
	display_name = "UNSC Crew Chief (flight) Spawn"
	restrict_job = list("Crew Chief (flight)")

/datum/spawnpoint/mechanic_chief/New()
	..()
	turfs = GLOB.mechanic_chief_spawns

/obj/effect/landmark/start/mechanic_chief
	name = "UNSC Crew Chief (flight) Spawn"

/obj/effect/landmark/start/mechanic_chief/New()
	..()
	GLOB.mechanic_chief_spawns += loc

//Mechanic

GLOBAL_LIST_EMPTY(mechanic_spawns)

/datum/spawnpoint/mechanic
	display_name = "UNSC Flight Mechanic Spawn"
	restrict_job = list("Flight Mechanic")

/datum/spawnpoint/mechanic/New()
	..()
	turfs = GLOB.mechanic_spawns

/obj/effect/landmark/start/mechanic
	name = "UNSC Flight Mechanic Spawn"

/obj/effect/landmark/start/mechanic/New()
	..()
	GLOB.mechanic_spawns += loc

//UNSC Heaven Above Medical Spawnpoints

//Medical Chief

GLOBAL_LIST_EMPTY(medical_chief_spawns)

/datum/spawnpoint/medical_chief
	display_name = "UNSC Chief Hospital Corpsman Spawn"
	restrict_job = list("Chief Hospital Corpsman")

/datum/spawnpoint/medical_chief/New()
	..()
	turfs = GLOB.medical_chief_spawns

/obj/effect/landmark/start/medical_chief
	name = "UNSC Chief Hospital Corpsman Spawn"

/obj/effect/landmark/start/medical_chief/New()
	..()
	GLOB.medical_chief_spawns += loc

//Medical

GLOBAL_LIST_EMPTY(medical_spawns)

/datum/spawnpoint/medical
	display_name = "UNSC Hospital Corpsman Spawn"
	restrict_job = list("Hospital Corpsman")

/datum/spawnpoint/medical/New()
	..()
	turfs = GLOB.medical_spawns

/obj/effect/landmark/start/medical
	name = "UNSC Hospital Corpsman Spawn"

/obj/effect/landmark/start/medical/New()
	..()
	GLOB.medical_spawns += loc

//UNSC Heaven Above Logistics Spawnpoints

//Crew Chief (Logistics)

GLOBAL_LIST_EMPTY(logistics_chief_spawns)

/datum/spawnpoint/logistics_chief
	display_name = "UNSC Crew Chief (logistics) Spawn"
	restrict_job = list("Crew Chief (logistics)")

/datum/spawnpoint/logistics_chief/New()
	..()
	turfs = GLOB.logistics_chief_spawns

/obj/effect/landmark/start/logistics_chief
	name = "UNSC Crew Chief (logistics) Spawn"

/obj/effect/landmark/start/logistics_chief/New()
	..()
	GLOB.logistics_chief_spawns += loc

//Logistics Specialist

GLOBAL_LIST_EMPTY(logistics_spawns)

/datum/spawnpoint/logistics
	display_name = "UNSC Logistics Specialist Spawn"
	restrict_job = list("Logistics Specialist")

/datum/spawnpoint/logistics/New()
	..()
	turfs = GLOB.logistics_spawns

/obj/effect/landmark/start/logistics
	name = "UNSC Logistics Specialist Spawn"

/obj/effect/landmark/start/logistics/New()
	..()
	GLOB.logistics_spawns += loc

//UNSC Heaven Above Marine Spawnpoints

//Marine

GLOBAL_LIST_EMPTY(marine_spawns)

/datum/spawnpoint/marine
	display_name = "UNSC Marine Spawn"
	restrict_job = list("Marine")

/datum/spawnpoint/marine/New()
	..()
	turfs = GLOB.marine_spawns

/obj/effect/landmark/start/marine
	name = "UNSC Marine Spawn"

/obj/effect/landmark/start/marine/New()
	..()
	GLOB.marine_spawns += loc

//Marine CO

GLOBAL_LIST_EMPTY(marine_co_spawns)

/datum/spawnpoint/marine_co
	display_name = "UNSC Marine Company Officer Spawn"
	restrict_job = list("Marine Company Officer")

/datum/spawnpoint/marine_co/New()
	..()
	turfs = GLOB.marine_co_spawns

/obj/effect/landmark/start/marine_co
	name = "UNSC Marine Company Officer Spawn"

/obj/effect/landmark/start/marine_co/New()
	..()
	GLOB.marine_co_spawns += loc

//Marine XO

GLOBAL_LIST_EMPTY(marine_xo_spawns)

/datum/spawnpoint/marine_xo
	display_name = "UNSC Marine Company Sergeant Spawn"
	restrict_job = list("Marine Company Sergeant")

/datum/spawnpoint/marine_xo/New()
	..()
	turfs = GLOB.marine_xo_spawns

/obj/effect/landmark/start/marine_xo
	name = "UNSC Marine Company Sergeant Spawn"

/obj/effect/landmark/start/marine_xo/New()
	..()
	GLOB.marine_xo_spawns += loc

//Marine SL

GLOBAL_LIST_EMPTY(marine_sl_spawns)

/datum/spawnpoint/marine_sl
	display_name = "UNSC Marine Squad Leader Spawn"
	restrict_job = list("Marine Squad Leader")

/datum/spawnpoint/marine_sl/New()
	..()
	turfs = GLOB.marine_sl_spawns

/obj/effect/landmark/start/marine_sl
	name = "UNSC Marine Squad Leader Spawn"

/obj/effect/landmark/start/marine_sl/New()
	..()
	GLOB.marine_sl_spawns += loc

//Marine Engineer

GLOBAL_LIST_EMPTY(specialist_spawns)

/datum/spawnpoint/specialist
	display_name = "UNSC Combat Engineer Spawn"
	restrict_job = list("Combat Engineer")

/datum/spawnpoint/specialist/New()
	..()
	turfs = GLOB.specialist_spawns

/obj/effect/landmark/start/specialist
	name = "UNSC Combat Engineer Spawn"

/obj/effect/landmark/start/specialist/New()
	..()
	GLOB.specialist_spawns += loc

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

//UNSC SHIP AI


GLOBAL_LIST_EMPTY(AI_spawns)

/datum/spawnpoint/AI
	display_name = "AI"
	restrict_job = list("AI")

/datum/spawnpoint/AI/New()
	..()
	turfs = GLOB.AI_spawns

/obj/effect/landmark/start/AI
	name = "AI"

/obj/effect/landmark/start/AI/New()
	..()
	GLOB.AI_spawns += loc