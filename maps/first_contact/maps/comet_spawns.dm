GLOBAL_LIST_EMPTY(innie_crew_spawns)

/datum/spawnpoint/innie_crew
	display_name = "Innie Crew"
	restrict_job = list("Insurrectionist Ship Crew","Insurrectionist Ship Captain")

/datum/spawnpoint/innie_crew/New()
	..()
	turfs = GLOB.innie_crew_spawns

/obj/effect/landmark/start/innie_crew
	name = "Innie Crew"

/obj/effect/landmark/start/innie_crew/New()
	..()
	GLOB.innie_crew_spawns += loc
