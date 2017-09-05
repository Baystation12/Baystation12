// MEDICAL SIDE EFFECT BASE
// ========================
/datum/medical_effect
	var/name = "None"
	var/strength = 0
	var/start = 0
	var/list/triggers
	var/list/cures
	var/cure_message

/datum/medical_effect/proc/manifest(mob/living/carbon/human/H)
	for(var/R in cures)
		if(H.reagents.has_reagent(R))
			return 0
	for(var/R in triggers)
		if(H.reagents.get_reagent_amount(R) >= triggers[R])
			return 1
	return 0

/datum/medical_effect/proc/on_life(mob/living/carbon/human/H, strength)
	return

/datum/medical_effect/proc/cure(mob/living/carbon/human/H)
	for(var/R in cures)
		if(H.reagents.has_reagent(R))
			if (cure_message)
				to_chat(H, "<span class='notice'>[cure_message]</span>")
			return 1
	return 0


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


	var/T = side_effects[name]
	if (!T)
		return

	var/datum/medical_effect/M = new T
	if(M.name == name)
		M.strength = strength
		M.start = life_tick
		side_effects += M

/mob/living/carbon/human/proc/handle_medical_side_effects()
	//Going to handle those things only every few ticks.
	if(life_tick % 15 != 0)
		return 0

	var/list/L = typesof(/datum/medical_effect)-/datum/medical_effect
	for(var/T in L)
		var/datum/medical_effect/M = new T
		if (M.manifest(src))
			src.add_side_effect(M.name)

	// One full cycle(in terms of strength) every 10 minutes
	for (var/datum/medical_effect/M in side_effects)
		if (!M) continue
		var/strength_percent = sin((life_tick - M.start) / 2)

		// Only do anything if the effect is currently strong enough
		if(strength_percent >= 0.4)
			if (M.cure(src) || M.strength > 50)
				side_effects -= M
				M = null
			else
				if(life_tick % 45 == 0)
					M.on_life(src, strength_percent*M.strength)
				// Effect slowly growing stronger
				M.strength+=0.08

// HEADACHE
// ========
/datum/medical_effect/headache
	name = "Headache"
	triggers = list(/datum/reagent/cryoxadone = 10, /datum/reagent/bicaridine = 15, /datum/reagent/tricordrazine = 15)
	cures = list(/datum/reagent/alkysine, /datum/reagent/tramadol, /datum/reagent/paracetamol, /datum/reagent/oxycodone)
	cure_message = "Your head stops throbbing..."

/datum/medical_effect/headache/on_life(mob/living/carbon/human/H, strength)
	var/obj/item/organ/external/head/head = H.get_organ("head")
	if(istype(head))
		switch(strength)
			if(1 to 10)
				H.custom_pain("You feel a light pain in your head.",0, affecting = head)
			if(11 to 30)
				H.custom_pain("You feel a throbbing pain in your head!",1, affecting = head)
			if(31 to INFINITY)
				H.custom_pain("You feel an excrutiating pain in your head!",1, affecting = head)

// BAD STOMACH
// ===========
/datum/medical_effect/bad_stomach
	name = "Bad Stomach"
	triggers = list(/datum/reagent/kelotane = 30, /datum/reagent/dermaline = 15)
	cures = list(/datum/reagent/dylovene)
	cure_message = "Your stomach feels a little better now..."

/datum/medical_effect/bad_stomach/on_life(mob/living/carbon/human/H, strength)
	switch(strength)
		if(1 to 10)
			H.custom_pain("You feel a bit light around the stomach.",0)
		if(11 to 30)
			H.custom_pain("Your stomach hurts.",0)
		if(31 to INFINITY)
			H.custom_pain("You feel sick.",1)

// CRAMPS
// ======
/datum/medical_effect/cramps
	name = "Cramps"
	triggers = list(/datum/reagent/dylovene = 30, /datum/reagent/tramadol = 15)
	cures = list(/datum/reagent/inaprovaline)
	cure_message = "The cramps let up..."

/datum/medical_effect/cramps/on_life(mob/living/carbon/human/H, strength)
	switch(strength)
		if(1 to 10)
			H.custom_pain("The muscles in your body hurt a little.",0)
		if(11 to 30)
			H.custom_pain("The muscles in your body cramp up painfully.",0)
		if(31 to INFINITY)
			H.visible_message("<B>\The [src]</B> flinches as all the muscles in their body cramp up.")
			H.custom_pain("There's pain all over your body.",1)

// ITCH
// ====
/datum/medical_effect/itch
	name = "Itch"
	triggers = list(/datum/reagent/space_drugs = 10)
	cures = list(/datum/reagent/inaprovaline)
	cure_message = "The itching stops..."

/datum/medical_effect/itch/on_life(mob/living/carbon/human/H, strength)
	switch(strength)
		if(1 to 10)
			H.custom_pain("You feel a slight itch.",0)
		if(11 to 30)
			H.custom_pain("You want to scratch your itch badly.",0)
		if(31 to INFINITY)
			H.visible_message("<B>\The [src]</B> shivers slightly.")
			H.custom_pain("This itch makes it really hard to concentrate.",1)
