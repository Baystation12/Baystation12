
/* This file contains all the procs processing allergy onset, healing, and symptoms.
For the file where the allergy trait is defined; check datum/traits/maluses/allergy.dm
Mild allergies increase heart rate and give itch messages. Inaprovaline resolves these symptoms; but the allergy will keep running as long as a reagent is in the system.
Severe allergies cause breathing problems and an even faster heart rate. Inaprovaline markedly stabilizes these symptoms; but only adrenaline can stop a severe allergy
As long as you have inaprovaline in your system, an allergy cannot trigger. Key is to keep inaprov longer than the allergen exists above threshold after treatment */

/*
Checks if allergy will be triggered at a reagent level. Called by handle_allergy().
If all offending reagent levels fall below threshold and no severe allergy is running; will stop allergies.
Also checks if medications that stop allergies from triggering are in system. This is done after the list of active_allergies is updated.
*/
/mob/living/carbon/proc/check_allergy(datum/reagent/reagent, current_level = 0)
	if (!ispath(reagent))
		return
	var/allergy_severity = GetTraitLevel(/singleton/trait/malus/allergy, reagent)
	if (!allergy_severity)
		return
	var/threshold = 1/allergy_severity //For Medium sized mobs; threshold of 1 for minor allergies and 0.33 for major allergies.
	if (current_level < threshold)
		LAZYREMOVE(active_allergies, reagent)
		return

	LAZYDISTINCTADD(active_allergies, reagent)
	start_allergy(allergy_severity)

///This starts an allergy. Dosage/drug are handled at check_allergy proc, if you call this proc directly you must do your own checks.
/mob/living/carbon/proc/start_allergy(allergy_severity)
	if (trait_flags & SEVERE_ALLERGY)
		return
	if ((trait_flags & MILD_ALLERGY) && allergy_severity <= TRAIT_LEVEL_MINOR)
		return
	if (chem_effects[CE_STABLE] || chem_doses[/datum/reagent/adrenaline])
		return

	switch (allergy_severity)
		if (TRAIT_LEVEL_MINOR)
			trait_flags |= MILD_ALLERGY
			to_chat(src, SPAN_DANGER("You start feeling uncontrollably itchy!"))
			next_allergy_time = world.time + 2 MINUTES

		if (TRAIT_LEVEL_MAJOR)
			trait_flags |= SEVERE_ALLERGY
			to_chat(src, SPAN_DANGER("Your throat starts swelling up and it suddenly becomes very difficult to breathe!"))
			next_allergy_time = world.time + 1 MINUTES

		else
			crash_with("Allergy called with incorrect severity of [allergy_severity].")

///Ends allergies and unsets flag. Conditions handled at handle_allergy proc; if you call this directly do your own checks.
///If no severity supplied will end all allergies.
/mob/living/carbon/proc/stop_allergy(allergy_flag = null)
	if (!(trait_flags & (MILD_ALLERGY|SEVERE_ALLERGY)))
		return

	if ((trait_flags & MILD_ALLERGY) && allergy_flag == (MILD_ALLERGY || null))
		if (!chem_effects[CE_STABLE]) //People with inaprov aren't itching to start with.
			to_chat(src, SPAN_NOTICE("You feel the itching subside."))
		trait_flags &= ~MILD_ALLERGY

	if ((trait_flags & SEVERE_ALLERGY) && allergy_flag == (SEVERE_ALLERGY || null))
		to_chat(src, SPAN_NOTICE("You feel your airways open up and breathing feels easier!"))
		trait_flags &= ~SEVERE_ALLERGY

/mob/living/var/next_allergy_time = 0
/mob/living/proc/handle_allergy()
	return

///Main proc through which all other allergy procs are called; it is called by carbon/Life().
///If adrenaline is in system, all active allergies will be stopped. Having inaprov (CE_STABLE) will prevent them from retriggering when adrenaline washes out.
/mob/living/carbon/handle_allergy()
	if (stat)
		return
	if (!HAS_TRAIT(src, /singleton/trait/malus/allergy))
		return
	var/list/allergy_list = traits[/singleton/trait/malus/allergy]

	for (var/picked as anything in allergy_list)
		if (!(picked in chem_doses) && !(picked in active_allergies))
			continue
		var/datum/reagent/reagent = picked
		check_allergy(reagent, chem_doses[reagent])

	if ((trait_flags & MILD_ALLERGY) && (!length(active_allergies)))
		stop_allergy(MILD_ALLERGY)

	if ((trait_flags & SEVERE_ALLERGY) && chem_doses[/datum/reagent/adrenaline] >= 0.2)
		stop_allergy(SEVERE_ALLERGY)

	run_allergy_symptoms()


///Proc called by handle_allergy, handles chemical effects and symptoms.
/mob/living/carbon/proc/run_allergy_symptoms()
	if (!(trait_flags & (MILD_ALLERGY|SEVERE_ALLERGY)))
		return

	add_chemical_effect(CE_PULSE, 2)
	if (trait_flags & SEVERE_ALLERGY)
		add_chemical_effect(CE_BREATHLOSS, 2)
		add_chemical_effect(CE_PULSE, 2)
		if (prob(50))
			add_chemical_effect(CE_VOICELOSS, 1)

	if (!can_feel_pain() || world.time < next_allergy_time || chem_effects[CE_STABLE])
		return

	to_chat(src, SPAN_WARNING("You feel uncontrollably itchy!"))
	var/delay = 2 MINUTES
	if (trait_flags & SEVERE_ALLERGY)
		delay /= 2
	next_allergy_time = world.time + delay
