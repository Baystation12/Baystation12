/mob/living/simple_animal/hostile/legion/speculator
	name = "legion speculator"
	desc = "A multi-legged robot of some kind made of a yellowish metallic allow with glowing yellow lights. The fact you can even see this one is probably concerning..."
	icon = 'packs/legion/icons/speculatore.dmi'
	icon_state = "base"
	alpha = 127
	invisibility = INVISIBILITY_LEVEL_ONE
	movable_flags = MOVABLE_FLAG_PROXMOVE | MOVABLE_FLAG_POSTMOVEMENT
	maxHealth = 125
	health = 125
	armor_type = /datum/extension/armor
	natural_armor = list(
		"melee" = ARMOR_MELEE_KNIVES,
		"bullet" = ARMOR_BALLISTIC_PISTOL,
		"laser" = ARMOR_LASER_HANDGUNS,
		"energy" = ARMOR_ENERGY_RESISTANT,
		"bomb" = ARMOR_BOMB_MINOR,
		"bio" = ARMOR_BIO_SHIELDED,
		"rad" = ARMOR_RAD_SHIELDED
	)
	default_pixel_x = -16
	default_pixel_y = -16
	pixel_x = -16
	pixel_y = -16
	movement_cooldown = 1
	base_attack_cooldown = 5 SECONDS

	ai_holder = /datum/ai_holder/legion/speculator
	natural_weapon = /obj/item/natural_weapon/legion/speculator_blade

	/// Integer. Alpha level to use when the mob is "cloaked". This is only visible for ghosts and anything that can see `cloak_level`.
	var/cloaked_alpha = 127
	/// Integer. Invisibility value to use when cloaked.
	var/cloak_level = INVISIBILITY_LEVEL_ONE
	/// Boolean. Whether or not the cloaking effect is in progress.
	var/cloaking = FALSE

	/// How many loops the flicker animation in `flicker_cloak()` plays for. Each loop is approximately 0.2 seconds, or 2 game ticks.
	var/const/FLICKER_TIME = 4

	/// Integer. `world.time` of the last `flicker_cloak()` call so it's not overly spammy.
	var/last_flicker

	/// Integer. `world.time` of the last `hidden_*_hint()` call.
	var/last_hint_time

	/// List of sounds. Sound effects played during `hidden_*_hint()` procs.
	var/list/hint_sounds = list(
		'packs/legion/sounds/speculator_hint_1.ogg',
		'packs/legion/sounds/speculator_hint_2.ogg',
		'packs/legion/sounds/speculator_hint_3.ogg'
	)

	/// List of sounds. Sound effects played when cloaking.
	var/list/cloak_sounds = list(
		'packs/legion/sounds/speculator_cloak_1.ogg'
	)

	/// List of sounds. Sound effects played when decloaking.
	var/list/uncloak_sounds = list(
		'packs/legion/sounds/speculator_decloak_1.ogg'
	)


/mob/living/simple_animal/hostile/legion/speculator/Initialize(mapload, obj/structure/legion/beacon/spawner)
	. = ..()
	update_icon()
	last_hint_time = world.time
	last_flicker = world.time


/mob/living/simple_animal/hostile/legion/speculator/Life()
	..()

	if (!is_cloaked() || world.time <= last_hint_time + 1 MINUTE)
		return
	if (!prob(10))
		return
	hidden_idle_hint()


/mob/living/simple_animal/hostile/legion/speculator/post_movement(turf/old_turf, turf/new_turf)
	for (var/mob/living/living in new_turf)
		if (living.stat)
			continue
		living.show_message(SPAN_SUBTLE("You feel something brush past you..."))

	if (!is_cloaked() || world.time <= last_hint_time + 1 MINUTE)
		return
	if (!prob(20))
		return
	hidden_movement_hint()


/mob/living/simple_animal/hostile/legion/speculator/on_update_icon()
	ClearOverlays()
	..()
	if (!is_cloaked())
		AddOverlays(emissive_appearance(icon, "[icon_state]-emissive", FLOAT_LAYER + 1))


/mob/living/simple_animal/hostile/legion/speculator/bullet_act(obj/item/projectile/Proj)
	. = ..()
	if (. == PROJECTILE_FORCE_MISS)
		return
	try_disrupt()


/mob/living/simple_animal/hostile/legion/speculator/hit_with_weapon(obj/item/O, mob/living/user, effective_force, hit_zone)
	. = ..()
	try_disrupt()


/mob/living/simple_animal/hostile/legion/speculator/ex_act(severity)
	..()
	if (stat || QDELETED(src))
		return

	switch (severity)
		if (EX_ACT_DEVASTATING)
			disrupt_cloak(rand(5 SECONDS, 7 SECONDS))
		if (EX_ACT_HEAVY)
			disrupt_cloak(rand(1 SECONDS, 3 SECONDS))
		if (EX_ACT_LIGHT)
			try_disrupt()


/mob/living/simple_animal/hostile/legion/speculator/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	. = ..()
	flicker_cloak()


/mob/living/simple_animal/hostile/legion/speculator/emp_act(severity)
	..()
	switch (severity)
		if (EMP_ACT_HEAVY)
			disrupt_cloak(rand(2 SECONDS, 4 SECONDS))
		if (EMP_ACT_LIGHT)
			flicker_cloak()


/// Whether or not the speculator is currently cloaked.
/mob/living/simple_animal/hostile/legion/speculator/is_cloaked()
	return (invisibility == cloak_level)


/// Enables the speculator's cloak.
/mob/living/simple_animal/hostile/legion/speculator/proc/cloak()
	if (stat || cloaking || is_cloaked())
		return
	visible_message(
		SPAN_WARNING("\The [src] fades out of view!")
	)
	cloaking = TRUE
	animate(src, alpha = 0, time = 1 SECOND)
	addtimer(new Callback(src, .proc/post_cloak, TRUE), 1 SECOND)
	playsound(loc, pick(cloak_sounds), 50, TRUE)


/// Disables the speculator's cloak.
/mob/living/simple_animal/hostile/legion/speculator/proc/uncloak()
	if (cloaking || !is_cloaked())
		return
	alpha = 0
	invisibility = 0
	visible_message(
		SPAN_WARNING("\The [src] flashes into view!")
	)
	cloaking = TRUE
	animate(src, alpha = 255, time = 1 SECOND)
	addtimer(new Callback(src, .proc/post_cloak, FALSE), 1 SECOND)
	playsound(loc, pick(uncloak_sounds), 50, TRUE)


/**
 * Second stage of the speculator's cloak/uncloak. Called by the relevant procs after the animation completes.
 *
 * **Parametetrs**:
 * - `cloak_state` (Boolean) - Whether or the speculator has finished cloaking or decloaking.
 */
/mob/living/simple_animal/hostile/legion/speculator/proc/post_cloak(cloak_state)
	if (cloak_state)
		set_invisibility(cloak_level)
		alpha = cloaked_alpha
	else
		set_invisibility()
		alpha = 255
	cloaking = FALSE
	update_icon()


/**
 * Temporarily disables the speculator's cloak for the given time.
 *
 * **Parameters**:
 * - `time` (Integer, default `2 SECONDS`, minimum `2 SECONDS`). Amount of time in ticks the cloak should remain disrupted. Minimum of 2 seconds to account for cloak animations.
 */
/mob/living/simple_animal/hostile/legion/speculator/proc/disrupt_cloak(time = 2 SECONDS)
	if (time < 2 SECONDS)
		time = 2 SECONDS
	uncloak()
	addtimer(new Callback(src, .proc/cloak), time, TIMER_UNIQUE)


/// A brief cloaking flicker effect. Intended to partially reveal the mob's location without fully decloaking. See `FLICKER_TIME` for some configuration.
/mob/living/simple_animal/hostile/legion/speculator/proc/flicker_cloak()
	set waitfor = FALSE
	if (cloaking || !is_cloaked())
		return
	if (world.time <= last_flicker + 2 SECONDS)
		return
	cloaking = TRUE
	alpha = 0
	set_invisibility()
	visible_message(
		SPAN_WARNING("\The [src] flickers in and out of view!")
	)
	for (var/count = 1 to FLICKER_TIME)
		animate(src, alpha = 127, time = 0.1 SECONDS)
		sleep (0.1 SECONDS)
		animate(src, alpha = 0, time = 0.1 SECONDS)
		sleep (0.1 SECONDS)
	set_invisibility(cloak_level)
	alpha = cloaked_alpha
	cloaking = FALSE
	last_flicker = world.time


/// Attempts to randomly disrupt the speculator's cloak.
/mob/living/simple_animal/hostile/legion/speculator/proc/try_disrupt()
	if (!is_cloaked())
		return
	// 50% chance of no effect
	// 35% chance of flickering the cloak
	// 15% chance of disrupting the cloak
	if (!prob(50))
		return
	if (prob(30))
		disrupt_cloak(rand(2 SECONDS, 4 SECONDS))
	else
		flicker_cloak()


/// Does some hinting the speculator is nearby and idle. Audio and narration cue.
/mob/living/simple_animal/hostile/legion/speculator/proc/hidden_idle_hint()
	if (!is_cloaked())
		return
	last_hint_time = world.time
	loc.audible_message(
		SPAN_SUBTLE("You hear a slow, rythmic, metallic tapping from somewhere nearby...")
	)
	playsound(loc, pick(hint_sounds), 50, TRUE)


/// Does some hinting the speculator is nearby and moving. Audio and narration cue.
/mob/living/simple_animal/hostile/legion/speculator/proc/hidden_movement_hint()
	if (!is_cloaked())
		return
	last_hint_time = world.time
	loc.audible_message(
		SPAN_SUBTLE("You hear the subtle sound of something skittering around from somewhere nearby...")
	)
	playsound(loc, pick(hint_sounds), 50, TRUE)
