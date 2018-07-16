#include "mining_areas.dm"

//MINING-1 // CLUSTER
/obj/effect/overmap/sector/cluster
	name = "asteroid cluster"
	desc = "Large group of asteroids. Mineral content detected."
	icon_state = "sector"
	initial_generic_waypoints = list(
		"nav_cluster_1",
		"nav_cluster_2",
		"nav_cluster_3",
		"nav_cluster_4",
		"nav_cluster_5",
		"nav_cluster_6",
		"nav_cluster_7"
	)
	known = 0
	start_x = 4
	start_y = 5

/datum/map_template/ruin/away_site/mining_asteroid
	name = "Mining - Asteroid"
	id = "awaysite_mining_asteroid"
	description = "A medium-sized asteroid full of minerals."
	suffixes = list("mining/mining-asteroid.dmm")
	cost = 1
	accessibility_weight = 10
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

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
	initial_generic_waypoints = list(
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
	initial_generic_waypoints = list(
		"nav_orb_1",
		"nav_orb_2",
		"nav_orb_3",
		"nav_orb_4",
		"nav_orb_5",
		"nav_orb_6",
		"nav_orb_7"
	)
	known = 0

/datum/map_template/ruin/away_site/orb
	name = "Mining - Orb"
	id = "awaysite_mining_orb"
	description = "A sort of circular asteroid with a bird."
	suffixes = list("mining/mining-orb.dmm")
	cost = 1
	accessibility_weight = 10
	base_turf_for_zs = /turf/simulated/floor/asteroid

/obj/effect/shuttle_landmark/orb/nav1
	name = "Anchor point A"
	landmark_tag = "nav_orb_1"

/obj/effect/shuttle_landmark/orb/nav2
	name = "Anchor point B"
	landmark_tag = "nav_orb_2"

/obj/effect/shuttle_landmark/orb/nav3
	name = "Anchor point C"
	landmark_tag = "nav_orb_3"

/obj/effect/shuttle_landmark/orb/nav4
	name = "Anchor point D"
	landmark_tag = "nav_orb_4"

/obj/effect/shuttle_landmark/orb/nav5
	name = "Anchor point E"
	landmark_tag = "nav_orb_5"

/obj/effect/shuttle_landmark/orb/nav6
	name = "Anchor point F"
	landmark_tag = "nav_orb_6"

/obj/effect/shuttle_landmark/orb/nav7
	name = "Landing zone A"
	landmark_tag = "nav_orb_7"
	base_area = /area/mine/explored

/mob/living/simple_animal/parrot/space
	name = "space parrot"
	desc = "It could be some all-knowing being that, for reasons we could never hope to understand, is assuming the shape and general mannerisms of a parrot - or just a rather large bird."
	icon = 'icons/mob/parrot_grey.dmi'
	gender = FEMALE
	health = 750 //how sweet it is to be a god!
	maxHealth = 750
	mob_size = MOB_LARGE
	speak_emote = list("professes","speaks unto you","elaborates","proclaims")
	emote_hear = list("sings a song to herself", "preens herself")
	melee_damage_lower = 20
	melee_damage_upper = 40
	attacktext = "pecked"
	min_gas = null
	max_gas = null
	minbodytemp = 0
	universal_understand = 1
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	see_in_dark = 7
	can_escape = 1

/mob/living/simple_animal/parrot/space/Initialize()
	. = ..()
	name = pick("Simurgh", "Ziz", "Phoenix", "Fenghuang", "Roc of Ages")
	var/matrix/M = new
	M.Scale(2)
	transform = M
	color = get_random_colour(lower = 190)


/obj/structure/totem
	name = "totem"
	desc = "Some kind of post, pillar, plinth, column, or totem."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "totem"
	density = 1
	anchored = 1
	unacidable = 1
	var/number

/obj/structure/totem/Initialize()
	. = ..()
	number = rand(10,99)

/obj/structure/totem/examine()
	..()
	to_chat(usr, "It's been engraved with the symbols '<font face='Shage'>RWH QaG [number]</font>'.") //i am not a linguist


/obj/item/weapon/stool/stone/New(var/newloc)
	..(newloc,"sandstone")

/turf/simulated/floor/airless/stone
	name = "temple floor"
	desc = "You can only imagine what once took place in these halls."
	icon = 'icons/turf/flooring/cult.dmi'
	icon_state = "cult_g"
	color = "#c9ae5e"
