//affected_mob.contract_disease(new /datum/disease/alien_embryo)

//cael - retained this file for legacy reference, see code\modules\mob\living\carbon\alien\special\alien_embryo.dm for replacement

//Our own special process so that dead hosts still chestburst
/datum/disease/alien_embryo/process()
	if(!holder) return
	if(holder == affected_mob)
		stage_act()
	if(affected_mob)
		if(affected_mob.stat == DEAD)
			if(prob(50))
				if(--longevity<=0)
					cure(0)
	else //the virus is in inanimate obj
		cure(0)
	return

/datum/disease/alien_embryo/New()
	..()
	/* Special Hud for xenos */
	spawn(0)
		if (affected_mob)
			AddInfectionImages(affected_mob)

/datum/disease/alien_embryo/cure(var/resistance=1)
	..()
	spawn(0)
		if (affected_mob)
			RemoveInfectionImages(affected_mob)

/datum/disease/alien_embryo
	name = "Unidentified Foreign Body"
	max_stages = 5
	spread = "None"
	spread_type = SPECIAL
	cure = "Unknown"
	cure_id = list("lexorin","toxin","gargleblaster")
	cure_chance = 50
	affected_species = list("Human", "Monkey")
	permeability_mod = 15//likely to infect
	can_carry = 0
	stage_prob = 3
	var/gibbed = 0
	stage_minimum_age = 300

/datum/disease/alien_embryo/stage_act()
	..()
	switch(stage)
		if(2, 3)
			if(prob(1))
				affected_mob.emote("sneeze")
			if(prob(1))
				affected_mob.emote("cough")
			if(prob(1))
				affected_mob << "\red Your throat feels sore."
			if(prob(1))
				affected_mob << "\red Mucous runs down the back of your throat."
		if(4)
			if(prob(1))
				affected_mob.emote("sneeze")
			if(prob(1))
				affected_mob.emote("cough")
			if(prob(2))
				affected_mob << "\red Your muscles ache."
				if(prob(20))
					affected_mob.take_organ_damage(1)
			if(prob(2))
				affected_mob << "\red Your stomach hurts."
				if(prob(20))
					affected_mob.adjustToxLoss(1)
					affected_mob.updatehealth()
		if(5)
			affected_mob << "\red You feel something tearing its way out of your stomach..."
			affected_mob.adjustToxLoss(10)
			affected_mob.updatehealth()
			if(prob(50))
				if(gibbed != 0) return 0
				var/list/candidates = get_alien_candidates()
				var/picked = null

				// To stop clientless larva, we will check that our host has a client
				// if we find no ghosts to become the alien. If the host has a client
				// he will become the alien but if he doesn't then we will set the stage
				// to 2, so we don't do a process heavy check everytime.

				if(candidates.len)
					picked = pick(candidates)
				else if(affected_mob.client)
					picked = affected_mob.key
				else
					stage = 2 // Let's try again later.
					return

				var/mob/living/carbon/alien/larva/new_xeno = new(affected_mob.loc)
				new_xeno.key = picked
				new_xeno << sound('sound/voice/hiss5.ogg',0,0,0,100)	//To get the player's attention
				affected_mob.gib()
				src.cure(0)
				gibbed = 1
				return

/datum/disease/alien_embryo/stage_change(var/old_stage)
	RefreshInfectionImage()

/*----------------------------------------
Proc: RefreshInfectionImage()
Des: Removes all infection images from aliens and places an infection image on all infected mobs for aliens.
----------------------------------------*/
/datum/disease/alien_embryo/proc/RefreshInfectionImage()
	spawn(0)
		for (var/mob/living/carbon/alien/alien in player_list)
			if (alien.client)
				for(var/image/I in alien.client.images)
					if(dd_hasprefix_case(I.icon_state, "infected"))
						del(I)

		for (var/mob/living/carbon/alien/alien in player_list)
			if (alien.client)
				for (var/mob/living/carbon/C in mob_list)
					if(C)
						if (C.status_flags & XENO_HOST)
							var/I = image('icons/mob/alien.dmi', loc = C, icon_state = "infected[stage]")
							alien.client.images += I
		return

/*----------------------------------------
Proc: AddInfectionImages(C)
Des: Checks if the passed mob (C) is infected with the alien egg, then gives each alien client an infected image at C.
----------------------------------------*/
/datum/disease/alien_embryo/proc/AddInfectionImages(var/mob/living/carbon/C)
	if (C)
		for (var/mob/living/carbon/alien/alien in player_list)
			if (alien.client)
				if (C.status_flags & XENO_HOST)
					var/I = image('icons/mob/alien.dmi', loc = C, icon_state = "infected[stage]")
					alien.client.images += I
	return

/*----------------------------------------
Proc: RemoveInfectionImage(C)
Des: Removes the alien infection image from all aliens in the world located in passed mob (C).
----------------------------------------*/

/datum/disease/alien_embryo/proc/RemoveInfectionImages(var/mob/living/carbon/C)
	if (C)
		for (var/mob/living/carbon/alien/alien in player_list)
			if (alien.client)
				for(var/image/I in alien.client.images)
					if(I.loc == C)
						if(dd_hasprefix_case(I.icon_state, "infected"))
							del(I)
	return
