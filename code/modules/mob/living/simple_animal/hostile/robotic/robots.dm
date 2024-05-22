// Laser version of defense robots: Kiting mobs that pack a moderate punch.

/mob/living/simple_animal/hostile/hivebot/ranged_damage/fleet_robot
	name = "\improper security robot"
	desc = "A relatively recent model of a 'tracker' security subaltern, armed with a laser carbine."
	icon = 'icons/mob/hostile_robot.dmi'
	icon_state = "fleetlaser"
	icon_dead = "fleetlaser"
	faction = "hivebot"
	projectiletype = /obj/item/projectile/beam/smalllaser
	base_attack_cooldown = 1 SECOND
	projectilesound = 'sound/weapons/Laser.ogg'
	projectile_dispersion = 0.5
	projectile_accuracy = -1
	speed = 7
	needs_reload = TRUE
	reload_max = 6
	reload_time = 2 SECONDS
	reload_sound = 'sound/mecha/internaldmgalarm.ogg'

	natural_armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
		)

	ai_holder = /datum/ai_holder/simple_animal/ranged/kiting/threatening/deimos

	var/exploded = FALSE
	var/explosion_radius = 3
	var/explosion_max_power = EX_ACT_HEAVY

	maxHealth = 100
	health = 100

/mob/living/simple_animal/hostile/hivebot/ranged_damage/fleet_robot/Process_Spacemove()
	return 1

/datum/ai_holder/simple_animal/ranged/kiting/threatening/deimos
	speak_chance = 0
	threaten = FALSE
	moonwalk = TRUE
	violent_breakthrough = TRUE
	firing_lanes = TRUE
	run_if_this_close = 3

/mob/living/simple_animal/hostile/hivebot/ranged_damage/fleet_robot/death()
	visible_message(SPAN_DANGER("\The [src]'s body ruptures and explodes!"))
	playsound(src,'sound/weapons/smg_empty_alarm.ogg', 50, 1, -6)
	explosion(loc, explosion_radius, explosion_max_power)
	var/turf/origin = get_turf(src)
	if (origin)
		var/datum/effect/spark_spread/sparks = new
		sparks.set_up(3, 1, origin)
		sparks.start()
		var/list/loot = list()
		for (var/i = rand(1, 2) to 1 step -1)
			loot += new /obj/item/material/shard/shrapnel/steel (origin)
		for (var/i = rand(1, 2) to 1 step -1)
			loot += new /obj/item/material/shard/shrapnel/aluminium (origin)
		if (prob(50))
			loot += new /obj/item/material/shard/shrapnel/titanium (origin)
		if (prob(50))
			loot += new /obj/item/material/shard/shrapnel/copper (origin)
		for (var/obj/item/item as anything in loot)
			item.throw_at(CircularRandomTurfAround(origin, Frand(2, 6)), 5, 5)
	qdel(src)

// Ion version of the defending robots. Watch the friendly fire!

/mob/living/simple_animal/hostile/hivebot/ranged_damage/fleet_robot/ion
	desc = "A relatively recent model of a 'tracker' security subaltern, armed with an ion rifle."
	projectiletype = /obj/item/projectile/ion
	projectilesound = 'sound/weapons/Laser.ogg'
	icon_state = "fleetmagnetic"
	icon_dead = "fleetmagnetic"
	projectile_dispersion = 1
	projectile_accuracy = 0
	base_attack_cooldown = 2 SECONDS
	needs_reload = FALSE

// Ballistic version of the defending robots. Deals way more damage than your regular bot.

/mob/living/simple_animal/hostile/hivebot/ranged_damage/fleet_robot/ballistic
	desc = "A relatively recent model of a 'tracker' security subaltern, armed with a sub-machine gun."
	projectiletype = /obj/item/projectile/bullet/pistol/holdout
	casingtype = /obj/item/ammo_casing/pistol/small
	projectilesound = 'sound/weapons/gunshot/gunshot_smg.ogg'
	base_attack_cooldown = 0.5 SECONDS
	projectile_dispersion = 2
	icon_state = "fleetrifle"
	icon_dead = "fleetrifle"
	reload_max = 12
	reload_time = 2 SECONDS
	reload_sound = 'sound/weapons/smg_empty_alarm.ogg'

/obj/item/projectile/beam/bunkerbuster
	name = "accelerated particle projection"
	icon_state = "u_laser"
	fire_sound = 'sound/weapons/marauder.ogg'
	damage = 90
	penetrating = 6
	armor_penetration = 50
	distance_falloff = 0
	damage_falloff_list = list(
		list(6, 1),
		list(9, 1),
		list(11, 0.9),
	)

	muzzle_type = /obj/projectile/laser/pulse/muzzle
	tracer_type = /obj/projectile/laser/pulse/tracer
	impact_type = /obj/projectile/laser/pulse/impact
	penetration_modifier = 1.5

/obj/item/projectile/beam/bunkerbuster/check_penetrate(atom/A)
	..()

	var/chance = damage
	var/datum/extension/penetration/P = get_extension(A, /datum/extension/penetration)
	if(P)
		chance = min(100, P.PenetrationProbability(chance, damage, damage_type) * penetration_modifier)

	if(prob(chance))
		if(A.opacity)
			A.visible_message(SPAN_WARNING("\The [src] pierces through \the [A]!"))
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/fleet_heavy
	name = "\improper hullbreaker monitor"
	desc = "A Massive, heavily armored drone with anti-gravity propulsion and a particle-projector cannon mounted on its front. <span class='danger'>The exposed back-mounted reactor crackles with barely-restrained energy.</span>"
	icon = 'icons/mob/hostile_robot_big.dmi'
	default_pixel_x = -16
	default_pixel_y = -16
	pixel_x = -16
	pixel_y = -16
	faction = "hivebot"
	icon_state = "fleet_artillery"
	icon_living = "fleet_artillery"
	icon_dead = "fleet_artillery"
	projectilesound = 'sound/effects/heavy_cannon_blast.ogg'
	ranged = TRUE
	projectiletype = /obj/item/projectile/beam/bunkerbuster

	min_gas = null
	max_gas = null
	minbodytemp = 0
	speed = 4
	bleed_colour = SYNTH_BLOOD_COLOUR

	meat_type =     null
	meat_amount =   0
	bone_material = null
	bone_amount =   0
	skin_material = null
	skin_amount =   0

	maxHealth = 150
	health = 150
	can_escape = TRUE

	natural_armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
		)

	var/exploded = FALSE
	var/explosion_radius = 5
	var/explosion_max_power = EX_ACT_DEVASTATING

	/// Lower bound for explosion delay.
	var/explosion_delay_lower	= 4 SECONDS
	/// Upper bound for explosion delay.
	var/explosion_delay_upper	= 6 SECONDS

	ai_holder = /datum/ai_holder/simple_animal/ranged/kiting/threatening/fleet_heavy

	ranged_attack_delay = 2 SECOND //How much time we wait before really shooting

/datum/ai_holder/simple_animal/ranged/kiting/threatening/fleet_heavy
	firing_lanes = FALSE        // Lets you use others as shields
	returns_home = TRUE     // So it won't chase you forever
	violent_breakthrough = TRUE //It won't try to break walls and such maybe? Modify as needed
	moonwalk = TRUE
	run_if_this_close = 3

/mob/living/simple_animal/hostile/fleet_heavy/ranged_pre_animation(atom/A)
	//Create an effect that will ease out
	//we could use do_attack_effect here, but doesnt give a lot of freedom for animation

	var/image/I = image('icons/effects/Targeted.dmi', A, "lockonbig")
	I.AddOverlays(
		emissive_appearance(icon, "lockonbig"),
		"lockonbig"
	)

	if (!I)
		return

	flick_overlay(I, GLOB.clients, ranged_attack_delay)

	// And animate the attack!
	animate(
		I,
		alpha = 255,
		transform = matrix().Update(scale_x = 0.75, scale_y = 0.75),
		pixel_x = 0,
		pixel_y = 0,
		pixel_z = 0,
		time = ranged_attack_delay
	)
	icon_state = "fleet_artillery_firing"
	animate(time = 1)
	animate(alpha = 0, time = ranged_attack_delay, easing = CIRCULAR_EASING|EASE_OUT)
	. = ..()

/mob/living/simple_animal/hostile/fleet_heavy/shoot_target(atom/A)
	set waitfor = FALSE
	visible_message(SPAN_DANGER("\The [src]'s weapons begin humming loudly as they're aimed against [A]!"))
	playsound(src,'sound/weapons/smg_empty_alarm.ogg', 50, 1, -6)
	//This thing doesn't actually shoot at you, it shoots at where you were when proc was called. Bit of a different thing.
	. = ..(get_turf(A))

	//now, delay the creature a bit before AI decides on a new path

/mob/living/simple_animal/hostile/fleet_heavy/ranged_post_animation(atom/A)

	icon_state = "fleet_artillery"

	set_AI_busy(TRUE)

	sleep(3 SECONDS)

	set_AI_busy(FALSE)

/mob/living/simple_animal/hostile/fleet_heavy/death()
	visible_message(SPAN_DANGER("\The [src]'s back begins to crack and hum!"))
	playsound(src,'sound/effects/cascade.ogg', 50, 1, -6)
	var/delay = rand(explosion_delay_lower, explosion_delay_upper)
	addtimer(new Callback(src, PROC_REF(flash), delay), 0)

	return ..()

/mob/living/simple_animal/hostile/fleet_heavy/proc/flash(delay)
	// Flash yellow and red as a warning.
	for (var/i = 1 to delay)
		if (i % 2 == 0)
			color = "#feffd0"
		else
			color = "#ff0000"
		sleep(1)

	detonate()

/mob/living/simple_animal/hostile/fleet_heavy/proc/detonate()
	// The actual boom.
	if (src && !exploded)
		visible_message(SPAN_DANGER("\The [src]'s body detonates!"))
		exploded = TRUE
		explosion(loc, explosion_radius, explosion_max_power)
		qdel(src)

/mob/living/simple_animal/hostile/fleet_heavy/Process_Spacemove()
	return TRUE

/obj/aura/mobshield
	icon = 'icons/mecha/shield.dmi'
	name = "mechshield"
	icon_state = "shield_null"
	layer = ABOVE_HUMAN_LAYER
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	mouse_opacity = 0
	var/max_block = 60 // Should block most things - Max AP or damage it can block, else it will just go through.

/obj/aura/mobshield/added_to(mob/living/target)
	. = ..()
	target.vis_contents += src
	flick("shield_raise", src) //Animation on add / spawn
	set_dir() //the whole dir bit is for rendering, if you dont use this just remove this and the GLOB.dir_set_event stuff
	GLOB.dir_set_event.register(user, src, TYPE_PROC_REF(/obj/aura/mobshield, update_dir))

/obj/aura/mobshield/proc/update_dir(user, old_dir, dir)
	set_dir(dir) //Theres ways to make vis contents inherit dir but eh

/obj/aura/mobshield/Destroy()
	if(user)
		GLOB.dir_set_event.unregister(user, src, TYPE_PROC_REF(/obj/aura/mechshield, update_dir))
		user.vis_contents -= src
	. = ..()

/obj/aura/mobshield/proc/block_chance(damage, pen, atom/source, mob/attacker)
	if (damage > max_block || pen > max_block) //Could also add them, your choice here
		return 0
	else
		var/effective_block = 100 //% chance of blocking from front

		var/bad_arc = reverse_direction(user.dir) //arc of directions from which we cannot block

		if(check_shield_arc(user, bad_arc, source, attacker))
			effective_block = 100 //Front and sides
		else
			effective_block = 0 //From behind

		return effective_block

/obj/aura/mobshield/aura_check_bullet(obj/item/projectile/proj, def_zone)
	if (prob(block_chance(proj.damage, proj.armor_penetration, source = proj)))
		user.visible_message(SPAN_WARNING("\The [user]'s shields flash and crackle."))
		flick("shield_drop", src)
		playsound(user,'sound/effects/basscannon.ogg',35,1)
		new /obj/effect/smoke/illumination(user.loc, 5, 4, 1, "#ffffff")
		return AURA_FALSE|AURA_CANCEL
	visible_message(SPAN_DANGER("\The [src]'s exposed back dents and buckles!"))
	playsound(user,'sound/items/Welder2.ogg',35,1)
	return EMPTY_BITFIELD

/obj/aura/mobshield/aura_check_thrown(atom/movable/thrown_atom, datum/thrownthing/thrown_datum)
	. = ..()
	var/throw_damage = 0
	if (isobj(thrown_atom))
		var/obj/object = thrown_atom
		throw_damage = object.throwforce * (thrown_datum.speed / THROWFORCE_SPEED_DIVISOR)

	if (prob(block_chance(throw_damage, 0, source = thrown_atom, attacker = thrown_datum.thrower)))
		user.visible_message(SPAN_WARNING("\The [thrown_atom] bounces off \the [user]'s shields."))
		playsound(user.loc, 'sound/weapons/Genhit.ogg', 50, 1)
		flick("shield_drop", src)
		return AURA_FALSE|AURA_CANCEL

/obj/aura/mobshield/aura_check_weapon(obj/item/weapon, mob/attacker, click_params)
	. = ..()
	if (prob(block_chance(weapon.force, weapon.armor_penetration, source = weapon, attacker = attacker)))
		user.visible_message(SPAN_WARNING("\The [weapon] is blocked by \the [user]'s shields."))
		playsound(user.loc, 'sound/weapons/Genhit.ogg', 50, TRUE)
		flick("shield_drop", src)
		return AURA_FALSE|AURA_CANCEL

/mob/living/simple_animal/hostile/fleet_heavy/Initialize()
	. = ..()
	new /obj/aura/mobshield(src)
