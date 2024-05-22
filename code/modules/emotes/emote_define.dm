// Note about emote messages:
// - USER / TARGET will be replaced with the relevant name, in bold.
// - USER_THEM / TARGET_THEM / USER_THEIR / TARGET_THEIR will be replaced with a
//   gender-appropriate version of the same.
// - Impaired messages do not do any substitutions.

/singleton/emote

	var/key                            // Command to use emote ie. '*[key]'
	var/emote_message_1p               // First person message ('You do a flip!')
	var/emote_message_3p               // Third person message ('Urist McShitter does a flip!')
	var/emote_message_impaired         // Deaf/blind message ('You hear someone flipping out.', 'You see someone opening and closing their mouth')

	var/emote_message_1p_target        // 'You do a flip at Urist McTarget!'
	var/emote_message_3p_target        // 'Urist McShitter does a flip at Urist McTarget!'

	var/message_type = VISIBLE_MESSAGE // Audible/visual flag
	var/targetted_emote                // Whether or not this emote needs a target.
	var/check_restraints               // Can this emote be used while restrained?
	var/check_range                    // falsy, or a range outside which the emote will not work
	var/conscious = TRUE               // Do we need to be awake to emote this?
	var/emote_range                    // falsy, or a range outside which the emote is not shown

/singleton/emote/proc/get_emote_message_1p(atom/user, atom/target, extra_params)
	if(target)
		return emote_message_1p_target
	return emote_message_1p

/singleton/emote/proc/get_emote_message_3p(atom/user, atom/target, extra_params)
	if(target)
		return emote_message_3p_target
	return emote_message_3p

/singleton/emote/proc/do_emote(atom/user, extra_params)

	if(ismob(user) && check_restraints)
		var/mob/M = user
		if(M.restrained())
			to_chat(user, SPAN_WARNING("You are restrained and cannot do that."))
			return

	var/atom/target
	if(can_target() && extra_params)
		extra_params = lowertext(extra_params)
		for(var/atom/thing in view(user))
			if(extra_params == lowertext(thing.name))
				target = thing
				break

	if (targetted_emote && !target)
		to_chat(user, SPAN_WARNING("You can't do that to thin air."))
		return

	if (target && target != user && check_range)
		if (get_dist(user, target) > check_range)
			to_chat(user, SPAN_WARNING("\The [target] is too far away."))
			return

	var/datum/pronouns/user_pronouns = user.choose_from_pronouns()
	var/datum/pronouns/target_pronouns
	if(target)
		target_pronouns = target.choose_from_pronouns()

	var/use_3p
	var/use_1p


	var/runemessage = -1
	if(emote_message_1p)
		if(target && emote_message_1p_target)
			use_1p = get_emote_message_1p(user, target, extra_params)
			use_1p = replacetext(use_1p, "TARGET_THEM", target_pronouns.him)
			use_1p = replacetext(use_1p, "TARGET_THEIR", target_pronouns.his)
			use_1p = replacetext(use_1p, "TARGET_SELF", target_pronouns.self)
			use_1p = replacetext(use_1p, "TARGET", "<b>\the [target]</b>")
		else
			use_1p = get_emote_message_1p(user, null, extra_params)
		use_1p = capitalize(use_1p)

	if(emote_message_3p)
		if(target && emote_message_3p_target)
			use_3p = get_emote_message_3p(user, target, extra_params)
			use_3p = replacetext(use_3p, "TARGET_THEM", target_pronouns.him)
			use_3p = replacetext(use_3p, "TARGET_THEIR", target_pronouns.his)
			use_3p = replacetext(use_3p, "TARGET_SELF", target_pronouns.self)
			use_3p = replacetext(use_3p, "TARGET", "<b>\the [target]</b>")
		else
			use_3p = get_emote_message_3p(user, null, extra_params)
		use_3p = replacetext(use_3p, "USER_THEM", user_pronouns.him)
		use_3p = replacetext(use_3p, "USER_THEIR", user_pronouns.his)
		use_3p = replacetext(use_3p, "USER_SELF", user_pronouns.self)

		runemessage = replacetext(use_3p, "USER", "")

		use_3p = replacetext(use_3p, "USER", "<b>\the [user]</b>")
		use_3p = capitalize(use_3p)

	var/use_range = emote_range
	if (!use_range)
		use_range = world.view

	if(ismob(user))
		var/mob/M = user
		if(message_type == AUDIBLE_MESSAGE)
			M.audible_message(message = use_3p, self_message = use_1p, deaf_message = emote_message_impaired, hearing_distance = use_range, checkghosts = /datum/client_preference/ghost_sight, runemessage = runemessage)
		else
			M.visible_message(message = use_3p, self_message = use_1p, blind_message = emote_message_impaired, range = use_range, checkghosts = /datum/client_preference/ghost_sight, runemessage = runemessage)

	do_extra(user, target)

/singleton/emote/proc/do_extra(atom/user, atom/target)
	return

/singleton/emote/proc/check_user(atom/user)
	return TRUE

/singleton/emote/proc/can_target()
	return (emote_message_1p_target || emote_message_3p_target)

/singleton/emote/dd_SortValue()
	return key
