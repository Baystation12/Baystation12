GLOBAL_LIST_EMPTY(geminus_innie_spawns)

/datum/spawnpoint/geminus_innie
	display_name = "Geminus Innie"
	restrict_job = list("Insurrectionist","Insurrectionist Officer","Insurrectionist Commander","Insurrectionist Orion Defector")

/datum/spawnpoint/geminus_innie/New()
	..()
	turfs = GLOB.geminus_innie_spawns

/obj/effect/landmark/start/geminus_innie
	name = "Geminus Innie"

/obj/effect/landmark/start/geminus_innie/New()
	..()
	GLOB.geminus_innie_spawns += loc
