GLOBAL_LIST_EMPTY(UNSC_turfs)

/datum/spawnpoint/UNSC_A_S_M
	display_name = "ODST Assault Squad Member"
	restrict_job = list("ODST Assault Squad Member")

/datum/spawnpoint/UNSC_A_S_M/New()
	..()
	turfs = GLOB.UNSC_turfs

/obj/effect/landmark/start/UNSC_A_S_M
	name = "ODST Assault Squad Member"

/obj/effect/landmark/start/UNSC_A_S_M/New()
	..()
	GLOB.UNSC_turfs += loc

/obj/effect/landmark/start/UNSC_R
	name = "ODST Rifleman"

/obj/effect/landmark/start/UNSC_R/New()
	..()
	GLOB.UNSC_turfs += loc

/obj/effect/landmark/start/UNSC_OBO
	name = "ONI Bridge Officer"

/obj/effect/landmark/start/UNSC_OBO/New()
	..()
	GLOB.UNSC_turfs += loc

/datum/spawnpoint/UNSC_A_S_L
	display_name = "ODST Assault Squad Lead"
	restrict_job = list("ODST Assault Squad Lead")

/datum/spawnpoint/UNSC_A_S_L/New()
	..()
	turfs = GLOB.UNSC_turfs

/obj/effect/landmark/start/UNSC_A_S_L
	name = "ODST Assault Squad Lead"

/obj/effect/landmark/start/UNSC_A_S_L/New()
	..()
	GLOB.UNSC_turfs += loc

/datum/spawnpoint/UNSC_A_T_L
	display_name = "ODST Assault Team Lead"
	restrict_job = list("ODST Assault Team Lead")

/datum/spawnpoint/UNSC_A_T_L/New()
	..()
	turfs = GLOB.UNSC_turfs

/obj/effect/landmark/start/UNSC_A_T_L
	name = "ODST Assault Team Lead"

/obj/effect/landmark/start/UNSC_A_T_L/New()
	..()
	GLOB.UNSC_turfs += loc
