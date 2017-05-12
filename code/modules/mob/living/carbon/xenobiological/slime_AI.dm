/mob/living/carbon/slime/proc/handle_regular_AI()
	if(client)
		return

	if(attacked > 0)
		if(attacked > 50)
			attacked = 50 // Let's not get into absurdly long periods of rage
		--attacked

	if(confused > 0)
		--confused
		return

	if(nutrition < get_starve_nutrition()) // If a slime is starving, it starts losing its friends
		if(Friends.len > 0 && prob(1))
			var/mob/nofriend = pick(Friends)
			if(nofriend && Friends[nofriend])
				Friends[nofriend] -= 1
				if (Friends[nofriend] <= 0)
					Friends[nofriend] = null
					Friends -= nofriend
					Friends -= null

	handle_targets()
	if (!AIproc)
		spawn()
			handle_AI()
	handle_speech_and_mood()

/mob/living/carbon/slime/proc/handle_targets()
	if(Victim) // If it's eating someone already, continue eating!
		return

	if(Target)
		--target_patience
		if (target_patience <= 0 || attacked || rabid) // Tired of chasing or attacking everything nearby
			target_patience = 0
			Target = null

	var/hungry = 0 // determines if the slime is hungry

	if (nutrition < get_starve_nutrition())
		hungry = 2
	else if (nutrition < get_grow_nutrition() && prob(25) || nutrition < get_hunger_nutrition())
		hungry = 1

	if(!Target)
		if(will_hunt(hungry) || attacked || rabid) // Only add to the list if we need to
			var/list/targets = list()

			for(var/mob/living/L in view(7,src))
				if(AssessTarget(L))
					targets += L // Possible target found!

			if(targets.len > 0)
				if(attacked || rabid || hungry == 2)
					Target = targets[1] // I am attacked and am fighting back or so hungry I don't even care
				else
					for(var/mob/living/carbon/C in targets)
						if(ishuman(C) && prob(5))
							Target = C
							break

						if(isalien(C) || issmall(C) || isanimal(C))
							Target = C
							break

		if (Target)
			target_patience = rand(5,7)
			if (is_adult)
				target_patience += 3

	if(!Target) // If we have no target, we are wandering or following orders
		if (Leader)
			if (holding_still)
				holding_still = max(holding_still - 1, 0)
			else if(canmove && isturf(loc))
				step_to(src, Leader)

		else if(hungry)
			if (holding_still)
				holding_still = max(holding_still - 1 - hungry, 0)
			else if(canmove && isturf(loc) && prob(50))
				step(src, pick(GLOB.cardinal))

		else
			if (holding_still)
				holding_still = max(holding_still - 1, 0)
			else if(canmove && isturf(loc) && prob(33))
				step(src, pick(GLOB.cardinal))

/mob/living/carbon/slime/proc/AssessTarget(var/mob/living/M)
	if(isslime(M)) // Ignore other slimes
		return 0

	if(M in Friends) // Ignore friends
		return 0

	if(M.stat != DEAD) // Checks for those we just want to attack
		if(rabid || attacked) // Will attack everything that isn't dead
			return 1

	if(!invalidFeedTarget(M)) // Checks for those we want to eat
		if(istype(M, /mob/living/carbon/human)) // Ignore slime(wo)men - player-controlled slimes still can attack them
			var/mob/living/carbon/human/H = M
			if(H.species.name == "Promethean")
				return 0
		return 1

	return 0

/mob/living/carbon/slime/proc/handle_AI()  // the master AI process
	if(stat == DEAD || client || Victim)
		AIproc = 0
		return // If we're dead or have a client, we don't need AI, if we're feeding, we continue feeding

	if(confused)
		AIproc = 0
		return

	AIproc = 1
	var/addedDelay = 0

	if(amount_grown >= 10 && !Target)
		if(is_adult)
			Reproduce()
		else
			Evolve()
		AIproc = 0
		return

	if(Target) // We're chasing the target
		if(!AssessTarget(Target) || Target == Victim) // We don't need to chase them anymore
			Target = null
			AIproc = 0
			return

		for(var/mob/living/carbon/slime/M in view(1, Target))
			if(M.Victim == Target)
				Target = null
				AIproc = 0
				return

		if(Target.Adjacent(src))
			if(istype(Target, /mob/living/silicon)) // Glomp the silicons
				a_intent = I_HURT
				UnarmedAttack(Target)
				addedDelay = 10

			else if(Target.client && !Target.lying && prob(60 + powerlevel * 4)) // Try to take down the target first
				a_intent = I_DISARM
				UnarmedAttack(Target)
				addedDelay = 10

			else
				a_intent = I_GRAB
				if(invalidFeedTarget(Target))
					a_intent = I_HURT //just glomp them instead
					addedDelay = 10
				UnarmedAttack(Target)

		else if(Target in view(7, src))
			step_to(src, Target)

		else
			Target = null
			AIproc = 0
			return

	else
		var/mob/living/carbon/slime/frenemy
		for (var/mob/living/carbon/slime/S in view(1, src))
			if (S != src)
				frenemy = S
		if (frenemy && prob(1))
			if (frenemy.colour == colour)
				a_intent = I_HELP
			else
				a_intent = I_HURT
			UnarmedAttack(frenemy)

	var/sleeptime = max(movement_delay(), 5) + addedDelay // Maximum one action per half a second
	spawn (sleeptime)
		handle_AI()
	return

/mob/living/carbon/slime/proc/UpdateFace()
	var/newmood = ""
	a_intent = I_HELP
	if(confused)
		newmood = "pout"
	else if(rabid || attacked)
		newmood = "angry"
		a_intent = I_HURT
	else if(Target)
		newmood = "mischevous"

	if (!newmood)
		if (prob(1))
			newmood = pick("sad", ":3")

	if ((mood == "sad" || mood == ":3") && !newmood)
		if (prob(75)) newmood = mood

	if (newmood != mood) // This is so we don't redraw them every time
		mood = newmood
		regenerate_icons()

/mob/living/carbon/slime/proc/handle_speech_and_mood()
	UpdateFace()

	//Speech understanding starts here
	var/to_say
	if (speech_buffer.len > 0)
		var/who = speech_buffer[1] // Who said it?
		var/phrase = speech_buffer[2] // What did they say?
		if ((findtext(phrase, num2text(number)) || findtext(phrase, "slimes"))) // Talking to us
			if (findtext(phrase, "hello") || findtext(phrase, "hi"))
				to_say = pick("Hello...", "Hi...")
			else if (findtext(phrase, "follow"))
				if (Leader)
					if (Leader == who) // Already following him
						to_say = pick("Yes...", "Lead...", "Following...")
					else if (Friends[who] > Friends[Leader]) // VIVA
						Leader = who
						to_say = "Yes... I follow [who]..."
					else
						to_say = "No... I follow [Leader]..."
				else
					if (Friends[who] > 2)
						Leader = who
						to_say = "I follow..."
					else // Not friendly enough
						to_say = pick("No...", "I won't follow...")
			else if (findtext(phrase, "stop"))
				if (Victim) // We are asked to stop feeding
					if (Friends[who] > 4)
						Victim = null
						Target = null
						if (Friends[who] < 7)
							--Friends[who]
							to_say = "Grrr..." // I'm angry but I do it
						else
							to_say = "Fine..."
				else if (Target) // We are asked to stop chasing
					if (Friends[who] > 3)
						Target = null
						if (Friends[who] < 6)
							--Friends[who]
							to_say = "Grrr..." // I'm angry but I do it
						else
							to_say = "Fine..."
				else if (Leader) // We are asked to stop following
					if (Leader == who)
						to_say = "Yes... I'll stay..."
						Leader = null
					else
						if (Friends[who] > Friends[Leader])
							Leader = null
							to_say = "Yes... I'll stop..."
						else
							to_say = "No... I'll keep following..."
			else if (findtext(phrase, "stay"))
				if (Leader)
					if (Leader == who)
						holding_still = Friends[who] * 10
						to_say = "Yes... Staying..."
					else if (Friends[who] > Friends[Leader])
						holding_still = (Friends[who] - Friends[Leader]) * 10
						to_say = "Yes... Staying..."
					else
						to_say = "No... I'll keep following..."
				else
					if (Friends[who] > 2)
						holding_still = Friends[who] * 10
						to_say = "Yes... Staying..."
					else
						to_say = "No... I won't stay..."
		speech_buffer = list()

	//Speech starts here
	if (to_say)
		say (to_say)
	else if(prob(1))
		emote(pick("bounce","sway","light","vibrate","jiggle"))
	else
		var/t = 10
		var/slimes_near = -1 // Don't count myself
		var/dead_slimes = 0
		var/friends_near = list()
		for (var/mob/living/carbon/M in view(7,src))
			if (isslime(M))
				++slimes_near
				if (M.stat == DEAD)
					++dead_slimes
			if (M in Friends)
				t += 20
				friends_near += M
		if (nutrition < get_hunger_nutrition()) t += 10
		if (nutrition < get_starve_nutrition()) t += 10
		if (prob(2) && prob(t))
			var/phrases = list()
			if (Target) phrases += "[Target]... looks tasty..."
			if (nutrition < get_starve_nutrition())
				phrases += "So... hungry..."
				phrases += "Very... hungry..."
				phrases += "Need... food..."
				phrases += "Must... eat..."
			else if (nutrition < get_hunger_nutrition())
				phrases += "Hungry..."
				phrases += "Where is the food?"
				phrases += "I want to eat..."
			phrases += "Rawr..."
			phrases += "Blop..."
			phrases += "Blorble..."
			if (rabid || attacked)
				phrases += "Hrr..."
				phrases += "Nhuu..."
				phrases += "Unn..."
			if (mood == ":3")
				phrases += "Purr..."
			if (attacked)
				phrases += "Grrr..."
			if (getToxLoss() > 30)
				phrases += "Cold..."
			if (getToxLoss() > 60)
				phrases += "So... cold..."
				phrases += "Very... cold..."
			if (getToxLoss() > 90)
				phrases += "..."
				phrases += "C... c..."
			if (Victim)
				phrases += "Nom..."
				phrases += "Tasty..."
			if (powerlevel > 3) phrases += "Bzzz..."
			if (powerlevel > 5) phrases += "Zap..."
			if (powerlevel > 8) phrases += "Zap... Bzz..."
			if (mood == "sad") phrases += "Bored..."
			if (slimes_near) phrases += "Brother..."
			if (slimes_near > 1) phrases += "Brothers..."
			if (dead_slimes) phrases += "What happened?"
			if (!slimes_near)
				phrases += "Lonely..."
			for (var/M in friends_near)
				phrases += "[M]... friend..."
				if (nutrition < get_hunger_nutrition())
					phrases += "[M]... feed me..."
			say (pick(phrases))

/mob/living/carbon/slime/proc/will_hunt(var/hunger) // Check for being stopped from feeding and chasing
	if (hunger == 2 || rabid || attacked) return 1
	if (Leader) return 0
	if (holding_still) return 0
	if (hunger == 1 || prob(25))
		return 1
	return 0
