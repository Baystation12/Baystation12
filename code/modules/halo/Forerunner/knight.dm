
/mob/living/simple_animal/hostile/knight
	name = "Knight"
	desc = "A Promethean Knight, a frontline soldier of Promethean forces"
	faction = "Forerunner"
	icon = 'code/modules/halo/Forerunner/knight.dmi'
	icon_state = "knight"
	icon_living = "knight"
	icon_dead = "knight"
	universal_speak = 1
	universal_understand = 1
	response_harm = "batters"
	health = 200
	maxHealth = 200
	ranged = 1
	move_to_delay = 5
	resistance = 15
	speak_chance = 0
	pixel_x = -2
	speak = list()
	emote_see = list("scans its body for damage","scans the environment")
	emote_hear = list("buzzes")

	possible_weapons = list(/obj/item/weapon/gun/projectile/boltshot,/obj/item/weapon/gun/projectile/boltshot/shotgun_preload,/obj/item/weapon/gun/projectile/suppressor,/obj/item/weapon/gun/projectile/binary_rifle)
	possible_grenades = list(/obj/item/weapon/grenade/splinter)

	death_sounds = list('code/modules/halo/sounds/forerunner/sentDeath1.ogg','code/modules/halo/sounds/forerunner/sentDeath2.ogg','code/modules/halo/sounds/forerunner/sentDeath3.ogg','code/modules/halo/sounds/forerunner/sentDeath4.ogg')

/mob/living/simple_animal/hostile/knight/doRoll(var/rolldir,var/roll_dist,var/roll_delay)
	var/turf/endpoint = null
	var/turf/step_to = loc
	for(var/i = 0,i < roll_dist,i++)
		step_to = get_step(step_to,rolldir)
		if(step_to.density == 0)
			endpoint = step_to
	if(endpoint && endpoint.density == 0)
		new /obj/effect/knightroll_tp(loc)
		new /obj/effect/knightroll_tp (endpoint)
		forceMove(endpoint)

/mob/living/simple_animal/hostile/knight/death()
	new /obj/effect/knightroll_tp (loc)
	qdel(src)

/mob/living/simple_animal/hostile/knight/cqb
	name = "Knight (CQB)"
	possible_weapons = list(/obj/item/weapon/gun/projectile/boltshot/shotgun_preload)

/mob/living/simple_animal/hostile/knight/assault
	name = "Knight (Assault)"
	possible_weapons = list(/obj/item/weapon/gun/projectile/suppressor)

/mob/living/simple_animal/hostile/knight/sniper
	name = "Knight (Sniper)"
	possible_weapons = list(/obj/item/weapon/gun/projectile/binary_rifle)