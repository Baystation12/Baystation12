
//----------------------------
// Gold laser beam
//----------------------------
/obj/effect/projectile/laser_gold/tracer
	icon_state = "beam_gold"

/obj/effect/projectile/laser_gold/muzzle
	icon_state = "muzzle_gold"

/obj/effect/projectile/laser_gold/impact
	icon_state = "impact_gold"


//Sentinel Beam

/obj/item/projectile/beam/sentinel
	name = "sentinel beam"
	icon_state = "beam_blue"

	damage = 10
	shield_damage = 30
	damage_type = BURN
	check_armour = "energy"
	armor_penetration = 20
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
	recharge_time = 1
	max_shots = 500
	fire_delay = 20
	burst_delay = 1.5
	burst = 7
	charge_meter = 0

	fire_sound = 'code/modules/halo/sounds/forerunner/sentFire.ogg'

	projectile_type = /obj/item/projectile/beam/sentinel

/obj/item/weapon/gun/energy/laser/sentinel_beam/handle_click_empty(mob/user)
	if(user)
		to_chat(user,"<span class='info'>[src] is temporarily out of charge, please wait a moment.</span>")


//Found as random loot in forerunner areas (Utilise loot distributor system)//
/obj/item/weapon/gun/energy/laser/sentinel_beam/detached
	burst = 10
	fire_delay = 10
	recharge_time = 25
	max_shots = 100
	one_hand_penalty = 3


//AI Pathing Landmark

/obj/effect/landmark/assault_target/sentinel
	name = "sentinel assault target marker"

//Mobs

/mob/living/simple_animal/hostile/sentinel
    name = "Sentinel"
    desc = "An automated defence drone made of advanced alien technology."
    faction = "Forerunner"
    icon = 'code/modules/halo/forerunner/simple_mobs/sentinel.dmi'
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
    resistance = 15
    speak_chance = 1
    speak = list()
    emote_see = list("extends and retracts its manipulator arms", "scans its body for damage", "scans the environment")
    emote_hear = list("buzzes")
    var/obj/item/weapon/gun/energy/laser/sentinel_beam/sentinel_beam
    assault_target_type = /obj/effect/landmark/assault_target/sentinel
    death_sounds = list('code/modules/halo/sounds/forerunner/sentDeath1.ogg', 'code/modules/halo/sounds/forerunner/sentDeath2.ogg', 'code/modules/halo/sounds/forerunner/sentDeath3.ogg', 'code/modules/halo/sounds/forerunner/sentDeath4.ogg')
    // Shield Variables
    var/shield_strength = 0
    var/shield_max = 0
    var/shield_timeout = 0

    New()
        ..()
        if(!sentinel_beam)
            sentinel_beam = new /obj/item/weapon/gun/energy/laser/sentinel_beam(src)
        update_icon()

    Life()
        ..()
        if(stat != DEAD)
            if(shield_strength > 0 && world.time > shield_timeout)
                shield_strength = 0
                shield_max = 0
                shield_timeout = 0
                update_icon()
            overlays -= "shield_flicker"

    update_icon()
        overlays.Cut()
        if(stat == DEAD)
            icon_state = icon_dead
        else
            icon_state = icon_living
        if(shield_strength > 0 && world.time <= shield_timeout)
            overlays += "shield"

    adjustBruteLoss(damage)
        if(damage > 0 && shield_strength > 0 && world.time <= shield_timeout)
            overlays |= "shield_flicker"
            var/shield_absorbed = min(shield_strength, damage)
            shield_strength -= shield_absorbed
            damage -= shield_absorbed
            if(shield_strength <= 0)
                shield_strength = 0
                update_icon()
        return ..(damage)

    bullet_act(obj/item/projectile/P)
        if(P.damage > 0)
            adjustBruteLoss(P.damage)
        return ..()

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

/mob/living/simple_animal/hostile/sentinel/major
	name = "Sentinel Major"
	desc = "An automated defence drone made of advanced alien technology, this one seems to be a more advanced variant."
	icon_state = "sentinel_major"
	icon_living = "sentinel_major"
	icon_dead = "sentinel_major_dead"
	health = 200
	maxHealth = 200

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