
GLOBAL_LIST_EMPTY(colony_spawns)

/datum/spawnpoint/colonist
	display_name = "Colony Arrival Shuttle"
	restrict_job_type = list(\
		/datum/job/colonist,\
		/datum/job/colonist_mayor,\
		/datum/job/police,\
		/datum/job/police_chief\
		)
	msg = "has arrived on the colony"
	restrict_spawn_faction = "Human Colony"

/datum/spawnpoint/colonist/New()
	..()
	turfs = GLOB.colony_spawns

/obj/effect/landmark/start/colonist
	name = "Colonist"

/obj/effect/landmark/start/colonist/New()
	..()
	GLOB.colony_spawns += loc

//UNSC SHIP AI

/obj/effect/landmark/start/colony_AI
	name = "UEG Colonial AI"
