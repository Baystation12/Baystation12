
/****************************************************
					WOUNDS
****************************************************/
/datum/wound
	var/current_stage = 0      // number representing the current stage
	var/desc = "wound"         // description of the wound. default in case something borks
	var/damage = 0             // amount of damage this wound causes
	var/bleed_timer = 0        // ticks of bleeding left.
	var/bleed_threshold = 30   // Above this amount wounds you will need to treat the wound to stop bleeding, regardless of bleed_timer
	var/min_damage = 0         // amount of damage the current wound type requires(less means we need to apply the next healing stage)
	var/bandaged = 0           // is the wound bandaged?
	var/clamped = 0            // Similar to bandaged, but works differently
	var/salved = 0             // is the wound salved?
	var/disinfected = 0        // is the wound disinfected?
	var/created = 0
	var/amount = 1             // number of wounds of this type
	var/germ_level = 0         // amount of germs in the wound

	/*  These are defined by the wound type and should not be changed */
	var/list/stages            // stages such as "cut", "deep cut", etc.
	var/internal = 0           // internal wounds can only be fixed through surgery
	var/max_bleeding_stage = 0 // maximum stage at which bleeding should still happen. Beyond this stage bleeding is prevented.
	var/damage_type = CUT      // one of CUT, PIERCE, BRUISE, BURN
	var/autoheal_cutoff = 15   // the maximum amount of damage that this wound can have and still autoheal

	// helper lists
	var/tmp/list/desc_list = list()
	var/tmp/list/damage_list = list()

/datum/wound/New(var/damage)

	created = world.time

	// reading from a list("stage" = damage) is pretty difficult, so build two separate
	// lists from them instead
	for(var/V in stages)
		desc_list += V
		damage_list += stages[V]

	src.damage = damage

	// initialize with the appropriate stage
	src.init_stage(damage)

	bleed_timer += damage

// returns 1 if there's a next stage, 0 otherwise
/datum/wound/proc/init_stage(var/initial_damage)
	current_stage = stages.len

	while(src.current_stage > 1 && src.damage_list[current_stage-1] <= initial_damage / src.amount)
		src.current_stage--

	src.min_damage = damage_list[current_stage]
	src.desc = desc_list[current_stage]

// the amount of damage per wound
/datum/wound/proc/wound_damage()
	return src.damage / src.amount

/datum/wound/proc/can_autoheal()
	return (src.wound_damage() <= autoheal_cutoff) ? 1 : is_treated()

// checks whether the wound has been appropriately treated
/datum/wound/proc/is_treated()
	switch(damage_type)
		if(BRUISE, CUT, PIERCE)
			return bandaged
		if(BURN)
			return salved

	// Checks whether other other can be merged into src.
/datum/wound/proc/can_merge(var/datum/wound/other)
	if (other.type != src.type) return 0
	if (other.current_stage != src.current_stage) return 0
	if (other.damage_type != src.damage_type) return 0
	if (!(other.can_autoheal()) != !(src.can_autoheal())) return 0
	if (!(other.bandaged) != !(src.bandaged)) return 0
	if (!(other.clamped) != !(src.clamped)) return 0
	if (!(other.salved) != !(src.salved)) return 0
	if (!(other.disinfected) != !(src.disinfected)) return 0
	return 1

/datum/wound/proc/merge_wound(var/datum/wound/other)
	src.damage += other.damage
	src.amount += other.amount
	src.bleed_timer += other.bleed_timer
	src.germ_level = max(src.germ_level, other.germ_level)
	src.created = max(src.created, other.created)	//take the newer created time

// checks if wound is considered open for external infections
// untreated cuts (and bleeding bruises) and burns are possibly infectable, chance higher if wound is bigger
/datum/wound/proc/infection_check()
	if (damage < 10)	//small cuts, tiny bruises, and moderate burns shouldn't be infectable.
		return 0
	if (is_treated() && damage < 25)	//anything less than a flesh wound (or equivalent) isn't infectable if treated properly
		return 0
	if (disinfected)
		germ_level = 0	//reset this, just in case
		return 0

	if (damage_type == BRUISE && !bleeding()) //bruises only infectable if bleeding
		return 0

	var/dam_coef = round(damage/10)
	switch (damage_type)
		if (BRUISE)
			return prob(dam_coef*5)
		if (BURN)
			return prob(dam_coef*10)
		if (CUT)
			return prob(dam_coef*20)

	return 0

/datum/wound/proc/bandage()
	bandaged = 1

/datum/wound/proc/salve()
	salved = 1

/datum/wound/proc/disinfect()
	disinfected = 1

// heal the given amount of damage, and if the given amount of damage was more
// than what needed to be healed, return how much heal was left
// set @heals_internal to also heal internal organ damage
/datum/wound/proc/heal_damage(amount, heals_internal = 0)
	if(src.internal && !heals_internal)
		// heal nothing
		return amount

	var/healed_damage = min(src.damage, amount)
	amount -= healed_damage
	src.damage -= healed_damage

	while(src.wound_damage() < damage_list[current_stage] && current_stage < src.desc_list.len)
		current_stage++
	desc = desc_list[current_stage]
	src.min_damage = damage_list[current_stage]

	// return amount of healing still leftover, can be used for other wounds
	return amount

// opens the wound again
/datum/wound/proc/open_wound(damage)
	src.damage += damage
	bleed_timer += damage

	while(src.current_stage > 1 && src.damage_list[current_stage-1] <= src.damage / src.amount)
		src.current_stage--

	src.desc = desc_list[current_stage]
	src.min_damage = damage_list[current_stage]

// returns whether this wound can absorb the given amount of damage.
// this will prevent large amounts of damage being trapped in less severe wound types
/datum/wound/proc/can_worsen(damage_type, damage)
	if (src.damage_type != damage_type)
		return 0	//incompatible damage types

	if (src.amount > 1)
		return 0	//merged wounds cannot be worsened.

	//with 1.5*, a shallow cut will be able to carry at most 30 damage,
	//37.5 for a deep cut
	//52.5 for a flesh wound, etc.
	var/max_wound_damage = 1.5*src.damage_list[1]
	if (src.damage + damage > max_wound_damage)
		return 0
	return 1

/datum/wound/proc/bleeding()
	return !(internal || (current_stage > max_bleeding_stage) || bandaged || clamped || (bleed_timer <= 0 && wound_damage() <= bleed_threshold))
