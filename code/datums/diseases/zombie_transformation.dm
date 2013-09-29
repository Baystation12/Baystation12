/datum/disease/zombie_transformation		//Labeling the class as an effect type
	name = "zombie virus"
	max_stages = 5
	spread_type = CONTACT_GENERAL			//Maybe switch back to hands?
	hidden = list(1, 0)
	cure = "Spaceacillin"
	cure_id ="necrocure"
	cure_list = list("necrocure", "zmeat")
	cure_chance = 5
	holder = /mob/living/simple_animal/hostile/zombie
	agent = "Necrophobes T"
	affected_species = list("Human", "Monkey")	//Monkeys can carry the virus but are not directly affected by it
	desc = null
	severity = "DANGEROUS"
	permeability_mod = 0.8
	contagious_period = 0
	var/gibbed = 0
	var/faction = "undead"
	stage_minimum_age = 110
	stage_prob = 10
	longevity = 600

/datum/disease/zombie_transformation/stage_act()
	if(istype(affected_mob, /mob/living/simple_animal/hostile/zombie))	//Double check first, suppose to stop zombie from curing itself...
		return	//Do nothing
	..()			//There is still a chance that the dead body will "cure" itself, anybody killed by zeds will probably either cure or turn
	if(affected_mob.stat == 2 && !istype(affected_mob, /mob/living/carbon/monkey))
		sleep(rand(10,3000))
		affected_mob:Turnundead()	//Doesn't support turning monkies undead
		return		//add turn zombie
	if(istype(affected_mob, /mob/living/carbon/human))	//Percents might be a little high
		switch(stage)
			if(2)
				if(prob(4))
					affected_mob << "\blue You feel hot."
					affected_mob.bodytemperature += 10
				if(prob(4))
					affected_mob.say("*cough")
					return
				if(prob(1))
					affected_mob << "\red You smell meat."
			if(3)
				if(prob(8))
					affected_mob << "\red Your skin itches."
					var/vatk_target = pick("head", "chest", "l_hand", "r_hand", "l_leg", "r_leg")
					affected_mob.apply_damage(2, BRUTE, vatk_target)
				if(prob(5))
					affected_mob <<	"\red Your stomache hurts."
					affected_mob.nutrition -= 20
					return
				if(prob(5))
					affected_mob <<	"\red You are feeling tired."
					affected_mob.drowsyness += 5
			if(4)
				if(prob(3))
					affected_mob.say("*choke")
					var/vatk_target = pick("head", "chest")
					affected_mob.apply_damage(5, BRUTE, vatk_target)
					var/turf/simulated/pos = get_turf(affected_mob)
					pos.add_blood_floor(affected_mob)
					playsound(pos, 'sound/effects/splat.ogg', 50, 1)
					//add blood effect
				if(prob(15))
					affected_mob.hallucination += 5
				if(prob(8))
					affected_mob << pick("\red Kill them.", "\red You are not going to escape", "\red They won't miss their legs.")
					affected_mob.hallucination += 25
					return
				if(prob(2))
					affected_mob << "\blue Through sheer will you're holding your sanity together."
					affected_mob.hallucination = 0
					return
				if(prob(7))
					affected_mob.custom_emote(1, "is having trouble keeping their eyes open.")
					affected_mob.drowsyness += 2
					return
				if(prob(1))
					affected_mob << pick("\red You come to the realization that you're infected and possibly about to turn.")
					affected_mob.nutrition -= 50
					affected_mob.drowsyness += 30
					affected_mob.hallucination = 0
					var/vatk_target = pick("head", "chest", "l_hand", "r_hand", "l_leg", "r_leg")
					affected_mob.apply_damage(20, BRUTE, vatk_target)
			if(5)
				if(!istype(affected_mob, /mob/living/carbon/monkey))
					affected_mob:Turnundead()

/datum/disease/zombie_transformation/process()	//Almost the same thing, a few tweaks needed for dead people.
	if(!affected_mob) return
	if(!holder)
		active_diseases -= src
		return
	if(prob(65))
		spread(holder)

	if(affected_mob.faction == null)
		cure(0)
		return

	if(affected_mob)
		for(var/datum/disease/D in affected_mob.viruses)
			if(D != src)
				if(IsSame(D))
					//error("Deleting [D.name] because it's the same as [src.name].")
					del(D) // if there are somehow two viruses of the same kind in the system, delete the other one

	if(holder == affected_mob)
		if(affected_mob.stat != DEAD) //he's alive
			stage_act()
		else //he's dead.
			if(spread_type!=SPECIAL)
				spread_type = CONTACT_GENERAL
				stage_act()			//Dead and not a zombie, should act

	if(affected_mob.faction == "undead" || istype(affected_mob, /mob/living/carbon/monkey) && affected_mob.stat == 2) //the virus is in inanimate obj, dead zed, or monkey
		if(prob(70))
			if(--longevity<=0)
				cure(0)
	return
