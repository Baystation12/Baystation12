/datum/reagent
	var/name = "Reagent"
	var/description = "A non-descript chemical."
	var/taste_description = "old rotten bandaids"
	var/taste_mult = 1 //how this taste compares to others. Higher values means it is more noticable
	var/datum/reagents/holder = null
	var/reagent_state = SOLID
	var/list/data = null
	var/volume = 0
	var/metabolism = REM // This would be 0.2 normally
	var/ingest_met = 0
	var/touch_met = 0
	var/overdose = 0
	var/scannable = 0 // Shows up on health analyzers.
	var/color = "#000000"
	var/color_weight = 1
	var/color_foods = FALSE // If TRUE, this reagent affects the color of food items it's added to
	var/protein_amount = 0 //What *percentage* of this is made of *animal* protein (1 is 100%). Used to calculate how it affects skrell

	// If TRUE, this reagent transfers changes to its 'color' var when moving to other containers
	// Of note: Mixing two reagents of the same type with this var that have different colors
	// will cause them both to take on the color of the form being added into the holder.
	// i.e. if you add red to blue, all of the reagent turns red and vice-versa.
	var/color_transfer = FALSE

	var/alpha = 255
	var/flags = 0
	var/hidden_from_codex

	var/glass_icon = DRINK_ICON_DEFAULT
	var/glass_name = "something"
	var/glass_desc = "It's a glass of... what, exactly?"
	var/list/glass_special = null // null equivalent to list()

	// GAS DATA, generic values copied from base XGM datum type.
	var/gas_specific_heat = 20
	var/gas_molar_mass =    0.032
	var/gas_overlay_limit = 0.7
	var/gas_flags =         0
	var/gas_burn_product
	var/gas_overlay = "generic"
	// END GAS DATA

	// Matter state data.
	var/chilling_point
	var/chilling_message = "crackles and freezes!"
	var/chilling_sound = 'sound/effects/bubbles.ogg'
	var/list/chilling_products

	var/list/heating_products
	var/heating_point
	var/heating_message = "begins to boil!"
	var/heating_sound = 'sound/effects/bubbles.ogg'

	var/temperature_multiplier = 1
	var/value = 1

	var/scent //refer to _scent.dm
	var/scent_intensity = /decl/scent_intensity/normal
	var/scent_descriptor = SCENT_DESC_SMELL
	var/scent_range = 1

	var/should_admin_log = FALSE

/datum/reagent/New(var/datum/reagents/holder)
	if(!istype(holder))
		CRASH("Invalid reagents holder: [log_info_line(holder)]")
	src.holder = holder
	..()

/datum/reagent/proc/remove_self(var/amount) // Shortcut
	if(QDELETED(src)) // In case we remove multiple times without being careful.
		return
	holder.remove_reagent(type, amount)

/datum/reagent/proc/on_leaving_metabolism(var/mob/parent, var/metabolism_class)
	return

// This doesn't apply to skin contact - this is for, e.g. extinguishers and sprays. The difference is that reagent is not directly on the mob's skin - it might just be on their clothing.
/datum/reagent/proc/touch_mob(var/mob/M, var/amount)
	return

/datum/reagent/proc/touch_obj(var/obj/O, var/amount) // Acid melting, cleaner cleaning, etc
	return

/datum/reagent/proc/touch_turf(var/turf/T, var/amount) // Cleaner cleaning, lube lubbing, etc, all go here
	return

/datum/reagent/proc/on_mob_life(var/mob/living/carbon/M, var/alien, var/location) // Currently, on_mob_life is called on carbons. Any interaction with non-carbon mobs (lube) will need to be done in touch_mob.
	if(QDELETED(src))
		return // Something else removed us.
	if(!istype(M))
		return
	if(!(flags & AFFECTS_DEAD) && M.stat == DEAD && (world.time - M.timeofdeath > 150))
		return
	if(overdose && (location != CHEM_TOUCH))
		var/overdose_threshold = overdose * (flags & IGNORE_MOB_SIZE? 1 : MOB_MEDIUM/M.mob_size)
		if(volume > overdose_threshold)
			overdose(M, alien)

	//determine the metabolism rate
	var/removed = metabolism
	if(ingest_met && (location == CHEM_INGEST))
		removed = ingest_met
	if(touch_met && (location == CHEM_TOUCH))
		removed = touch_met
	removed = M.get_adjusted_metabolism(removed)

	//adjust effective amounts - removed, dose, and max_dose - for mob size
	var/effective = removed
	if(!(flags & IGNORE_MOB_SIZE) && location != CHEM_TOUCH)
		effective *= (MOB_MEDIUM/M.mob_size)

	M.chem_doses[type] = M.chem_doses[type] + effective
	if(effective >= (metabolism * 0.1) || effective >= 0.1) // If there's too little chemical, don't affect the mob, just remove it
		switch(location)
			if(CHEM_BLOOD)
				affect_blood(M, alien, effective)
			if(CHEM_INGEST)
				affect_ingest(M, alien, effective)
			if(CHEM_TOUCH)
				affect_touch(M, alien, effective)

	if(volume)
		remove_self(removed)

/datum/reagent/proc/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	return

/datum/reagent/proc/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if (alien == IS_SKRELL && protein_amount > 0)
		var/datum/species/skrell/S = M.species
		S.handle_protein(M, src)
	affect_blood(M, alien, removed * 0.5)
	return

/datum/reagent/proc/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	return

/datum/reagent/proc/overdose(var/mob/living/carbon/M, var/alien) // Overdose effect. Doesn't happen instantly.
	M.add_chemical_effect(CE_TOXIN, 1)
	M.adjustToxLoss(REM)
	return

/datum/reagent/proc/initialize_data(var/newdata) // Called when the reagent is created.
	if(!isnull(newdata))
		data = newdata
	return

/datum/reagent/proc/mix_data(var/newdata, var/newamount) // You have a reagent with data, and new reagent with its own data get added, how do you deal with that?
	return

/datum/reagent/proc/get_data() // Just in case you have a reagent that handles data differently.
	if(data && istype(data, /list))
		return data.Copy()
	else if(data)
		return data
	return null

/datum/reagent/Destroy() // This should only be called by the holder, so it's already handled clearing its references
	holder = null
	. = ..()

/datum/reagent/proc/ex_act(obj/item/reagent_containers/holder, severity)
	return

/* DEPRECATED - TODO: REMOVE EVERYWHERE */

/datum/reagent/proc/reaction_turf(var/turf/target)
	touch_turf(target)

/datum/reagent/proc/reaction_obj(var/obj/target)
	touch_obj(target)

/datum/reagent/proc/reaction_mob(var/mob/target)
	touch_mob(target)

/datum/reagent/proc/custom_temperature_effects(var/temperature)
