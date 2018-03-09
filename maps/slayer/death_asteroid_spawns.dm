/datum/map/teamslayer_asteroid
	allowed_spawns = list("Red Spawn","Blue Spawn","Neutral Spawn","Covenant Spawn")
	default_spawn = "Neutral Spawn"


GLOBAL_LIST_EMPTY(latejoin_slayer_neutral)

/datum/spawnpoint/slayer_neutral
	display_name = "Neutral Spawn"
	//msg = "has completed cryogenic revival"
	//disallow_job = list("Blue Team Soldier")

/datum/spawnpoint/slayer_neutral/New()
	..()
	turfs = GLOB.latejoin_slayer_neutral

/obj/effect/landmark/start/slayer_neutral
	name = "Neutral Spawn"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x3"

/obj/effect/landmark/start/slayer_neutral/New()
	..()
	GLOB.latejoin_slayer_neutral += src.loc


//--- RED ---//

GLOBAL_LIST_EMPTY(latejoin_slayer_red)

/datum/spawnpoint/slayer_red
	display_name = "Red Spawn"
	disallow_job = list("Blue Team Spartan")

/datum/spawnpoint/slayer_red/New()
	..()
	turfs = GLOB.latejoin_slayer_red

/obj/effect/landmark/start/slayer_red
	name = "Red Team Spartan"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"

/obj/effect/landmark/start/slayer_red/New()
	..()
	GLOB.latejoin_slayer_red += src.loc


//--- BLUE ---//

GLOBAL_LIST_EMPTY(latejoin_slayer_blue)

/datum/spawnpoint/slayer_blue
	display_name = "Blue Spawn"
	disallow_job = list("Red Team Spartan")

/datum/spawnpoint/slayer_blue/New()
	..()
	turfs = GLOB.latejoin_slayer_blue

/obj/effect/landmark/start/slayer_blue
	name = "Blue Team Spartan"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"

/obj/effect/landmark/start/slayer_blue/New()
	..()
	GLOB.latejoin_slayer_blue += src.loc

//Covenant Spawns//
GLOBAL_LIST_EMPTY(latejoin_slayer_covenant)

/datum/spawnpoint/slayer_covenant
	display_name = "Covenant Spawn"
	disallow_job = list("Spartans")

/datum/spawnpoint/slayer_covenant/New()
	..()
	turfs = GLOB.latejoin_slayer_covenant

/obj/effect/landmark/start/slayer_covenant
	name = "Elites"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"

/obj/effect/landmark/start/slayer_covenant/New()
	..()
	GLOB.latejoin_slayer_covenant += src.loc

//Spartans Spawns - Covenant V Spartans //

/datum/spawnpoint/slayer_spartan_covenant
	display_name = "Spartans"
	disallow_job = list("Elites")

/datum/spawnpoint/slayer_blue/New()
	..()
	turfs = GLOB.latejoin_slayer_red

/obj/effect/landmark/start/slayer_red/spartan_covenant
	name = "Spartans"
