/datum/reagents
	var/list/datum/reagent/reagent_list = list()
	var/total_volume = 0
	var/maximum_volume = 100
	var/atom/my_atom = null

/datum/reagents/New(var/max = 100)
	maximum_volume = max
	//I dislike having these here but map-objects are initialised before world/New() is called. >_>
	if(!chemical_reagents_list)
		//Chemical Reagents - Initialises all /datum/reagent into a list indexed by reagent id
		var/paths = typesof(/datum/reagent) - /datum/reagent
		chemical_reagents_list = list()
		for(var/path in paths)
			var/datum/reagent/D = new path()
			if(!D.name)
				continue
			chemical_reagents_list[D.id] = D

	if(!chemical_reactions_list)
		//Chemical Reactions - Initialises all /datum/chemical_reaction into a list
		// It is filtered into multiple lists within a list.
		// For example:
		// chemical_reaction_list["phoron"] is a list of all reactions relating to phoron

		var/paths = typesof(/datum/chemical_reaction) - /datum/chemical_reaction
		chemical_reactions_list = list()

		for(var/path in paths)

			var/datum/chemical_reaction/D = new path()
			var/list/reaction_ids = list()

			if(D.required_reagents && D.required_reagents.len)
				for(var/reaction in D.required_reagents)
					reaction_ids += reaction

			// Create filters based on each reagent id in the required reagents list
			for(var/id in reaction_ids)
				if(!chemical_reactions_list[id])
					chemical_reactions_list[id] = list()
				chemical_reactions_list[id] += D
				break // Don't bother adding ourselves to other reagent ids, it is redundant.

/datum/reagents/Destroy()
	..()
	for(var/datum/reagent/R in reagent_list)
		qdel(R)
	reagent_list.Cut()
	reagent_list = null
	if(my_atom && my_atom.reagents == src)
		my_atom.reagents = null

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

/datum/reagents/proc/get_master_reagent_id() // Returns the id of the reagent with the biggest volume.
	var/the_id = null
	var/the_volume = 0
	for(var/datum/reagent/A in reagent_list)
		if(A.volume > the_volume)
			the_volume = A.volume
			the_id = A.id

	return the_id

/datum/reagents/proc/update_total() // Updates volume.
	total_volume = 0
	for(var/datum/reagent/R in reagent_list)
		if(R.volume < MINIMUM_CHEMICAL_VOLUME)
			del_reagent(R.id)
		else
			total_volume += R.volume
	return

/datum/reagents/proc/delete()
	for(var/datum/reagent/R in reagent_list)
		R.holder = null
	if(my_atom)
		my_atom.reagents = null

/datum/reagents/proc/handle_reactions()
	if(!my_atom) // No reactions in temporary holders
		return
	if(my_atom.flags & NOREACT) // No reactions here
		return

	var/reaction_occured = 0
	do
		reaction_occured = 0
		for(var/datum/reagent/R in reagent_list)
			for(var/datum/chemical_reaction/C in chemical_reactions_list[R.id])
				var/reagents_suitable = 1
				for(var/B in C.required_reagents)
					if(!has_reagent(B))
						reagents_suitable = 0
				for(var/B in C.catalysts)
					if(!has_reagent(B, C.catalysts[B]))
						reagents_suitable = 0
				for(var/B in C.inhibitors)
					if(has_reagent(B, C.inhibitors[B]))
						reagents_suitable = 0

				if(!reagents_suitable || !C.can_happen(src))
					continue

				var/use = -1
				for(var/B in C.required_reagents)
					if(use == -1)
						use = get_reagent_amount(B) / C.required_reagents[B]
					else
						use = min(use, get_reagent_amount(B) / C.required_reagents[B])

				var/newdata = C.send_data(src) // We need to get it before reagents are removed. See blood paint.
				for(var/B in C.required_reagents)
					remove_reagent(B, use * C.required_reagents[B], safety = 1)

				if(C.result)
					add_reagent(C.result, C.result_amount * use, newdata)

				if(!ismob(my_atom) && C.mix_message)
					var/list/seen = viewers(4, get_turf(my_atom))
					for(var/mob/M in seen)
						M << "<span class='notice'>\icon[my_atom] [C.mix_message]</span>"
					playsound(get_turf(my_atom), 'sound/effects/bubbles.ogg', 80, 1)

				C.on_reaction(src, C.result_amount * use)
				reaction_occured = 1
	while(reaction_occured)
	update_total()
	return

/* Holder-to-chemical */

/datum/reagents/proc/add_reagent(var/id, var/amount, var/data = null, var/safety = 0)
	if(!isnum(amount) || amount <= 0)
		return 0

	update_total()
	amount = min(amount, get_free_space())

	for(var/datum/reagent/current in reagent_list)
		if(current.id == id)
			current.volume += amount
			if(!isnull(data)) // For all we know, it could be zero or empty string and meaningful
				current.mix_data(data, amount)
			update_total()
			if(!safety)
				handle_reactions()
			if(my_atom)
				my_atom.on_reagent_change()
			return 1
	var/datum/reagent/D = chemical_reagents_list[id]
	if(D)
		var/datum/reagent/R = new D.type()
		reagent_list += R
		R.holder = src
		R.volume = amount
		R.initialize_data(data)
		update_total()
		if(!safety)
			handle_reactions()
		if(my_atom)
			my_atom.on_reagent_change()
		return 1
	else
		warning("[my_atom] attempted to add a reagent called '[id]' which doesn't exist. ([usr])")
	return 0

/datum/reagents/proc/remove_reagent(var/id, var/amount, var/safety = 0)
	if(!isnum(amount))
		return 0
	for(var/datum/reagent/current in reagent_list)
		if(current.id == id)
			current.volume -= amount // It can go negative, but it doesn't matter
			update_total() // Because this proc will delete it then
			if(!safety)
				handle_reactions()
			if(my_atom)
				my_atom.on_reagent_change()
			return 1
	return 0

/datum/reagents/proc/del_reagent(var/id)
	for(var/datum/reagent/current in reagent_list)
		if (current.id == id)
			reagent_list -= current
			qdel(current)
			update_total()
			if(my_atom)
				my_atom.on_reagent_change()
			return 0

/datum/reagents/proc/has_reagent(var/id, var/amount = 0)
	for(var/datum/reagent/current in reagent_list)
		if(current.id == id)
			if(current.volume >= amount)
				return 1
			else
				return 0
	return 0

/datum/reagents/proc/clear_reagents()
	for(var/datum/reagent/current in reagent_list)
		del_reagent(current.id)
	return

/datum/reagents/proc/get_reagent_amount(var/id)
	for(var/datum/reagent/current in reagent_list)
		if(current.id == id)
			return current.volume
	return 0

/datum/reagents/proc/get_data(var/id)
	for(var/datum/reagent/current in reagent_list)
		if(current.id == id)
			return current.get_data()
	return 0

/datum/reagents/proc/get_reagents()
	var/res = ""
	for(var/datum/reagent/current in reagent_list)
		if (res != "") res += ","
		res += "[current.id]([current.volume])"

	return res

/* Holder-to-holder and similar procs */

/datum/reagents/proc/remove_any(var/amount = 1) // Removes up to [amount] of reagents from [src]. Returns actual amount removed.
	amount = min(amount, total_volume)

	if(!amount)
		return

	var/part = amount / total_volume

	for(var/datum/reagent/current in reagent_list)
		var/amount_to_remove = current.volume * part
		remove_reagent(current.id, amount_to_remove, 1)

	update_total()
	handle_reactions()
	return amount

/datum/reagents/proc/trans_to_holder(var/datum/reagents/target, var/amount = 1, var/multiplier = 1, var/copy = 0) // Transfers [amount] reagents from [src] to [target], multiplying them by [multiplier]. Returns actual amount removed from [src] (not amount transferred to [target]).
	if(!target || !istype(target))
		return

	amount = min(amount, total_volume, target.get_free_space() / multiplier)

	if(!amount)
		return

	var/part = amount / total_volume

	for(var/datum/reagent/current in reagent_list)
		var/amount_to_transfer = current.volume * part
		target.add_reagent(current.id, amount_to_transfer * multiplier, current.get_data(), safety = 1) // We don't react until everything is in place
		if(!copy)
			remove_reagent(current.id, amount_to_transfer, 1)

	if(!copy)
		handle_reactions()
	target.handle_reactions()
	return amount

/* Holder-to-atom and similar procs */

/datum/reagents/proc/touch(var/atom/target) // This picks the appropriate reaction. Reagents are not guaranteed to transfer to the target.
	if(ismob(target))
		touch_mob(target)
	if(isturf(target))
		touch_turf(target)
	if(isobj(target))
		touch_obj(target)
	return

/datum/reagents/proc/touch_mob(var/mob/target)
	if(!target || !istype(target))
		return

	for(var/datum/reagent/current in reagent_list)
		current.touch_mob(target)

	update_total()

/datum/reagents/proc/touch_turf(var/turf/target)
	if(!target || !istype(target))
		return

	for(var/datum/reagent/current in reagent_list)
		current.touch_turf(target)

	update_total()

/datum/reagents/proc/touch_obj(var/obj/target)
	if(!target || !istype(target))
		return

	for(var/datum/reagent/current in reagent_list)
		current.touch_obj(target)

	update_total()

/datum/reagents/proc/trans_to(var/atom/target, var/amount = 1, var/multiplier = 1, var/copy = 0)
	if(ismob(target))
		//warning("[my_atom] is trying to transfer reagents to [target], which is a mob, using trans_to()")
		//return trans_to_mob(target, amount, multiplier, copy)
		return splash_mob(target, amount)
	if(isturf(target))
		return trans_to_turf(target, amount, multiplier, copy)
	if(isobj(target))
		return trans_to_obj(target, amount, multiplier, copy)
	return 0

/datum/reagents/proc/trans_id_to(var/atom/target, var/id, var/amount = 1)
	if (!target || !target.reagents)
		return

	amount = min(amount, get_reagent_amount(id))

	if(!amount)
		return

	var/datum/reagents/F = new /datum/reagents(amount)
	var/tmpdata = get_data(id)
	F.add_reagent(id, amount, tmpdata)
	remove_reagent(id, amount)

	return F.trans_to(target, amount) // Let this proc check the atom's type

/datum/reagents/proc/splash_mob(var/mob/target, var/amount = 1, var/clothes = 1)
	var/perm = 0
	var/list/L = list("head" = THERMAL_PROTECTION_HEAD, "upper_torso" = THERMAL_PROTECTION_UPPER_TORSO, "lower_torso" = THERMAL_PROTECTION_LOWER_TORSO, "legs" = THERMAL_PROTECTION_LEG_LEFT + THERMAL_PROTECTION_LEG_RIGHT, "feet" = THERMAL_PROTECTION_FOOT_LEFT + THERMAL_PROTECTION_FOOT_RIGHT, "arms" = THERMAL_PROTECTION_ARM_LEFT + THERMAL_PROTECTION_ARM_RIGHT, "hands" = THERMAL_PROTECTION_HAND_LEFT + THERMAL_PROTECTION_HAND_RIGHT)
	if(clothes)
		for(var/obj/item/clothing/C in target.get_equipped_items())
			if(C.permeability_coefficient == 1 || C.body_parts_covered == 0)
				continue
			if(C.body_parts_covered & HEAD)
				L["head"] *= C.permeability_coefficient
			if(C.body_parts_covered & UPPER_TORSO)
				L["upper_torso"] *= C.permeability_coefficient
			if(C.body_parts_covered & LOWER_TORSO)
				L["lower_torso"] *= C.permeability_coefficient
			if(C.body_parts_covered & LEGS)
				L["legs"] *= C.permeability_coefficient
			if(C.body_parts_covered & FEET)
				L["feet"] *= C.permeability_coefficient
			if(C.body_parts_covered & ARMS)
				L["arms"] *= C.permeability_coefficient
			if(C.body_parts_covered & HANDS)
				L["hands"] *= C.permeability_coefficient
	for(var/t in L)
		perm += L[t]
	return trans_to_mob(target, amount, CHEM_TOUCH, perm)

/datum/reagents/proc/trans_to_mob(var/mob/target, var/amount = 1, var/type = CHEM_BLOOD, var/multiplier = 1, var/copy = 0) // Transfer after checking into which holder...
	if(!target || !istype(target))
		return
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		if(type == CHEM_BLOOD)
			var/datum/reagents/R = C.reagents
			return trans_to_holder(R, amount, multiplier, copy)
		if(type == CHEM_INGEST)
			var/datum/reagents/R = C.ingested
			return trans_to_holder(R, amount, multiplier, copy)
		if(type == CHEM_TOUCH)
			var/datum/reagents/R = C.touching
			return trans_to_holder(R, amount, multiplier, copy)
	else
		var/datum/reagents/R = new /datum/reagents(amount)
		. = trans_to_holder(R, amount, multiplier, copy)
		R.touch_mob(target)

/datum/reagents/proc/trans_to_turf(var/turf/target, var/amount = 1, var/multiplier = 1, var/copy = 0) // Turfs don't have any reagents (at least, for now). Just touch it.
	if(!target)
		return

	var/datum/reagents/R = new /datum/reagents(maximum_volume)
	. = trans_to_holder(R, amount, multiplier, copy)
	R.touch_turf(target)
	return

/datum/reagents/proc/trans_to_obj(var/turf/target, var/amount = 1, var/multiplier = 1, var/copy = 0) // Objects may or may not; if they do, it's probably a beaker or something and we need to transfer properly; otherwise, just touch.
	if(!target)
		return

	if(!target.reagents)
		var/datum/reagents/R = new /datum/reagents(maximum_volume)
		. = trans_to_holder(R, amount, multiplier, copy)
		R.touch_obj(target)
		return

	return trans_to_holder(target.reagents, amount, multiplier, copy)

/datum/reagents/proc/metabolize(var/alien, var/location)
	if(!iscarbon(my_atom))
		return
	var/mob/living/carbon/C = my_atom
	if(!C || !istype(C))
		return
	for(var/datum/reagent/current in reagent_list)
		current.on_mob_life(C, alien, location)
	update_total()

/* Atom reagent creation - use it all the time */

/atom/proc/create_reagents(var/max_vol)
	reagents = new/datum/reagents(max_vol)
	reagents.my_atom = src
