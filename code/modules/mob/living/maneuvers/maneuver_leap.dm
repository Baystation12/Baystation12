/singleton/maneuver/leap
	name = "leap"
	stamina_cost = 10
	reflexive_modifier = 1.5

/singleton/maneuver/leap/perform(mob/living/user, atom/target, strength, reflexively = FALSE)
	. = ..()
	if(.)
		var/old_pass_flags = user.pass_flags
		user.pass_flags |= PASS_FLAG_TABLE
		user.visible_message(SPAN_DANGER("\The [user] takes a flying leap!"))
		strength = max(2, strength * user.get_jump_distance())
		if(reflexively)
			strength *= reflexive_modifier
		user.jump_layer_shift()
		animate(user, pixel_z = 16, time = 3, easing = SINE_EASING | EASE_IN)
		animate(pixel_z = user.default_pixel_z, time = 3, easing = SINE_EASING | EASE_OUT)
		user.throw_at(get_turf(target), strength, 1, user, FALSE, new Callback(src, TYPE_PROC_REF(/singleton/maneuver/leap, end_leap), user, target, old_pass_flags))
		addtimer(new Callback(user, TYPE_PROC_REF(/mob/living, jump_layer_shift_end)), 4.5)

/singleton/maneuver/leap/proc/end_leap(mob/living/user, atom/target, pass_flag)
	user.pass_flags = pass_flag
	user.post_maneuver()

/singleton/maneuver/leap/show_initial_message(mob/living/user, atom/target)
	user.visible_message(SPAN_WARNING("\The [user] crouches, preparing for a leap!"))

/singleton/maneuver/leap/can_be_used_by(mob/living/user, atom/target, silent = FALSE)
	. = ..()
	if(.)
		var/can_leap_distance = user.get_jump_distance() * user.get_acrobatics_multiplier()
		if (can_leap_distance <= 0)
			if (!silent)
				to_chat(user, SPAN_WARNING("You can't leap in your current state."))
			return FALSE
		if (!istype(target))
			if (!silent)
				to_chat(user, SPAN_WARNING("That is not a valid leap target."))
			return FALSE
		if (get_dist(user, target) > can_leap_distance)
			if (!silent)
				to_chat(user, SPAN_WARNING("You can't leap that far."))
			return FALSE
		return TRUE

/singleton/maneuver/leap/spider
	stamina_cost = 0

/singleton/maneuver/leap/spider/show_initial_message(mob/living/user, atom/target)
	user.visible_message(SPAN_WARNING("\The [user] reels back and prepares to launch itself at \the [target]!"))

/singleton/maneuver/leap/grab
	name = "spring leap"
	stamina_cost = 40
	reflexive_modifier = 0.5
	cooldown = 15 SECONDS
	delay = 0 SECONDS

/singleton/maneuver/leap/grab/end_leap(mob/living/user, atom/target)
	. = ..()
	if(ishuman(user) && !user.lying && ismob(target) && user.Adjacent(target))
		var/mob/living/carbon/human/H = user
		H.species.attempt_grab(H, target)

/singleton/maneuver/leap/quick
	name = "quick jump"
	stamina_cost = 20
	reflexive_modifier = 0.75
	cooldown = 10 SECONDS
	delay = 0 SECONDS

/singleton/maneuver/leap/quick/perform(mob/living/user, atom/target, strength, reflexively = FALSE)
	. = ..()
	strength = 1
	if (.)
		user.visible_message(SPAN_DANGER("\The [user] pulls off a quick leap!"))
		if(reflexively)
			strength *= reflexive_modifier
		user.jump_layer_shift()
		animate(user, pixel_z = 16, time = 3, easing = SINE_EASING | EASE_IN)
		animate(pixel_z = user.default_pixel_z, time = 3, easing = SINE_EASING | EASE_OUT)
		user.throw_at(get_turf(target), strength, 1, user, FALSE, new Callback(src, TYPE_PROC_REF(/singleton/maneuver/leap, end_leap), user, target))
		addtimer(new Callback(user, TYPE_PROC_REF(/mob/living, jump_layer_shift_end)), 4.5)
