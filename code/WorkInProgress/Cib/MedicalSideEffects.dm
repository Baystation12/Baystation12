// MEDICAL SIDE EFFECT BASE
// ========================
/datum/medical_effect/var/name = "None"
/datum/medical_effect/var/strength = 0
/datum/medical_effect/var/start = 0
/datum/medical_effect/proc/manifest(mob/living/carbon/human/H)
/datum/medical_effect/proc/on_life(mob/living/carbon/human/H, strength)
/datum/medical_effect/proc/cure(mob/living/carbon/human/H)


// MOB HELPERS
// ===========
/mob/living/carbon/human/var/list/datum/medical_effect/side_effects = list()
/mob/proc/add_side_effect(name, strength = 0)
/mob/living/carbon/human/add_side_effect(name, strength = 0)
	for(var/datum/medical_effect/M in src.side_effects)
		if(M.name == name)
			M.strength = max(M.strength, 10)
			M.start = life_tick
			return

	var/list/L = typesof(/datum/medical_effect)-/datum/medical_effect

	for(var/T in L)
		var/datum/medical_effect/M = new T
		if(M.name == name)
			M.strength = strength
			M.start = life_tick
			side_effects += M

/mob/living/carbon/human/proc/handle_medical_side_effects()

	var/list/L = typesof(/datum/medical_effect)-/datum/medical_effect
	for(var/T in L)
		var/datum/medical_effect/M = new T
		if (M.manifest(src))
			src.add_side_effect(M.name)

	// One full cycle(in terms of strength) every 10 minutes
	for (var/datum/medical_effect/M in side_effects)
		if (!M) continue
		var/strength_percent = sin((life_tick - M.start) / 2)
		log_debug ("[src], tick [life_tick] : Processing [M],  Current phase: [strength_percent]")

		// Only do anything if the effect is currently strong enough
		if(strength_percent >= 0.4)
			log_debug ("[src], tick [life_tick] : Active phase ; strength [M.strength]")
			if (M.cure(src) || M.strength > 50)
				log_debug ("[src], tick [life_tick] : [M] cured or reached end of lifecycle")
				side_effects -= M
				del(M)
			else
				if(life_tick % 45 == 0)
					log_debug ("[src], tick [life_tick] : Activating [M] ")
					M.on_life(src, strength_percent*M.strength)
				// Effect slowly growing stronger
				M.strength+=0.08

// HEADACHE
// ========
/datum/medical_effect/headache/name = "Headache"
/datum/medical_effect/headache/manifest(mob/living/carbon/human/H)
	if(H.reagents.has_reagent("alkysine") || H.reagents.has_reagent("tramadol"))
		return 0
	if(H.reagents.has_reagent("cryoxadone") >= 10 || H.reagents.get_reagent_amount("bicaridine") >= 15 || H.reagents.get_reagent_amount("tricordrazine") >= 15)
		return 1
	return 0

/datum/medical_effect/headache/on_life(mob/living/carbon/human/H, strength)
	switch(strength)
		if(1 to 10)
			H.custom_pain("You feel a light pain in your head.",0)
		if(11 to 30)
			H.custom_pain("You feel a throbbing pain in your head!",1)
		if(31 to INFINITY)
			H.custom_pain("You feel an excrutiating pain in your head!",1)
			H.adjustBrainLoss(1)

/datum/medical_effect/headache/cure(mob/living/carbon/human/H)
	if(H.reagents.has_reagent("alkysine") || H.reagents.has_reagent("tramadol"))
		H << "\red Your head stops throbbing.."
		return 1
	return 0

// BAD STOMACH
// ===========
/datum/medical_effect/bad_stomach/name = "Bad Stomach"
/datum/medical_effect/bad_stomach/manifest(mob/living/carbon/human/H)
	if(H.reagents.has_reagent("anti_toxin"))
		return 0
	if(H.reagents.get_reagent_amount("kelotane") >= 30 || H.reagents.get_reagent_amount("dermaline") >= 15)
		return 1
	return 0


/datum/medical_effect/bad_stomach/on_life(mob/living/carbon/human/H, strength)
	switch(strength)
		if(1 to 10)
			H.custom_pain("You feel a bit light around the stomach.",0)
		if(11 to 30)
			H.custom_pain("Your stomach hurts.",0)
		if(31 to INFINITY)
			H.custom_pain("You feel sick.",1)
			H.adjustToxLoss(1)

/datum/medical_effect/bad_stomach/cure(mob/living/carbon/human/H)
	if(H.reagents.has_reagent("anti_toxin"))
		H << "\red Your stomach feels a little better now.."
		return 1
	return 0


// CRAMPS
// ======
/datum/medical_effect/cramps/name = "Cramps"
/datum/medical_effect/cramps/manifest(mob/living/carbon/human/H)
	if(H.reagents.has_reagent("inaprovaline"))
		return 0
	if( H.reagents.get_reagent_amount("anti_toxin") >= 30 || H.reagents.get_reagent_amount("tramadol") >= 15)
		return 1
	return 0
/datum/medical_effect/cramps/on_life(mob/living/carbon/human/H, strength)
	switch(strength)
		if(1 to 10)
			H.custom_pain("The muscles in your body hurt a little.",0)
		if(11 to 30)
			H.custom_pain("The muscles in your body cramp up painfully.",0)
		if(31 to INFINITY)
			H.emote("me",1,"flinches as all the muscles in their body cramp up.")
			H.custom_pain("There's pain all over your body.",1)
			H.adjustToxLoss(1)

/datum/medical_effect/cramps/cure(mob/living/carbon/human/H)
	if(H.reagents.has_reagent("inaprovaline"))
		H << "\red The cramps let up.."
		return 1
	return 0

// ITCH
// ====
/datum/medical_effect/itch/name = "Itch"
/datum/medical_effect/itch/manifest(mob/living/carbon/human/H)
	if(H.reagents.has_reagent("inaprovaline"))
		return 0
	if(H.reagents.get_reagent_amount("space_drugs") >= 10)
		return 1
	return 0
/datum/medical_effect/itch/on_life(mob/living/carbon/human/H, strength)
	switch(strength)
		if(1 to 10)
			H.custom_pain("You feel a slight itch.",0)
		if(11 to 30)
			H.custom_pain("You want to scratch your itch badly.",0)
		if(31 to INFINITY)
			H.emote("me",1,"shivers slightly.")
			H.custom_pain("This itch makes it really hard to concentrate.",1)
			H.adjustToxLoss(1)

/datum/medical_effect/itch/cure(mob/living/carbon/human/H)
	if(H.reagents.has_reagent("inaprovaline"))
		H << "\red The itching stops.."
		return 1
	return 0