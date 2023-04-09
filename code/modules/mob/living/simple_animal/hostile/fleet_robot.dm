/mob/living/simple_animal/hostile/hivebot/ranged_damage/fleet
	name = "\improper security robot"
	desc = "A relatively recent model of a 'tracker' security subaltern, armed with a laser carbine and bearing unconspicious green and copper markings over sol blue."
	icon = 'icons/mob/simple_animal/smallrobot.dmi'
	icon_state = "deimoslaser"
	icon_dead = "deimoslaser"
	faction = "deimos"
	projectiletype = /obj/item/projectile/beam/smalllaser
	base_attack_cooldown = 10
	projectilesound = 'sound/weapons/Laser.ogg'
	projectile_dispersion = 0
	projectile_accuracy = 1
	speed = 7

	natural_armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
		)

	ai_holder = /datum/ai_holder/simple_animal/hostile/hivebot/ranged_damage/fleet

	var/exploded = FALSE
	var/explosion_radius = 1
	var/explosion_max_power = EX_ACT_LIGHT

	/// Lower bound for explosion delay.
	var/explosion_delay_lower	= 3 SECONDS
	/// Upper bound for explosion delay.
	var/explosion_delay_upper	= 5 SECONDS

	maxHealth = 100
	health = 100

/datum/ai_holder/simple_animal/hostile/hivebot/ranged_damage/fleet
	pointblank = TRUE
	speak_chance = 0
	threaten = FALSE

/mob/living/simple_animal/hostile/hivebot/ranged_damage/fleet/death()
	src.visible_message(SPAN_DANGER("\The [src]'s body begins to shine brightly!"))
	playsound(src,'sound/weapons/smg_empty_alarm.ogg', 50, 1, -6)
	var/delay = rand(explosion_delay_lower, explosion_delay_upper)
	addtimer(new Callback(src, .proc/flash, delay), 0)

	return ..()

/mob/living/simple_animal/hostile/hivebot/ranged_damage/fleet/proc/flash(delay)
	// Flash black and red as a warning.
	for (var/i = 1 to delay)
		if (i % 2 == 0)
			color = "#000000"
		else
			color = "#ff0000"
		sleep(1)

	detonate()

/mob/living/simple_animal/hostile/hivebot/ranged_damage/fleet/proc/detonate()
	// The actual boom.
	if (src && !exploded)
		src.visible_message(SPAN_DANGER("\The [src]'s body detonates!"))
		playsound(src,'sound/weapons/smg_empty_alarm.ogg', 50, 1, -6)
		exploded = TRUE
		explosion(loc, explosion_radius, explosion_max_power)
		qdel(src)

/mob/living/simple_animal/hostile/hivebot/ranged_damage/fleet/ion
	desc = "A relatively recent model of a 'tracker' security subaltern, armed with an ion rifle and bearing unconspicious green and copper markings over sol blue."
	projectiletype = /obj/item/projectile/ion
	projectilesound = 'sound/weapons/Laser.ogg'
	icon_state = "deimosmagnetic"
	icon_dead = "deimosmagnetic"

/mob/living/simple_animal/hostile/hivebot/ranged_damage/fleet/ballistic
	desc = "A relatively recent model of a 'tracker' security subaltern, armed with sub-machine gun and bearing unconspicious green and copper markings over sol blue."
	projectiletype = /obj/item/projectile/bullet/flechette
	projectilesound = 'sound/weapons/gunshot/gunshot_smg.ogg'
	base_attack_cooldown = 4 // Use sparingly, if people rush the ship. Can easily take down mechs and people if teamed with some meatwall units.
	icon_state = "deimosrifle"
	icon_dead = "deimosrifle"

// BIG TELEGRAPHED MOB

/obj/item/projectile/beam/bunkerbuster
	name = "accelerated particle projection"
	icon_state = "u_laser"
	fire_sound = 'sound/weapons/marauder.ogg'
	damage = 90
	penetrating = 3
	armor_penetration = 50
	distance_falloff = 0
	damage_falloff_list = list(
		list(6, 1),
		list(9, 1),
		list(11, 0.9),
	)

	muzzle_type = /obj/effect/projectile/laser/pulse/muzzle
	tracer_type = /obj/effect/projectile/laser/pulse/tracer
	impact_type = /obj/effect/projectile/laser/pulse/impact

/mob/living/simple_animal/hostile/fleetheavy
	name = "\improper hullbreaker monitor"
	desc = "A Massive, heavily armored drone with anti-gravity propulsion and a particle-projector cannon mounted on its front. <span class='danger'>The exposed back-mounted reactor crackles with barely-restrained energy.</span>"
	icon = 'icons/mob/simple_animal/bigrobot.dmi'
	pixel_x = -16
	pixel_y = -16
	faction = "deimos"
	icon_state = "deimosbig"
	icon_living = "deimosbig"
	icon_dead = "deimosbig"
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

	maxHealth = 70
	health = 70
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
	var/explosion_delay_lower	= 3 SECONDS
	/// Upper bound for explosion delay.
	var/explosion_delay_upper	= 5 SECONDS

	ai_holder = /datum/ai_holder/simple_animal/ranged/kiting/threatening/fleetheavy

	ranged_attack_delay = 2 SECONDS //How much time we wait before really shooting

/datum/ai_holder/simple_animal/ranged/kiting/threatening/fleetheavy
	firing_lanes = TRUE        // Lets you use others as shields
	returns_home = TRUE     // So it won't chase you forever
	violent_breakthrough = FALSE //It won't try to break walls and such maybe? Modify as needed
	moonwalk = TRUE

/mob/living/simple_animal/hostile/fleetheavy/ranged_pre_animation(atom/A)
	//Create an effect that will ease out
	//we could use do_attack_effect here, but doesnt give a lot of freedom for animation

	var/image/I = image('icons/mob/simple_animal/smallrobot.dmi', A, "lockonbig")
	I.plane = EFFECTS_ABOVE_LIGHTING_PLANE

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
	animate(time = 1)
	animate(alpha = 0, time = ranged_attack_delay, easing = CIRCULAR_EASING|EASE_OUT)
	. = ..()

/mob/living/simple_animal/hostile/fleetheavy/shoot_target(atom/A)
	set waitfor = FALSE
	src.visible_message(SPAN_DANGER("\The [src]'s weapons begin humming loudly as they're aimed against [A]!"))
	playsound(src,'sound/weapons/smg_empty_alarm.ogg', 50, 1, -6)
	//This thing doesn't actually shoot at you, it shoots at where you were when proc was called. Bit of a different thing.
	. = ..(get_turf(A))

	//now, delay the creature a bit before AI decides on a new path

/mob/living/simple_animal/hostile/fleetheavy/ranged_post_animation(atom/A)

	set_AI_busy(TRUE)

	sleep(3 SECONDS)

	set_AI_busy(FALSE)

/mob/living/simple_animal/hostile/fleetheavy/death()
	src.visible_message(SPAN_DANGER("\The [src]'s back begins to crack and hum!"))
	playsound(src,'sound/effects/cascade.ogg', 50, 1, -6)
	var/delay = rand(explosion_delay_lower, explosion_delay_upper)
	addtimer(new Callback(src, .proc/flash, delay), 0)

	return ..()

/mob/living/simple_animal/hostile/fleetheavy/proc/flash(delay)
	// Flash yellow and red as a warning.
	for (var/i = 1 to delay)
		if (i % 2 == 0)
			color = "#feffd0"
		else
			color = "#ff0000"
		sleep(1)

	detonate()

/mob/living/simple_animal/hostile/fleetheavy/proc/detonate()
	// The actual boom.
	if (src && !exploded)
		src.visible_message(SPAN_DANGER("\The [src]'s body detonates!"))
		exploded = TRUE
		explosion(loc, explosion_radius, explosion_max_power)
		qdel(src)

/mob/living/simple_animal/hostile/fleetheavy/Allow_Spacemove(check_drift)
	return TRUE

/obj/aura/mobshield
	icon = 'icons/mecha/shield.dmi'
	name = "mechshield"
	icon_state = "shield_null"
	layer = ABOVE_HUMAN_LAYER
	plane = DEFAULT_PLANE
	mouse_opacity = 0
	var/max_block = 60 // Should block most things - Max AP or damage it can block, else it will just go through.

/obj/aura/mobshield/added_to(mob/living/target)
	. = ..()
	target.vis_contents += src
	flick("shield_raise", src) //Animation on add / spawn
	set_dir() //the whole dir bit is for rendering, if you dont use this just remove this and the GLOB.dir_set_event stuff
	GLOB.dir_set_event.register(user, src, /obj/aura/mobshield/proc/update_dir)

/obj/aura/mobshield/proc/update_dir(user, old_dir, dir)
	set_dir(dir) //Theres ways to make vis contents inherit dir but eh

/obj/aura/mobshield/Destroy()
	if(user)
		GLOB.dir_set_event.unregister(user, src, /obj/aura/mechshield/proc/update_dir)
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
		new /obj/effect/effect/smoke/illumination(user.loc, 5, 4, 1, "#ffffff")
		return AURA_FALSE|AURA_CANCEL
	src.visible_message(SPAN_DANGER("\The [src]'s exposed back dents and buckles!"))
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

/mob/living/simple_animal/hostile/fleetheavy/Initialize()
	. = ..()
	new /obj/aura/mobshield(src)
