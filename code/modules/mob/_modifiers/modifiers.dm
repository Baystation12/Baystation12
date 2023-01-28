// This is a datum that tells the mob that something is affecting them.
// The advantage of using this datum verses just setting a variable on the mob directly, is that there is no risk of two different procs overwriting
// each other, or other weirdness.  An excellent example is adjusting max health.

/datum/modifier
	var/name = null						// Mostly used to organize, might show up on the UI in the Future(tm)
	var/desc = null						// Ditto.
	var/icon_state = null				// See above.
	var/mob/living/holder = null		// The mob that this datum is affecting.
	var/weakref/origin = null			// A weak reference to whatever caused the modifier to appear.  THIS NEEDS TO BE A MOB/LIVING.  It's a weakref to not interfere with qdel().
	var/expire_at = null				// world.time when holder's Life() will remove the datum.  If null, it lasts forever or until it gets deleted by something else.
	var/on_created_text = null			// Text to show to holder upon being created.
	var/on_expired_text = null			// Text to show to holder when it expires.
	var/hidden = FALSE					// If true, it will not show up on the HUD in the Future(tm)
	var/stacks = MODIFIER_STACK_FORBID	// If true, attempts to add a second instance of this type will refresh expire_at instead.
	var/flags = 0						// Flags for the modifier, see mobs.dm defines for more details.

	var/light_color = null				// If set, the mob possessing the modifier will glow in this color.  Not implemented yet.
	var/light_range = null				// How far the light for the above var goes. Not implemented yet.
	var/light_intensity = null			// Ditto. Not implemented yet.
	var/mob_overlay_state = null		// Icon_state for an overlay to apply to a (human) mob while this exists.  This is actually implemented.
	var/client_color = null				// If set, the client will have the world be shown in this color, from their perspective.
	var/wire_colors_replace = null		// If set, the client will have wires replaced by the given replacement list. For colorblindness.
	var/list/filter_parameters = null	// If set, will add a filter to the holder with the parameters in this var. Must be a list.
	var/filter_priority = 1				// Used to make filters be applied in a specific order, if that is important.
	var/filter_instance = null			// Instance of a filter created with the `filter_parameters` list. This exists to make `animate()` calls easier. Don't set manually.

	// Now for all the different effects.
	// Percentage modifiers are expressed as a multipler. (e.g. +25% damage should be written as 1.25)
	var/max_health_flat					// Adjusts max health by a flat (e.g. +20) amount.  Note this is added to base health.
	var/max_health_percent				// Adjusts max health by a percentage (e.g. -30%).
	var/disable_duration_percent		// Adjusts duration of 'disables' (stun, weaken, paralyze, confusion, sleep, halloss, etc)  Setting to 0 will grant immunity.
	var/incoming_damage_percent			// Adjusts all incoming damage.
	var/incoming_brute_damage_percent	// Only affects bruteloss.
	var/incoming_fire_damage_percent	// Only affects fireloss.
	var/incoming_tox_damage_percent		// Only affects toxloss.
	var/incoming_oxy_damage_percent		// Only affects oxyloss.
	var/incoming_clone_damage_percent	// Only affects cloneloss.
	var/incoming_hal_damage_percent		// Only affects halloss.
	var/incoming_healing_percent		// Adjusts amount of healing received.
	var/outgoing_melee_damage_percent	// Adjusts melee damage inflicted by holder by a percentage.  Affects attacks by melee weapons and hand-to-hand.
	var/slowdown						// Negative numbers speed up, positive numbers slow down movement.
	var/haste							// If set to 1, the mob will be 'hasted', which makes it ignore slowdown and go really fast.
	var/evasion							// Positive numbers reduce the odds of being hit. Negative numbers increase the odds.
	var/bleeding_rate_percent			// Adjusts amount of blood lost when bleeding.
	var/accuracy						// Positive numbers makes hitting things with guns easier, negatives make it harder.
	var/accuracy_dispersion				// Positive numbers make gun firing cover a wider tile range, and therefore more inaccurate.  Negatives help negate dispersion penalties.
	var/metabolism_percent				// Adjusts the mob's metabolic rate, which affects reagent processing.  Won't affect mobs without reagent processing.
	var/icon_scale_x_percent			// Makes the holder's icon get scaled wider or thinner.
	var/icon_scale_y_percent			// Makes the holder's icon get scaled taller or shorter.
	var/attack_speed_percent			// Makes the holder's 'attack speed' (click delay) shorter or longer.
	var/pain_immunity					// Makes the holder not care about pain while this is on. Only really useful to human mobs.
	var/pulse_modifier					// Modifier for pulse, will be rounded on application, then added to the normal 'pulse' multiplier which ranges between 0 and 5 normally. Only applied if they're living.
	var/pulse_set_level					// Positive number. If this is non-null, it will hard-set the pulse level to this. Pulse ranges from 0 to 5 normally.
	var/emp_modifier					// Added to the EMP strength, which is an inverse scale from 1 to 4, with 1 being the strongest EMP. 5 is a nullification.
	var/explosion_modifier				// Added to the bomb strength, which is an inverse scale from 1 to 3, with 1 being gibstrength. 4 is a nullification.

	// Note that these are combined with the mob's real armor values additatively. You can also omit specific armor types.
	var/list/armor_percent = null		// List of armor values to add to the holder when doing armor calculations. This is for percentage based armor. E.g. 50 = half damage.
	var/list/armor_flat = null			// Same as above but only for flat armor calculations. E.g. 5 = 5 less damage (this comes after percentage).
	// Unlike armor, this is multiplicative. Two 50% protection modifiers will be combined into 75% protection (assuming no base protection on the mob).
	var/heat_protection = null			// Modifies how 'heat' protection is calculated, like wearing a firesuit. 1 = full protection.
	var/cold_protection = null			// Ditto, but for cold, like wearing a winter coat.
	var/siemens_coefficient = null		// Similar to above two vars but 0 = full protection, to be consistant with siemens numbers everywhere else.

	var/vision_flags					// Vision flags to add to the mob. SEE_MOB, SEE_OBJ, etc.

/datum/modifier/New(var/new_holder, var/new_origin)
	holder = new_holder
	if(new_origin)
		origin = weakref(new_origin)
	else // We assume the holder caused the modifier if not told otherwise.
		origin = weakref(holder)
	..()

// Checks if the modifier should be allowed to be applied to the mob before attaching it.
// Override for special criteria, e.g. forbidding robots from receiving it.
/datum/modifier/proc/can_apply(var/mob/living/L, var/suppress_output = FALSE)
	return TRUE

// Checks to see if this datum should continue existing.
/datum/modifier/proc/check_if_valid()
	if(expire_at && expire_at < world.time) // Is our time up?
		src.expire()

/datum/modifier/proc/expire(var/silent = FALSE)
	if(on_expired_text && !silent)
		to_chat(holder, on_expired_text)
	on_expire()
	holder.modifiers.Remove(src)
	if(mob_overlay_state) // We do this after removing ourselves from the list so that the overlay won't remain.
		holder.update_modifier_visuals()
	if(icon_scale_x_percent || icon_scale_y_percent) // Correct the scaling.
		holder.SetTransform()
	if(client_color)
		holder.update_client_color()
	if(LAZYLEN(filter_parameters))
		holder.remove_filter(REF(src))
	qdel(src)

// Override this for special effects when it gets added to the mob.
/datum/modifier/proc/on_applied()
	return

// Override this for special effects when it gets removed.
/datum/modifier/proc/on_expire()
	return

// Called every Life() tick.  Override for special behaviour.
/datum/modifier/proc/tick()
	return

/mob/living
	var/list/modifiers = list() // A list of modifier datums, which can adjust certain mob numbers.

/mob/living/Destroy()
	remove_all_modifiers(TRUE)
	return ..()

// Called by Life().
/mob/living/proc/handle_modifiers()
	if(!length(modifiers)) // No work to do.
		return
	// Get rid of anything we shouldn't have.
	for(var/datum/modifier/M in modifiers)
		M.check_if_valid()
	// Remaining modifiers will now receive a tick().  This is in a second loop for safety in order to not tick() an expired modifier.
	for(var/datum/modifier/M in modifiers)
		M.tick()

// Call this to add a modifier to a mob. First argument is the modifier type you want, second is how long it should last, in ticks.
// Third argument is the 'source' of the modifier, if it's from someone else.  If null, it will default to the mob being applied to.
// The SECONDS/MINUTES macro is very helpful for this.  E.g. M.add_modifier(/datum/modifier/example, 5 MINUTES)
// The fourth argument is a boolean to suppress failure messages, set it to true if the modifier is repeatedly applied (as chem-based modifiers are) to prevent chat-spam
/mob/living/proc/add_modifier(var/modifier_type, var/expire_at = null, var/mob/living/origin = null, var/suppress_failure = FALSE)
	// First, check if the mob already has this modifier.
	for(var/datum/modifier/M in modifiers)
		if(ispath(modifier_type, M))
			switch(M.stacks)
				if(MODIFIER_STACK_FORBID)
					return // Stop here.
				if(MODIFIER_STACK_ALLOWED)
					break // No point checking anymore.
				if(MODIFIER_STACK_EXTEND)
					// Not allow to add a second instance, but we can try to prolong the first instance.
					if(expire_at && world.time + expire_at > M.expire_at)
						M.expire_at = world.time + expire_at
					return

	// If we're at this point, the mob doesn't already have it, or it does but stacking is allowed.
	var/datum/modifier/mod = new modifier_type(src, origin)
	if(!mod.can_apply(src, suppress_failure))
		qdel(mod)
		return
	if(expire_at)
		mod.expire_at = world.time + expire_at
	if(mod.on_created_text)
		to_chat(src, mod.on_created_text)
	modifiers.Add(mod)
	mod.on_applied()
	if(mod.mob_overlay_state)
		update_modifier_visuals()
	if(mod.icon_scale_x_percent || mod.icon_scale_y_percent)
		SetTransform()
	if(mod.client_color)
		update_client_color()
	if(LAZYLEN(mod.filter_parameters))
		add_filter(REF(mod), mod.filter_priority, mod.filter_parameters)
		mod.filter_instance = get_filter(REF(mod))

	return mod

// Removes a specific instance of modifier
/mob/living/proc/remove_specific_modifier(var/datum/modifier/M, var/silent = FALSE)
	M.expire(silent)

// Removes one modifier of a type
/mob/living/proc/remove_a_modifier_of_type(var/modifier_type, var/silent = FALSE)
	for(var/datum/modifier/M in modifiers)
		if(ispath(M.type, modifier_type))
			M.expire(silent)
			break

// Removes all modifiers of a type
/mob/living/proc/remove_modifiers_of_type(var/modifier_type, var/silent = FALSE)
	for(var/datum/modifier/M in modifiers)
		if(ispath(M.type, modifier_type))
			M.expire(silent)

// Removes all modifiers, useful if the mob's being deleted
/mob/living/proc/remove_all_modifiers(var/silent = FALSE)
	for(var/datum/modifier/M in modifiers)
		M.expire(silent)

// Checks if the mob has a modifier type.
/mob/living/proc/has_modifier_of_type(var/modifier_type)
	return get_modifier_of_type(modifier_type) ? TRUE : FALSE

// Gets the first instance of a specific modifier type or subtype.
/mob/living/proc/get_modifier_of_type(var/modifier_type)
	for(var/datum/modifier/M in modifiers)
		if(istype(M, modifier_type))
			return M
	return null

// This displays the actual 'numbers' that a modifier is doing.  Should only be shown in OOC contexts.
// When adding new effects, be sure to update this as well.
/datum/modifier/proc/describe_modifier_effects()
	var/list/effects = list()
	if(!isnull(max_health_flat))
		effects += "You [max_health_flat > 0 ? "gain" : "lose"] [abs(max_health_flat)] maximum health."
	if(!isnull(max_health_percent))
		effects += "You [max_health_percent > 1.0 ? "gain" : "lose"] [multipler_to_percentage(max_health_percent, TRUE)] maximum health."

	if(!isnull(disable_duration_percent))
		effects += "Disabling effects on you last [multipler_to_percentage(disable_duration_percent, TRUE)] [disable_duration_percent > 1.0 ? "longer" : "shorter"]"

	if(!isnull(incoming_damage_percent))
		effects += "You take [multipler_to_percentage(incoming_damage_percent, TRUE)] [incoming_damage_percent > 1.0 ? "more" : "less"] damage."
	if(!isnull(incoming_brute_damage_percent))
		effects += "You take [multipler_to_percentage(incoming_brute_damage_percent, TRUE)] [incoming_brute_damage_percent > 1.0 ? "more" : "less"] brute damage."
	if(!isnull(incoming_fire_damage_percent))
		effects += "You take [multipler_to_percentage(incoming_fire_damage_percent, TRUE)] [incoming_fire_damage_percent > 1.0 ? "more" : "less"] fire damage."
	if(!isnull(incoming_tox_damage_percent))
		effects += "You take [multipler_to_percentage(incoming_tox_damage_percent, TRUE)] [incoming_tox_damage_percent > 1.0 ? "more" : "less"] toxin damage."
	if(!isnull(incoming_oxy_damage_percent))
		effects += "You take [multipler_to_percentage(incoming_oxy_damage_percent, TRUE)] [incoming_oxy_damage_percent > 1.0 ? "more" : "less"] oxy damage."
	if(!isnull(incoming_clone_damage_percent))
		effects += "You take [multipler_to_percentage(incoming_clone_damage_percent, TRUE)] [incoming_clone_damage_percent > 1.0 ? "more" : "less"] clone damage."
	if(!isnull(incoming_hal_damage_percent))
		effects += "You take [multipler_to_percentage(incoming_hal_damage_percent, TRUE)] [incoming_hal_damage_percent > 1.0 ? "more" : "less"] agony damage."

	if(!isnull(incoming_healing_percent))
		effects += "Healing applied to you is [multipler_to_percentage(incoming_healing_percent, TRUE)] [incoming_healing_percent > 1.0 ? "stronger" : "weaker"]."

	if(!isnull(outgoing_melee_damage_percent))
		effects += "Damage you do with melee weapons and unarmed combat is [multipler_to_percentage(outgoing_melee_damage_percent, TRUE)] \
		[outgoing_melee_damage_percent > 1.0 ? "higher" : "lower"]."

	if(!isnull(slowdown))
		effects += "[slowdown > 0 ? "lose" : "gain"] [slowdown] slowdown."

	if(!isnull(haste))
		effects += "You move at maximum speed, and cannot be slowed by any means."

	if(!isnull(evasion))
		effects += "You are [abs(evasion)]% [evasion > 0 ? "harder" : "easier"] to hit with weapons."

	if(!isnull(bleeding_rate_percent))
		effects += "You bleed [multipler_to_percentage(bleeding_rate_percent, TRUE)] [bleeding_rate_percent > 1.0 ? "faster" : "slower"]."

	if(!isnull(accuracy))
		effects += "It is [abs(accuracy)]% [accuracy > 0 ? "easier" : "harder"] for you to hit someone with a ranged weapon."

	if(!isnull(accuracy_dispersion))
		effects += "Projectiles you fire are [accuracy_dispersion > 0 ? "more" : "less"] likely to stray from your intended target."

	if(!isnull(metabolism_percent))
		effects += "Your metabolism is [metabolism_percent > 1.0 ? "faster" : "slower"], \
		causing reagents in your body to process, and hunger to occur [multipler_to_percentage(metabolism_percent, TRUE)] [metabolism_percent > 1.0 ? "faster" : "slower"]."

	if(!isnull(icon_scale_x_percent))
		effects += "Your appearance is [multipler_to_percentage(icon_scale_x_percent, TRUE)] [icon_scale_x_percent > 1 ? "wider" : "thinner"]."

	if(!isnull(icon_scale_y_percent))
		effects += "Your appearance is [multipler_to_percentage(icon_scale_y_percent, TRUE)] [icon_scale_y_percent > 1 ? "taller" : "shorter"]."

	if(!isnull(attack_speed_percent))
		effects += "The delay between attacking is [multipler_to_percentage(attack_speed_percent, TRUE)] [disable_duration_percent > 1.0 ? "longer" : "shorter"]."

	return jointext(effects, "<br>")



// Helper to format multiplers (e.g. 1.4) to percentages (like '40%')
/proc/multipler_to_percentage(var/multi, var/abs = FALSE)
	if(abs)
		return "[abs( ((multi - 1) * 100) )]%"
	return "[((multi - 1) * 100)]%"
