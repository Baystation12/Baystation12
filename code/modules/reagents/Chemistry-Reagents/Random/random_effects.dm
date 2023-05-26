#define RANDOM_CHEM_EFFECT_TRUE  1 //Boolean, starts true
#define RANDOM_CHEM_EFFECT_INT   2
#define RANDOM_CHEM_EFFECT_FLOAT 3

/singleton/random_chem_effect
	var/minimum = 0
	var/maximum = 1
	var/mode = RANDOM_CHEM_EFFECT_TRUE
	var/beneficial = 0 // Neutral; 1 for beneficial, -1 for harmful
	var/desc
	var/cost = 500 // Modify if an effect should be valued more.

/singleton/random_chem_effect/proc/get_random_value()
	switch(mode)
		if(RANDOM_CHEM_EFFECT_TRUE)
			return 1
		if(RANDOM_CHEM_EFFECT_INT)
			return rand(minimum, maximum)
		if(RANDOM_CHEM_EFFECT_FLOAT)
			return rand() * (maximum - minimum) + minimum

/singleton/random_chem_effect/proc/mix_data(first_value, first_ratio, second_value)
	switch(mode)
		if(RANDOM_CHEM_EFFECT_TRUE)
			return !!(first_value * first_ratio + second_value * (1 - first_ratio)) // Basically |, unless ratio is 0 or 1
		if(RANDOM_CHEM_EFFECT_INT)
			return round(first_value * first_ratio + second_value * (1 - first_ratio))
		if(RANDOM_CHEM_EFFECT_FLOAT)
			return first_value * first_ratio + second_value * (1 - first_ratio)

/singleton/random_chem_effect/proc/prototype_process(datum/reagent/random/prototype, temperature)
	prototype.data[type] = get_random_value()

/singleton/random_chem_effect/proc/on_property_recompute(datum/reagent/random/reagent, value)

/singleton/random_chem_effect/proc/affect_blood(mob/living/carbon/M, removed, value)

/singleton/random_chem_effect/proc/distillation_act(datum/reagent/random/reagent, datum/reagents/reagents)

/singleton/random_chem_effect/proc/cooling_act(datum/reagent/random/reagent, datum/reagents/reagents)

/singleton/random_chem_effect/proc/get_interactions()

// This is referring to monetary value.
/singleton/random_chem_effect/proc/get_value(value)
	switch(beneficial)
		if(1)
			return cost * (value - minimum)/(maximum - minimum)
		if(0)
			return 0
		if(-1)
			return -3 * cost * (value - minimum)/(maximum - minimum)

// All general properties will be chosen.

/singleton/random_chem_effect/general_properties/name
	maximum = 999
	minimum = 100
	mode = RANDOM_CHEM_EFFECT_INT

/singleton/random_chem_effect/general_properties/name/on_property_recompute(datum/reagent/random/reagent, value)
	reagent.name = "[initial(reagent.name)]-[value]"

/singleton/random_chem_effect/general_properties/color_r
	maximum = 255
	mode = RANDOM_CHEM_EFFECT_INT

/singleton/random_chem_effect/general_properties/color_g
	maximum = 255
	mode = RANDOM_CHEM_EFFECT_INT

/singleton/random_chem_effect/general_properties/color_b
	maximum = 255
	mode = RANDOM_CHEM_EFFECT_INT

/singleton/random_chem_effect/general_properties/color_r/on_property_recompute(datum/reagent/random/reagent, value)
	reagent.color = rgb(\
		reagent.data[/singleton/random_chem_effect/general_properties/color_r],\
		reagent.data[/singleton/random_chem_effect/general_properties/color_r],\
		reagent.data[/singleton/random_chem_effect/general_properties/color_b]
	)

/singleton/random_chem_effect/general_properties/overdose
	minimum = REAGENTS_OVERDOSE * 0.2
	maximum = REAGENTS_OVERDOSE * 2
	mode = RANDOM_CHEM_EFFECT_FLOAT

/singleton/random_chem_effect/general_properties/overdose/on_property_recompute(datum/reagent/random/reagent, value)
	reagent.overdose = value

/singleton/random_chem_effect/general_properties/metabolism
	minimum = REM * 0.5
	maximum = REM * 3
	mode = RANDOM_CHEM_EFFECT_FLOAT

/singleton/random_chem_effect/general_properties/metabolism/on_property_recompute(datum/reagent/random/reagent, value)
	reagent.metabolism = value

/singleton/random_chem_effect/general_properties/chilling_point
	minimum = TCMB
	var/generic_minimum = T0C - 80 // Will be used unless the temperature we're gunning for is too cold
	maximum = T0C - 10
	mode = RANDOM_CHEM_EFFECT_FLOAT

/singleton/random_chem_effect/general_properties/chilling_point/get_random_value(temperature)
	var/max = max(min(maximum, temperature - 20), minimum) // Use given max unless that's above the given temp - margin
	var/min = max(min(generic_minimum, max - 20), minimum) // Use the generic min as min unless that's above the max - margin
	return rand() * (max - min) + min

/singleton/random_chem_effect/general_properties/chilling_point/prototype_process(datum/reagent/random/prototype, temperature = T20C)
	prototype.data[type] = get_random_value(temperature)

/singleton/random_chem_effect/general_properties/chilling_point/on_property_recompute(datum/reagent/random/reagent, value)
	reagent.chilling_point = value

/singleton/random_chem_effect/general_properties/heating_point
	minimum = T0C + 60
	var/generic_maximum = T0C + 180
	maximum = T0C + 500
	mode = RANDOM_CHEM_EFFECT_FLOAT

/singleton/random_chem_effect/general_properties/heating_point/get_random_value(temperature)
	var/min = min(max(minimum, temperature + 20), maximum)
	var/max = min(max(generic_maximum, min + 20), maximum)
	return rand() * (max - min) + min

/singleton/random_chem_effect/general_properties/heating_point/prototype_process(datum/reagent/random/prototype, temperature = T20C)
	prototype.data[type] = get_random_value(temperature)

/singleton/random_chem_effect/general_properties/heating_point/on_property_recompute(datum/reagent/random/reagent, value)
	reagent.heating_point = value

// Only some random properties are picked.

/singleton/random_chem_effect/random_properties
	var/chem_effect_define                //If it corresponds to a CE_WHATEVER define, place here and it will do generic affect blood based on it
	var/list/distillation_inhibitor_cache // Format: list(type = list(reagent types))
	var/list/cooling_enhancer_cache
	var/list/reaction_rate_cache
	var/number_of_reaction_modifiers = 3

/singleton/random_chem_effect/random_properties/proc/set_caches(datum/reagent/random/prototype, list/whitelist)
	LAZYSET(reaction_rate_cache, prototype.type, 1.5 * rand() + 0.5)
	for(var/i = 1, i <= number_of_reaction_modifiers, i++)
		if(length(whitelist))
			LAZYINITLIST(distillation_inhibitor_cache)
			LAZYADD(distillation_inhibitor_cache[prototype.type], pick_n_take(whitelist))
		if(length(whitelist))
			LAZYINITLIST(cooling_enhancer_cache)
			LAZYADD(cooling_enhancer_cache[prototype.type], pick_n_take(whitelist))

/singleton/random_chem_effect/random_properties/distillation_act(datum/reagent/random/reagent, datum/reagents/reagents, value)
	var/list/inhibitors = distillation_inhibitor_cache[reagent.type]
	if(reagents.has_any_reagent(inhibitors))
		return
	return purify(reagent, reagents, value)

/singleton/random_chem_effect/random_properties/cooling_act(datum/reagent/random/reagent, datum/reagents/reagents, value)
	var/list/enhancers = cooling_enhancer_cache[reagent.type]
	if(!reagents.has_any_reagent(enhancers))
		return
	return purify(reagent, reagents, value)

/singleton/random_chem_effect/random_properties/proc/purify(datum/reagent/random/reagent, datum/reagents/reagents, value)
	var/target = reagents.has_reagent(/datum/reagent/toxin/phoron) ? minimum : maximum
	if(target == value)
		return
	var/rate = reaction_rate_cache[reagent.type]
	switch(mode)
		if(RANDOM_CHEM_EFFECT_TRUE)
			if(prob(10 * rate))
				return target
			return value // this will keep us reacting
		if(RANDOM_CHEM_EFFECT_INT)
			var/amount = (target - value) * rate * 0.1
			if(abs(amount) >= 1)
				return round(amount + value)
			else if(prob(100 * abs(amount)))
				return value + sign(amount)
			return value
		if(RANDOM_CHEM_EFFECT_FLOAT)
			var/resolution = (maximum - minimum)/100
			var/new_val = value + (target - value) * rate * 0.1
			var/round_dir = new_val > value ? -1 : 1                                   // Rounds up if going up, to nearest percent of max - min
			new_val = round(round_dir * new_val / resolution) * round_dir * resolution // makes this finish in finite time to save processing power.
			return new_val

/singleton/random_chem_effect/random_properties/cooling_act(datum/reagent/random/reagent, datum/reagents/reagents)

/singleton/random_chem_effect/random_properties/affect_blood(mob/living/carbon/M, removed, value)
	if(chem_effect_define && !IS_METABOLICALLY_INERT(M)) // screw diona
		M.add_chemical_effect(chem_effect_define, value)

/singleton/random_chem_effect/random_properties/get_interactions(datum/reagent/random/reagent, sci_skill, chem_skill)
	if(chem_skill < SKILL_EXPERIENCED)
		return
	. = list("<br>")
	if(sci_skill > SKILL_TRAINED)
		. += "For [desc]:<br>"
	var/list/interactions = list()
	if(chem_skill == SKILL_MASTER)
		. += "Heating: "
	for(var/interaction in distillation_inhibitor_cache[reagent.type])
		var/datum/reagent/R = interaction
		interactions += initial(R.name)
	if(chem_skill == SKILL_MASTER)
		. += english_list(interactions)
		interactions.Cut()
		. += ". Cooling: "
	for(var/interaction in cooling_enhancer_cache[reagent.type])
		var/datum/reagent/R = interaction
		interactions += initial(R.name)
	if(chem_skill <= SKILL_MASTER)
		shuffle(interactions)
	. += english_list(interactions)
	. += "."

/singleton/random_chem_effect/random_properties/ce_stable
	chem_effect_define = CE_STABLE
	beneficial = 1
	desc = "stabilization"

/singleton/random_chem_effect/random_properties/ce_antibiotic
	chem_effect_define = CE_ANTIBIOTIC
	beneficial = 1
	desc = "antibiotic power"

/singleton/random_chem_effect/random_properties/ce_bloodrestore
	chem_effect_define = CE_BLOODRESTORE
	beneficial = 1
	minimum = 1
	maximum = 12
	mode = RANDOM_CHEM_EFFECT_INT
	desc = "blood restoration"

/singleton/random_chem_effect/random_properties/ce_painkiller
	chem_effect_define = CE_PAINKILLER
	beneficial = 1
	maximum = 100
	mode = RANDOM_CHEM_EFFECT_INT
	desc = "pain suppression"

/singleton/random_chem_effect/random_properties/ce_alcohol
	chem_effect_define = CE_ALCOHOL
	beneficial = -1
	desc = "intoxication"

/singleton/random_chem_effect/random_properties/ce_alcotoxic
	chem_effect_define = CE_ALCOHOL_TOXIC
	beneficial = -1
	maximum = 8
	mode = RANDOM_CHEM_EFFECT_INT
	desc = "liver damage"

/singleton/random_chem_effect/random_properties/ce_gofast
	chem_effect_define = CE_SPEEDBOOST
	beneficial = 1
	maximum = 2
	mode = RANDOM_CHEM_EFFECT_INT
	desc = "faster movement"

/singleton/random_chem_effect/random_properties/ce_goslow
	chem_effect_define = CE_SLOWDOWN
	beneficial = -1
	maximum = 20
	mode = RANDOM_CHEM_EFFECT_INT
	desc = "slower movement"

/singleton/random_chem_effect/random_properties/ce_xcardic
	chem_effect_define = CE_PULSE
	beneficial = -1
	minimum = -2
	maximum = 4
	mode = RANDOM_CHEM_EFFECT_INT
	desc = "pulse destabilization"

/singleton/random_chem_effect/random_properties/ce_heartstop
	chem_effect_define = CE_NOPULSE
	beneficial = -1
	desc = "cardiac arrest"

/singleton/random_chem_effect/random_properties/ce_antitox
	chem_effect_define = CE_ANTITOX
	beneficial = 1
	desc = "poison removal"

/singleton/random_chem_effect/random_properties/ce_oxygen
	chem_effect_define = CE_OXYGENATED
	beneficial = 1
	maximum = 2
	mode = RANDOM_CHEM_EFFECT_INT
	desc = "blood oxygenation"

/singleton/random_chem_effect/random_properties/ce_brainfix
	chem_effect_define = CE_BRAIN_REGEN
	beneficial = 1
	desc = "neurological repair"

/singleton/random_chem_effect/random_properties/ce_antiviral
	chem_effect_define = CE_ANTIVIRAL
	beneficial = 1
	maximum = VIRUS_EXOTIC
	mode = RANDOM_CHEM_EFFECT_INT
	desc = "antiviral action"

/singleton/random_chem_effect/random_properties/ce_toxins
	chem_effect_define = CE_TOXIN
	beneficial = -1
	desc = "general toxicity"

/singleton/random_chem_effect/random_properties/ce_breathloss
	chem_effect_define = CE_BREATHLOSS
	beneficial = -1
	maximum = 0.6
	mode = RANDOM_CHEM_EFFECT_FLOAT
	desc = "respiratory depression"

/singleton/random_chem_effect/random_properties/ce_mindbending
	chem_effect_define = CE_MIND
	beneficial = -1
	minimum = -2
	maximum = 2
	mode = RANDOM_CHEM_EFFECT_INT
	desc = "phychiatric effects"

/singleton/random_chem_effect/random_properties/ce_cryogenic
	chem_effect_define = CE_CRYO
	beneficial = 1
	desc = "hypothermia protection"

/singleton/random_chem_effect/random_properties/ce_blockage
	chem_effect_define = CE_BLOCKAGE
	beneficial = -1
	maximum = 0.5
	mode = RANDOM_CHEM_EFFECT_FLOAT
	desc = "blood flow obstruction"

/singleton/random_chem_effect/random_properties/ce_squeaky
	chem_effect_define = CE_SQUEAKY
	beneficial = -1
	desc = "abnormal speech patterns"

/singleton/random_chem_effect/random_properties/tox_damage
	beneficial = -1
	maximum = 100
	mode = RANDOM_CHEM_EFFECT_INT
	desc = "acute toxicity"

/singleton/random_chem_effect/random_properties/heal_brute/affect_blood(mob/living/carbon/M, removed, value)
	if (!IS_METABOLICALLY_INERT(M))
		M.adjustToxLoss(value * removed)

/singleton/random_chem_effect/random_properties/heal_brute
	beneficial = 1
	maximum = 10
	desc = "tissue repair"

/singleton/random_chem_effect/random_properties/heal_brute/affect_blood(mob/living/carbon/M, removed, value)
	if (!IS_METABOLICALLY_INERT(M))
		M.heal_organ_damage(removed * value, 0)

/singleton/random_chem_effect/random_properties/heal_burns
	beneficial = 1
	maximum = 10
	desc = "burn repair"

/singleton/random_chem_effect/random_properties/heal_brute/affect_blood(mob/living/carbon/M, removed, value)
	if (!IS_METABOLICALLY_INERT(M))
		M.heal_organ_damage(0, removed * value)

#undef RANDOM_CHEM_EFFECT_TRUE
#undef RANDOM_CHEM_EFFECT_INT
#undef RANDOM_CHEM_EFFECT_FLOAT
