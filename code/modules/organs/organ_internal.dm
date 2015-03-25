#define PROCESS_ACCURACY 10

/****************************************************
				INTERNAL ORGANS
****************************************************/

/mob/living/carbon/var/list/internal_organs = list()

/datum/organ/internal
	var/damage = 0 // amount of damage to the organ
	var/min_bruised_damage = 10
	var/min_broken_damage = 30
	var/parent_organ = "chest"
	var/robotic = 0 //For being a robot
	var/removed_type //When removed, forms this object.
	var/rejecting            // Is this organ already being rejected?
	var/obj/item/organ/organ_holder // If not in a body, held in this item.
	var/list/transplant_data

/datum/organ/internal/proc/rejuvenate()
	damage=0

/datum/organ/internal/proc/is_bruised()
	return damage >= min_bruised_damage

/datum/organ/internal/proc/is_broken()
	return damage >= min_broken_damage || status & ORGAN_CUT_AWAY

/datum/organ/internal/New(mob/living/carbon/M)
	..()
	if(M && istype(M))

		M.internal_organs |= src
		src.owner = M

		var/mob/living/carbon/human/H = M
		if(istype(H))
			var/datum/organ/external/E = H.organs_by_name[src.parent_organ]
			if(E.internal_organs == null)
				E.internal_organs = list()
			E.internal_organs |= src

/datum/organ/internal/process()

	//Process infections
	if (robotic >= 2 || (owner.species && owner.species.flags & IS_PLANT))	//TODO make robotic internal and external organs separate types of organ instead of a flag
		germ_level = 0
		return

	if(owner.bodytemperature >= 170)	//cryo stops germs from moving and doing their bad stuffs
		//** Handle antibiotics and curing infections
		handle_antibiotics()

		//** Handle the effects of infections
		var/antibiotics = owner.reagents.get_reagent_amount("spaceacillin")

		if (germ_level > 0 && germ_level < INFECTION_LEVEL_ONE/2 && prob(30))
			germ_level--

		if (germ_level >= INFECTION_LEVEL_ONE/2)
			//aiming for germ level to go from ambient to INFECTION_LEVEL_TWO in an average of 15 minutes
			if(antibiotics < 5 && prob(round(germ_level/6)))
				germ_level++

		if (germ_level >= INFECTION_LEVEL_TWO)
			var/datum/organ/external/parent = owner.get_organ(parent_organ)
			//spread germs
			if (antibiotics < 5 && parent.germ_level < germ_level && ( parent.germ_level < INFECTION_LEVEL_ONE*2 || prob(30) ))
				parent.germ_level++

			if (prob(3))	//about once every 30 seconds
				take_damage(1,silent=prob(30))

		// Process unsuitable transplants. TODO: consider some kind of
		// immunosuppressant that changes transplant data to make it match.
		if(transplant_data)
			if(!rejecting && prob(20) && owner.dna && blood_incompatible(transplant_data["blood_type"],owner.dna.b_type,owner.species,transplant_data["species"]))
				rejecting = 1
			else
				rejecting++ //Rejection severity increases over time.
				if(rejecting % 10 == 0) //Only fire every ten rejection ticks.
					switch(rejecting)
						if(1 to 50)
							take_damage(1)
						if(51 to 200)
							owner.reagents.add_reagent("toxin", 1)
							take_damage(1)
						if(201 to 500)
							take_damage(rand(2,3))
							owner.reagents.add_reagent("toxin", 2)
						if(501 to INFINITY)
							take_damage(4)
							owner.reagents.add_reagent("toxin", rand(3,5))

/datum/organ/internal/proc/take_damage(amount, var/silent=0)
	if(src.robotic == 2)
		src.damage += (amount * 0.8)
	else
		src.damage += amount

	var/datum/organ/external/parent = owner.get_organ(parent_organ)
	if (!silent)
		owner.custom_pain("Something inside your [parent.display_name] hurts a lot.", 1)

/datum/organ/internal/proc/emp_act(severity)
	switch(robotic)
		if(0)
			return
		if(1)
			switch (severity)
				if (1.0)
					take_damage(20,0)
					return
				if (2.0)
					take_damage(7,0)
					return
				if(3.0)
					take_damage(3,0)
					return
		if(2)
			switch (severity)
				if (1.0)
					take_damage(40,0)
					return
				if (2.0)
					take_damage(15,0)
					return
				if(3.0)
					take_damage(10,0)
					return

/datum/organ/internal/proc/mechanize() //Being used to make robutt hearts, etc
	robotic = 2

/datum/organ/internal/proc/mechassist() //Used to add things like pacemakers, etc
	robotic = 1
	min_bruised_damage = 15
	min_broken_damage = 35

/****************************************************
				INTERNAL ORGANS DEFINES
****************************************************/

/datum/organ/internal/heart // This is not set to vital because death immediately occurs in blood.dm if it is removed.
	name = "heart"
	parent_organ = "chest"
	removed_type = /obj/item/organ/heart

/datum/organ/internal/lungs
	name = "lungs"
	parent_organ = "chest"
	removed_type = /obj/item/organ/lungs

	process()
		..()
		if (germ_level > INFECTION_LEVEL_ONE)
			if(prob(5))
				owner.emote("cough")		//respitory tract infection

		if(is_bruised())
			if(prob(2))
				spawn owner.emote("me", 1, "coughs up blood!")
				owner.drip(10)
			if(prob(4))
				spawn owner.emote("me", 1, "gasps for air!")
				owner.losebreath += 15

/datum/organ/internal/liver
	name = "liver"
	parent_organ = "chest"
	removed_type = /obj/item/organ/liver

	process()

		..()

		if (germ_level > INFECTION_LEVEL_ONE)
			if(prob(1))
				owner << "\red Your skin itches."
		if (germ_level > INFECTION_LEVEL_TWO)
			if(prob(1))
				spawn owner.vomit()

		if(owner.life_tick % PROCESS_ACCURACY == 0)

			//High toxins levels are dangerous
			if(owner.getToxLoss() >= 60 && !owner.reagents.has_reagent("anti_toxin"))
				//Healthy liver suffers on its own
				if (src.damage < min_broken_damage)
					src.damage += 0.2 * PROCESS_ACCURACY
				//Damaged one shares the fun
				else
					var/datum/organ/internal/O = pick(owner.internal_organs)
					if(O)
						O.damage += 0.2  * PROCESS_ACCURACY

			//Detox can heal small amounts of damage
			if (src.damage && src.damage < src.min_bruised_damage && owner.reagents.has_reagent("anti_toxin"))
				src.damage -= 0.2 * PROCESS_ACCURACY

			if(src.damage < 0)
				src.damage = 0

			// Get the effectiveness of the liver.
			var/filter_effect = 3
			if(is_bruised())
				filter_effect -= 1
			if(is_broken())
				filter_effect -= 2

			// Do some reagent processing.
			if(owner.chem_effects[CE_ALCOHOL_TOXIC])
				if(filter_effect < 3)
					owner.adjustToxLoss(owner.chem_effects[CE_ALCOHOL_TOXIC] * 0.1 * PROCESS_ACCURACY)
				else
					take_damage(owner.chem_effects[CE_ALCOHOL_TOXIC] * 0.1 * PROCESS_ACCURACY, prob(1)) // Chance to warn them

/datum/organ/internal/kidney
	name = "kidneys"
	parent_organ = "groin"
	removed_type = /obj/item/organ/kidneys

	process()

		..()

		// Coffee is really bad for you with busted kidneys.
		// This should probably be expanded in some way, but fucked if I know
		// what else kidneys can process in our reagent list.
		var/datum/reagent/coffee = locate(/datum/reagent/drink/coffee) in owner.reagents.reagent_list
		if(coffee)
			if(is_bruised())
				owner.adjustToxLoss(0.1 * PROCESS_ACCURACY)
			else if(is_broken())
				owner.adjustToxLoss(0.3 * PROCESS_ACCURACY)

/datum/organ/internal/brain
	name = "brain"
	parent_organ = "head"
	removed_type = /obj/item/organ/brain
	vital = 1

/datum/organ/internal/brain/xeno
	removed_type = /obj/item/organ/brain/xeno

/datum/organ/internal/brain/golem
	name = "golem chem"
	removed_type = /obj/item/organ/brain/golem

/datum/organ/internal/brain/slime
	name = "slime core"
	removed_type = /obj/item/organ/brain/slime

/datum/organ/internal/eyes
	name = "eyes"
	parent_organ = "head"
	removed_type = /obj/item/organ/eyes

	process() //Eye damage replaces the old eye_stat var.
		..()
		if(is_bruised())
			owner.eye_blurry = 20
		if(is_broken())
			owner.eye_blind = 20

/datum/organ/internal/appendix
	name = "appendix"
	parent_organ = "groin"
	removed_type = /obj/item/organ/appendix

/datum/organ/internal/proc/remove(var/mob/user)

	if(!removed_type) return 0

	var/turf/target_loc
	if(user)
		target_loc = get_turf(user)
	else
		target_loc = get_turf(owner)

	var/obj/item/organ/removed_organ = new removed_type(target_loc)

	if(istype(removed_organ))
		removed_organ.organ_data = src
		removed_organ.update()
		organ_holder = removed_organ

	return removed_organ