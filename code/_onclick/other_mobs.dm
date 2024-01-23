/**
 * Generic attack and damage proc, called on the attacked atom.
 *
 * **Parameters**:
 * - `user` - The attacking mob.
 * - `damage` (int) - The damage value.
 * - `attack_verb` (string) - The verb/string used for attack messages.
 * - `wallbreaker` (boolean) - Whether or not the attack is considered a 'wallbreaker' attack.
 * - `damtype` (string, one of `DAMAGE_*`) - The attack's damage type.
 * - `armorcheck` (string) - TODO: Unused. Remove.
 * - `dam_flags` (bitfield, any of `DAMAGE_FLAG_*`) - Damage flags associated with the attack.
 *
 * Returns boolean.
 */
/atom/proc/attack_generic(mob/user, damage, attack_verb = "hits", wallbreaker = FALSE, damtype = DAMAGE_BRUTE, armorcheck = "melee", dam_flags = EMPTY_BITFIELD)
	if (damage && get_max_health())
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.do_attack_animation(src)
		if (!can_damage_health(damage, damtype))
			playsound(src, damage_hitsound, 50, TRUE)
			user.visible_message(
				SPAN_WARNING("\The [user] bonks \the [src] harmlessly!"),
				SPAN_WARNING("You bonk \the [src] harmlessly!")
			)
			return
		var/damage_flags = EMPTY_BITFIELD
		if (wallbreaker)
			SET_FLAGS(damage_flags, DAMAGE_FLAG_TURF_BREAKER)
		playsound(src, damage_hitsound, 75, TRUE)
		if (damage_health(damage, damtype, damage_flags, skip_can_damage_check = TRUE))
			user.visible_message(
				SPAN_DANGER("\The [user] smashes through \the [src]!"),
				SPAN_DANGER("You smash through \the [src]!")
			)
		else
			user.visible_message(
				SPAN_DANGER("\The [user] [attack_verb] \the [src]!"),
				SPAN_DANGER("You [attack_verb] \the [src]!")
			)


/*
	Humans:
	Adds an exception for gloves, to allow special glove types like the ninja ones.

	Otherwise pretty standard.
*/
/mob/living/carbon/human/UnarmedAttack(atom/A, proximity)

	if(!..())
		return

	// Special glove functions:
	// If the gloves do anything, have them return 1 to stop
	// normal attack_hand() here.
	var/obj/item/clothing/gloves/G = gloves // not typecast specifically enough in defines
	if(istype(G) && G.Touch(A,1))
		return

	A.attack_hand(src)


/**
 * Called when the atom is clicked on by a mob with an empty hand.
 *
 * **Parameters**:
 * - `user` - The mob that clicked on the atom.
 */
/atom/proc/attack_hand(mob/user)
	return


/**
 * Called when a mob attempts to use an empty hand on itself.
 *
 * **Parameters**:
 * - `bp_hand` (string, `BP_R_HAND` or `BP_L_HAND`) - The targeted and used hand's bodypart slot.
 */
/mob/proc/attack_empty_hand(bp_hand)
	return


/mob/living/carbon/human/RestrainedClickOn(atom/A)
	return

/mob/living/CtrlClickOn(atom/A)
	. = ..()
	if(!. && a_intent == I_GRAB && length(available_maneuvers))
		. = perform_maneuver(prepared_maneuver || available_maneuvers[1], A)

/mob/living/carbon/human/RangedAttack(atom/A, params)
	//Climbing up open spaces
	if((istype(A, /turf/simulated/floor) || istype(A, /turf/unsimulated/floor) || istype(A, /obj/structure/lattice) || istype(A, /obj/structure/catwalk)) && isturf(loc) && bound_overlay && !is_physically_disabled()) //Climbing through openspace
		return climb_up(A)

	if(gloves)
		var/obj/item/clothing/gloves/G = gloves
		if(istype(G) && G.Touch(A,0)) // for magic gloves
			return TRUE

	. = ..()

/mob/living/RestrainedClickOn(atom/A)
	return

/*
	Aliens
*/

/mob/living/carbon/alien/RestrainedClickOn(atom/A)
	return

/mob/living/carbon/alien/UnarmedAttack(atom/A, proximity)

	if(!..())
		return 0

	setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	A.attack_generic(src,rand(5,6),"bitten")

/*
	Slimes
	Nothing happening here
*/

/mob/living/carbon/slime/RestrainedClickOn(atom/A)
	return

/mob/living/carbon/slime/UnarmedAttack(atom/A, proximity)

	if(!..())
		return

	// Eating
	if(Victim)
		if (Victim == A)
			Feedstop()
		return

	//should have already been set if we are attacking a mob, but it doesn't hurt and will cover attacking non-mobs too
	setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	var/mob/living/M = A
	if(!istype(M))
		A.attack_generic(src, (is_adult ? rand(20,40) : rand(5,25)), "glomped") // Basic attack.
	else
		var/power = max(0, min(10, (powerlevel + rand(0, 3))))

		switch(src.a_intent)
			if (I_HELP) // We just poke the other
				M.visible_message(SPAN_NOTICE("[src] gently pokes [M]!"), SPAN_NOTICE("[src] gently pokes you!"))
			if (I_DISARM) // We stun the target, with the intention to feed
				var/stunprob = 1

				if (powerlevel > 0 && !istype(A, /mob/living/carbon/slime))
					switch(power * 10)
						if(0) stunprob *= 10
						if(1 to 2) stunprob *= 20
						if(3 to 4) stunprob *= 30
						if(5 to 6) stunprob *= 40
						if(7 to 8) stunprob *= 60
						if(9) 	   stunprob *= 70
						if(10) 	   stunprob *= 95

				if(prob(stunprob))
					var/shock_damage = max(0, powerlevel-3) * rand(6,10)
					M.electrocute_act(shock_damage, src, 1.0, ran_zone())
				else if(prob(40))
					M.visible_message(SPAN_DANGER("[src] has pounced at [M]!"), SPAN_DANGER("[src] has pounced at you!"))
					M.Weaken(power)
				else
					M.visible_message(SPAN_DANGER("[src] has tried to pounce at [M]!"), SPAN_DANGER("[src] has tried to pounce at you!"))
				M.updatehealth()
			if (I_GRAB) // We feed
				Wrap(M)
			if (I_HURT) // Attacking
				if(iscarbon(M) && prob(15))
					M.visible_message(SPAN_DANGER("[src] has pounced at [M]!"), SPAN_DANGER("[src] has pounced at you!"))
					M.Weaken(power)
				else
					A.attack_generic(src, (is_adult ? rand(20,40) : rand(5,25)), "glomped")

/*
	New Players:
	Have no reason to click on anything at all.
*/
/mob/new_player/ClickOn()
	return

/*
	Animals
*/
/mob/living/simple_animal/UnarmedAttack(atom/A, proximity)
	if (!..())
		return
	setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if (istype(A,/mob/living))
		if (!get_natural_weapon() || a_intent == I_HELP)
			custom_emote(VISIBLE_MESSAGE, "[friendly] [A]!")
			return
		if (ckey)
			admin_attack_log(src, A, "Has attacked its victim.", "Has been attacked by its attacker.")
	if (a_intent == I_HELP)
		A.attack_animal(src)
	else if (get_natural_weapon())
		var/obj/item/weapon = get_natural_weapon()
		weapon.resolve_attackby(A, src)


/**
 * Called when a `simple_animal` mob clicks on the atom with an 'empty hand.'
 *
 * **Parameters**:
 * - `user` - The mob clicking on the atom.
 */
/atom/proc/attack_animal(mob/user)
	return attack_hand(user)
