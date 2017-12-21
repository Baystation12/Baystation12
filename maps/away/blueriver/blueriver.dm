//quality code theft
#include "blueriver-1.dmm"
#include "blueriver-2.dmm"
#include "blueriver_areas.dm"
/obj/effect/overmap/sector/arcticplanet
	name = "Arctic Planet"
	desc = "Sensor array detects an arctic planet with a small vessle on the surface. Scans further indicate strange energy levels below the planet's surface."
	name = "Arctic Planet"
	generic_waypoints = list(
		"nav_blueriv_1",
		"nav_blueriv_2",
		"nav_blueriv_3",
		"nav_blueriv_antag"
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

	harm_intent_damage = 8
	melee_damage_lower = 30
	melee_damage_upper = 35
	attacktext = "evisceratds"
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
	name = "Glowing Floor"
	desc = "The floor glows without any apparent reason"
	icon = 'riverturfs.dmi'
	icon_state = "floor"
	temperature = 233


/turf/simulated/floor/away/blueriver/alienfloor/Initialize()
	.=..()

///turf/simulated/floor/away/blueriver/alienfloor/Initial()
	set_light(l_range = 5, l_power = 2, l_color = "#0066FF")


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

///turf/unsimulated/wall/away/blueriver/livingwall/Initial()
//	..()

	if(prob(80))
		icon_state = "evilwall_[rand(1,8)]"

/turf/unsimulated/wall/supermatterriver
	name = "Unknown"
	desc = "The viscous liquid glows and moves as if it were alive."
	icon='blueriver.dmi'
	icon_state = "bluespacecrystal1"
	layer = SUPERMATTER_WALL_LAYER
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	opacity = 0
	dynamic_lighting = 0

/turf/unsimulated/wall/supermatterriver/Initialize()
	.=..()

///turf/unsimulated/wall/supermatterriver/Initial()
	icon_state = "bluespacecrystal[rand(1,3)]"
	set_light(l_range = 5, l_power = 2, l_color = "#0066FF")

/turf/unsimulated/wall/supermatterriver/attack_generic(mob/user as mob)
	if(istype(user))
		return attack_hand(user)

/turf/unsimulated/wall/supermatterriver/attack_robot(mob/user as mob)
	if(Adjacent(user))
		return attack_hand(user)
	else
		user.examinate(src)

/turf/unsimulated/wall/supermatterriver/attack_ghost(mob/user as mob)
	user.examinate(src)

/turf/unsimulated/wall/supermatterriver/attack_ai(mob/user as mob)
	user.examinate(src)

#define MayConsume(A) (istype(A) && A.simulated && !isobserver(A))

/turf/unsimulated/wall/supermatterriver/attack_hand(mob/user as mob)
	if(!MayConsume(user))
		return
	user.visible_message("<span class=\"warning\">\The [user] reaches out and touches \the [src]... And then blinks out of existance.</span>",\
		"<span class=\"danger\">You reach out and touch \the [src]. Everything immediately goes quiet. Your last thought is \"That was not a wise decision.\"</span>",\
		"<span class=\"warning\">You hear an unearthly noise.</span>")

	playsound(src, 'sound/effects/supermatter.ogg', 50, 1)
	qdel(user)

/turf/unsimulated/wall/supermatterriver/attackby(obj/item/weapon/W as obj, mob/living/user as mob)
	if(!MayConsume(W))
		return

	user.visible_message("<span class=\"warning\">\The [user] touches \a [W] to \the [src] as a silence fills the room...</span>",\
		"<span class=\"danger\">You touch \the [W] to \the [src] when everything suddenly goes silent.\"</span>\n<span class=\"notice\">\The [W] flashes into dust as you flinch away from \the [src].</span>",\
		"<span class=\"warning\">Everything suddenly goes silent.</span>")

	playsound(src, 'sound/effects/supermatter.ogg', 50, 1)
	user.drop_from_inventory(W)
	Consume(W)


/turf/unsimulated/wall/supermatterriver/Bumped(var/atom/movable/AM)
	if(!MayConsume(AM))
		return

	if(istype(AM, /mob/living))
		AM.visible_message("<span class=\"warning\">\The [AM] slams into \the [src] inducing a resonance... \his body starts to glow and catch flame before flashing into ash.</span>",\
		"<span class=\"danger\">You slam into \the [src] as your ears are filled with unearthly ringing. Your last thought is \"Oh, fuck.\"</span>",\
		"<span class=\"warning\">You hear an unearthly noise as a wave of heat washes over you.</span>")
		Consume(AM)

	else
		AM.visible_message("<span class=\"warning\">\The [AM] smacks into \the [src] and rapidly flashes to ash.</span>",\
		"<span class=\"warning\">You hear a loud crack as you are washed with a wave of heat.</span>")
		Consume(AM)


	playsound(src, 'sound/effects/supermatter.ogg', 50, 1)

/turf/unsimulated/wall/supermatterriver/Entered(var/atom/movable/AM)
	Bumped(AM)


/turf/unsimulated/wall/supermatterriver/proc/Consume(atom/AM)
	return AM.supermatter_act(src)

#undef MayConsume