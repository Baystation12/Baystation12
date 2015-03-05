/datum/reagents
	var/list/datum/reagent/reagent_list = list()
	var/volume = 0
	var/max_volume = 100
	var/atom/my_atom = null

/datum/reagents/New(var/max = 100)
	max_volume = max
	//I dislike having these here but map-objects are initialised before world/New() is called. >_>
	if(!chemical_reagents_list)
		//Chemical Reagents - Initialises all /datum/reagent into a list indexed by reagent id
		var/paths = typesof(/datum/reagent) - /datum/reagent
		chemical_reagents_list = list()
		for(var/path in paths)
			var/datum/reagent/D = new path()
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

/* Internal procs */

/datum/reagents/proc/get_free_space() // Returns free space.
	return max_volume - volume

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

/datum/reagents/proc/update_volume() // Updates volume.
	volume = 0
	for(var/datum/reagent/R in reagent_list)
		if(R.volume < MINIMUM_CHEMICAL_VOLUME)
			del_reagent(R.id)
		else
			volume += R.volume
	return

/datum/reagents/proc/delete()
	for(var/datum/reagent/R in reagent_list)
		R.holder = null
	if(my_atom)
		my_atom.reagents = null

/datum/reagents/proc/handle_reactions() // TODO
	if(!my_atom) // No reactions in temporary holders
		return
	if(my_atom.flags & NOREACT) return //Yup, no reactions here. No siree.

	var/reaction_occured = 0
	do
		reaction_occured = 0
		for(var/datum/reagent/R in reagent_list) // Usually a small list
			for(var/reaction in chemical_reactions_list[R.id]) // Was a big list but now it should be smaller since we filtered it with our reagent id

				if(!reaction)
					continue

				var/datum/chemical_reaction/C = reaction

				//check if this recipe needs to be heated to mix
				if(C.requires_heating)
					if(istype(my_atom.loc, /obj/machinery/bunsen_burner))
						if(!my_atom.loc:heated)
							continue
					else
						continue

				var/total_required_reagents = C.required_reagents.len
				var/total_matching_reagents = 0
				var/total_required_catalysts = C.required_catalysts.len
				var/total_matching_catalysts= 0
				var/matching_container = 0
				var/matching_other = 0
				var/list/multipliers = new/list()

				for(var/B in C.required_reagents)
					if(!has_reagent(B, C.required_reagents[B]))	break
					total_matching_reagents++
					multipliers += round(get_reagent_amount(B) / C.required_reagents[B])
				for(var/B in C.required_catalysts)
					if(!has_reagent(B, C.required_catalysts[B]))	break
					total_matching_catalysts++

				if(!C.required_container)
					matching_container = 1

				else
					if(my_atom.type == C.required_container)
						matching_container = 1

				if(!C.required_other)
					matching_other = 1

				else
					/*if(istype(my_atom, /obj/item/slime_core))
						var/obj/item/slime_core/M = my_atom

						if(M.POWERFLAG == C.required_other && M.Uses > 0) // added a limit to slime cores -- Muskets requested this
							matching_other = 1*/
					if(istype(my_atom, /obj/item/slime_extract))
						var/obj/item/slime_extract/M = my_atom

						if(M.Uses > 0) // added a limit to slime cores -- Muskets requested this
							matching_other = 1




				if(total_matching_reagents == total_required_reagents && total_matching_catalysts == total_required_catalysts && matching_container && matching_other)
					var/multiplier = min(multipliers)
					var/preserved_data = null
					for(var/B in C.required_reagents)
						if(!preserved_data)
							preserved_data = get_data(B)
						remove_reagent(B, (multiplier * C.required_reagents[B]), safety = 1)

					var/created_volume = C.result_amount*multiplier
					if(C.result)
						feedback_add_details("chemical_reaction","[C.result]|[C.result_amount*multiplier]")
						multiplier = max(multiplier, 1) //this shouldnt happen ...
						if(!isnull(C.resultcolor)) //paints
							add_reagent(C.result, C.result_amount*multiplier, C.resultcolor)
						else
							add_reagent(C.result, C.result_amount*multiplier)
							//set_data(C.result, preserved_data)

						//add secondary products
						for(var/S in C.secondary_results)
							add_reagent(S, C.result_amount * C.secondary_results[S] * multiplier)

					var/list/seen = viewers(4, get_turf(my_atom))
					if(!ismob(my_atom))
						for(var/mob/M in seen)
							M << "\blue \icon[my_atom] The solution begins to bubble."
						playsound(get_turf(my_atom), 'sound/effects/bubbles.ogg', 80, 1)

					if(istype(my_atom, /obj/item/slime_extract))
						var/obj/item/slime_extract/ME2 = my_atom
						ME2.Uses--
						if(ME2.Uses <= 0) // give the notification that the slime core is dead
							for(var/mob/M in seen)
								M << "\blue \icon[my_atom] The [my_atom]'s power is consumed in the reaction."
								ME2.name = "used slime extract"
								ME2.desc = "This extract has been used up."


					C.on_reaction(src, created_volume)
					reaction_occured = 1
					break

	while(reaction_occured)
	update_volume()
	return 0

/* Holder-to-chemical */

/datum/reagents/proc/add_reagent(var/id, var/amount, var/data = null, var/safety = 0)
	if(!isnum(amount))
		return 0
	update_volume()
	amount = min(amount, get_free_space())

	for(var/datum/reagent/current in reagent_list)
		if(current.id == id)
			current.volume += amount
			update_volume()
			if(!isnull(data)) // For all we know, it could be zero or empty string and meaningful
				current.mix_data(data)
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
		R.initialize_data()
		if(!isnull(data))
			R.mix_data(data)
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
			update_volume() // Because this proc will delete it then
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
			del(current)
			update_volume()
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
	amount = min(amount, volume)

	if(!amount)
		return

	var/part = amount / volume

	for(var/datum/reagent/current in reagent_list)
		var/amount_to_remove = current.volume * part
		remove_reagent(current.id, amount_to_remove, 1)

	update_volume()
	handle_reactions()
	return amount

/datum/reagents/proc/trans_to_holder(var/datum/reagents/target, var/amount = 1, var/multiplier = 1, var/copy = 0) // Transfers [amount] reagents from [src] to [target], multiplying them by [multiplier]. Returns actual amount removed from [src] (not amount transferred to [target]).
	if(!target || !istype(target))
		return

	amount = min(min(amount, volume), target.get_free_space() / multiplier)

	if(!amount)
		return

	var/part = amount / volume

	for(var/datum/reagent/current in reagent_list)
		var/amount_to_transfer = current.volume * part
		target.add_reagent(current.id, amount_to_transfer * multiplier, current.get_data(), safety = 1) // We don't react until everything is in place
		if(!copy)
			remove_reagent(current.id, amount_to_transfer, 1)

	if(!copy)
		update_volume()
		handle_reactions()
	target.update_volume()
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

	update_volume()

/datum/reagents/proc/touch_turf(var/turf/target)
	if(!target || !istype(target))
		return

	for(var/datum/reagent/current in reagent_list)
		current.touch_turf(target)

	update_volume()

/datum/reagents/proc/touch_obj(var/obj/target)
	if(!target || !istype(target))
		return

	for(var/datum/reagent/current in reagent_list)
		current.touch_obj(target)

	update_volume()

/datum/reagents/proc/trans_to(var/atom/target, var/amount = 1, var/multiplier = 1, var/copy = 0)
	if(ismob(target))
		warning("[my_atom] is trying to transfer reagents to [target], which is a mob, using trans_to()")
		//return trans_to_mob(target, amount, multiplier, copy)
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

/datum/reagents/proc/trans_to_mob(var/mob/target, var/amount = 1, var/type, var/multiplier = 1, var/copy = 0) // Transfer after checking into which holder...
	if(!target || !istype(target))
		return
	if(!type || !(type in list(CHEM_BLOOD, CHEM_INGEST, CHEM_TOUCH)))
		warning("[my_atom] is trying to transfer reagents to [target], mob, without specifying the type")
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

	var/datum/reagents/R = new /datum/reagents(max_volume)
	. = trans_to_holder(R, amount, multiplier, copy)
	R.touch_turf(target)
	return

/datum/reagents/proc/trans_to_obj(var/turf/target, var/amount = 1, var/multiplier = 1, var/copy = 0) // Objects may or may not; if they do, it's probably a beaker or something and we need to transfer properly; otherwise, just touch.
	if(!target)
		return

	if(!target.reagents)
		var/datum/reagents/R = new /datum/reagents(max_volume)
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
	update_volume()

/* Atom reagent creation - use it all the time */

/atom/proc/create_reagents(var/max_vol)
	reagents = new/datum/reagents(max_vol)
	reagents.my_atom = src