
//----------------------------
// Gold laser beam
//----------------------------
/obj/effect/projectile/laser_gold/tracer
	icon_state = "beam_gold"

/obj/effect/projectile/laser_gold/muzzle
	icon_state = "muzzle_gold"

/obj/effect/projectile/laser_gold/impact
	icon_state = "impact_gold"


//sentinel laser beam

/obj/item/projectile/beam/sentinel
	name = "sentinel beam"
	icon_state = "beam_blue"

	damage = 7.5
	damage_type = BURN
	check_armour = "laser"
	armor_penetration = 15
	tracer_delay_time = 2.5

	muzzle_type = /obj/effect/projectile/laser_gold/muzzle
	tracer_type = /obj/effect/projectile/laser_gold/tracer
	impact_type = /obj/effect/projectile/laser_gold/impact

/obj/item/weapon/gun/energy/laser/sentinel_beam
	name = "Sentinel Beam"
	desc = "A sustained fire beam weapon. It seems to self-recharge using an internal reactor."
	icon = 'code/modules/halo/Forerunner/forerunner_weapons.dmi'
	icon_state = "sentinel_beam"
	self_recharge = 1
	recharge_time = 0
	max_shots = 500
	fire_delay = 20
	charge_meter = 0
	sustain_time = 2 SECONDS
	sustain_delay = 2.5 //Make sure this aligns with the tracer delay time

	fire_sound = 'code/modules/halo/sounds/forerunner/sentFire.ogg'

	projectile_type = /obj/item/projectile/beam/sentinel

/obj/item/weapon/gun/energy/laser/sentinel_beam/handle_click_empty(mob/user)
	if(user)
		to_chat(user,"<span class='info'>[src] is temporarily out of charge, please wait a moment.</span>")


//Found as random loot in forerunner areas (Utilise loot distributor system)//
/obj/item/weapon/gun/energy/laser/sentinel_beam/detached
	sustain_time = 3 SECONDS
	recharge_time = 1
	max_shots = 75


// AI pathing landmark

/obj/effect/landmark/assault_target/sentinel
	name = "sentinel assault target marker"

// Mob

/mob/living/simple_animal/hostile/sentinel
	name = "Sentinel"
	desc = "An automated defence drone made of advanced alien technology."
	faction = "Forerunner"
	icon = 'code/modules/halo/Forerunner/Sentinel.dmi'
	icon_state = "sentinel"
	icon_living = "sentinel"
	icon_dead = "sentinel_dead"
	universal_speak = 1
	universal_understand = 1
	response_harm = "batters"
	health = 150
	maxHealth = 150
	ranged = 1
	move_to_delay = 5
	resistance = 10
	speak_chance = 1
	speak = list()
	emote_see = list("extends and retracts its manipulator arms","scans its body for damage","scans the environment")
	emote_hear = list("buzzes")
	var/obj/item/weapon/gun/energy/laser/sentinel_beam/sentinel_beam
	assault_target_type = /obj/effect/landmark/assault_target/sentinel

	death_sounds = list('code/modules/halo/sounds/forerunner/sentDeath1.ogg','code/modules/halo/sounds/forerunner/sentDeath2.ogg','code/modules/halo/sounds/forerunner/sentDeath3.ogg','code/modules/halo/sounds/forerunner/sentDeath4.ogg')

/mob/living/simple_animal/hostile/sentinel/New()
	. = ..()
	if(isnull(sentinel_beam))
		sentinel_beam = new(src)
	set_light(8)

/mob/living/simple_animal/hostile/sentinel/Life()
	. = ..()
	if(stat != DEAD && health < maxHealth)
		health++

/mob/living/simple_animal/hostile/sentinel/RangedAttack(var/atom/attacked)
	sentinel_beam.afterattack(attacked, src)

/mob/living/simple_animal/hostile/sentinel/death(gibbed, deathmessage = "crashes into the ground!", show_dead_message = 1)
	new /obj/effect/gibspawner/robot(src.loc)
	. = ..(gibbed, deathmessage, show_dead_message)

//how do i shoot gun
/mob/living/simple_animal/hostile/sentinel/IsAdvancedToolUser()
	return 1

/mob/living/simple_animal/hostile/sentinel/get_equivalent_body_part(var/def_zone)
	return "chassis"

/mob/living/simple_animal/hostile/sentinel/bullet_act(var/obj/item/projectile/P, var/def_zone)
	if(istype(P, /obj/item/projectile/beam/sentinel) || istype(P, /obj/item/projectile/beam/monitor) || istype(P, /obj/item/projectile/beam/monitor_stun) )
		if(P.firer)
			if(P.firer.faction == faction)
				return PROJECTILE_FORCE_MISS
		else
			return PROJECTILE_FORCE_MISS

	return ..()

/mob/living/simple_animal/hostile/sentinel/player_sentinel
	name = "Sentinel"
	desc = "An automated defence drone made of advanced alien technology. This one seems to posses some higher-thought functions."
	health = 200
	maxHealth = 200
	resistance = 10

/mob/living/simple_animal/hostile/sentinel/player_sentinel/New()
	sentinel_beam = new /obj/item/weapon/gun/energy/laser/sentinel_beam/detached (src)
	//This beam is balanced for player use, so player sentinel gets one
	. = ..()