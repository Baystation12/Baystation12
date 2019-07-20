GLOBAL_LIST_EMPTY(facil_researcher_spawns)

/datum/spawnpoint/facil_researcher
	display_name =  "Research Facility Spawn"
	restrict_job = list("ONI Researcher")

/datum/spawnpoint/facil_researcher/New()
	..()
	turfs = GLOB.facil_researcher_spawns

/obj/effect/landmark/start/facil_researcher
	name = "Researcher Spawn"

/obj/effect/landmark/start/facil_researcher/New()
	..()
	GLOB.facil_researcher_spawns += loc



GLOBAL_LIST_EMPTY(facil_director_spawns)

/datum/spawnpoint/facil_director
	display_name =  "Research Facility Director Spawn"
	restrict_job = list("ONI Research Director")

/datum/spawnpoint/facil_director/New()
	..()
	turfs = GLOB.facil_director_spawns

/obj/effect/landmark/start/facil_director
	name = "Research Director Spawn"

/obj/effect/landmark/start/facil_director/New()
	..()
	GLOB.facil_director_spawns += loc



GLOBAL_LIST_EMPTY(facil_security_spawns)

/datum/spawnpoint/facil_security
	display_name =  "Research Facility Security Spawn"
	restrict_job = list("ONI Security Guard","ONI Security Commander")

/datum/spawnpoint/facil_security/New()
	..()
	turfs = GLOB.facil_security_spawns

/obj/effect/landmark/start/facil_security
	name = "Research Facility Security Spawn"

/obj/effect/landmark/start/facil_security/New()
	..()
	GLOB.facil_security_spawns += loc



GLOBAL_LIST_EMPTY(facil_comms_spawns)

/datum/spawnpoint/facil_comms
	display_name =  "Research Facility Comms Spawn"
	restrict_job = list("ONI Communications Operator")

/datum/spawnpoint/facil_comms/New()
	..()
	turfs = GLOB.facil_comms_spawns

/obj/effect/landmark/start/facil_comms
	name = "Research Facility Comms Spawn"

/obj/effect/landmark/start/facil_comms/New()
	..()
	GLOB.facil_comms_spawns += loc
