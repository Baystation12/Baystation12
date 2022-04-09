// Contains code for speaking and emoting.

/datum/ai_holder
	var/threaten = FALSE				// If hostile and sees a valid target, gives a 'warning' to the target before beginning the attack.
	var/threatening = FALSE				// If the mob actually gave the warning, checked so it doesn't constantly yell every tick.
	var/threaten_delay = 3 SECONDS		// How long a 'threat' lasts, until actual fighting starts. If null, the mob never starts the fight but still does the threat.
	var/threaten_timeout = 1 MINUTE		// If the mob threatens someone, they leave, and then come back before this timeout period, the mob escalates to fighting immediately.
	var/last_conflict_time = null		// Last occurance of fighting being used, in world.time.
	var/last_threaten_time = null		// Ditto but only for threats.
	var/last_target_time = null			// Ditto for when we last switched targets, used to stop retaliate from gimping mobs

	var/speak_chance = 0				// Probability that the mob talks (this is 'X in 200' chance since even 1/100 is pretty noisy)


/datum/ai_holder/proc/should_threaten()
	if (!threaten)
		return FALSE // We don't negotiate.
	if (check_attacker(target))
		return FALSE // They (or someone like them) attacked us before, escalate immediately.
	if (!will_threaten(target))
		return FALSE // Pointless to threaten an animal, a mindless drone, or an object.
	if (stance in STANCES_COMBAT)
		return FALSE // We're probably already fighting or recently fought if not in these stances.
	if (last_threaten_time && threaten_delay && last_conflict_time + threaten_timeout > world.time)
		return FALSE // We threatened someone recently, so lets show them we mean business.
	return TRUE // Lets give them a chance to choose wisely and walk away.

/datum/ai_holder/proc/threaten_target()
	holder.face_atom(target) // Constantly face the target.

	if (!threatening) // First tick.
		threatening = TRUE
		last_threaten_time = world.time

		if (holder.say_list?.say_threaten)
			holder.ISay(pick(holder.say_list.say_threaten))
			playsound(holder, holder.say_list.threaten_sound, 50, 1) // We do this twice to make the sound -very- noticable to the target.
			playsound(target, holder.say_list.threaten_sound, 50, 1) // Actual aim-mode also does that so at least it's consistant.
	else // Otherwise we are waiting for them to go away or to wait long enough for escalate.
		if (target in list_targets()) // Are they still visible?
			var/should_escalate = FALSE

			if (threaten_delay && last_threaten_time + threaten_delay < world.time) // Waited too long.
				should_escalate = TRUE

			if (should_escalate)
				threatening = FALSE
				set_stance(STANCE_APPROACH)
				if (holder.say_list?.say_escalate)
					holder.ISay(pick(holder.say_list.say_escalate))
			else
				return // Wait a bit.

		else // They left, or so we think.
			if (last_threaten_time + threaten_timeout < world.time)	// They've been gone long enough, probably safe to stand down
				threatening = FALSE
			set_stance(STANCE_IDLE)
			if (holder.say_list?.say_stand_down)
				holder.ISay(pick(holder.say_list.say_stand_down))
				playsound(holder, holder.say_list.stand_down_sound, 50, 1) // We do this twice to make the sound -very- noticable to the target.
				playsound(target, holder.say_list.stand_down_sound, 50, 1) // Actual aim-mode also does that so at least it's consistant.

// Determines what is deserving of a warning when STANCE_ALERT is active.
/datum/ai_holder/proc/will_threaten(mob/living/the_target)
	if (!isliving(the_target))
		return FALSE // Turrets don't give a fuck so neither will we.
	/*
	// Find a nice way of doing this later.
	if (istype(the_target, /mob/living/simple_animal) && istype(holder, /mob/living/simple_animal))
		var/mob/living/simple_animal/us = holder
		var/mob/living/simple_animal/them = target

		if (them.intelligence_level < us.intelligence_level) // Todo: Bitflag these.
			return FALSE // Humanoids don't care about drones/animals/etc. Drones don't care about animals, and so on.
		*/
	return TRUE

// Temp defines to make the below code a bit more readable.
#define COMM_SAY				"say"
#define COMM_AUDIBLE_EMOTE		"audible emote"
#define COMM_VISUAL_EMOTE		"visual emote"

/datum/ai_holder/proc/handle_idle_speaking()
	if (rand(0,200) < speak_chance)
		// Check if anyone is around to 'appreciate' what we say.
		var/alone = TRUE
		for(var/m in viewers(holder))
			var/mob/M = m
			if (M.client)
				alone = FALSE
				break
		if (alone) // Forever alone. No point doing anything else.
			return

		var/list/comm_types = list() // What kinds of things can we do?
		if (!holder.say_list)
			return

		if (holder.say_list.speak.len)
			comm_types += COMM_SAY
		if (holder.say_list.emote_hear.len)
			comm_types += COMM_AUDIBLE_EMOTE
		if (holder.say_list.emote_see.len)
			comm_types += COMM_VISUAL_EMOTE

		if (!comm_types.len)
			return // All the relevant lists are empty, so do nothing.

		switch(pick(comm_types))
			if (COMM_SAY)
				holder.ISay(pick(holder.say_list.speak))
			if (COMM_AUDIBLE_EMOTE)
				holder.audible_emote(pick(holder.say_list.emote_hear))
			if (COMM_VISUAL_EMOTE)
				holder.visible_emote(pick(holder.say_list.emote_see))

#undef COMM_SAY
#undef COMM_AUDIBLE_EMOTE
#undef COMM_VISUAL_EMOTE

// Handles the holder hearing a mob's say()
// Does nothing by default, override this proc for special behavior.
/datum/ai_holder/proc/on_hear_say(mob/living/speaker, message)
	return

// This is to make responses feel a bit more natural and not instant.
/datum/ai_holder/proc/delayed_say(message, mob/speak_to)
	addtimer(CALLBACK(src, .proc/do_delayed_say, message, speak_to), rand(1 SECOND, 2 SECONDS))

/datum/ai_holder/proc/do_delayed_say(message, mob/speak_to)
	if (!src || !holder || !can_act())  // We might've died/got deleted/etc in the meantime.
		return

	if (speak_to)
		holder.face_atom(speak_to)
	holder.ISay(message)
