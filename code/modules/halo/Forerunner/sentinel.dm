
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

	damage = 5
	damage_type = BURN
	check_armour = "laser"
	armor_penetration = 10
	tracer_delay_time = 2

	muzzle_type = /obj/effect/projectile/laser_gold/muzzle
	tracer_type = /obj/effect/projectile/laser_gold/tracer
	impact_type = /obj/effect/projectile/laser_gold/impact

/obj/item/weapon/gun/energy/laser/sentinel_beam
	name = "Sentinel Beam"
	self_recharge = 1
	recharge_time = 0
	max_shots = 500
	fire_delay = 20
	channel_time = 3 SECONDS
	channel_delay = 2 //Make sure this aligns with the tracer delay time

	//fire_sound = 'code/modules/halo/sounds/Spartan_Laser_Beam_Shot_Sound_Effect.ogg'
	fire_sound = 'sound/weapons/pulse3.ogg'

	projectile_type = /obj/item/projectile/beam/sentinel

/obj/item/weapon/gun/energy/laser/sentinel_beam/handle_click_empty(mob/user)
	if(user)
		to_chat(user,"<span class='info'>[src] is temporarily out of charge, please wait a moment.</span>")


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
	health = 200
	maxHealth = 200
	ranged = 1
	move_to_delay = 5
	resistance = 15
	speak_chance = 1
	speak = list()
	emote_see = list("extends and retracts its manipulator arms","scans its body for damage","scans the environment")
	emote_hear = list("buzzes")
	var/obj/item/weapon/gun/energy/laser/sentinel_beam/sentinel_beam
	assault_target_type = /obj/effect/landmark/assault_target/sentinel

/mob/living/simple_animal/hostile/sentinel/New()
	. = ..()
	sentinel_beam = new(src)
	set_light(6)

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
	if(istype(P, /obj/item/projectile/beam/sentinel))
		return PROJECTILE_FORCE_MISS

	if(istype(P, /obj/item/projectile/beam/monitor))
		return PROJECTILE_FORCE_MISS

	if(istype(P, /obj/item/projectile/beam/monitor_stun))
		return PROJECTILE_FORCE_MISS

	return ..()
