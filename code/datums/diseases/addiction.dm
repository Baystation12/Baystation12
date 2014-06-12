/datum/disease/addiction
	name = "Chemical Addiction"
	max_stages = 5
	spread = "None"
	spread_type = SPECIAL
	cure = "Unknown"
	cure_id = list("fixer", "water")
	cure_chance = 3
	affected_species = list("Human", "Monkey", "Skrell", "Unathi", "Tajaran", "Kidan", "Grey")
	var/datum/reagent/addicted_to
	var/addiction
	var/addiction_countdown = 1800 // Three minutes

/datum/disease/addiction/New()
	if(addicted_to)
		src.name = "[addicted_to.name] Addiction"
		src.addiction ="[addicted_to.name]"
		src.cure = addicted_to.id
		//affected_mob.addictions += addicted_to
	..()

/datum/disease/addiction/proc/has_addict_reagent()
	var/result = 0
	if(affected_mob.reagents.has_reagent(addicted_to))
		result = 1
	return result

/datum/disease/addiction/process()
	if(!holder) return
	var/addict_reagent_present = has_addict_reagent()
	var/tickcount = 0

	if(affected_mob)
		for(var/datum/disease/D in affected_mob.viruses)
			if(D != src)
				if(istype(src, D.type))
					if(istype(src.addicted_to, D:addicted_to)) // Allow for multiple addictions as long as each addiction is for a different reagent
						del(src) // if there are somehow two viruses of the same kind in the system, delete the other one

	if(holder == affected_mob)
		if(affected_mob.stat < 2) //he's alive
			if(addict_reagent_present) //he's taken the reagent to which he's addicted
				stage = 1
				tickcount++
				if(prob(20))
					affected_mob << "\blue You feel a wave of euphoria as [addiction] surges through your bloodstream..."
				if(tickcount >= 900)
					stage_act()
					tickcount = 0
			else //he's ignored his addiction or hasn't taken the reagent
				stage_act()
		else //he's dead.
			if(spread_type!=SPECIAL)
				spread_type = CONTACT_GENERAL
			affected_mob = null
	if(!affected_mob) //the virus is in inanimate obj
		if(prob(70))
			if(--longevity<=0)
				cure(0)
	return

/datum/disease/addiction/stage_act()
	var/cure_present = has_cure()
	var/addict_reagent_present = has_addict_reagent()

	if(carrier&&!cure_present)
		return

	spread = (cure_present?"Remissive":initial(spread))

	if(stage > max_stages)
		stage = max_stages
	if(stage_prob != 0 && prob(stage_prob) && stage != max_stages && !cure_present && !addict_reagent_present) //now the disease shouldn't get back up to stage 4 in no time
		stage++
	if(stage != 1 && (prob(1) || (cure_present && prob(cure_chance))))
		stage--
	else if(stage <= 1 && ((prob(1) && curable) || (cure_present && prob(cure_chance))))
		cure()
		return

	switch(stage)
		if(2)
			if(prob(5))
				affected_mob << "\red You can't stop thinking about [addiction]!"
			if(affected_mob.sleeping && prob(1))
				affected_mob << "\blue You feel better."
				stage--
			if(prob(1))
				if(prob(1))
					stage--
		if(3)
			if(prob(5))
				affected_mob << "\red You gotta have some [addiction]!"
			if(affected_mob.sleeping && prob(1))
				affected_mob << "\blue You feel better."
				stage--
			if(prob(1))
				if(prob(1))
					stage--
		if(4)
			if(prob(7))
				affected_mob << "\red Gotta have some [addiction]!"
				if(prob(10))
					affected_mob.take_organ_damage(1)
			if(prob(2))
				affected_mob << "\red Your stomach hurts."
				if(prob(5))
					affected_mob.emote("blink")
				if(prob(10))
					affected_mob.toxloss += 1
					affected_mob.updatehealth()
			if(affected_mob.sleeping && prob(1))
				affected_mob << "\blue You feel better."
				stage--
			if(prob(1))
				if(prob(1))
					stage--
		if(5)
			if(prob(5))
				affected_mob << "\red \bold You can't stand not having [addiction]!"
				if(prob(20))
					affected_mob.toxloss += 2
					affected_mob.updatehealth()
			if(prob(2))
				affected_mob << "\red \bold [addiction] calls out to your mind!"
				for(var/mob/O in viewers(affected_mob, null))
					O.show_message(text("\red [] rakes at their eyes!", affected_mob), 1)
				affected_mob.eye_blind = 2
				affected_mob.eye_blurry = 3
			if(prob(1))
				affected_mob.emote("twitch")
			if(affected_mob.sleeping && prob(1))
				affected_mob << "\blue You feel better."
				stage--
			if(prob(1))
				if(prob(1))
					stage--