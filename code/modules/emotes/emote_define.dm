var/list/all_emotes = list()

/proc/get_emote(var/emote_path)
	if(!all_emotes[emote_path])
		var/decl/emote/emote = new emote_path
		all_emotes[emote_path] = emote
	return all_emotes[emote_path]

// Note about emote messages:
// - USER / TARGET will be replaced with the relevant name, in bold.
// - USER_THEM / TARGET_THEM / USER_THEIR / TARGET_THEIR will be replaced with a
//   gender-appropriate version of the same.
// - Impaired messages do not do any substitutions.

/decl/emote

	var/key					           // Command to use emote ie. '*[key]'
	var/emote_message_1p               // First person message ('You do a flip!')
	var/emote_message_3p               // Third person message ('Urist McShitter does a flip!')
	var/emote_message_impaired         // Deaf/blind message ('You hear someone flipping out.', 'You see someone opening and closing their mouth')

	var/emote_message_1p_target        // 'You do a flip at Urist McTarget!'
	var/emote_message_3p_target        // 'Urist McShitter does a flip at Urist McTarget!'

	var/message_type = VISIBLE_MESSAGE // Audible/visual flag
	var/targetted_emote                // Whether or not this emote needs a target.
	var/check_restraints               // Can this emote be used while restrained?

/decl/emote/proc/get_emote_message_1p(var/atom/user, var/atom/target, var/extra_params)
	if(target)
		return emote_message_1p_target
	return emote_message_1p

/decl/emote/proc/get_emote_message_3p(var/atom/user, var/atom/target, var/extra_params)
	if(target)
		return emote_message_3p_target
	return emote_message_3p

/decl/emote/proc/do_emote(var/atom/user, var/extra_params)

	if(ismob(user) && check_restraints)
		var/mob/M = user
		if(M.restrained())
			to_chat(user, "<span class='warning'>You are restrained and cannot do that.</span>")
			return

	var/user_them
	var/user_their
	switch(user.get_visible_gender())
		if(MALE)
			user_them = "him"
			user_their = "his"
		if(FEMALE)
			user_them = "her"
			user_their = "her"
		if(PLURAL)
			user_them = "them"
			user_their = "their"
		else
			user_them = "it"
			user_their = "its"

	var/atom/target
	if(can_target() && extra_params)
		extra_params = lowertext(extra_params)
		for(var/atom/thing in view(user))
			if(extra_params == lowertext(thing.name))
				target = thing
				break

	var/target_them
	var/target_their
	if(target)
		switch(target.get_visible_gender())
			if(MALE)
				target_them = "him"
				target_their = "his"
			if(FEMALE)
				target_them = "her"
				target_their = "her"
			if(PLURAL)
				target_them = "them"
				target_their = "their"
			else
				target_them = "it"
				target_their = "its"

	var/use_3p
	var/use_1p
	if(emote_message_1p)
		if(target && emote_message_1p_target)
			use_1p = get_emote_message_1p(user, target, extra_params)
			use_1p = replacetext(use_1p, "TARGET_THEM", target_them)
			use_1p = replacetext(use_1p, "TARGET_THEIR", target_their)
			use_1p = replacetext(use_1p, "TARGET", "<b>\the [target]</b>")
		else
			use_1p = get_emote_message_1p(user, null, extra_params)
	if(emote_message_3p)
		if(target && emote_message_3p_target)
			use_3p = get_emote_message_3p(user, target, extra_params)
			use_3p = replacetext(use_3p, "TARGET_THEM", target_them)
			use_3p = replacetext(use_3p, "TARGET_THEIR", target_their)
			use_3p = replacetext(use_3p, "TARGET", "<b>\the [target]</b>")
		else
			use_3p = get_emote_message_3p(user, null, extra_params)
		use_3p = replacetext(use_3p, "USER_THEM", user_them)
		use_3p = replacetext(use_3p, "USER_THEIR", user_their)
		use_3p = replacetext(use_3p, "USER", "<b>\the [user]</b>")

	if(message_type == AUDIBLE_MESSAGE)
		user.audible_message(message = use_3p, self_message = use_1p, deaf_message = emote_message_impaired, checkghosts = /datum/client_preference/ghost_sight)
	else
		user.visible_message(message = use_3p, self_message = use_1p, blind_message = emote_message_impaired, checkghosts = /datum/client_preference/ghost_sight)

	do_extra(user, target)

/decl/emote/proc/do_extra(var/atom/user, var/atom/target)
	return

/decl/emote/proc/check_user(var/atom/user)
	return TRUE

/decl/emote/proc/can_target()
	return (emote_message_1p_target || emote_message_3p_target)

/decl/emote/dd_SortValue()
	return key