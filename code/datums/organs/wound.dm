
/****************************************************
					WOUNDS
****************************************************/
/datum/wound
	// stages such as "cut", "deep cut", etc.
	var/list/stages
	// number representing the current stage
	var/current_stage = 0

	// description of the wound
	var/desc = ""

	// amount of damage this wound causes
	var/damage = 0

	// amount of damage the current wound type requires(less means we need to apply the next healing stage)
	var/min_damage = 0

	// one of CUT, BRUISE, BURN
	var/damage_type = CUT

	// whether this wound needs a bandage/salve to heal at all
	var/needs_treatment = 0

	// is the wound bandaged?
	var/tmp/bandaged = 0
	// is the wound salved?
	var/tmp/salved = 0
	// is the wound disinfected?
	var/tmp/disinfected = 0
	var/tmp/created = 0

	// number of wounds of this type
	var/tmp/amount = 1

	// helper lists
	var/tmp/list/desc_list = list()
	var/tmp/list/damage_list = list()
	New(var/damage)

		created = world.time

		// reading from a list("stage" = damage) is pretty difficult, so build two separate
		// lists from them instead
		for(var/V in stages)
			desc_list += V
			damage_list += stages[V]

		src.damage = damage

		// initialize with the first stage
		next_stage()

		// this will ensure the size of the wound matches the damage
		src.heal_damage(0)

	// returns 1 if there's a next stage, 0 otherwise
	proc/next_stage()
		if(current_stage + 1 > src.desc_list.len)
			return 0

		current_stage++

		src.min_damage = damage_list[current_stage]
		src.desc = desc_list[current_stage]
		return 1

	// returns 1 if the wound has started healing
	proc/started_healing()
		return (current_stage > 1)

	// checks whether the wound has been appropriately treated
	// always returns 1 for wounds that don't need to be treated
	proc/is_treated()
		if(!needs_treatment) return 1

		if(damage_type == BRUISE || damage_type == CUT)
			return bandaged
		else if(damage_type == BURN)
			return salved

	// heal the given amount of damage, and if the given amount of damage was more
	// than what needed to be healed, return how much heal was left
	proc/heal_damage(amount)
		var/healed_damage = min(src.damage, amount)
		amount -= healed_damage
		src.damage -= healed_damage

		while(src.damage / src.amount < damage_list[current_stage] && current_stage < src.desc_list.len)
			current_stage++
		desc = desc_list[current_stage]

		// return amount of healing still leftover, can be used for other wounds
		return amount

	// opens the wound again
	proc/open_wound()
		if(current_stage > 1)
			// e.g. current_stage is 2, then reset it to 0 and do next_stage(), bringing it to 1
			src.current_stage -= 2
			next_stage()
			src.damage = src.min_damage + 5

/** CUTS **/
/datum/wound/cut
	// link wound descriptions to amounts of damage
	stages = list("cut" = 5, "healing cut" = 2, "small scab" = 0)

/datum/wound/deep_cut
	stages = list("deep cut" = 15, "clotted cut" = 8, "scab" = 2, "fresh skin" = 0)

/datum/wound/flesh_wound
	stages = list("flesh wound" = 25, "blood soaked clot" = 15, "large scab" = 5, "fresh skin" = 0)

/datum/wound/gaping_wound
	stages = list("gaping wound" = 50, "large blood soaked clot" = 25, "large clot" = 15, "small angry scar" = 5, \
	               "small straight scar" = 0)

/datum/wound/big_gaping_wound
	stages = list("big gaping wound" = 60, "gauze wrapped wound" = 50, "blood soaked bandage" = 25,\
				  "large angry scar" = 10, "large straight scar" = 0)

	needs_treatment = 1 // this only heals when bandaged

/datum/wound/massive_wound
	stages = list("massive wound" = 70, "massive blood soaked bandage" = 40, "huge bloody mess" = 20,\
				  "massive angry scar" = 10,  "massive jagged scar" = 0)

	needs_treatment = 1 // this only heals when bandaged

/** BRUISES **/
/datum/wound/bruise
	stages = list("monumental bruise" = 80, "huge bruise" = 50, "large bruise" = 30,\
				  "moderate bruise" = 20, "small bruise" = 10, "tiny bruise" = 5)

	needs_treatment = 1 // this only heals when bandaged
	damage_type = BRUISE

/datum/wound/bruise/monumental_bruise

// implement sub-paths by starting at a later stage
/datum/wound/bruise/huge_bruise
	current_stage = 1

/datum/wound/bruise/large_bruise
	current_stage = 2

/datum/wound/bruise/moderate_bruise
	current_stage = 3
	needs_treatment = 0

/datum/wound/bruise/small_bruise
	current_stage = 4
	needs_treatment = 0

/datum/wound/bruise/tiny_bruise
	current_stage = 5
	needs_treatment = 0

/** BURNS **/
/datum/wound/moderate_burn
	stages = list("moderate burn" = 5, "moderate salved burn" = 2, "fresh skin" = 0)

	needs_treatment = 1 // this only heals when bandaged

	damage_type = BURN

/datum/wound/large_burn
	stages = list("large burn" = 15, "large salved burn" = 5, "fresh skin" = 0)

	needs_treatment = 1 // this only heals when bandaged

	damage_type = BURN

/datum/wound/severe_burn
	stages = list("severe burn" = 30, "severe salved burn" = 10, "burn scar" = 0)

	needs_treatment = 1 // this only heals when bandaged

	damage_type = BURN

/datum/wound/deep_burn
	stages = list("deep burn" = 40, "deep salved burn" = 15,  "large burn scar" = 0)

	needs_treatment = 1 // this only heals when bandaged

	damage_type = BURN


/datum/wound/carbonised_area
	stages = list("carbonised area" = 50, "treated carbonised area" = 20, "massive burn scar" = 0)

	needs_treatment = 1 // this only heals when bandaged

	damage_type = BURN