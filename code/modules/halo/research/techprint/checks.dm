
/datum/techprint
	var/debug_reagents = FALSE

/datum/techprint/proc/check_reagents(var/obj/item/I, var/update_progress = FALSE)
	. = FALSE

	if(debug_reagents)	to_debug_listeners("/techprint/proc/check_reagents([I.type], [update_progress])")

	if(required_reagents.len)
		//grab the reagents datum... the holder can be anything eg different beakers or syringes
		var/datum/reagents/R = I.reagents
		if(R)
			var/success = FALSE
			//loop over the needed chemicals
			for(var/reagent_type in required_reagents)
				if(debug_reagents)	to_debug_listeners("	check_reagents() [reagent_type]")
				var/result = R.has_reagent(reagent_type, required_reagents[reagent_type], debug_reagents)
				if(debug_reagents)	to_debug_listeners("	check_reagents() result: [result]")
				if(result)
					if(update_progress)
						//potentially has more than one
						required_reagents -= reagent_type
						consumables_current += 1
						success = TRUE
						continue

					//only need to find one
					return TRUE

			return success

/datum/techprint/proc/check_materials(var/obj/item/I, var/update_progress = FALSE)
	. = FALSE

	//only check material sheets for now
	if(istype(I, /obj/item/stack/material))
		var/obj/item/stack/material/M = I

		if(required_materials.Find(M.default_type) && M.amount >= required_materials[M.default_type])
			if(update_progress)
				required_materials -= M.default_type
				consumables_current += 1

			return TRUE

/datum/techprint/proc/check_objs(var/obj/item/I, var/update_progress = FALSE)
	. = FALSE

	for(var/checktype in required_objs)
		//this will check subtypes as well
		//ss13 code is inconsistent in that:
		//		sometimes subtypes are the same as the parent but with tweaked stats
		//		sometimes subtypes are a substantially different thing
		//this assumes all subtypes are similar enough to be equivalent
		if(istype(I, checktype))
			if(update_progress)
				required_objs -= checktype
				consumables_current += 1

			return TRUE
