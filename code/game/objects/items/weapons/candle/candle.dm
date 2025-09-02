/obj/item/flame/candle
	name = "candle"
	desc = "A small pillar candle. Its specially-formulated fuel-oxidizer wax mixture allows continued combustion in airless environments."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle1"
	item_state = "candle1"
	w_class = ITEM_SIZE_TINY
	light_color = "#e09d37"
	throwforce = 1

	var/available_colours = list(COLOR_WHITE, COLOR_DARK_GRAY, COLOR_RED, COLOR_ORANGE, COLOR_YELLOW, COLOR_GREEN, COLOR_BLUE, COLOR_INDIGO, COLOR_VIOLET)
	var/wax
	var/last_lit
	var/icon_set = "candle"
	var/candle_range = CANDLE_LUM
	var/candle_power

/obj/item/flame/candle/Initialize()
	wax = rand(27 MINUTES, 33 MINUTES) / SSobj.wait // Enough for 27-33 minutes. 30 minutes on average, adjusted for subsystem tickrate.
	if(available_colours)
		color = pick(available_colours)
	. = ..()

/obj/item/flame/candle/on_update_icon()
	switch(wax)
		if(1500 to INFINITY)
			icon_state = "[icon_set]1"
		if(800 to 1500)
			icon_state = "[icon_set]2"
		else
			icon_state = "[icon_set]3"

	if(lit != last_lit)
		last_lit = lit
		ClearOverlays()
		if(lit)
			AddOverlays(overlay_image(icon, "[icon_state]_lit", flags=RESET_COLOR))

/obj/item/flame/candle/use_tool(obj/item/tool, mob/living/user, list/click_params)
	// Light the candle
	if (isFlameOrHeatSource(tool))
		if (lit)
			USE_FEEDBACK_FAILURE("\The [src] is already lit.")
			return TRUE
		light()
		user.visible_message(
			SPAN_NOTICE("\The [user] lights \a [src] with \a [tool]."),
			SPAN_NOTICE("You light \the [src] with \the [tool].")
		)
		return TRUE

	return ..()

/obj/item/flame/candle/proc/light()
	if (!lit)
		lit = TRUE
		set_light(candle_range, candle_power)
		START_PROCESSING(SSobj, src)

/obj/item/flame/candle/Process()
	if(!lit)
		return
	wax--
	if(!wax)
		var/obj/item/trash/candle/C = new(loc)
		C.color = color
		qdel(src)
		return
	update_icon()
	if(isturf(loc)) //start a fire if possible
		var/turf/T = loc
		T.hotspot_expose(700)

/obj/item/flame/candle/attack_self(mob/user as mob)
	if(lit)
		lit = 0
		update_icon()
		set_light(0)
		remove_extension(src, /datum/extension/scent)

/// Allows player to light a flammable mob with lit candle.
/obj/item/flame/candle/use_before(mob/living/fiery, mob/living/carbon/user)
	. = FALSE
	if (!istype(fiery))
		return FALSE
	if (lit)
		var/turf/location = get_turf(user)
		var/mob/living/burn = fiery
		if(isliving(fiery) && burn.fire_stacks > 0)
			user.visible_message(
				SPAN_WARNING("\The [user] sets \the [fiery] on fire with \a [src]!"),
				SPAN_WARNING("You set \the [fiery] on fire!")
			)
			fiery.IgniteMob()
			/// admin logs
			if(ismob(user))
				var/attacker_message = "Ignited using \a [src] (lit)"
				var/victim_message = "Was ignited with \a [src] (lit)"
				var/admin_message = "used \a [src] (lit) to ignite"
				admin_attack_log(user, fiery, attacker_message, victim_message, admin_message)
			else
				admin_victim_log(fiery, "was ignited by an <b> UNKNOWN SUBJECT (No longer exists)</b> using \a [src]")
			if (istype(fiery.wear_mask, /obj/item/clothing/mask/smokable/cigarette) && user.zone_sel.selecting == BP_MOUTH)
				var/obj/item/clothing/mask/smokable/cigarette/cig = fiery.wear_mask
				if (fiery == user)
					cig.use_tool(src, user)
				else
					cig.light(SPAN_NOTICE("[user] holds the [name] out for [fiery], and lights the [cig.name]."))
				return TRUE
		if(isturf(location))
			location.hotspot_expose(700)
	return
/// Ignites flammable mobs if you throw a lit candle at them
/obj/item/flame/candle/throw_impact(atom/hit_atom, datum/thrownthing/igniter)
	if (isliving(hit_atom))
		var/mob/living/victim = hit_atom
		var/miss_chance = max(15*(igniter.dist_travelled-2),0)
		if (!lit)
			return ..()
		/// Overwrites the hitby miss outcome, when it's lit.
		if (prob(miss_chance))
			visible_message(
				SPAN_NOTICE("\The [src] misses [victim] narrowly!")
			)
			/// admin log when there is intention, but a miss happens
			if (ismob(igniter.thrower))
				var/attacker_attempt = "Attempted to ignite using \a [src] (lit)"
				var/victim_attempt = "Was almost ignited with \a [src] (lit)"
				var/admin_attempt = "tried to use \a [src] (lit) to ignite"
				admin_attack_log(igniter.thrower, victim, attacker_attempt, victim_attempt, admin_attempt)
			else
				admin_victim_log(victim, "was almost ignited by an <b> UNKNOWN SUBJECT (No longer exists)</b> using \a [src]")
		else
			/// make it deal burn damage based on throwforce and speed
			var/dtype = DAMAGE_BURN
			var/throw_damage = src.throwforce*(src.throw_speed/THROWFORCE_SPEED_DIVISOR)
			igniter.thrower.visible_message(
				SPAN_WARNING("\The [igniter.thrower] throws \a lit [src] at \the [victim]!"),
				SPAN_WARNING("You throw \a lit [src] at \the [victim]!")
			)
			victim.IgniteMob()
			victim.apply_damage(damage = throw_damage, damagetype = dtype, used_weapon = igniter)
			/** admin logs
			* If victim is flammable, they'll be set on fire */
			if (victim.on_fire)
				if (ismob(igniter.thrower))
					var/attacker_ignited = "Ignited using \a [src] (lit)"
					var/victim_ignited = "Was ignited with \a [src] (lit)"
					var/admin_ignited = "used \a [src] (lit) to ignite"
					admin_attack_log(igniter.thrower, victim, attacker_ignited, victim_ignited, admin_ignited)
				else
					admin_victim_log(victim, "was ignited by an <b> UNKNOWN SUBJECT (No longer exists)</b> using \a [src]")
			/// But what if it fails/victim isn't flammable?
			else
				if (ismob(igniter.thrower))
					var/attacker_unblazed = "Failed to be ignited with \a [src] (lit)"
					var/victim_unblazed = "Was hit with \a [src] (lit) but didn't ignite"
					var/admin_unblazed = "used \a [src] (lit) to ignite"
					admin_attack_log(igniter.thrower, victim, attacker_unblazed, victim_unblazed, admin_unblazed)
/obj/item/storage/candle_box
	name = "candle pack"
	desc = "A pack of unscented candles in a variety of colours."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candlebox"
	throwforce = 2
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 7
	slot_flags = SLOT_BELT

	startswith = list(/obj/item/flame/candle = 7)
