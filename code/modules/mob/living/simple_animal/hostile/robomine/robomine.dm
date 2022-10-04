/mob/living/simple_animal/hostile/robomine
	name = "smart mine"
	desc = "A robotic explosive that uses an in-built IFF system to only trigger on identified hostiles."
	icon = 'icons/mob/simple_animal/robomine.dmi'
	var/base_icon = "smart"
	health = 50
	maxHealth = 50
	min_gas = null
	max_gas = null
	minbodytemp = 0
	natural_armor = list(
		melee = ARMOR_MELEE_KNIVES
	)
	bleed_colour = SYNTH_BLOOD_COLOUR
	density = FALSE
	thick_armor = TRUE
	mob_flags = MOB_FLAG_NO_PULL

	meat_type = null
	meat_amount = 0
	bone_material = null
	bone_amount = 0
	skin_material = null
	skin_amount = 0

	special_attack_charges = 1
	special_attack_min_range = 0
	special_attack_max_range = 1
	special_attack_delay = 1 SECOND // Doubles as detonation countdown time

	ai_holder = /datum/ai_holder/robomine

	/// Boolean. If set, the mine is currently detonating.
	var/detonating = FALSE
	/// Boolean. If unset, the mine is not armed and won't trigger.
	var/armed = TRUE


/mob/living/simple_animal/hostile/robomine/get_mechanics_info()
	. = ..()
	. += {"
		<p>Smart mines are hostile mobs that will trigger on any other mob that is not part of their defined faction. Seeker mines will chase after detected mobs.</p>
		<p>Smart mines currently cannot be constructed or deconstructed.</p>
	"}


/datum/ai_holder/robomine
	vision_range = 1
	hostile = TRUE
	retaliate = TRUE
	mauling = TRUE
	can_breakthrough = FALSE
	can_flee = FALSE
	firing_lanes = FALSE
	no_move = TRUE


/mob/living/simple_animal/hostile/robomine/Initialize()
	. = ..()
	update_icon()
	if (!armed)
		ai_holder.hostile = FALSE
		ai_holder.retaliate = FALSE


/mob/living/simple_animal/hostile/robomine/death(gibbed, deathmessage, show_dead_message)
	if (!gibbed && !detonating && special_attack_charges && armed && prob(50))
		detonate()
		return
	. = ..()


/mob/living/simple_animal/hostile/robomine/examine(mob/user, distance, infix, suffix)
	. = ..()
	if (!user.skill_check(SKILL_DEVICES, SKILL_AVERAGE))
		return
	if (!armed)
		to_chat(user, SPAN_NOTICE("It appears to not be armed."))
	else
		to_chat(user, SPAN_WARNING("It appears to be armed."))


/mob/living/simple_animal/hostile/robomine/handle_stance_update(old_stance, new_stance)
	if (detonating)
		return
	update_icon()
	if ((new_stance in STANCES_COMBAT) && !(old_stance in STANCES_COMBAT))
		audible_message(SPAN_WARNING("\The [src] chirps menacingly!"))
		playsound(src, 'sound/machines/boop1.ogg', 50, TRUE)
	else if ((old_stance in STANCES_COMBAT) && !(new_stance in STANCES_COMBAT))
		playsound(src, 'sound/machines/boop2.ogg', 50, TRUE)


/mob/living/simple_animal/hostile/robomine/do_special_attack(atom/A)
	// Detonation is called post-animation.
	return TRUE


/mob/living/simple_animal/hostile/robomine/special_pre_animation(atom/A)
	// Animation is handled by the `_exploding` overlay state in icon update. No additional windup animation.
	predetonate(A, FALSE)
	return


/mob/living/simple_animal/hostile/robomine/special_post_animation(atom/A)
	detonate(A)


/mob/living/simple_animal/hostile/robomine/on_update_icon()
	overlays.Cut()
	icon_state = "mine_[base_icon]"

	// No lights for off states
	if (sleeping || stat)
		return

	// Light states
	var/overlay_state
	if (detonating)
		overlay_state = "[base_icon]_exploding"
	else if (!armed)
		overlay_state = "[base_icon]_off"
	else
		switch (ai_holder.stance)
			if (STANCE_SLEEP, STANCE_IDLE, STANCE_MOVE)
				overlay_state = "[base_icon]_on"
			if (STANCE_ALERT, STANCE_APPROACH, STANCE_FIGHT, STANCE_BLINDFIGHT, STANCE_ATTACK, STANCE_ATTACKING)
				overlay_state = "[base_icon]_targetting"
			if (STANCE_DISABLED)
				overlay_state = "[base_icon]_malf"
	if (overlay_state)
		var/image/img = image(icon, src, overlay_state)
		overlays += img


/mob/living/simple_animal/hostile/robomine/emp_act(severity)
	if (detonating || sleeping || stat)
		return

	if (armed && prob(75 / severity))
		if (prob(50))
			detonate()
		else
			predetonate()
		return

	var/malfunction = pick(list("toggle_armed", "sleep"))
	switch (malfunction)
		if ("toggle_armed")
			set_armed(rand(0, 1))

		if ("sleep")
			sleeping = TRUE
			update_icon()
			visible_message(SPAN_WARNING("\The [src] grows dark and quiet..."))
			var/sleep_time = rand(30, 60) SECONDS / severity
			addtimer(CALLBACK(src, .proc/unset_sleeping), sleep_time, TIMER_UNIQUE | TIMER_OVERRIDE)

	..()


/mob/living/simple_animal/hostile/robomine/gib(anim, do_gibs)
	. = ..(anim, FALSE)
	gibs(loc, null, /obj/effect/gibspawner/robot)


/mob/living/simple_animal/hostile/robomine/proc/unset_sleeping()
	sleeping = FALSE
	update_icon()
	audible_message(SPAN_WARNING("\The [src] beeps softly."))
	playsound(src, 'sound/machines/boop2.ogg', 20, TRUE)


/**
 * Pre-explosion process. Emotes, plays a sound, updates icon, and sets a timer.
 *
 * **Parameters**:
 * - `target` - The atom the mine is triggering on.
 * - `trigger_detonate` Boolean (Default `TRUE`) - If not set, skips setting a timer. Only unset this if you're manually calling detonate(), or this is a false alarm.
 */
/mob/living/simple_animal/hostile/robomine/proc/predetonate(atom/target, trigger_detonate = TRUE)
	detonating = TRUE
	audible_message(
		SPAN_DANGER("\The [src] beeps rapidly and flashes bright red!"),
		deaf_message = SPAN_DANGER("\The [src] flashes bright red!")
	)
	playsound(src, 'sound/items/countdown_short.ogg', 50, TRUE)
	update_icon()
	if (trigger_detonate)
		addtimer(CALLBACK(src, .proc/detonate, target), special_attack_delay, TIMER_UNIQUE)


/**
 * Sets the mine's armed state.
 *
 * **Parameters**:
 * - `new_armed` Boolean (Default `TRUE`) - The new armed state to set.
 */
/mob/living/simple_animal/hostile/robomine/proc/set_armed(new_armed = TRUE)
	if (new_armed == armed)
		return
	armed = new_armed
	ai_holder.hostile = armed
	ai_holder.retaliate = armed
	update_icon()
	if (armed)
		audible_message(SPAN_WARNING("\The [src] beeps softly."))
		playsound(src, 'sound/machines/boop2.ogg', 20, TRUE)



/**
 * Handles detonation of the mine.
 *
 * **Paramaters**:
 * - `target` - The atom that triggered the detonation or that the detonation should target.
 */
/mob/living/simple_animal/hostile/robomine/proc/detonate(atom/target)
	detonating = TRUE // Usually redundant, but just in case - This will prevent a dead mine from trying to detonate a second time in the death call.
	visible_message(
		SPAN_DANGER("\The [src] detonates!"),
		blind_message = SPAN_DANGER("You hear a loud explosion!")
	)
	explosion(get_turf(src), 0, 2, 1)
	gib()
