#include "mining_areas.dm"

//MINING-1 // CLUSTER
/obj/effect/overmap/sector/cluster
	name = "asteroid cluster"
	desc = "Large group of asteroids. Mineral content detected."
	icon_state = "sector"
	generic_waypoints = list(
		"nav_cluster_1",
		"nav_cluster_2",
		"nav_cluster_3",
		"nav_cluster_4",
		"nav_cluster_5",
		"nav_cluster_6",
		"nav_cluster_7"
	)
	known = 0

/datum/map_template/ruin/away_site/mining_asteroid
	name = "Mining - Asteroid"
	id = "awaysite_mining_asteroid"
	description = "A medium-sized asteroid full of minerals."
	suffixes = list("mining/mining-asteroid.dmm")
	cost = 1
	accessibility_weight = 10
	spawn_guranteed = TRUE

/obj/effect/shuttle_landmark/cluster/nav1
	name = "Asteroid Navpoint #1"
	landmark_tag = "nav_cluster_1"

/obj/effect/shuttle_landmark/cluster/nav2
	name = "Asteroid Navpoint #2"
	landmark_tag = "nav_cluster_2"

/obj/effect/shuttle_landmark/cluster/nav3
	name = "Asteroid Navpoint #3"
	landmark_tag = "nav_cluster_3"

/obj/effect/shuttle_landmark/cluster/nav4
	name = "Asteroid Navpoint #4"
	landmark_tag = "nav_cluster_4"

/obj/effect/shuttle_landmark/cluster/nav5
	name = "Asteroid Landing zone #1"
	landmark_tag = "nav_cluster_5"
	base_area = /area/mine/explored

/obj/effect/shuttle_landmark/cluster/nav6
	name = "Asteroid Navpoint #5"
	landmark_tag = "nav_cluster_6"

/obj/effect/shuttle_landmark/cluster/nav7
	name = "Asteroid Landing zone #2"
	landmark_tag = "nav_cluster_7"
	base_area = /area/mine/explored

//MINING-2 // SIGNAL
/obj/effect/overmap/sector/away
	name = "faint signal from an asteroid"
	desc = "Faint signal detected, originating from the human-made structures on the site's surface."
	icon_state = "sector"
	generic_waypoints = list(
		"nav_away_1",
		"nav_away_2",
		"nav_away_3",
		"nav_away_4",
		"nav_away_5",
		"nav_away_6",
		"nav_away_7"
	)
	known = 0

/datum/map_template/ruin/away_site/mining_signal
	name = "Mining - Planetoid"
	id = "awaysite_mining_signal"
	description = "A mineral-rich, formerly-volcanic site on a planetoid."
	suffixes = list("mining/mining-signal.dmm")
	cost = 1
	base_turf_for_zs = /turf/simulated/floor/asteroid

/obj/effect/shuttle_landmark/away
	base_area = /area/mine/explored

/obj/effect/shuttle_landmark/away/nav1
	name = "Away Landing zone #1"
	landmark_tag = "nav_away_1"

/obj/effect/shuttle_landmark/away/nav2
	name = "Away Landing zone #2"
	landmark_tag = "nav_away_2"

/obj/effect/shuttle_landmark/away/nav3
	name = "Away Landing zone #3"
	landmark_tag = "nav_away_3"

/obj/effect/shuttle_landmark/away/nav4
	name = "Away Landing zone #4"
	landmark_tag = "nav_away_4"

/obj/effect/shuttle_landmark/away/nav5
	name = "Away Landing zone #5"
	landmark_tag = "nav_away_5"

/obj/effect/shuttle_landmark/away/nav6
	name = "Away Landing zone #6"
	landmark_tag = "nav_away_6"

/obj/effect/shuttle_landmark/away/nav7
	name = "Away Landing zone #7"
	landmark_tag = "nav_away_7"

//MINING-3 // THE ORB
/obj/effect/overmap/sector/orb
	name = "monolithic asteroid"
	desc = "Substantial mineral resources detected."
	icon_state = "sector"
	generic_waypoints = list(
		"nav_orb_1",
		"nav_orb_2",
		"nav_orb_3",
		"nav_orb_4",
		"nav_orb_5",
		"nav_orb_6",
		"nav_orb_7"
	)
	known = 0

/datum/map_template/ruin/away_site/mine
	name = "Mining - Orb"
	id = "awaysite_mining_orb"
	description = "A sort of circular asteroid with a bird."
	suffixes = list("mining/mining-orb.dmm")
	cost = 1
	accessibility_weight = 10

/obj/effect/shuttle_landmark/orb
	base_area = /area/mine/explored

/obj/effect/shuttle_landmark/orb/nav1
	name = "Landing zone #1"
	landmark_tag = "nav_orb_1"

/obj/effect/shuttle_landmark/orb/nav2
	name = "Landing zone #2"
	landmark_tag = "nav_orb_2"

/obj/effect/shuttle_landmark/orb/nav3
	name = "Landing zone #3"
	landmark_tag = "nav_orb_3"

/obj/effect/shuttle_landmark/orb/nav4
	name = "Landing zone #4"
	landmark_tag = "nav_orb_4"

/obj/effect/shuttle_landmark/orb/nav5
	name = "Landing zone #5"
	landmark_tag = "nav_orb_5"

/obj/effect/shuttle_landmark/orb/nav6
	name = "Landing zone #6"
	landmark_tag = "nav_orb_6"

/obj/effect/shuttle_landmark/orb/nav7
	name = "Landing zone #7"
	landmark_tag = "nav_orb_7"

/mob/living/simple_animal/parrot/space
	name = "Simurgh"
	desc = "It could be some all-knowing being that, for reasons we could never hope to understand, is assuming the shape and general mannerisms of a parrot - or just a rather large bird."
	icon = 'icons/mob/bigbird.dmi'
	gender = FEMALE
	health = 750 //how sweet it is to be a god!
	maxHealth = 750
	mob_size = MOB_LARGE
	speak_emote = list("professes","speaks unto you","elaborates","proclaims")
	emote_hear = list("sings a song to herself", "preens herself")
	melee_damage_lower = 15
	melee_damage_upper = 30
	attacktext = "pecked"
	min_gas = null
	max_gas = null
	minbodytemp = 0
	universal_understand = 1
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	see_in_dark = 7
	default_pixel_x = -16 //for resetting after attack animations
	default_pixel_y = -16
	can_escape = 1

/mob/living/simple_animal/parrot/space/Initialize()
	. = ..()
	color = get_random_colour(lower = 200)
	pixel_x = -16
	pixel_y = -16

/obj/structure/showcase/totem
	name = "totem"
	desc = "Some kind of post, pillar, plinth, column, or totem."
	icon_state = "totem"

/obj/item/weapon/stool/stone/New(var/newloc)
	..(newloc,"sandstone")