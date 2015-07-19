/datum/mob_ai_state/default_idle
	var/speak_chance = 0

	var/wanders = 1
	var/ticks_per_move = 1
	var/ticks_since_move = 0
	var/stop_wandering_when_pulled = 1	// Do we cease wandering while pulled?

/datum/mob_ai_state/default_idle/Life(datum/mob_ai/ai)
	..()
	Movement(ai)
	Speech(ai)

/datum/mob_ai_state/default_idle/proc/Movement(datum/mob_ai/ai)
	//Movement
	var/mob/host = ai.host
	if(wanders && !host.anchored && isturf(host.loc) && !host.incapacitated())		//This is so it only moves if it's not inside a closet, gentics machine, etc.
		ticks_since_move++
		if(ticks_since_move >= ticks_per_move && !(stop_wandering_when_pulled && host.pulledby)) //Some mobs don't move when pulled
			var/moving_to = 0 // otherwise it always picks 4, fuck if I know.   Did I mention fuck BYOND
			moving_to = pick(cardinal)
			host.set_dir(moving_to)			//How about we turn them the direction they are moving, yay.
			host.Move(get_step(host,moving_to))
			ticks_since_move = 0

/datum/mob_ai_state/default_idle/proc/Speech(datum/mob_ai/ai)
	var/mob/host = ai.host
	if(host.speak_chance && rand(0,200) < host.speak_chance)
		if(host.speak.len)
			if((host.emote_hear.len) || (host.emote_see.len))
				var/length = host.speak.len
				if(host.emote_hear.len)
					length += host.emote_hear.len
				if(host.emote_see.len)
					length += host.emote_see.len
				var/randomValue = rand(1,length)
				if(randomValue <= host.speak.len)
					host.say(pick(host.speak))
				else
					randomValue -= host.speak.len
					if(randomValue <= host.emote_see.len)
						host.visible_emote("[pick(host.emote_see)].")
					else
						host.audible_emote("[pick(host.emote_hear)].")
			else
				host.say(pick(host.speak))
		else
			if(!(host.emote_hear.len) && (host.emote_see.len))
				host.visible_emote("[pick(host.emote_see)].")
			if((host.emote_hear.len) && !(host.emote_see.len))
				host.audible_emote("[pick(host.emote_hear)].")
			if((host.emote_hear.len) && (host.emote_see.len))
				var/length = host.emote_hear.len + host.emote_see.len
				var/pick = rand(1,length)
				if(pick <= host.emote_see.len)
					host.visible_emote("[pick(host.emote_see)].")
				else
					host.audible_emote("[pick(host.emote_hear)].")
