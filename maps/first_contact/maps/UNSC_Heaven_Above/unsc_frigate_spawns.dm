
GLOBAL_LIST_EMPTY(unsc_frigate_spawns)

/datum/spawnpoint/unsc_frigate
	display_name = "UNSC Frigate"
	restrict_job = list("Commanding Officer","Executive Officer","Commander Air Group","Bridge Officer","Crew Chief (flight)",\
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