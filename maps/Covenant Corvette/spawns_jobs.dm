GLOBAL_LIST_EMPTY(sangheili_corvette_spawns)

/datum/spawnpoint/sangheili_corvette
	display_name =  "Sangheili Corvette Spawn"
	restrict_job = list("Sangheili - Minor","Sangheili - Major","Sangheili - Ultra","Sangheili - Shipmaster")

/datum/spawnpoint/sangheili_corvette/New()
	..()
	turfs = GLOB.sangheili_corvette_spawns

/obj/effect/landmark/start/sangheili_corvette
	name = "Sangheili Corvette Spawn"

/obj/effect/landmark/start/sangheili_corvette/New()
	..()
	GLOB.sangheili_corvette_spawns += loc

GLOBAL_LIST_EMPTY(kigyar_corvette_spawns)

/datum/spawnpoint/kigyar_corvette
	display_name =  "Kig-Yar Corvette Spawn"
	restrict_job = list("Kig-Yar - Minor","Kig-Yar - Major","Kig-Yar - Shipmistress","T-Vaoan - Major","T-Vaoan - Minor","T-Vaoan - Murmillo")

/datum/spawnpoint/kigyar_corvette/New()
	..()
	turfs = GLOB.kigyar_corvette_spawns

/obj/effect/landmark/start/kigyar_corvette
	name = "Kig-Yar Corvette Spawn"

/obj/effect/landmark/start/kigyar_corvette/New()
	..()
	GLOB.kigyar_corvette_spawns += loc

GLOBAL_LIST_EMPTY(unggoy_corvette_spawns)

/datum/spawnpoint/unggoy_corvette
	display_name =  "Unggoy Corvette Spawn"
	restrict_job = list("Unggoy - Minor","Unggoy - Major")

/datum/spawnpoint/unggoy_corvette/New()
	..()
	turfs = GLOB.unggoy_corvette_spawns

/obj/effect/landmark/start/unggoy_corvette
	name = "Unggoy Corvette Spawn"

/obj/effect/landmark/start/unggoy_corvette/New()
	..()
	GLOB.unggoy_corvette_spawns += loc

