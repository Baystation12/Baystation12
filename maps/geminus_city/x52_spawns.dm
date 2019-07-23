GLOBAL_LIST_EMPTY(x52_base_spawns)

/datum/spawnpoint/x52
	display_name = "X52 Researcher"
	restrict_job = list("X52 Researcher")

/datum/spawnpoint/x52/New()
	..()
	turfs = GLOB.x52_base_spawns

/obj/effect/landmark/start/x52
	name = "X52"

/obj/effect/landmark/start/x52/New()
	..()
	GLOB.x52_base_spawns += loc

///////////////////////////////////////////////////////

GLOBAL_LIST_EMPTY(x52_rd_base_spawns)

/datum/spawnpoint/x52_rd
	display_name = "X52 RD"
	restrict_job = list("X52 Research Director")

/datum/spawnpoint/x52_rd/New()
	..()
	turfs = GLOB.x52_rd_base_spawns

/obj/effect/landmark/start/x52_rd
	name = "X52 Research Director"

/obj/effect/landmark/start/x52_rd/New()
	..()
	GLOB.x52_rd_base_spawns += loc
