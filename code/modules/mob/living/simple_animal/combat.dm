// Does a melee attack.
/mob/living/simple_animal/proc/attack_target(atom/A)
	set waitfor = FALSE // For attack animations. Don't want the AI processor to get held up.

	if(!A.Adjacent(src))
		return ATTACK_FAILED
	var/turf/their_T = get_turf(A)

	face_atom(A)

	if(melee_attack_delay)
		melee_pre_animation(A)
		. = ATTACK_SUCCESSFUL //Shoving this in here as a 'best guess' since this proc is about to sleep and return and we won't be able to know the real value
		handle_attack_delay(A, melee_attack_delay) // This will sleep this proc for a bit, which is why waitfor is false.

	// Cooldown testing is done at click code (for players) and interface code (for AI).
	setClickCooldown(get_attack_speed(get_natural_weapon()))

	// Returns a value, but will be lost if
	. = do_attack(A, their_T)

	if(melee_attack_delay)
		melee_post_animation(A)

// This does the actual attack.
// This is a seperate proc for the purposes of attack animations.
// A is the thing getting attacked, T is the turf A is/was on when attack_target was called.
// Damage is handled by the mobs natural weapon.
/mob/living/simple_animal/proc/do_attack(atom/A, turf/T)
	face_atom(A)
	var/missed = FALSE
	if (get_dir(src, A) == facing_dir && get_dist(src, A) <= 1) // Turfs don't contain themselves so checking contents is pointless if we're targeting a turf.
		missed = TRUE
	else if (!T.AdjacentQuick(src))
		missed = TRUE

	if(missed) // Most likely we have a slow attack and they dodged it or we somehow got moved.
		playsound(src, 'sound/weapons/punchmiss.ogg', 75, 1)
		visible_message(SPAN_WARNING("\The [src] misses their attack."))
		return FALSE

	var/obj/item/natural_weapon/weapon = get_natural_weapon()

	if (weapon.resolve_attackby(A, src))
		apply_melee_effects(A)

	return TRUE

// Override for special effects after a successful attack, like injecting poison or stunning the target.
/mob/living/simple_animal/proc/apply_melee_effects(atom/A)
	return

// Override to modify the amount of damage the mob does conditionally.
// This must return the amount of outgoing damage.
// Note that this is done before mob modifiers scale the damage.
/mob/living/simple_animal/proc/apply_bonus_melee_damage(atom/A, damage_amount)
	return damage_amount

//The actual top-level ranged attack proc
/mob/living/simple_animal/proc/shoot_target(atom/A)
	set waitfor = FALSE
	setClickCooldown(get_attack_speed())

	face_atom(A)

	if(ranged_attack_delay)
		ranged_pre_animation(A)
		handle_attack_delay(A, ranged_attack_delay) // This will sleep this proc for a bit, which is why waitfor is false.

	if(needs_reload)
		if(reload_count >= reload_max)
			try_reload()
			return FALSE

	visible_message("<span class='danger'><b>\The [src]</b> fires at \the [A]!</span>")
	shoot(A)
	if(casingtype)
		new casingtype(loc)

	if(ranged_attack_delay)
		ranged_post_animation(A)

	return TRUE


// Shoot a bullet at something.
/mob/living/simple_animal/proc/shoot(atom/A)
	if(A == get_turf(src))
		return

	face_atom(A)

	var/obj/item/projectile/P = new projectiletype(src.loc)
	if(!P)
		return

	// If the projectile has its own sound, use it.
	// Otherwise default to the mob's firing sound.
	playsound(src, P.fire_sound ? P.fire_sound : projectilesound, 80, 1)

	// For some reason there isn't an argument for accuracy, so access the projectile directly instead.
	// Also, placing dispersion here instead of in forced_spread will randomize the chosen angle between dispersion and -dispersion in fire() instead of having to do that here.
	// P.accuracy += calculate_accuracy()
	// P.dispersion += calculate_dispersion()

	P.launch(target = A)
	if(needs_reload)
		reload_count++

/mob/living/simple_animal/proc/try_reload()
	set waitfor = FALSE
	set_AI_busy(TRUE)

	if(do_after(src, reload_time))
		if(reload_sound)
			playsound(src, reload_sound, 70, 1)
		reload_count = 0
		. = TRUE
	else
		. = FALSE
	set_AI_busy(FALSE)

/mob/living/simple_animal/proc/calculate_dispersion()
	. = projectile_dispersion // Start with the basic var.

	// Make sure we don't go under zero dispersion.
	. = max(., 0)

/mob/living/simple_animal/proc/calculate_accuracy()
	. = projectile_accuracy // Start with the basic var.

// Can we currently do a special attack?
/mob/living/simple_animal/proc/can_special_attack(atom/A)
	// Validity check.
	if(!istype(A))
		return FALSE

	// Ability check.
	if(isnull(special_attack_min_range) || isnull(special_attack_max_range))
		return FALSE

	// Distance check.
	var/distance = get_dist(src, A)
	if(distance < special_attack_min_range || distance > special_attack_max_range)
		return FALSE

	// Cooldown check.
	if(!isnull(special_attack_cooldown) && last_special_attack + special_attack_cooldown > world.time)
		return FALSE

	// Charge check.
	if(!isnull(special_attack_charges) && special_attack_charges <= 0)
		return FALSE

	return TRUE

// Should we do one? Used to make the AI not waste their special attacks. Only checked for AI. Players are free to screw up on their own.
/mob/living/simple_animal/proc/should_special_attack(atom/A)
	return TRUE

// Special attacks, like grenades or blinding spit or whatever.
// Don't override this, override do_special_attack() for your blinding spit/etc.
/mob/living/simple_animal/proc/special_attack_target(atom/A)
	face_atom(A)

	if(special_attack_delay)
		special_pre_animation(A)
		handle_attack_delay(A, special_attack_delay) // This will sleep this proc for a bit, which is why waitfor is false.

	last_special_attack = world.time
	if(do_special_attack(A))
		if(special_attack_charges)
			special_attack_charges -= 1
		. = TRUE
	else
		. = FALSE

	if(special_attack_delay)
		special_post_animation(A)

// Override this for the actual special attack.
/mob/living/simple_animal/proc/do_special_attack(atom/A)
	return FALSE

// Sleeps the proc that called it for the correct amount of time.
// Also makes sure the AI doesn't do anything stupid in the middle of the delay.
/mob/living/simple_animal/proc/handle_attack_delay(atom/A, delay_amount)
	set_AI_busy(TRUE)

	// Click delay modifiers also affect telegraphing time.
	// This means berserked enemies will leave less time to dodge.
	var/true_attack_delay = delay_amount

	setClickCooldown(true_attack_delay) // Insurance against a really long attack being longer than default click delay.

	sleep(true_attack_delay)

	set_AI_busy(FALSE)


// Override these four for special custom animations (like the GOLEM).
/mob/living/simple_animal/proc/melee_pre_animation(atom/A)
	do_windup_animation(A, melee_attack_delay)

/mob/living/simple_animal/proc/melee_post_animation(atom/A)

/mob/living/simple_animal/proc/ranged_pre_animation(atom/A)
	do_windup_animation(A, ranged_attack_delay) // Semi-placeholder.

/mob/living/simple_animal/proc/ranged_post_animation(atom/A)

/mob/living/simple_animal/proc/special_pre_animation(atom/A)
	do_windup_animation(A, special_attack_delay) // Semi-placeholder.

/mob/living/simple_animal/proc/special_post_animation(atom/A)

/mob/living/simple_animal/proc/get_natural_weapon()
	if(ispath(natural_weapon))
		natural_weapon = new natural_weapon(src)
	return natural_weapon
