
//Sentinel Super Beam

/obj/item/projectile/beam/sentinel_super
    name = "super sentinel beam"
    icon_state = "beam_gold"
    damage = 35
    shield_damage = 45
    damage_type = BURN
    check_armour = "energy"
    armor_penetration = 30
    step_delay = 1.5
    kill_count = 25
    muzzle_type = /obj/effect/projectile/laser_gold/muzzle
    tracer_type = /obj/effect/projectile/laser_gold/tracer
    impact_type = /obj/effect/projectile/laser_gold/impact

/obj/item/projectile/beam/sentinel_super/on_impact(atom/A)
    new /obj/effect/explosion(get_turf(src))
    explosion(get_turf(A), -1, 0, 1, 2)
    ..()
    qdel(src)

/obj/item/weapon/gun/energy/laser/sentinel_super_beam
    name = "Super Sentinel Beam"
    desc = "A powerful Forerunner weapon that fires a single, explosive hardlight bolt."
    icon = 'code/modules/halo/Forerunner/forerunner_weapons.dmi'
    icon_state = "sentinel_beam"
    self_recharge = 1
    recharge_time = 2
    max_shots = 600
    fire_delay = 25
    burst = 1
    fire_sound = 'code/modules/halo/sounds/forerunner/sentFire.ogg'
    projectile_type = /obj/item/projectile/beam/sentinel_super

//Mobs

/mob/living/simple_animal/hostile/sentinel/super
    name = "Super Sentinel"
    desc = "A larger, more advanced Forerunner defense drone that fires a single explosive hardlight bolt."
    faction = "Forerunner"
    icon = 'code/modules/halo/forerunner/simple_mobs/sentinel_super.dmi'
    icon_state = "sentinel_super"
    icon_living = "sentinel_super"
    icon_dead = "sentinel_super_dead"
    health = 350
    maxHealth = 350
    resistance = 20
    ranged = 1
    move_to_delay = 4
    speak_chance = 1
    emote_see = list("adjusts its beam emitter", "hovers menacingly", "scans the area with a wide beam")
    emote_hear = list("emits a low hum")
    assault_target_type = /obj/effect/landmark/assault_target/sentinel
    death_sounds = list(
        'code/modules/halo/sounds/forerunner/sentDeath1.ogg',
        'code/modules/halo/sounds/forerunner/sentDeath2.ogg',
        'code/modules/halo/sounds/forerunner/sentDeath3.ogg',
        'code/modules/halo/sounds/forerunner/sentDeath4.ogg'
    )
    var/obj/item/weapon/gun/energy/laser/sentinel_super_beam/sentinel_super_beam = null

/mob/living/simple_animal/hostile/sentinel/super/New()
    ..()
    if(isnull(sentinel_super_beam))
        sentinel_super_beam = new(src)
    set_light(10, 2, "#FFD700") // Gold light consistent with Forerunner theme

/mob/living/simple_animal/hostile/sentinel/super/Life()
    ..()
    if(stat != DEAD && health < maxHealth)
        health = min(health + 2, maxHealth)

/mob/living/simple_animal/hostile/sentinel/super/RangedAttack(atom/A)
    if(!A || !isturf(A.loc))
        return
    if(sentinel_super_beam)
        sentinel_super_beam.afterattack(A, src)

/mob/living/simple_animal/hostile/sentinel/super/death(gibbed, deathmessage = "collapses in a shower of sparks!", show_dead_message = 1)
    new /obj/effect/gibspawner/robot(loc)
    set_light(0)
    ..(gibbed, deathmessage, show_dead_message)

/mob/living/simple_animal/hostile/sentinel/super/IsAdvancedToolUser()
    return 1

/mob/living/simple_animal/hostile/sentinel/super/get_equivalent_body_part(def_zone)
    return "chassis"

/mob/living/simple_animal/hostile/sentinel/super/bullet_act(obj/item/projectile/P, def_zone)
    if(istype(P, /obj/item/projectile/beam/sentinel) || istype(P, /obj/item/projectile/beam/monitor) || istype(P, /obj/item/projectile/beam/monitor_stun))
        if(P.firer && P.firer.faction == faction)
            return PROJECTILE_FORCE_MISS
    return ..()