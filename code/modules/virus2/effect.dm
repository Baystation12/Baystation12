////////////////////////////////////////////////////////////////
////////////////////////EFFECTS/////////////////////////////////
////////////////////////////////////////////////////////////////
/proc/get_random_virus2_effect(stage, badness, exclude)
	var/list/datum/disease2/effect/candidates = list()
	for(var/T in subtypesof(/datum/disease2/effect))
		var/datum/disease2/effect/E = T
		if(E in exclude)
			continue
		if(initial(E.badness) > badness)	//we don't want such strong effects
			continue
		if(initial(E.stage) <= stage)
			candidates += T
	var/type = pick(candidates)
	var/datum/disease2/effect/effect = new type
	effect.generate()
	effect.chance = rand(0,effect.chance_max)
	effect.multiplier = rand(1,effect.multiplier_max)
	return effect

/datum/disease2/effect
	var/name = "Blanking effect"
	var/chance			//probality to fire every tick
	var/chance_max = 50
	var/multiplier = 1	//effect magnitude multiplier
	var/multiplier_max = 1
	var/stage = 4		//minimal stage
	var/badness = 1		//badness from 1 (common cold etc) to 3 (gibbingtons). Used in random generation.
	var/data = null 	//For semi-procedural effects; this should be generated in generate() if used
	var/oneshot

/datum/disease2/effect/proc/fire(var/mob/living/carbon/human/mob,var/current_stage)
	if(oneshot == -1)
		return
	if(stage <= current_stage && prob(chance))
		activate(mob)
		if(oneshot == 1)
			oneshot = -1

/datum/disease2/effect/proc/minormutate()
	switch(pick(1,2,3,4,5))
		if(1)
			chance = rand(0,chance_max)
		if(2)
			multiplier = rand(1,multiplier_max)

/datum/disease2/effect/proc/activate(var/mob/living/carbon/mob)
/datum/disease2/effect/proc/deactivate(var/mob/living/carbon/mob)
/datum/disease2/effect/proc/generate(copy_data) // copy_data will be non-null if this is a copy; it should be used to initialise the data for this effect if present

/datum/disease2/effect/invisible
	name = "Waiting Syndrome"
	stage = 1
	activate(var/mob/living/carbon/mob,var/multiplier)
		return

////////////////////////STAGE 4/////////////////////////////////

/datum/disease2/effect/nothing
	name = "Nil Syndrome"
	stage = 4
	badness = 1
	chance_max = 0

/datum/disease2/effect/gibbingtons
	name = "Gibbingtons Syndrome"
	stage = 4
	badness = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		// Probabilities have been tweaked to kill in ~2-3 minutes, giving 5-10 messages.
		// Probably needs more balancing, but it's better than LOL U GIBBED NOW, especially now that viruses can potentially have no signs up until Gibbingtons.
		mob.adjustBruteLoss(10*multiplier)
		if(istype(mob, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = mob
			var/obj/item/organ/external/O = pick(H.organs)
			if(prob(25))
				to_chat(mob, "<span class='warning'>Your [O.name] feels as if it might burst!</span>")
			if(prob(10))
				spawn(50)
					if(O)
						O.droplimb(0,DROPLIMB_BLUNT)
		else
			if(prob(75))
				to_chat(mob, "<span class='warning'>Your whole body feels like it might fall apart!</span>")
			if(prob(10))
				mob.adjustBruteLoss(25*multiplier)

/datum/disease2/effect/radian
	name = "Radian's Syndrome"
	stage = 4
	multiplier_max = 3
	badness = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.apply_effect(2*multiplier, IRRADIATE, blocked = 0)

/datum/disease2/effect/deaf
	name = "Dead Ear Syndrome"
	stage = 4
	badness = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.ear_deaf += 20

/datum/disease2/effect/monkey
	name = "Monkism Syndrome"
	stage = 4
	badness = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(istype(mob,/mob/living/carbon/human))
			var/mob/living/carbon/human/h = mob
			h.monkeyize()

/datum/disease2/effect/killertoxins
	name = "Toxification Syndrome"
	stage = 4
	badness = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.adjustToxLoss(15*multiplier)

/datum/disease2/effect/dna
	name = "Reverse Pattern Syndrome"
	stage = 4
	badness = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.bodytemperature = max(mob.bodytemperature, 350)
		scramble(0,mob,10)
		mob.apply_damage(10, CLONE)

/datum/disease2/effect/organs
	name = "Shutdown Syndrome"
	stage = 4
	badness = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(istype(mob, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = mob
			var/organ = pick(list(BP_R_ARM,BP_L_ARM,BP_R_LEG,BP_L_LEG))
			var/obj/item/organ/external/E = H.organs_by_name[organ]
			if (!(E.status & ORGAN_DEAD))
				E.status |= ORGAN_DEAD
				to_chat(H, "<span class='notice'>You can't feel your [E.name] anymore...</span>")
				for (var/obj/item/organ/external/C in E.children)
					C.status |= ORGAN_DEAD
			H.update_body(1)
		mob.adjustToxLoss(15*multiplier)

	deactivate(var/mob/living/carbon/mob,var/multiplier)
		if(istype(mob, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = mob
			for (var/obj/item/organ/external/E in H.organs)
				E.status &= ~ORGAN_DEAD
				for (var/obj/item/organ/external/C in E.children)
					C.status &= ~ORGAN_DEAD
			H.update_body(1)

/datum/disease2/effect/immortal
	name = "Longevity Syndrome"
	stage = 4
	badness = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(istype(mob, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = mob
			for (var/obj/item/organ/external/E in H.organs)
				if (E.status & ORGAN_BROKEN && prob(30))
					E.status ^= ORGAN_BROKEN
		var/heal_amt = -5*multiplier
		mob.apply_damages(heal_amt,heal_amt,heal_amt,heal_amt)

	deactivate(var/mob/living/carbon/mob,var/multiplier)
		if(istype(mob, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = mob
			to_chat(H, "<span class='notice'>You suddenly feel hurt and old...</span>")
			H.age += 8
		var/backlash_amt = 5*multiplier
		mob.apply_damages(backlash_amt,backlash_amt,backlash_amt,backlash_amt)

/datum/disease2/effect/bones
	name = "Fragile Bones Syndrome"
	stage = 4
	badness = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(istype(mob, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = mob
			for (var/obj/item/organ/external/E in H.organs)
				E.min_broken_damage = max(5, E.min_broken_damage - 30)

	deactivate(var/mob/living/carbon/mob,var/multiplier)
		if(istype(mob, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = mob
			for (var/obj/item/organ/external/E in H.organs)
				E.min_broken_damage = initial(E.min_broken_damage)

////////////////////////STAGE 3/////////////////////////////////

/datum/disease2/effect/toxins
	name = "Hyperacidity"
	stage = 3
	multiplier_max = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.adjustToxLoss((2*multiplier))

/datum/disease2/effect/shakey
	name = "World Shaking Syndrome"
	stage = 3
	multiplier_max = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		shake_camera(mob,5*multiplier)

/datum/disease2/effect/telepathic
	name = "Telepathy Syndrome"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.dna.SetSEState(REMOTETALKBLOCK,1)
		domutcheck(mob, null, MUTCHK_FORCED)

/datum/disease2/effect/mind
	name = "Lazy Mind Syndrome"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(istype(mob, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = mob
			var/obj/item/organ/internal/brain/B = H.internal_organs_by_name[BP_BRAIN]
			if (B && B.damage < B.min_broken_damage)
				B.take_damage(5)
		else
			mob.setBrainLoss(10)

/datum/disease2/effect/hallucinations
	name = "Hallucinational Syndrome"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.hallucination += 25

/datum/disease2/effect/deaf
	name = "Hard of Hearing Syndrome"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.ear_deaf = 5

/datum/disease2/effect/giggle
	name = "Uncontrolled Laughter Effect"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.say("*giggle")

/datum/disease2/effect/confusion
	name = "Topographical Cretinism"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		to_chat(mob, "<span class='notice'>You have trouble telling right and left apart all of a sudden.</span>")
		mob.confused += 10

/datum/disease2/effect/mutation
	name = "DNA Degradation"
	stage = 3
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.apply_damage(2, CLONE)

/datum/disease2/effect/groan
	name = "Groaning Syndrome"
	stage = 3
	chance_max = 25
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.say("*groan")

/datum/disease2/effect/chem_synthesis
	name = "Chemical Synthesis"
	stage = 3
	chance_max = 25

	generate(c_data)
		if(c_data)
			data = c_data
		else
			data = pick("bicaridine", "kelotane", "anti_toxin", "inaprovaline", "space_drugs", "sugar",
						"tramadol", "dexalin", "cryptobiolin", "impedrezene", "hyperzine", "ethylredoxrazine",
						"mindbreaker", "glucose")
		var/datum/reagent/R = chemical_reagents_list[data]
		name = "[initial(name)] ([initial(R.name)])"

	activate(var/mob/living/carbon/mob,var/multiplier)
		if (mob.reagents.get_reagent_amount(data) < 5)
			mob.reagents.add_reagent(data, 2)

////////////////////////STAGE 2/////////////////////////////////

/datum/disease2/effect/scream
	name = "Loudness Syndrome"
	stage = 2
	chance_max = 25
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.say("*scream")

/datum/disease2/effect/drowsness
	name = "Automated Sleeping Syndrome"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.drowsyness += 10

/datum/disease2/effect/sleepy
	name = "Resting Syndrome"
	stage = 2
	chance_max = 15
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.say("*collapse")

/datum/disease2/effect/blind
	name = "Blackout Syndrome"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.eye_blind = max(mob.eye_blind, 4)

/datum/disease2/effect/cough
	name = "Anima Syndrome"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.say("*cough")
		for(var/mob/living/carbon/M in oview(2,mob))
			mob.spread_disease_to(M)

/datum/disease2/effect/hungry
	name = "Appetiser Effect"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.nutrition = max(0, mob.nutrition - 200)

/datum/disease2/effect/fridge
	name = "Refridgerator Syndrome"
	stage = 2
	chance_max = 25
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.say("*shiver")

/datum/disease2/effect/hair
	name = "Hair Loss"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		if(istype(mob, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = mob
			if(H.species.name == SPECIES_HUMAN && !(H.h_style == "Bald") && !(H.h_style == "Balding Hair"))
				to_chat(H, "<span class='danger'>Your hair starts to fall out in clumps...</span>")
				spawn(50)
					H.h_style = "Balding Hair"
					H.update_hair()

/datum/disease2/effect/stimulant
	name = "Adrenaline Extra"
	stage = 2
	activate(var/mob/living/carbon/mob,var/multiplier)
		to_chat(mob, "<span class='notice'>You feel a rush of energy inside you!</span>")
		if (mob.reagents.get_reagent_amount("hyperzine") < 10)
			mob.reagents.add_reagent("hyperzine", 4)
		if (prob(30))
			mob.jitteriness += 10

////////////////////////STAGE 1/////////////////////////////////

/datum/disease2/effect/sneeze
	name = "Coldingtons Effect"
	stage = 1
	activate(var/mob/living/carbon/mob,var/multiplier)
		if (prob(30))
			to_chat(mob, "<span class='warning'>You feel like you are about to sneeze!</span>")
		sleep(5)
		mob.say("*sneeze")
		for(var/mob/living/carbon/M in get_step(mob,mob.dir))
			mob.spread_disease_to(M)
		if (prob(50))
			var/obj/effect/decal/cleanable/mucus/M = new(get_turf(mob))
			M.virus2 = virus_copylist(mob.virus2)

/datum/disease2/effect/gunck
	name = "Flemmingtons"
	stage = 1
	activate(var/mob/living/carbon/mob,var/multiplier)
		to_chat(mob, "<span class='warning'>Mucous runs down the back of your throat.</span>")

/datum/disease2/effect/drool
	name = "Saliva Effect"
	stage = 1
	chance_max = 25
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.say("*drool")

/datum/disease2/effect/twitch
	name = "Twitcher"
	stage = 1
	chance_max = 25
	activate(var/mob/living/carbon/mob,var/multiplier)
		mob.say("*twitch")

/datum/disease2/effect/headache
	name = "Headache"
	stage = 1
	activate(var/mob/living/carbon/mob,var/multiplier)
		to_chat(mob, "<span class='warning'>Your head hurts a bit.</span>")
