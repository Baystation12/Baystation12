#include "hydro_areas.dm"

/obj/effect/overmap/sector/hydro
	name = "unregistered hydroponics station"
	desc = "A hydroponics station of unknown origin."
	icon_state = "object"
	known = 0

	generic_waypoints = list(
		"nav_hydro_1",
		"nav_hydro_2",
		"nav_hydro_3")

/obj/effect/shuttle_landmark/nav_hydro/nav1
	name = "Navpoint Fore"
	landmark_tag = "nav_hydro_1"

/obj/effect/shuttle_landmark/nav_hydro/nav2
	name = "Navpoint Starboard"
	landmark_tag = "nav_hydro_2"

/obj/effect/shuttle_landmark/nav_hydro/nav3
	name = "Navpoint Aft"
	landmark_tag = "nav_hydro_3"

/obj/effect/overmap/sector/hydro/New()
	name = "[pick("IRS","IS")] [pick("Persephone", "Demeter", "Lakshmi")]"
	for(var/area/hydro/A)
		A.name = "\improper [name] - [A.name]"
		GLOB.using_map.area_purity_test_exempt_areas += A.type
	..()

/datum/map_template/ruin/away_site/hydro
	name = "Hydroponics Station"
	id = "awaysite_hydro"
	description = "Hydroponics station with farmbots and goats."
	suffixes = list("hydro/hydro.dmm")
	cost = 0.75
	accessibility_weight = 10

/obj/structure/closet/secure_closet/hydroponics/hydro
	name = "hydroponics supplies locker"
	req_access = list()

/mob/living/simple_animal/hostile/retaliate/goat/king/hydro //these goats are powerful but are not the king of goats
	name = "strange goat"
	desc = "Goat is as one can see... right?"
	health = 350
	maxHealth = 350
	melee_damage_lower = 25
	melee_damage_upper = 45

/mob/living/simple_animal/hostile/retaliate/malf_drone/hydro
	name = "Farmbot"
	desc = "The botanist's best friend. There's something slightly off about the way it moves."
	icon = 'maps/away/hydro/hydro.dmi'
	icon_state = "farmbot"
	icon_living = "farmbot"
	icon_dead = "farmbot_dead"
	faction = "farmbots"
	health = 200
	maxHealth = 200
	malfunctioning = 0

/mob/living/simple_animal/hostile/retaliate/malf_drone/hydro/ListTargets()
	if(hostile_drone)
		return view(src, 2)
	else
		return ..()