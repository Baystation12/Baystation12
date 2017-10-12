#define PROCESS_REACTION_ITER 5 //when processing a reaction, iterate this many times

/datum/reagents
	var/list/datum/reagent/reagent_list = list()
	var/total_volume = 0
	var/maximum_volume = 120
	var/atom/my_atom = null

/datum/reagents/New(var/maximum_volume = 120, var/atom/my_atom)
	if(!istype(my_atom))
		CRASH("Invalid reagents holder: [log_info_line(my_atom)]")
	..()
	src.my_atom = my_atom
	src.maximum_volume = maximum_volume

/datum/reagents/Destroy()
	. = ..()
	if(chemistryProcess)
		chemistryProcess.active_holders -= src

	QDEL_NULL_LIST(reagent_list)
	my_atom = null

/* Internal procs */

/datum/reagents/proc/get_free_space() // Returns free space.
	return maximum_volume - total_volume

/datum/reagents/proc/get_master_reagent() // Returns reference to the reagent with the biggest volume.
	var/the_reagent = null
	var/the_volume = 0

	for(var/datum/reagent/A in reagent_list)
		if(A.volume > the_volume)
			the_volume = A.volume
			the_reagent = A

	return the_reagent

/datum/reagents/proc/get_master_reagent_name() // Returns the name of the reagent with the biggest volume.
	var/the_name = null
	var/the_volume = 0
	for(var/datum/reagent/A in reagent_list)
		if(A.volume > the_volume)
			the_volume = A.volume
			the_name = A.name

	return the_name

/datum/reagents/proc/get_master_reagent_type() // Returns the type of the reagent with the biggest volume.
	var/the_type = null
	var/the_volume = 0
	for(var/datum/reagent/A in reagent_list)
		if(A.volume > the_volume)
			the_volume = A.volume
			the_type = A.type

	return the_type

/datum/reagents/proc/update_total() // Updates volume.
	total_volume = 0
	for(var/datum/reagent/R in reagent_list)
		if(R.volume < MINIMUM_CHEMICAL_VOLUME)
			del_reagent(R.type)
		else
			total_volume += R.volume
	return

/datum/reagents/proc/handle_reactions()
	if(chemistryProcess)
		chemistryProcess.mark_for_update(src)

//returns 1 if the holder should continue reactiong, 0 otherwise.
/datum/reagents/proc/process_reactions()
	if(!my_atom) // No reactions in temporary holders
		return 0
	if(!my_atom.loc) //No reactions inside GC'd containers
		return 0
	if(my_atom.flags & NOREACT) // No reactions here
		return 0

	var/reaction_occured
	var/list/effect_reactions = list()
	var/list/eligible_reactions = list()
	for(var/i in 1 to PROCESS_REACTION_ITER)
		reaction_occured = 0

		//need to rebuild this to account for chain reactions
		for(var/datum/reagent/R in reagent_list)
			eligible_reactions |= chemical_reactions_list[R.type]

		for(var/datum/chemical_reaction/C in eligible_reactions)
			if(C.can_happen(src) && C.process(src))
				effect_reactions |= C
				reaction_occured = 1

		eligible_reactions.Cut()

		if(!reaction_occured)
			break

	for(var/datum/chemical_reaction/C in effect_reactions)
		C.post_reaction(src)

	update_total()
	return reaction_occured

/* Holder-to-chemical */

/datum/reagents/proc/add_reagent(var/reagent_type, var/amount, var/data = null, var/safety = 0)
	if(!isnum(amount) || amount <= 0)
		return 0

	update_total()
	amount = min(amount, get_free_space())

	for(var/datum/reagent/current in reagent_list)
		if(current.type == reagent_type)
			current.volume += amount
			if(!isnull(data)) // For all we know, it could be zero or empty string and meaningful
				current.mix_data(data, amount)
			update_total()
			if(!safety)
				handle_reactions()
			if(my_atom)
				my_atom.on_reagent_change()
			return 1
	if(ispath(reagent_type, /datum/reagent))
		var/datum/reagent/R = new reagent_type(src)
		reagent_list += R
		R.volume = amount
		R.initialize_data(data)
		update_total()
		if(!safety)
			handle_reactions()
		if(my_atom)
			my_atom.on_reagent_change()
		return 1
	else
		warning("[log_info_line(my_atom)] attempted to add a reagent of type '[reagent_type]' which doesn't exist. ([usr])")
	return 0

/datum/reagents/proc/remove_reagent(var/reagent_type, var/amount, var/safety = 0)
	if(!isnum(amount))
		return 0
	for(var/datum/reagent/current in reagent_list)
		if(current.type == reagent_type)
			current.volume -= amount // It can go negative, but it doesn't matter
			update_total() // Because this proc will delete it then
			if(!safety)
				handle_reactions()
			if(my_atom)
				my_atom.on_reagent_change()
			return 1
	return 0

/datum/reagents/proc/del_reagent(var/reagent_type)
	for(var/datum/reagent/current in reagent_list)
		if (current.type == reagent_type)
			reagent_list -= current
			qdel(current)
			update_total()
			if(my_atom)
				my_atom.on_reagent_change()
			return 0

/datum/reagents/proc/has_reagent(var/reagent_type, var/amount = null)
	for(var/datum/reagent/current in reagent_list)
		if(current.type == reagent_type)
			if((isnull(amount) && current.volume > 0) || current.volume >= amount)
				return 1
			else
				return 0
	return 0

/datum/reagents/proc/has_any_reagent(var/list/check_reagents)
	for(var/datum/reagent/current in reagent_list)
		if(current.type in check_reagents)
			if(current.volume >= check_reagents[current.type])
				return 1
			else
				return 0
	return 0

/datum/reagents/proc/has_all_reagents(var/list/check_reagents)
	//this only works if check_reagents has no duplicate entries... hopefully okay since it expects an associative list
	var/missing = check_reagents.len
	for(var/datum/reagent/current in reagent_list)
		if(current.type in check_reagents)
			if(current.volume >= check_reagents[current.type])
				missing--
	return !missing

/datum/reagents/proc/clear_reagents()
	for(var/datum/reagent/current in reagent_list)
		del_reagent(current.type)
	return

/datum/reagents/proc/get_reagent_amount(var/reagent_type)
	for(var/datum/reagent/current in reagent_list)
		if(current.type == reagent_type)
			return current.volume
	return 0

/datum/reagents/proc/get_data(var/reagent_type)
	for(var/datum/reagent/current in reagent_list)
		if(current.type == reagent_type)
			return current.get_data()
	return 0

/datum/reagents/proc/get_reagents()
	. = list()
	for(var/datum/reagent/current in reagent_list)
		. += "[current.type] ([current.volume])"
	return english_list(., "EMPTY", "", ", ", ", ")

/* Holder-to-holder and similar procs */

/datum/reagents/proc/remove_any(var/amount = 1) // Removes up to [amount] of reagents from [src]. Returns actual amount removed.
	amount = min(amount, total_volume)

	if(!amount)
		return

	var/part = amount / total_volume

	for(var/datum/reagent/current in reagent_list)
		var/amount_to_remove = current.volume * part
		remove_reagent(current.type, amount_to_remove, 1)

	update_total()
	handle_reactions()
	return amount

/datum/reagents/proc/trans_to_holder(var/datum/reagents/target, var/amount = 1, var/multiplier = 1, var/copy = 0) // Transfers [amount] reagents from [src] to [target], multiplying them by [multiplier]. Returns actual amount removed from [src] (not amount transferred to [target]).
	if(!target || !istype(target))
		return

	amount = max(0, min(amount, total_volume, target.get_free_space() / multiplier))

	if(!amount)
		return

	var/part = amount / total_volume

	for(var/datum/reagent/current in reagent_list)
		var/amount_to_transfer = current.volume * part
		target.add_reagent(current.type, amount_to_transfer * multiplier, current.get_data(), safety = 1) // We don't react until everything is in place
		if(!copy)
			remove_reagent(current.type, amount_to_transfer, 1)

	if(!copy)
		handle_reactions()
	target.handle_reactions()
	return amount

/* Holder-to-atom and similar procs */

//The general proc for applying reagents to things. This proc assumes the reagents are being applied externally,
//not directly injected into the contents. It first calls touch, then the appropriate trans_to_*() or splash_mob().
//If for some reason touch effects are bypassed (e.g. injecting stuff directly into a reagent container or person),
//call the appropriate trans_to_*() proc.
/datum/reagents/proc/trans_to(var/atom/target, var/amount = 1, var/multiplier = 1, var/copy = 0)
	touch(target) //First, handle mere touch effects

	if(ismob(target))
		return splash_mob(target, amount, copy)
	if(isturf(target))
		return trans_to_turf(target, amount, multiplier, copy)
	if(isobj(target) && target.is_open_container())
		return trans_to_obj(target, amount, multiplier, copy)
	return 0

//Splashing reagents is messier than trans_to, the target's loc gets some of the reagents as well.
/datum/reagents/proc/splash(var/atom/target, var/amount = 1, var/multiplier = 1, var/copy = 0, var/min_spill=0, var/max_spill=60)
	var/spill = 0
	if(!isturf(target) && target.loc)
		spill = amount*(rand(min_spill, max_spill)/100)
		amount -= spill
	if(spill)
		splash(target.loc, spill, multiplier, copy, min_spill, max_spill)

	trans_to(target, amount, multiplier, copy)

/datum/reagents/proc/trans_type_to(var/atom/target, var/type, var/amount = 1)
	if (!target || !target.reagents || !target.simulated)
		return

	amount = min(amount, get_reagent_amount(type))

	if(!amount)
		return

	var/datum/reagents/F = new /datum/reagents(amount)
	var/tmpdata = get_data(type)
	F.add_reagent(type, amount, tmpdata)
	remove_reagent(type, amount)

	return F.trans_to(target, amount) // Let this proc check the atom's type

// When applying reagents to an atom externally, touch() is called to trigger any on-touch effects of the reagent.
// This does not handle transferring reagents to things.
// For example, splashing someone with water will get them wet and extinguish them if they are on fire,
// even if they are wearing an impermeable suit that prevents the reagents from contacting the skin.
/datum/reagents/proc/touch(var/atom/target)
	if(ismob(target))
		touch_mob(target)
	if(isturf(target))
		touch_turf(target)
	if(isobj(target))
		touch_obj(target)
	return

/datum/reagents/proc/touch_mob(var/mob/target)
	if(!target || !istype(target) || !target.simulated)
		return

	for(var/datum/reagent/current in reagent_list)
		current.touch_mob(target, current.volume)

	update_total()

/datum/reagents/proc/touch_turf(var/turf/target)
	if(!target || !istype(target) || !target.simulated)
		return

	for(var/datum/reagent/current in reagent_list)
		current.touch_turf(target, current.volume)

	update_total()

/datum/reagents/proc/touch_obj(var/obj/target)
	if(!target || !istype(target) || !target.simulated)
		return

	for(var/datum/reagent/current in reagent_list)
		current.touch_obj(target, current.volume)

	update_total()

// Attempts to place a reagent on the mob's skin.
// Reagents are not guaranteed to transfer to the target.
// Do not call this directly, call trans_to() instead.
/datum/reagents/proc/splash_mob(var/mob/target, var/amount = 1, var/copy = 0)
	var/perm = 1
	if(isliving(target)) //will we ever even need to tranfer reagents to non-living mobs?
		var/mob/living/L = target
		perm = L.reagent_permeability()
	return trans_to_mob(target, amount * perm, CHEM_TOUCH, 1, copy)

/datum/reagents/proc/trans_to_mob(var/mob/target, var/amount = 1, var/type = CHEM_BLOOD, var/multiplier = 1, var/copy = 0) // Transfer after checking into which holder...
	if(!target || !istype(target) || !target.simulated)
		return
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		if(type == CHEM_BLOOD)
			var/datum/reagents/R = C.reagents
			return trans_to_holder(R, amount, multiplier, copy)
		if(type == CHEM_INGEST)
			var/datum/reagents/R = C.ingested
			return C.ingest(src,R, amount, multiplier, copy) //perhaps this is a bit of a hack, but currently there's no common proc for eating reagents
		if(type == CHEM_TOUCH)
			var/datum/reagents/R = C.touching
			return trans_to_holder(R, amount, multiplier, copy)
	else
		var/datum/reagents/R = new /datum/reagents(amount)
		. = trans_to_holder(R, amount, multiplier, copy)
		R.touch_mob(target)

/datum/reagents/proc/trans_to_turf(var/turf/target, var/amount = 1, var/multiplier = 1, var/copy = 0) // Turfs don't have any reagents (at least, for now). Just touch it.
	if(!target || !target.simulated)
		return

	var/datum/reagents/R = new /datum/reagents(amount * multiplier)
	. = trans_to_holder(R, amount, multiplier, copy)
	R.touch_turf(target)
	return

/datum/reagents/proc/trans_to_obj(var/obj/target, var/amount = 1, var/multiplier = 1, var/copy = 0) // Objects may or may not; if they do, it's probably a beaker or something and we need to transfer properly; otherwise, just touch.
	if(!target || !target.simulated)
		return

	if(!target.reagents)
		var/datum/reagents/R = new /datum/reagents(amount * multiplier, GLOB.temp_reagents_holder)
		. = trans_to_holder(R, amount, multiplier, copy)
		R.touch_obj(target)
		qdel(R)
		return

	return trans_to_holder(target.reagents, amount, multiplier, copy)

/* Atom reagent creation - use it all the time */

/atom/proc/create_reagents(var/max_vol)
	if(reagents)
		log_debug("Attempted to create a new reagents holder when already referencing one: [log_info_line(src)]")
		reagents.maximum_volume = max(reagents.maximum_volume, max_vol)
	else
		reagents = new/datum/reagents(max_vol, src)
	return reagents
