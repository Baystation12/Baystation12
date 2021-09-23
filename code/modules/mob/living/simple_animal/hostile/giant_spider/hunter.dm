// Hunters are fast, fragile, and possess a leaping attack.
// The leaping attack is somewhat telegraphed and can be dodged if one is paying attention.
// The AI would've followed up after a successful leap with dragging the downed victim away, but the dragging code was too janky.

/mob/living/simple_animal/hostile/giant_spider/hunter
	desc = "Furry and black, it makes you shudder to look at it. This one has sparkling purple eyes."

	icon_state = "hunter"
	icon_living = "hunter"
	icon_dead = "hunter_dead"

	maxHealth = 120
	health = 120

	poison_per_bite = 5

	movement_cooldown = 0 // Hunters are FAST.

	ai_holder_type = /datum/ai_holder/simple_animal/melee/evasive/hunter_spider

	// Leaping is a special attack, so these values determine when leap can happen.
	// Leaping won't occur if its on cooldown.
	special_attack_min_range = 2
	special_attack_max_range = 4
	special_attack_cooldown = 10 SECONDS

	var/leap_warmup = 1 SECOND // How long the leap telegraphing is.
	var/leap_sound = 'sound/weapons/spiderlunge.ogg'

// Multiplies damage if the victim is stunned in some form, including a successful leap.
/mob/living/simple_animal/hostile/giant_spider/hunter/apply_bonus_melee_damage(atom/A, damage_amount)
	if(isliving(A))
		var/mob/living/L = A
		if(L.incapacitated(INCAPACITATION_DISABLED))
			return damage_amount * 1.5
	return ..()


// The actual leaping attack.
/mob/living/simple_animal/hostile/giant_spider/hunter/do_special_attack(atom/A)
	set waitfor = FALSE
	set_AI_busy(TRUE)

	// Telegraph, since getting stunned suddenly feels bad.
	do_windup_animation(A, leap_warmup)
	sleep(leap_warmup) // For the telegraphing.

	// Do the actual leap.
	status_flags |= LEAPING // Lets us pass over everything.
	visible_message(SPAN_DANGER("\The [src] leaps at \the [A]!"))
	throw_at(get_step(get_turf(A), get_turf(src)), special_attack_max_range+1, 1, src)
	playsound(src, leap_sound, 75, 1)

	sleep(5) // For the throw to complete. It won't hold up the AI ticker due to waitfor being false.

	if(status_flags & LEAPING)
		status_flags &= ~LEAPING // Revert special passage ability.

	var/turf/T = get_turf(src) // Where we landed. This might be different than A's turf.

	. = FALSE

	// Now for the stun.
	var/mob/living/victim = null
	for(var/mob/living/L in T) // So player-controlled spiders only need to click the tile to stun them.
		if(L == src)
			continue

		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.check_shields(damage = 0, damage_source = src, attacker = src, def_zone = null, attack_text = "the leap"))
				continue // We were blocked.

		victim = L
		break

	if(victim)
		victim.Weaken(2)
		victim.visible_message(SPAN_DANGER("\The [src] knocks down \the [victim]!"))
		to_chat(victim, "<span class='critical'>\The [src] jumps on you!</span>")
		. = TRUE

	set_AI_busy(FALSE)

/datum/ai_holder/simple_animal/melee/evasive/hunter_spider
	can_flee = TRUE
