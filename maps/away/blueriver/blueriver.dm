//quality code theft
#include "blueriver_areas.dm"
/obj/effect/overmap/visitable/sector/arcticplanet
	name = "arctic planetoid"
	desc = "Sensor array detects an arctic planet with a small vessle on the planet's surface. Scans further indicate strange energy levels below the planet's surface."
	in_space = 0
	icon_state = "globe"
	initial_generic_waypoints = list(
		"nav_blueriv_1",
		"nav_blueriv_2",
		"nav_blueriv_3",
		"nav_blueriv_antag"
	)

/obj/effect/overmap/visitable/sector/arcticplanet/New(nloc, max_x, max_y)
	name = "[generate_planet_name()], \a [name]"
	..()

/datum/map_template/ruin/away_site/blueriver
	name = "Bluespace River"
	id = "awaysite_blue"
	description = "Two z-level map with an arctic planet and an alien underground surface"
	suffixes = list("blueriver/blueriver-1.dmm", "blueriver/blueriver-2.dmm")
	generate_mining_by_z = 2
	area_usage_test_exempted_root_areas = list(/area/bluespaceriver)
	apc_test_exempt_areas = list(
		/area/bluespaceriver/underground = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/bluespaceriver/ground = NO_SCRUBBER|NO_VENT|NO_APC
	)

//This is ported from /vg/ and isn't entirely functional. If it sees a threat, it moves towards it, and then activates it's animation.
//At that point while it sees threats, it will remain in it's attack stage. It's a bug, but I figured it nerfs it enough to not be impossible to deal with
/mob/living/simple_animal/hostile/hive_alien/defender
	name = "hive defender"
	desc = "A terrifying monster resembling a massive, bloated tick in shape. Hundreds of blades are hidden underneath its rough shell."
	icon = 'maps/away/blueriver/blueriver.dmi'
	icon_state = "hive_executioner_move"
	icon_living = "hive_executioner_move"
	icon_dead = "hive_executioner_dead"
	move_to_delay = 5
	speed = -1
	health = 280
	maxHealth = 280
	can_escape = TRUE

	harm_intent_damage = 8
	melee_damage_lower = 30
	melee_damage_upper = 35
	attacktext = "eviscerated"
	attack_sound = 'sound/weapons/slash.ogg'
	var/attack_mode = FALSE

	var/transformation_delay_min = 4
	var/transformation_delay_max = 8

/mob/living/simple_animal/hostile/hive_alien/defender/proc/mode_movement() //Slightly broken, but it's alien and unpredictable so w/e
	set waitfor = 0
	icon_state = "hive_executioner_move"
	flick("hive_executioner_movemode", src)
	sleep(rand(transformation_delay_min, transformation_delay_max))
	anchored = FALSE
	speed = -1
	move_to_delay = 8
	attack_mode = FALSE

	//Immediately find a target so that we're not useless for 1 Life() tick!
	FindTarget()

/mob/living/simple_animal/hostile/hive_alien/defender/proc/mode_attack()
	set waitfor = 0
	icon_state = "hive_executioner_attack"
	flick("hive_executioner_attackmode", src)
	sleep(rand(transformation_delay_min, transformation_delay_max))
	anchored = TRUE
	speed = 0
	attack_mode = TRUE
	walk(src, 0)

/mob/living/simple_animal/hostile/hive_alien/defender/LostTarget()
	if(attack_mode && !FindTarget()) //If we don't immediately find another target, switch to movement mode
		mode_movement()

	return ..()

/mob/living/simple_animal/hostile/hive_alien/defender/LoseTarget()
	if(attack_mode && !FindTarget()) //If we don't immediately find another target, switch to movement mode
		mode_movement()

	return ..()

/mob/living/simple_animal/hostile/hive_alien/defender/AttackingTarget()
	if(!attack_mode)
		return mode_attack()

	flick("hive_executioner_attacking", src)

	return ..()

/mob/living/simple_animal/hostile/hive_alien/defender/wounded
	name = "wounded hive defender"
	health = 80
	can_escape = FALSE

/obj/effect/shuttle_landmark/nav_blueriv/nav1
	name = "Arctic Planet Landing Point #1"
	landmark_tag = "nav_blueriv_1"
	base_area = /area/bluespaceriver/ground

/obj/effect/shuttle_landmark/nav_blueriv/nav2
	name = "Arctic Planet Landing Point #2"
	landmark_tag = "nav_blueriv_2"
	base_area = /area/bluespaceriver/ground

/obj/effect/shuttle_landmark/nav_blueriv/nav3
	name = "Arctic Planet Landing Point #3"
	landmark_tag = "nav_blueriv_3"
	base_area = /area/bluespaceriver/ground

/obj/effect/shuttle_landmark/nav_blueriv/nav4
	name = "Arctic Planet Navpoint #4"
	landmark_tag = "nav_blueriv_antag"
	base_area = /area/bluespaceriver/ground

/turf/simulated/floor/away/blueriver/alienfloor
	name = "glowing floor"
	desc = "The floor glows without any apparent reason"
	icon = 'riverturfs.dmi'
	icon_state = "floor"
	temperature = 233

/turf/simulated/floor/away/blueriver/alienfloor/Initialize()
	.=..()

	set_light(0.7, 1, 5, l_color = "#0066ff")

/turf/unsimulated/wall/away/blueriver/livingwall
	name = "alien wall"
	desc = "You feel a sense of dread from just looking at this wall. Its surface seems to be constantly moving, as if it were breathing."
	icon = 'riverturfs.dmi'
	icon_state = "evilwall_1"
	opacity = 1
	density = 1
	temperature = 233

/turf/unsimulated/wall/away/blueriver/livingwall/Initialize()
	.=..()

	if(prob(80))
		icon_state = "evilwall_[rand(1,8)]"

/turf/unsimulated/wall/supermatter/no_spread
	name = "weird liquid"
	desc = "The viscous liquid glows and moves as if it were alive."
	icon='blueriver.dmi'
	icon_state = "bluespacecrystal1"
	layer = SUPERMATTER_WALL_LAYER
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	opacity = 0
	dynamic_lighting = 0

/turf/unsimulated/wall/supermatter/no_spread/Initialize()
	.=..()

	icon_state = "bluespacecrystal[rand(1,3)]"
	set_light(0.7, 1, 5, l_color = "#0066ff")

/turf/unsimulated/wall/supermatter/no_spread/Process()
	return PROCESS_KILL
