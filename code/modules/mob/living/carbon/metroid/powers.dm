/mob/living/carbon/slime/proc/Wrap(var/mob/living/M) // This is a proc for the clicks
	if (Victim == M || src == M)
		Feedstop()
		return

	if (Victim)
		src << "I am already feeding..."
		return

	var t = invalidFeedTarget(M)
	if (t)
		src << t
		return

	Feedon(M)

/mob/living/carbon/slime/proc/invalidFeedTarget(var/mob/living/M)
	if (!M || !istype(M))
		return "This subject is incomparable..."
	if (istype(M, /mob/living/carbon/slime)) // No cannibalism... yet
		return "I cannot feed on other slimes..."
	if (!Adjacent(M))
		return "This subject is too far away..."
	if (istype(M, /mob/living/carbon) && M.getCloneLoss() >= M.maxHealth * 1.5 || istype(M, /mob/living/simple_animal) && M.stat == DEAD)
		return "This subject does not have an edible life energy..."
	for(var/mob/living/carbon/slime/met in view())
		if(met.Victim == M && met != src)
			return "The [met.name] is already feeding on this subject..."
	return 0

/mob/living/carbon/slime/proc/Feedon(var/mob/living/M)
	Victim = M
	loc = M.loc
	canmove = 0
	anchored = 1

	regenerate_icons()

	while(Victim && !invalidFeedTarget(M) && stat != 2)
		canmove = 0

		if(Adjacent(M))
			UpdateFeed(M)

			if(istype(M, /mob/living/carbon))
				Victim.adjustCloneLoss(rand(5,6))
				Victim.adjustToxLoss(rand(1,2))
				if(Victim.health <= 0)
					Victim.adjustToxLoss(rand(2,4))

			else if(istype(M, /mob/living/simple_animal))
				Victim.adjustBruteLoss(is_adult ? rand(7, 15) : rand(4, 12))

			else
				src << "<span class='warning'>[pick("This subject is incompatable", "This subject does not have a life energy", "This subject is empty", "I am not satisified", "I can not feed from this subject", "I do not feel nourished", "This subject is not food")]...</span>"
				Feedstop()
				break

			if(prob(15) && M.client && istype(M, /mob/living/carbon))
				var/painMes = pick("You can feel your body becoming weak!", "You feel like you're about to die!", "You feel every part of your body screaming in agony!", "A low, rolling pain passes through your body!", "Your body feels as if it's falling apart!", "You feel extremely weak!", "A sharp, deep pain bathes every inch of your body!")
				if (ishuman(M))
					var/mob/living/carbon/human/H = M
					H.custom_pain(painMes)
				else if (istype(M, /mob/living/carbon))
					var/mob/living/carbon/C = M
					if (!(C.species && (C.species.flags & NO_PAIN)))
						M << "<span class='danger'>[painMes]</span>"

			gain_nutrition(rand(20,25))

			adjustOxyLoss(-10) //Heal yourself
			adjustBruteLoss(-10)
			adjustFireLoss(-10)
			adjustCloneLoss(-10)
			updatehealth()
			if(Victim)
				Victim.updatehealth()

			sleep(30) // Deal damage every 3 seconds
		else
			break

	canmove = 1
	anchored = 0

	if(M && invalidFeedTarget(M)) // This means that the slime drained the victim
		if(!client)
			if(Victim && !rabid && !attacked && Victim.LAssailant && Victim.LAssailant != Victim && prob(50))
				if(!(Victim.LAssailant in Friends))
					Friends[Victim.LAssailant] = 1
				else
					++Friends[Victim.LAssailant]

		else
			src << "<span class='notice'>This subject does not have a strong enough life energy anymore...</span>"

	Victim = null

/mob/living/carbon/slime/proc/Feedstop()
	if(Victim)
		if(Victim.client) Victim << "[src] has let go of your head!"
		Victim = null

/mob/living/carbon/slime/proc/UpdateFeed(var/mob/M)
	if(Victim)
		if(Victim == M)
			loc = M.loc // simple "attach to head" effect!

/mob/living/carbon/slime/verb/Evolve()
	set category = "Slime"
	set desc = "This will let you evolve from baby to adult slime."

	if(stat)
		src << "<span class='notice'>I must be conscious to do this...</span>"
		return

	if(!is_adult)
		if(amount_grown >= 10)
			is_adult = 1
			maxHealth = 200
			amount_grown = 0
			regenerate_icons()
			name = text("[colour] [is_adult ? "adult" : "baby"] slime ([number])")
		else
			src << "<span class='notice'>I am not ready to evolve yet...</span>"
	else
		src << "<span class='notice'>I have already evolved...</span>"

/mob/living/carbon/slime/verb/Reproduce()
	set category = "Slime"
	set desc = "This will make you split into four Slimes."

	if(stat)
		src << "<span class='notice'>I must be conscious to do this...</span>"
		return

	if(is_adult)
		if(amount_grown >= 10)
			if(stat)
				src << "<span class='notice'>I must be conscious to do this...</span>"
				return

			var/list/babies = list()
			var/new_nutrition = round(nutrition * 0.9)
			var/new_powerlevel = round(powerlevel / 4)
			for(var/i = 1, i <= 4, i++)
				var/t = colour
				if(prob(mutation_chance))
					t = slime_mutation[rand(1,4)]
				var/mob/living/carbon/slime/M = new /mob/living/carbon/slime/(loc, t)
				if(ckey)	M.nutrition = new_nutrition //Player slimes are more robust at spliting. Once an oversight of poor copypasta, now a feature!
				M.powerlevel = new_powerlevel
				if(i != 1) step_away(M, src)
				M.Friends = Friends.Copy()
				babies += M
				feedback_add_details("slime_babies_born","slimebirth_[replacetext(M.colour," ","_")]")

			var/mob/living/carbon/slime/new_slime = pick(babies)
			new_slime.universal_speak = universal_speak
			if(src.mind)
				src.mind.transfer_to(new_slime)
			else
				new_slime.key = src.key
			qdel(src)
		else
			src << "<span class='notice'>I am not ready to reproduce yet...</span>"
	else
		src << "<span class='notice'>I am not old enough to reproduce yet...</span>"