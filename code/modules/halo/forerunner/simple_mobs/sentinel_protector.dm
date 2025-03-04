//Sentinel Protector Beam

/obj/item/weapon/gun/energy/laser/sentinel_beam/protector
    name = "Protector Beam"
    desc = "A Forerunner weapon firing a single, high-energy bolt for devastating impact."
    max_shots = 300
    fire_delay = 15
    burst = 1
    fire_sound = 'code/modules/halo/sounds/protector_sentinel_fire.ogg'
    projectile_type = /obj/item/projectile/beam/sentinel/protector
    self_recharge = 1
    recharge_time = 2
    icon_state = "beam_gold"

/obj/item/projectile/beam/sentinel/protector
    name = "protector high-energy beam"
    icon_state = "beam_gold"
    damage = 50
    shield_damage = 75
    damage_type = BURN
    check_armour = "energy"
    armor_penetration = 30
    tracer_delay_time = 3
    muzzle_type = /obj/effect/projectile/laser_gold/muzzle
    tracer_type = /obj/effect/projectile/laser_gold/tracer
    impact_type = /obj/effect/projectile/laser_gold/impact

//Sentinel Protector Healing Beam

/obj/effect/projectile/healing_beam
    icon = 'code/modules/halo/forerunner/simple_mobs/sentinel_protector.dmi'
    icon_state = "healing_beam"

    New()
        ..()
        spawn(10)
            if(src)
                qdel(src)

//Sentinel Protector Shield

/obj/effect/forerunner_shield_pulse
    name = "shield pulse"
    icon = 'code/modules/halo/forerunner/simple_mobs/sentinel_protector.dmi'
    icon_state = "shield_pulse"
    plane = ABOVE_HUMAN_PLANE
    layer = ABOVE_HUMAN_LAYER

//Mobs

/mob/living/simple_animal/hostile/sentinel/protector
    name = "Protector Sentinel"
    desc = "A basic Forerunner drone designed to support allied units with a powerful high-energy beam."
    faction = "Forerunner"
    icon = 'code/modules/halo/forerunner/simple_mobs/sentinel_protector.dmi'
    icon_state = "sentinel_protector"
    icon_living = "sentinel_protector"
    icon_dead = "sentinel_protector_dead"
    health = 150
    maxHealth = 150
    resistance = 8
    ranged = 1
    move_to_delay = 6
    speak_chance = 1
    emote_see = list("adjusts its beam emitter", "scans for threats", "hovers cautiously")
    emote_hear = list("hums softly")
    death_sounds = list('code/modules/halo/sounds/forerunner/sentDeath1.ogg', 'code/modules/halo/sounds/forerunner/sentDeath2.ogg')
    var/obj/item/weapon/gun/energy/laser/sentinel_beam/protector_beam

    New()
        ..()
        if(isnull(protector_beam))
            protector_beam = new /obj/item/weapon/gun/energy/laser/sentinel_beam/protector(src)
        set_light(5, 2, "#FF0000")

    RangedAttack(atom/A)
        if(!A || !isturf(A.loc))
            return
        protector_beam.afterattack(A, src)

/mob/living/simple_animal/hostile/sentinel/protector/healer
    name = "Healing Protector Sentinel"
    desc = "A Forerunner drone designed to aid and protect allied units with healing energy."
    faction = "Forerunner"
    icon = 'code/modules/halo/forerunner/simple_mobs/sentinel_protector.dmi'
    icon_state = "sentinel_protector_healer"
    icon_living = "sentinel_protector_healer"
    icon_dead = "sentinel_protector_dead"
    health = 150
    maxHealth = 150
    resistance = 10
    ranged = 0
    move_to_delay = 6
    speak_chance = 1
    emote_see = list("emits a soft healing pulse", "scans for wounded allies", "hovers protectively")
    emote_hear = list("hums gently")
    death_sounds = list('code/modules/halo/sounds/forerunner/sentDeath1.ogg', 'code/modules/halo/sounds/forerunner/sentDeath2.ogg')

    New()
        ..()
        sentinel_beam = null
        set_light(5, 2, "#00FF00")

    Life()
        ..()
        if(stat != DEAD)
            heal_allies()

    proc/heal_allies()
        if(world.time - last_shot < 60)
            return
        var/heal_range = 5
        var/heal_amount = 5
        var/healed = FALSE
        for(var/mob/living/M in range(heal_range, src))
            if(M.faction != faction || M.stat == DEAD)
                continue
            if(istype(M, /mob/living/carbon/human))
                var/mob/living/carbon/human/H = M
                if(H.getBruteLoss() > 0 || H.getFireLoss() > 0)
                    H.adjustBruteLoss(-heal_amount)
                    H.adjustFireLoss(-heal_amount)
                    healed = TRUE
            else if(istype(M, /mob/living/simple_animal))
                if(M.health < M.maxHealth)
                    M.health = min(M.maxHealth, M.health + heal_amount)
                    healed = TRUE
            if(healed)
                var/obj/effect/projectile/healing_beam/HB = new(get_turf(src))
                HB.dir = get_dir(src, M)
                HB.forceMove(get_step_towards(HB, M))
        if(healed)
            playsound(src, 'code/modules/halo/sounds/protector_healing_pulse.ogg', 50, 1)
            last_shot = world.time

    RangedAttack(atom/A)
        return

    death(gibbed, deathmessage = "fades into a burst of light!", show_dead_message = 1)
        new /obj/effect/gibspawner/robot(loc)
        ..(gibbed, deathmessage, show_dead_message)

    get_equivalent_body_part(def_zone)
        return "chassis"

    bullet_act(obj/item/projectile/P, def_zone)
        if(istype(P, /obj/item/projectile/beam/sentinel) || istype(P, /obj/item/projectile/beam/monitor) || istype(P, /obj/item/projectile/beam/monitor_stun))
            if(P.firer && P.firer.faction == faction)
                return PROJECTILE_FORCE_MISS
        return ..()

    var/last_shot = 0

/mob/living/simple_animal/hostile/sentinel/protector/shield
    name = "Shield Protector Sentinel"
    desc = "A Forerunner drone that pulses temporary hardlight shields to allied Sentinels."
    icon = 'code/modules/halo/forerunner/simple_mobs/sentinel_protector.dmi'
    icon_state = "sentinel_protector_shield"
    icon_living = "sentinel_protector_shield"
    icon_dead = "sentinel_protector_dead"
    health = 150
    maxHealth = 150
    resistance = 10
    move_to_delay = 6
    ranged = 0
    speak_chance = 1
    emote_see = list("scans for allies", "hovers protectively", "emits a faint hum")
    emote_hear = list("pulses softly")
    death_sounds = list('code/modules/halo/sounds/forerunner/sentDeath1.ogg', 'code/modules/halo/sounds/forerunner/sentDeath2.ogg')
    faction = "Forerunner" // Default, overridden by spawner
    var/last_pulse = 0
    var/pulse_range = 5
    var/pulse_shield = 175    // Shield amount granted
    var/pulse_duration = 600 // 60 seconds
    var/pulse_cooldown = 200 // 20 seconds

    New()
        ..()
        sentinel_beam = null // No ranged weapon
        set_light(5, 2, "#FFFF00")

    Life()
        ..()
        if(stat != DEAD)
            pulse_shields()

    proc/pulse_shields()
        if(world.time - last_pulse < pulse_cooldown)
            return

        var/shielded = FALSE
        for(var/mob/living/simple_animal/hostile/sentinel/S in range(pulse_range, src))
            if(S == src || S.faction != src.faction || S.stat == DEAD)
                continue
            if(S.shield_strength > 0 && world.time < S.shield_timeout)
                continue // Skip if already shielded
            S.shield_strength = pulse_shield
            S.shield_max = pulse_shield
            S.shield_timeout = world.time + pulse_duration
            S.update_icon()
            shielded = TRUE

        if(shielded)
            spawn_effect()
            playsound(src, 'code/modules/halo/sounds/protector_shield_pulse.ogg', 50, 1)
            visible_message("<span class='notice'>[src] emits a protective hardlight pulse to its [src.faction] Sentinels!</span>")
            last_pulse = world.time

    proc/spawn_effect()
        var/obj/effect/E = new /obj/effect/forerunner_shield_pulse(get_turf(src))
        spawn(10) // Delay deletion by 1 second
            qdel(E)
