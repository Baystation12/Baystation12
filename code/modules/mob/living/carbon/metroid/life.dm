/mob/living/carbon/slime/Life()
	set invisibility = 0
	set background = 1

	if (src.transforming)
		return

	..()

	if(stat != DEAD)
		handle_nutrition()

		if (!client)
			handle_targets()
			if (!AIproc)
				spawn()
					handle_AI()
			handle_speech_and_mood()

	regular_hud_updates()

	handle_regular_status_updates() // Status updates, death etc.

/mob/living/carbon/slime/handle_environment(datum/gas_mixture/environment)
	if(!environment)
		adjustToxLoss(rand(10,20))
		return

	//var/environment_heat_capacity = environment.heat_capacity()
	var/loc_temp = T0C
	if(istype(get_turf(src), /turf/space))
		//environment_heat_capacity = loc:heat_capacity
		var/turf/heat_turf = get_turf(src)
		loc_temp = heat_turf.temperature
	else if(istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
		loc_temp = loc:air_contents.temperature
	else
		loc_temp = environment.temperature

	if(loc_temp < 310.15) // a cold place
		bodytemperature += adjust_body_temperature(bodytemperature, loc_temp, 1)
	else // a hot place
		bodytemperature += adjust_body_temperature(bodytemperature, loc_temp, 1)

	//Account for massive pressure differences

	if(bodytemperature < (T0C + 5)) // start calculating temperature damage etc

		if(bodytemperature <= (T0C - 50)) // hurt temperature
			if(bodytemperature <= 50) // sqrting negative numbers is bad
				adjustToxLoss(200)
			else
				adjustToxLoss(round(sqrt(bodytemperature)) * 2)

	updatehealth()

	return //TODO: DEFERRED

/mob/living/carbon/slime/proc/adjust_body_temperature(current, loc_temp, boost)
	var/temperature = current
	var/difference = abs(current-loc_temp)	//get difference
	var/increments// = difference/10			//find how many increments apart they are
	if(difference > 50)
		increments = difference/5
	else
		increments = difference/10
	var/change = increments*boost	// Get the amount to change by (x per increment)
	var/temp_change
	if(current < loc_temp)
		temperature = min(loc_temp, temperature+change)
	else if(current > loc_temp)
		temperature = max(loc_temp, temperature-change)
	temp_change = (temperature - current)
	return temp_change

/mob/living/carbon/slime/handle_chemicals_in_body()
	chem_effects.Cut()
	analgesic = 0

	if(touching)
		touching.metabolize(0, CHEM_TOUCH)
	if(ingested)
		ingested.metabolize(0, CHEM_INGEST)
	if(reagents)
		reagents.metabolize(0, CHEM_BLOOD)

	if(CE_PAINKILLER in chem_effects)
		analgesic = chem_effects[CE_PAINKILLER]

	src.updatehealth()

	return //TODO: DEFERRED

/mob/living/carbon/slime/proc/handle_regular_status_updates()

	src.blinded = null

	health = maxHealth - (getOxyLoss() + getToxLoss() + getFireLoss() + getBruteLoss() + getCloneLoss())

	if(health < 0 && stat != DEAD)
		death()
		return

	if (halloss)
		halloss = 0

	if(prob(30))
		adjustOxyLoss(-1)
		adjustToxLoss(-1)
		adjustFireLoss(-1)
		adjustCloneLoss(-1)
		adjustBruteLoss(-1)

	if (src.stat == DEAD)
		src.lying = 1
		src.blinded = 1
	else
		if (src.paralysis || src.stunned || src.weakened || (status_flags && FAKEDEATH)) //Stunned etc.
			if (src.stunned > 0)
				AdjustStunned(-1)
				src.stat = 0
			if (src.weakened > 0)
				AdjustWeakened(-1)
				src.lying = 0
				src.stat = 0
			if (src.paralysis > 0)
				AdjustParalysis(-1)
				src.blinded = 0
				src.lying = 0
				src.stat = 0

		else
			src.lying = 0
			src.stat = 0

	if (src.stuttering) src.stuttering = 0

	if (src.eye_blind)
		src.eye_blind = 0
		src.blinded = 1

	if (src.ear_deaf > 0) src.ear_deaf = 0
	if (src.ear_damage < 25)
		src.ear_damage = 0

	src.density = !( src.lying )

	if (src.sdisabilities & BLIND)
		src.blinded = 1
	if (src.sdisabilities & DEAF)
		src.ear_deaf = 1

	if (src.eye_blurry > 0)
		src.eye_blurry = 0

	if (src.druggy > 0)
		src.druggy = 0

	return 1

/mob/living/carbon/slime/proc/handle_nutrition()

	if (prob(15))
		nutrition -= 1 + is_adult

	if(nutrition <= 0)
		nutrition = 0
		adjustToxLoss(rand(1,3))
		if (client && prob(5))
			src << "<span class='danger'>You are starving!</span>"

	else if (nutrition >= get_grow_nutrition() && amount_grown < 10)
		nutrition -= 20
		amount_grown++

/mob/living/carbon/slime/proc/handle_targets()
	if(attacked > 50) attacked = 50 // Let's not get into absurdly long periods of rage

	if(attacked > 0)
		attacked--

	if(Discipline > 0)

		if(Discipline >= 5 && rabid)
			if(prob(60)) rabid = 0

		if(prob(10))
			Discipline--

	if(!canmove) return

	if(Victim) return // if it's eating someone already, continue eating!

	if(Target)
		--target_patience
		if (target_patience <= 0 || SStun || Discipline || attacked) // Tired of chasing or something draws out attention
			target_patience = 0
			Target = null

	var/hungry = 0 // determines if the slime is hungry

	if (nutrition < get_starve_nutrition())
		hungry = 2
	else if (nutrition < get_grow_nutrition() && prob(25) || nutrition < get_hunger_nutrition())
		hungry = 1

	if(hungry == 2 && !client) // if a slime is starving, it starts losing its friends
		if(Friends.len > 0 && prob(1))
			var/mob/nofriend = pick(Friends)
			--Friends[nofriend]
			if (Friends[nofriend] <= 0)
				Friends -= nofriend

	if(!Target)
		if(will_hunt(hungry) || attacked || rabid) // Only add to the list if we need to
			var/list/targets = list()

			for(var/mob/living/L in view(7,src))

				if(isslime(L) || L.stat == DEAD) // Ignore other slimes and dead mobs
					continue

				if(L in Friends) // No eating friends!
					continue

				if(issilicon(L) && (rabid || attacked)) // They can't eat silicons, but they can glomp them in defence
					targets += L // Possible target found!

				if(istype(L, /mob/living/carbon/human) && dna) //Ignore slime(wo)men
					var/mob/living/carbon/human/H = L
					if(H.species.name == "Slime")
						continue

				if(!L.canmove) // Only one slime can latch on at a time.
					var/notarget = 0
					for(var/mob/living/carbon/slime/M in view(1,L))
						if(M.Victim == L)
							notarget = 1
					if(notarget)
						continue

				targets += L // Possible target found!

			if(targets.len > 0)
				if(attacked || rabid || hungry == 2)
					Target = targets[1] // I am attacked and am fighting back or so hungry I don't even care
				else
					for(var/mob/living/carbon/C in targets)
						if(ishuman(C) && !Discipline && prob(5))
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
				step(src, pick(cardinal))

		else
			if (holding_still)
				holding_still = max(holding_still - 1, 0)
			else if(canmove && isturf(loc) && prob(33))
				step(src, pick(cardinal))

/mob/living/carbon/slime/proc/handle_AI()  // the master AI process

	if(stat == DEAD || client || Victim) return // If we're dead or have a client, we don't need AI, if we're feeding, we continue feeding
	AIproc = 1

	if(amount_grown >= 10 && !Target)
		if(is_adult)
			Reproduce()
		else
			Evolve()
		AIproc = 0
		return

	if(Target) // We're chasing the target
		if(Target.stat == DEAD)
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
				if(!Atkcool)
					a_intent = I_HURT
					UnarmedAttack(Target)
					Atkcool = 1
					spawn(45)
						Atkcool = 0
				AIproc = 0
				return

			if(Target.client && !Target.lying && prob(60 + powerlevel * 4)) // Try to take down the target first
				if(!Atkcool)
					Atkcool = 1
					spawn(45)
						Atkcool = 0

					a_intent = I_DISARM
					UnarmedAttack(Target)

			else
				if(!Atkcool)
					a_intent = I_GRAB
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

	var/sleeptime = movement_delay()
	if(sleeptime <= 5) sleeptime = 5 // Maximum one action per half a second
	spawn (sleeptime)
		handle_AI()
	return

/mob/living/carbon/slime/proc/handle_speech_and_mood()
	//Mood starts here
	var/newmood = ""
	a_intent = I_HELP
	if (rabid || attacked)
		newmood = "angry"
		a_intent = I_HURT
	else if (Target) newmood = "mischevous"

	if (!newmood)
		if (Discipline && prob(25))
			newmood = "pout"
		else if (prob(1))
			newmood = pick("sad", ":3", "pout")

	if ((mood == "sad" || mood == ":3" || mood == "pout") && !newmood)
		if (prob(75)) newmood = mood

	if (newmood != mood) // This is so we don't redraw them every time
		mood = newmood
		regenerate_icons()

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

/mob/living/carbon/slime/proc/get_max_nutrition() // Can't go above it
	if (is_adult) return 1200
	else return 1000

/mob/living/carbon/slime/proc/get_grow_nutrition() // Above it we grow, below it we can eat
	if (is_adult) return 1000
	else return 800

/mob/living/carbon/slime/proc/get_hunger_nutrition() // Below it we will always eat
	if (is_adult) return 600
	else return 500

/mob/living/carbon/slime/proc/get_starve_nutrition() // Below it we will eat before everything else
	if (is_adult) return 300
	else return 200

/mob/living/carbon/slime/proc/will_hunt(var/hunger) // Check for being stopped from feeding and chasing
	if (hunger == 2 || rabid || attacked) return 1
	if (Leader) return 0
	if (holding_still) return 0
	if (hunger == 1 || prob(25))
		return 1
	return 0

/mob/living/carbon/slime/slip() //Can't slip something without legs.
	return 0