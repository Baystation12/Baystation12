GLOBAL_DATUM_INIT(temp_reagents_holder, /obj, new)

/datum/reagents
	var/list/datum/reagent/reagent_list = list()
	var/total_volume = 0
	var/maximum_volume = 120
	var/atom/my_atom = null
	var/del_info

/datum/reagents/New(var/maximum_volume = 120, var/atom/my_atom)
	if(!istype(my_atom))
		CRASH("Invalid reagents holder: [log_info_line(my_atom)]")
	..()
	src.my_atom = my_atom
	src.maximum_volume = maximum_volume

/datum/reagents/Destroy()
	. = ..()
	del_info = "[my_atom]([reagent_list?.len||"_"]):[my_atom?.x||"_"],[my_atom?.y||"_"],[my_atom?.z||"_"]"
	UNQUEUE_REACTIONS(src) // While marking for reactions should be avoided just before deleting if possible, the async nature means it might be impossible.
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

/datum/reagents/proc/process_reactions()

	if(!my_atom) // No reactions in temporary holders
		return 0

	if(!my_atom.loc) //No reactions inside GC'd containers
		return 0

	if(my_atom.atom_flags & ATOM_FLAG_NO_REACT) // No reactions here
		return 0

	var/reaction_occured = FALSE
	var/list/eligible_reactions = list()

	var/temperature = my_atom ? my_atom.temperature : T20C
	for(var/thing in reagent_list)
		var/datum/reagent/R = thing
		if(R.custom_temperature_effects(temperature, src))
			reaction_occured = TRUE
			continue

		// Check if the reagent is decaying or not.
		var/list/replace_self_with
		var/replace_message
		var/replace_sound

		if(LAZYLEN(R.chilling_products) && temperature <= R.chilling_point)
			replace_self_with = R.chilling_products
			replace_message =   "\The [lowertext(R.name)] [R.chilling_message]"
			replace_sound =     R.chilling_sound

		else if(LAZYLEN(R.heating_products) && temperature >= R.heating_point)
			replace_self_with = R.heating_products
			replace_message =   "\The [lowertext(R.name)] [R.heating_message]"
			replace_sound =     R.heating_sound

		// If it is, handle replacing it with the decay product.
		if(replace_self_with)
			var/replace_amount = R.volume / LAZYLEN(replace_self_with)
			del_reagent(R.type)
			for(var/product in replace_self_with)
				add_reagent(product, replace_amount)
			reaction_occured = TRUE

			if(my_atom)
				if(replace_message)
					my_atom.visible_message("<span class='notice'>[icon2html(my_atom, viewers(get_turf(my_atom)))] [replace_message]</span>")
				if(replace_sound)
					playsound(my_atom, replace_sound, 80, 1)

		else // Otherwise, collect all possible reactions.
			eligible_reactions |= SSchemistry.reactions_by_id[R.type]

	var/list/active_reactions = list()

	for(var/datum/chemical_reaction/C in eligible_reactions)
		if(C.can_happen(src))
			active_reactions[C] = 1 // The number is going to be 1/(fraction of remaining reagents we are allowed to use), computed below
			reaction_occured = 1

	var/list/used_reagents = list()
	// if two reactions share a reagent, each is allocated half of it, so we compute this here
	for(var/datum/chemical_reaction/C in active_reactions)
		var/list/adding = C.get_used_reagents()
		for(var/R in adding)
			LAZYADD(used_reagents[R], C)

	for(var/R in used_reagents)
		var/counter = length(used_reagents[R])
		if(counter <= 1)
			continue // Only used by one reaction, so nothing we need to do.
		for(var/datum/chemical_reaction/C in used_reagents[R])
			active_reactions[C] = max(counter, active_reactions[C])
			counter-- //so the next reaction we execute uses more of the remaining reagents
			// Note: this is not guaranteed to maximize the size of the reactions we do (if one reaction is limited by reagent A, we may be over-allocating reagent B to it)
			// However, we are guaranteed to fully use up the most profligate reagent if possible.
			// Further reactions may occur on the next tick, when this runs again.

	for(var/thing in active_reactions)
		var/datum/chemical_reaction/C = thing
		C.process(src, active_reactions[C])

	for(var/thing in active_reactions)
		var/datum/chemical_reaction/C = thing
		C.post_reaction(src)

	update_total()

	if(reaction_occured)
		HANDLE_REACTIONS(src) // Check again in case the new reagents can react again

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
				HANDLE_REACTIONS(src)
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
			HANDLE_REACTIONS(src)
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
				HANDLE_REACTIONS(src)
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

/datum/reagents/proc/get_reagent(var/reagent_type)
	for(var/datum/reagent/current in reagent_list)
		if(current.type == reagent_type)
			return current
	return

/datum/reagents/proc/get_reagent_amount(reagent_type, allow_subtypes)
	for (var/datum/reagent/current in reagent_list)
		if(current.type == reagent_type)
			return current.volume
	return 0


/datum/reagents/proc/get_reagent_amount_list(reagent_type)
	var/list/result = list()
	for (var/datum/reagent/reagent as anything in reagent_list)
		if (istype(reagent, reagent_type))
			result[reagent.type] = reagent.volume
	return result


/datum/reagents/proc/get_data(var/reagent_type)
	for(var/datum/reagent/current in reagent_list)
		if(current.type == reagent_type)
			return current.get_data()
	return 0

/datum/reagents/proc/get_overdose(var/datum/reagent/current)
	if(current)
		return initial(current.overdose)
	return 0

/datum/reagents/proc/get_reagents(scannable_only = 0, precision)
	. = list()
	for(var/datum/reagent/current in reagent_list)
		if(scannable_only && !current.scannable)
			continue
		var/volume = current.volume
		if(precision)
			volume = round(volume, precision)
		if(volume)
			. += "[current.name] ([volume])"
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
	HANDLE_REACTIONS(src)
	return amount

// Transfers [amount] reagents from [src] to [target], multiplying them by [multiplier].
// Returns actual amount removed from [src] (not amount transferred to [target]).
// Use safety = 1 for temporary targets to avoid queuing them up for processing.
/datum/reagents/proc/trans_to_holder(var/datum/reagents/target, var/amount = 1, var/multiplier = 1, var/copy = 0, var/safety = 0)
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
		if (current.color_transfer)
			var/datum/reagent/added = target.get_reagent(current.type)
			if (added)
				added.color = current.color
				if (target.my_atom)
					target.my_atom.on_color_transfer_reagent_change()
					target.my_atom.update_icon()

	if(!copy)
		HANDLE_REACTIONS(src)
	if(!safety)
		HANDLE_REACTIONS(target)
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

/datum/reagents/proc/trans_type_to(var/atom/target, var/type, var/amount = 1, var/multiplier = 1)
	if (!target || !target.reagents || !target.simulated)
		return

	amount = min(amount, get_reagent_amount(type))

	if(!amount)
		return

	var/datum/reagents/F = new /datum/reagents(amount, GLOB.temp_reagents_holder)
	var/tmpdata = get_data(type)
	F.add_reagent(type, amount, tmpdata)
	remove_reagent(type, amount)

	. = F.trans_to(target, amount, multiplier) // Let this proc check the atom's type

	qdel(F)

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
			var/datum/reagents/R = C.get_ingested_reagents()
			return C.ingest(src, R, amount, multiplier, copy) //perhaps this is a bit of a hack, but currently there's no common proc for eating reagents
		if(type == CHEM_TOUCH)
			var/datum/reagents/R = C.touching
			return trans_to_holder(R, amount, multiplier, copy)
	else
		var/datum/reagents/R = new /datum/reagents(amount, GLOB.temp_reagents_holder)
		. = trans_to_holder(R, amount, multiplier, copy, 1)
		R.touch_mob(target)
		qdel(R)

/datum/reagents/proc/trans_to_turf(var/turf/target, var/amount = 1, var/multiplier = 1, var/copy = 0) // Turfs don't have any reagents (at least, for now). Just touch it.
	if(!target || !target.simulated)
		return

	var/datum/reagents/R = new /datum/reagents(amount * multiplier, GLOB.temp_reagents_holder)
	. = trans_to_holder(R, amount, multiplier, copy, 1)
	R.touch_turf(target)
	qdel(R)
	return

/datum/reagents/proc/trans_to_obj(var/obj/target, var/amount = 1, var/multiplier = 1, var/copy = 0) // Objects may or may not; if they do, it's probably a beaker or something and we need to transfer properly; otherwise, just touch.
	if(!target || !target.simulated)
		return

	if(!target.reagents)
		var/datum/reagents/R = new /datum/reagents(amount * multiplier, GLOB.temp_reagents_holder)
		. = trans_to_holder(R, amount, multiplier, copy, 1)
		R.touch_obj(target)
		qdel(R)
		return

	return trans_to_holder(target.reagents, amount, multiplier, copy)

/datum/reagents/proc/should_admin_log()
	for (var/datum/reagent/R in reagent_list)
		if (R.should_admin_log)
			return TRUE
	return FALSE

/* Atom reagent creation - use it all the time */

/atom/proc/create_reagents(var/max_vol)
	if(reagents)
		log_debug("Attempted to create a new reagents holder when already referencing one: [log_info_line(src)]")
		reagents.maximum_volume = max(reagents.maximum_volume, max_vol)
	else
		reagents = new/datum/reagents(max_vol, src)
	return reagents
