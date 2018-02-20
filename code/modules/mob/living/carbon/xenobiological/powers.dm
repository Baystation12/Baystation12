/mob/living/carbon/slime/proc/Wrap(var/mob/living/M) // This is a proc for the clicks
	if (Victim == M || src == M)
		Feedstop()
		return

	if (Victim)
		to_chat(src, "I am already feeding...")
		return

	var t = invalidFeedTarget(M)
	if (t)
		to_chat(src, t)
		return

	Feedon(M)

/mob/living/carbon/slime/proc/invalidFeedTarget(var/mob/living/M)
	if (!istype(M))
		return "This subject is incompatible..."
	if (istype(M, /mob/living/carbon/slime)) // No cannibalism... yet
		return "I cannot feed on other slimes..."
	if (!Adjacent(M))
		return "This subject is too far away..."
	if (issilicon(M))
		return "This subject does not have an edible life energy..."
	if (M.getarmor(null, "bio") >= 100)
		return "This subject is protected..."
	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.species_flags & (SPECIES_FLAG_NO_POISON|SPECIES_FLAG_NO_SCAN))
			//they can't take clone or tox damage, then for the most part they aren't affected by being fed on - and presumably feeding on them would not affect the slime either
			return "This subject does not have an edible life energy..."
	if (istype(M, /mob/living/carbon) && M.getCloneLoss() >= M.maxHealth * 1.5 || istype(M, /mob/living/simple_animal) && M.stat == DEAD)
		return "This subject does not have an edible life energy..."
	for(var/mob/living/carbon/slime/met in view())
		if(met.Victim == M && met != src)
			return "\The [met] is already feeding on this subject..."
	return 0

/mob/living/carbon/slime/proc/Feedon(var/mob/living/M)
	set waitfor = 0
	Victim = M
	forceMove(M.loc)

	sleep(20) // A small delay to give the victim a chance to shake them off

	regenerate_icons()
	var/happyWithFood = 0
	var/totalDrained = 0

	while(Victim && stat != 2)
		if(Adjacent(M))
			UpdateFeed()

			var/hazmat = blocked_mult(M.getarmor(null, "bio")) //scale feeding rate by overall bio protection
			if(istype(M, /mob/living/carbon))
				Victim.adjustCloneLoss(5 * hazmat)
				Victim.adjustToxLoss(1 * hazmat)
				if(Victim.health <= 0)
					Victim.adjustToxLoss(1 * hazmat)

			else if(istype(M, /mob/living/simple_animal))
				Victim.adjustBruteLoss(10 * hazmat)

			else
				to_chat(src, "<span class='warning'>[pick("This subject is incompatable", "This subject does not have a life energy", "This subject is empty", "I am not satisified", "I can not feed from this subject", "I do not feel nourished", "This subject is not food")]...</span>")
				Feedstop()
				break

			if(prob(15) && M.client && istype(M, /mob/living/carbon))
				var/painMes = pick("You can feel your body becoming weak!", "You feel like you're about to die!", "You feel every part of your body screaming in agony!", "A low, rolling pain passes through your body!", "Your body feels as if it's falling apart!", "You feel extremely weak!", "A sharp, deep pain bathes every inch of your body!")
				if (ishuman(M))
					var/mob/living/carbon/human/H = M
					H.custom_pain(painMes,100)
				else if (istype(M, /mob/living/carbon))
					var/mob/living/carbon/C = M
					if (C.can_feel_pain())
						to_chat(M, "<span class='danger'>[painMes]</span>")

			gain_nutrition(20 * hazmat)
			totalDrained += 20 * hazmat
			if(totalDrained > 200)
				happyWithFood = 1

			var/heal_amt = 10 * hazmat
			adjustOxyLoss(-heal_amt) //Heal yourself
			adjustBruteLoss(-heal_amt)
			adjustFireLoss(-heal_amt)
			adjustCloneLoss(-heal_amt)
			updatehealth()
			if(Victim)
				Victim.updatehealth()

			if(invalidFeedTarget(M) && totalDrained > 40) // Drained
				happyWithFood = 1
				break

			sleep(20) // Deal damage every 2 seconds
		else
			break

	if(happyWithFood) // This means that the slime has either drained the victim or let it go
		if(!client)
			if(Victim && !rabid && !attacked && Victim.LAssailant && Victim.LAssailant != Victim)
				if(!(Victim.LAssailant in Friends))
					Friends[Victim.LAssailant] = 1
				else
					++Friends[Victim.LAssailant]

		else
			to_chat(src, "<span class='notice'>This subject does not have a strong enough life energy anymore...</span>")

	Victim = null

/mob/living/carbon/slime/proc/Feedstop()
	if(Victim)
		Victim = null

/mob/living/carbon/slime/proc/UpdateFeed()
	if(Victim)
		forceMove(Victim.loc) // simple "attach to head" effect!

/mob/living/carbon/slime/verb/Evolve()
	set category = "Slime"
	set desc = "This will let you evolve from baby to adult slime."

	if(stat)
		to_chat(src, "<span class='notice'>I must be conscious to do this...</span>")
		return

	if(!is_adult)
		if(amount_grown >= 10)
			is_adult = 1
			maxHealth = 200
			amount_grown = 0
			regenerate_icons()
			SetName(text("[colour] [is_adult ? "adult" : "baby"] slime ([number])"))
		else
			to_chat(src, "<span class='notice'>I am not ready to evolve yet...</span>")
	else
		to_chat(src, "<span class='notice'>I have already evolved...</span>")

/mob/living/carbon/slime/verb/Reproduce()
	set category = "Slime"
	set desc = "This will make you split into four slimes."

	if(stat)
		to_chat(src, "<span class='notice'>I must be conscious to do this...</span>")
		return

	if(is_adult)
		if(amount_grown >= 10)
			if(stat)
				to_chat(src, "<span class='notice'>I must be conscious to do this...</span>")
				return

			var/list/babies = list()
			var/list/mutations = GetMutations()
			for(var/i = 1 to 4)
				var/t = colour
				if(prob(mutation_chance))
					t = pick(mutations)
				var/mob/living/carbon/slime/M = new /mob/living/carbon/slime(loc, t)
				if(i != 1)
					step_away(M, src)
				M.Friends = Friends.Copy()
				babies += M
				feedback_add_details("slime_babies_born","slimebirth_[replacetext(M.colour," ","_")]")

			var/mob/living/carbon/slime/new_slime = babies[1]
			new_slime.universal_speak = universal_speak
			if(src.mind)
				src.mind.transfer_to(new_slime)
			else
				new_slime.key = src.key
			qdel(src)
		else
			to_chat(src, "<span class='notice'>I am not ready to reproduce yet...</span>")
	else
		to_chat(src, "<span class='notice'>I am not old enough to reproduce yet...</span>")
