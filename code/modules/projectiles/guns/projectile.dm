/obj/item/gun/projectile
	name = "gun"
	desc = "A gun that fires bullets."
	icon = 'icons/obj/guns/pistol.dmi'
	icon_state = "secguncomp"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	w_class = ITEM_SIZE_NORMAL
	matter = list(MATERIAL_STEEL = 1000)
	screen_shake = 1
	space_recoil = 1
	combustion = TRUE
	waterproof = TRUE

	/// String (One of `CALIBER_*`). Determines which casings will fit.
	var/caliber = CALIBER_PISTOL
	var/handle_casings = EJECT_CASINGS	//determines how spent casings should be handled
	var/load_method = SINGLE_CASING|SPEEDLOADER //1 = Single shells, 2 = box or quick loader, 4 = magazine
	var/obj/item/ammo_casing/chambered = null

	//For SINGLE_CASING or SPEEDLOADER guns
	var/max_shells = 0			//the number of casings that will fit inside
	var/ammo_type = null		//the type of ammo that the gun comes preloaded with
	var/list/loaded = list()	//stored ammo
	var/starts_loaded = 1		//whether the gun starts loaded or not, can be overridden for guns crafted in-game
	var/load_sound = 'sound/weapons/guns/interaction/bullet_insert.ogg'
	var/recentload = 0		// artificially limits how fast a gun can be loaded

	//For CYCLE_CASING guns
	var/chamber_offset = 0 //how many empty chambers in the cylinder until you hit a round

	//For MAGAZINE guns
	var/magazine_type = null	//the type of magazine that the gun comes preloaded with
	var/obj/item/ammo_magazine/ammo_magazine = null //stored magazine
	/// LAZYLIST (Types of `/obj/item/ammo_magazine`). Magazine types that may be loaded.
	var/list/allowed_magazines
	/// LAZYLIST (Types of `/obj/item/ammo_magazine`). Magazine types that may NOT be loaded. Overrides `allowed_magazines`.
	var/list/banned_magazines
	/// If the magazine should automatically eject itself when empty.
	var/auto_eject = FALSE
	var/auto_eject_sound = null
	var/mag_insert_sound = 'sound/weapons/guns/interaction/pistol_magin.ogg'
	var/mag_remove_sound = 'sound/weapons/guns/interaction/pistol_magout.ogg'
	/// Whether or not we can tactical/speed reload.
	var/can_special_reload = TRUE

	/// Whether this gun is jammed
	var/is_jammed = FALSE
	/// Chance it jams on fire. 0 to 100.
	var/jam_chance = 0
	var/bolt_open = FALSE
	/// Whether or not the weapon fires from a closed bolt. Closed bolt means an extra round in the chamber.
	var/fire_closed_bolt = TRUE
	/// Whether or not this weapon automatically holds its bolt open when emptied.
	var/hold_open = TRUE
	/// Prevents spamming.
	var/recentrack = 0
	var/rackdelay = 5
	/// Delay for click-racking. Scales with level. Generally used for shotguns/boltloaders.
	var/autorackdelay = 1
	var/racksound = 'sound/weapons/flipblade.ogg'
	var/selectorsound = 'sound/weapons/flipblade.ogg'
	/// Whether a gun with multiple chambers can dump all its rounds at once (e.g a revolver)
	var/allow_dump = FALSE
	//TODO generalize ammo icon states for guns
	//var/magazine_states = 0
	//var/list/icon_keys = list()		//keys
	//var/list/ammo_states = list()	//values


/obj/item/gun/projectile/Initialize()
	. = ..()
	if (starts_loaded)
		if(ispath(ammo_type) && (load_method & (SINGLE_CASING|SPEEDLOADER)))
			for(var/i in 1 to max_shells)
				loaded += new ammo_type(src)
		if(ispath(magazine_type) && (load_method & MAGAZINE))
			ammo_magazine = new magazine_type(src)
	update_icon()


/obj/item/gun/projectile/consume_next_projectile()
	if (is_jammed)
		return
	if (fire_closed_bolt && chambered) //locked and loaded
		return chambered.BB
	//get the next casing
	if (!fire_closed_bolt)
		close_bolt(FALSE)
	if (handle_casings == CYCLE_CASINGS)
		if (prob(jam_chance))
			return //failure to fire malfunction
		var/obj/item/ammo_casing/casing
		if (length(loaded))
			casing = loaded[1]
		if (ammo_magazine && length(ammo_magazine.stored_ammo))
			casing = ammo_magazine.stored_ammo[1]
		if (casing)
			return casing.BB
		else
			return
	if (chambered)
		return chambered.BB
	return


/obj/item/gun/projectile/handle_post_fire()
	..()

	if (handle_casings == CYCLE_CASINGS) //technically incorrect, revolvers cycle before firing, but this makes things more intuitive
		process_chambered(FALSE)
	if (!chambered)
		return
	if (!chambered.BB)
		return
	chambered.expend()
	if (handle_casings != HOLD_CASINGS)
		process_chambered(FALSE)


/obj/item/gun/projectile/process_point_blank(obj/projectile, mob/user, atom/target)
	..()
	if(chambered && ishuman(target))
		var/mob/living/carbon/human/H = target
		var/zone = BP_CHEST
		if(user && user.zone_sel)
			zone = user.zone_sel.selecting
		var/obj/item/organ/external/E = H.get_organ(zone)
		if(E)
			chambered.put_residue_on(E)
			H.apply_damage(3, DAMAGE_BURN, used_weapon = "Gunpowder Burn", given_organ = E)


/obj/item/gun/projectile/handle_click_empty()
	if(!ismob(loc))
		return

	var/mob/user = loc

	if (handle_casings == CYCLE_CASINGS)
		process_chambered(FALSE)
		return ..()

	if (!user.skill_check(SKILL_WEAPONS, SKILL_TRAINED))
		return ..()

	if (handle_casings == HOLD_CASINGS)
		autorackdelay = 6 - user.skillset.get_value(SKILL_WEAPONS)

	if (is_held_twohanded(user) || user.skill_check(SKILL_WEAPONS, SKILL_MASTER) || (bolt_open && hold_open)) //don't risk automatically dropping the gun on the floor
		attack_self(user) //tap, rack, bang

	..()


/obj/item/gun/projectile/proc/penalty_check()
	var/underwater = submerged()
	var/unskilled = 0
	var/mismatched = !istype(ammo_magazine, magazine_type)
	if (ishuman(loc))
		var/mob/living/carbon/human/user = loc
		unskilled = user.get_skill_value(SKILL_WEAPONS) == SKILL_UNSKILLED
	return underwater*20 + unskilled*5 + mismatched*3


/obj/item/gun/projectile/proc/open_bolt(manual)
	var/obj/item/ammo_casing/ejected = null
	var/total_chance = jam_chance + penalty_check()
	if (chambered && !bolt_open && !is_jammed)
		if (!prob(total_chance/2)) //"double feed" aka failure to extract malfunction
			chambered.dropInto(get_turf(loc))
			if (!manual)
				chambered.throw_at(get_ranged_target_turf(get_turf(src),turn(loc.dir,270),1), rand(0,1), 5)
			if (length(chambered.fall_sounds))
				playsound(loc, pick(chambered.fall_sounds), 50, 1)
			ejected = chambered
			chambered = null
			check_autoeject()
	bolt_open = TRUE
	update_icon()
	return ejected


/obj/item/gun/projectile/proc/close_bolt(manual)
	if (is_jammed)
		return
	var/total_chance = jam_chance + penalty_check()
	if (hold_open)
		if (prob(total_chance)) // "out of battery" aka failure to feed malfunction.
			return
		if (ammo_magazine && !length(ammo_magazine.stored_ammo) && !manual) // Bolt hold open on empty.
			return
	if (bolt_open)
		if (chambered)
			if (((load_method != MAGAZINE) && length(loaded))) // Double feed check.
				is_jammed = TRUE
				return
			if ((ammo_magazine && length(ammo_magazine.stored_ammo)))
				is_jammed = TRUE
				return
		if (!prob(total_chance)) // "stovepipe" aka failure to feed malfunction.
			if (ammo_magazine && length(ammo_magazine.stored_ammo)) // Attempt to load next casing.
				chambered = ammo_magazine.stored_ammo[length(ammo_magazine.stored_ammo)]
				ammo_magazine.stored_ammo -= chambered
			if (length(loaded))
				chambered = loaded[1]
				loaded -= chambered
	bolt_open = FALSE
	update_icon()
	return TRUE


/// Manual should be TRUE if the operator is running the action by hand, FALSE otherwise.
/obj/item/gun/projectile/proc/process_chambered(manual)
	switch(handle_casings)
		if (CYCLE_CASINGS) // Cycle the casing back to the end.
			chamber_offset = 0
			var/obj/item/ammo_casing/cartridge
			var/obj/item/ammo_casing/new_round
			for (var/entry in loaded) // Clean up.
				if (!entry)
					loaded -= entry
			if (ammo_magazine)
				for (var/entry in ammo_magazine.stored_ammo)
					if (!entry)
						ammo_magazine.stored_ammo -= entry
			if (ammo_magazine && length(ammo_magazine.stored_ammo))
				cartridge = ammo_magazine.stored_ammo[1]
				ammo_magazine.stored_ammo -= cartridge
				ammo_magazine.stored_ammo += cartridge
				new_round = ammo_magazine.stored_ammo[1]
			else if (length(loaded))
				cartridge = loaded[1]
				loaded -= cartridge
				loaded += cartridge
				new_round = loaded[1]
			if (cartridge && !manual)
				cartridge.expend()
			if (manual)
				if (max_shells > 1)
					to_chat(loc, SPAN_NOTICE("You cycle \the [src]'s chambers. \The [new_round] is now next to fire."))
		else // Eject casing onto ground.
			if (!chambered && !manual) // Chamber is empty and the action isn't being run manually, so gun can't cycle on its own.
				return
			if (!manual)
				open_bolt(manual)
				if (fire_closed_bolt)
					close_bolt(manual)
			else
				if (ismob(loc))
					var/mob/user = loc // If we have an operator, we should probably start thinking about whether they're using one or two hands.
					if (hold_open && (handle_casings == EJECT_CASINGS) && bolt_open) // Hit the bolt release, you can do it one-handed and fast.
						to_chat(user, SPAN_NOTICE("You hit the bolt release on \the [src]."))
						close_bolt(FALSE)
					else if (!(world.time >= recentrack + (rackdelay * autorackdelay)))
						to_chat(user, SPAN_WARNING("You cannot rack \the [src] yet!"))
						autorackdelay = 1 // Reset auto-rack delay.
						return
					if (!is_held_twohanded(user))
						var/fail_chance = user.skill_fail_chance(SKILL_WEAPONS, 90, SKILL_EXPERIENCED, 0.25)
						var/drop_chance = user.skill_fail_chance(SKILL_WEAPONS, 50, SKILL_EXPERIENCED, 0.5)

						if (!fail_chance)
							user.visible_message(
								SPAN_NOTICE("\The [user] racks \the [src] with one hand."),
								SPAN_NOTICE("You manage to rack \the [src] with one hand.")
							)
							open_bolt(manual)
							close_bolt(handle_casings != EJECT_CASINGS)
						else if (prob(fail_chance))
							if (prob(drop_chance) && user.unEquip(src, user.loc))
								user.visible_message(
									SPAN_WARNING("\The [user] attempts to rack \the [src], but it falls out of their hands!"),
									SPAN_WARNING("You attempt to rack \the [src], but it falls out of your hands!")
								)
							else
								user.visible_message(
									SPAN_WARNING("\The [user] fails to rack \the [src]!"),
									SPAN_WARNING("You fail to rack \the [src]!")
								)
						else
							user.visible_message(
								SPAN_NOTICE("\The [user] manages to akwardly rack \the [src] with one hand."),
								SPAN_NOTICE("You manage to awkwardly rack \the [src] with one hand.")
							)
							open_bolt(manual)
							close_bolt(handle_casings != EJECT_CASINGS)
					else
						user.visible_message(
							SPAN_NOTICE("\The [user] racks \the [src]."),
							SPAN_NOTICE("You rack \the [src].")
						)
						open_bolt(manual)
						if (fire_closed_bolt)
							close_bolt(handle_casings != EJECT_CASINGS)

					recentrack = world.time
					autorackdelay = 1 // Reset auto-rack delay.
					playsound(loc, racksound, 60, TRUE)

	update_icon()

#define EXP_TAC_RELOAD 1 SECOND
#define PROF_TAC_RELOAD 0.5 SECONDS
#define EXP_SPD_RELOAD 0.5 SECONDS
#define PROF_SPD_RELOAD 0.25 SECONDS


/obj/item/gun/projectile/proc/check_autoeject()
	var/mob/user = null
	if(ismob(loc))
		user = loc
	if(auto_eject && ammo_magazine && ammo_magazine.stored_ammo && !length(ammo_magazine.stored_ammo))
		ammo_magazine.dropInto(user.loc)
		if(!user)
			return
		user.visible_message(
			"[ammo_magazine] falls out and clatters on the floor!",
			SPAN_NOTICE("[ammo_magazine] falls out and clatters on the floor!")
			)
		if(auto_eject_sound)
			playsound(user, auto_eject_sound, 40, 1)
		ammo_magazine.update_icon()
		ammo_magazine = null
		update_icon() //make sure to do this after unsetting ammo_magazine
		return TRUE
	return


/**
 * Attempts to load an item into `src`, depending on the type of thing being loaded and `load_method`.
 *
 * **Parameters**:
 * - `ammo` - The item to attempt to load.
 * - `user` - The mob attempting to load `ammo`.
 *
 * Returns boolean. `TRUE` if the interaction was handled, `FALSE` otherwise.
 */

/obj/item/gun/projectile/proc/load_ammo(obj/item/ammo, mob/user)
	// Magazines.
	if (istype(ammo, /obj/item/ammo_magazine))
		var/obj/item/ammo_magazine/magazine = ammo
		if (caliber != magazine.caliber)
			USE_FEEDBACK_FAILURE("\The [ammo]'s caliber is not compatible with \the [src].")
			return TRUE
		if (!GET_FLAGS(load_method, magazine.mag_type))
			USE_FEEDBACK_FAILURE("\The [ammo] can't be loaded in \the [src].")
			return TRUE

		switch (magazine.mag_type)
			if (MAGAZINE)
				if (!is_type_in_list(ammo, allowed_magazines) || is_type_in_list(ammo, banned_magazines))
					USE_FEEDBACK_FAILURE("\The [ammo] doesn't fit in \the [src].")
					return TRUE

				// Tactical/speed reload checks.
				if (ammo_magazine)
					if ((user.a_intent in list(I_HELP, I_DISARM)) || !user.skill_check(SKILL_WEAPONS, SKILL_EXPERIENCED))
						USE_FEEDBACK_FAILURE("\The [src] already has \a [ammo_magazine] loaded.")
						return TRUE
					if (!can_special_reload)
						USE_FEEDBACK_FAILURE("\The [src] can't be tactical or speed reloaded.")
						return TRUE
					if (!user.canUnEquip(ammo, src))
						return TRUE

					var/obj/item/prior_magazine = ammo_magazine
					var/prof_reload_time = 0
					var/exp_reload_time = 0
					var/drop_magazine = FALSE
					switch (user.a_intent)
						if (I_GRAB) // Tactical Reloading.
							prof_reload_time = PROF_TAC_RELOAD
							exp_reload_time = EXP_TAC_RELOAD

						if (I_HURT) // Speed Reloading.
							prof_reload_time = PROF_SPD_RELOAD
							exp_reload_time = EXP_SPD_RELOAD
							drop_magazine = TRUE

					var/do_after_time = user.get_skill_value(SKILL_WEAPONS) == SKILL_MASTER ? prof_reload_time : exp_reload_time
					if (!do_after(user, do_after_time, src, DO_DEFAULT | DO_BOTH_UNIQUE_ACT))
						return TRUE
					var/master_check = user.get_skill_value(SKILL_WEAPONS) == SKILL_MASTER
					if (!user.use_sanity_check(src, ammo, (master_check & SANITY_CHECK_TOOL_IN_HAND) | SANITY_CHECK_BOTH_ADJACENT))
						return TRUE
					if (ammo_magazine != prior_magazine)
						USE_FEEDBACK_FAILURE("\The [src] is no longer holding [QDELETED(prior_magazine) ? "the magazine" : "\the [prior_magazine]"] you were swapping out.")
						return TRUE
					if (!user.unEquip(ammo, src))
						return TRUE

					playsound(src, mag_insert_sound, 75, TRUE)
					if (drop_magazine)
						ammo_magazine.dropInto(user.loc)
					else
						user.put_in_hands(ammo_magazine)
					ammo_magazine.update_icon()
					ammo_magazine = ammo
					ammo.update_icon()
					update_icon()

					user.visible_message(
						SPAN_NOTICE("\The [user] reloads \a [src] with \a [ammo]."),
						SPAN_NOTICE("You swap \the [src]'s [ammo_magazine.name] with \a [ammo].")
					)
					return TRUE

				// Normal reload
				if (!user.unEquip(ammo, src))
					return TRUE
				playsound(src, mag_insert_sound, 50, TRUE)
				ammo_magazine = ammo
				ammo.update_icon()
				update_icon()
				user.visible_message(
					SPAN_NOTICE("\The [user] loads \a [src] with \a [ammo]."),
					SPAN_NOTICE("You load \the [src] with \the [ammo].")
				)
				return TRUE

			if (SPEEDLOADER)
				if (length(loaded) >= max_shells) {
					USE_FEEDBACK_FAILURE("\The [src] is full of ammunition.")
					return TRUE
				}
				var/count = 0
				for (var/obj/item/ammo_casing/casing in magazine.stored_ammo)
					if (length(loaded) >= max_shells)
						break
					if (casing.caliber == caliber)
						casing.forceMove(src)
						loaded += casing
						magazine.stored_ammo -= casing
						count++
				if (!count)
					USE_FEEDBACK_FAILURE("The casings stored in \the [ammo] are not compatible with \the [src].")
					return TRUE
				playsound(src, 'sound/weapons/empty.ogg', 50, TRUE)
				ammo.update_icon()
				update_icon()
				user.visible_message(
					SPAN_NOTICE("\The [user] loads \a [src] with \a [ammo]."),
					SPAN_NOTICE("You load [count] round\s into \the [src] with \the [ammo].")
				)
				return TRUE

	// Casings.
	if (istype(ammo, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/casing = ammo
		if (!GET_FLAGS(load_method, SINGLE_CASING) && !GET_FLAGS(load_method, MAGAZINE))
			USE_FEEDBACK_FAILURE("\The [src] cannot be loaded with single casings.")
			return TRUE
		if (caliber != casing.caliber)
			USE_FEEDBACK_FAILURE("\The [casing] does not fit in \the [src]'s chamber.")
			return TRUE
		if (length(loaded) >= max_shells)
			USE_FEEDBACK_FAILURE("\The [src] is full of ammo.")
			return TRUE
		if (!user.unEquip(ammo, src))
			return TRUE
		playsound(src, load_sound, 50, TRUE)
		loaded.Insert(1, ammo)
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] loads \a [casing] into \a [src]."),
			SPAN_NOTICE("You load \the [casing] into \the [src].")
		)
		return TRUE

	return FALSE


#undef EXP_TAC_RELOAD
#undef PROF_TAC_RELOAD
#undef EXP_SPD_RELOAD
#undef PROF_SPD_RELOAD


/**
 * Attempts to unload the gun.
 *
 * **Parameters**:
 * - `user` - The mob unloading the gun.
 * - `allow_dump` (Boolean, default `TRUE`) - If set and the gun accepts speed loaders, allows dumping rounds onto the floor.
 *
 * Has no return value.
 */

/obj/item/gun/projectile/proc/unload_ammo(mob/user)
	// Clear jams.
	if (is_jammed)
		if (handle_casings == HOLD_CASINGS && !bolt_open)
			USE_FEEDBACK_FAILURE("The bolt is closed.")
			return
		user.visible_message(
			SPAN_NOTICE("\The [user] struggles to unload [src]."),
			SPAN_NOTICE("You struggle to unload [src]")
		)
		if(!do_after(user, round((50/(user.get_skill_value(SKILL_WEAPONS))), 1), src, DO_DEFAULT | DO_BOTH_UNIQUE_ACT | DO_SHOW_PROGRESS))
			return
		is_jammed = FALSE

	// Eject magazine.
	if (ammo_magazine)
		user.put_in_hands(ammo_magazine)
		user.visible_message(
			SPAN_NOTICE("\The [user] ejects \a [ammo_magazine] from \a [src]."),
			SPAN_NOTICE("You eject \the [ammo_magazine] from \the [src].")
		)
		playsound(loc, mag_remove_sound, 50, 1)
		ammo_magazine.update_icon()
		ammo_magazine = null
		update_icon()
		return

	if (!length(loaded))
		USE_FEEDBACK_FAILURE("\The [src] has no ammunition to unload.")
		return

	// Unload single casings.
	if (GET_FLAGS(load_method, SINGLE_CASING))
		if (istype(src, /obj/item/gun/projectile/boltloader) && !bolt_open)
			USE_FEEDBACK_FAILURE("\The [src] is closed.")
			return
		var/obj/item/ammo_casing/casing = pop(loaded)
		user.put_in_hands(casing)
		user.visible_message(
			SPAN_NOTICE("\The [user] removes \a [casing] from \a [src]."),
			SPAN_NOTICE("You remove \a [casing] from \the [src].")
		)
		chambered = null
		update_icon()
		return

	// Dump everything on the floor.
	if (allow_dump && GET_FLAGS(load_method, SPEEDLOADER))
		var/count = 0
		var/turf/turf = get_turf(src)
		if (!turf)
			return
		for (var/obj/item/ammo_casing/casing in loaded)
			if (LAZYLEN(casing.fall_sounds))
				playsound(src, pick(casing.fall_sounds), 50, TRUE)
			casing.forceMove(turf)
			count++
		loaded.Cut()
		if (count)
			user.visible_message(
				SPAN_NOTICE("\The [user] dumps \a [src]'s casing[count > 1 ? "s" : null] on \the [turf]."),
				SPAN_NOTICE("You dump \the [src]'s casing[count > 1 ? "s" : null] on \the [turf].")
			)
		chambered = null
		update_icon()
		return


/obj/item/gun/projectile/use_before(atom/target, mob/living/user, click_parameters)
	if (istype(target, /obj/item/ammo_magazine) && target.loc == user)
		if (user.skill_check(SKILL_WEAPONS, SKILL_MASTER))
			if (one_hand_penalty < 3)
				return load_ammo(target, user)
	return ..()


/obj/item/gun/projectile/use_tool(obj/item/tool, mob/user, list/click_params)
	// Anything - Attempt to load ammo.
	if (load_ammo(tool, user))
		return TRUE

	return ..()


/obj/item/gun/projectile/attack_self(mob/user as mob)
	if (ammo_magazine)
		if (!length(ammo_magazine.stored_ammo) && !chambered)
			unload_ammo(user, allow_dump)

	process_chambered(TRUE)


/obj/item/gun/projectile/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		unload_ammo(user, allow_dump)
	else
		return ..()


/obj/item/gun/projectile/examine(mob/user)
	. = ..()
	if (is_jammed && user.skill_check(SKILL_WEAPONS, SKILL_BASIC))
		to_chat(user, SPAN_WARNING("It looks jammed."))
		if (user.skill_check(SKILL_WEAPONS, SKILL_EXPERIENCED))
			if (load_method & MAGAZINE)
				if (fire_closed_bolt)
					to_chat(user, SPAN_NOTICE("To unjam it, you'd have to pull out the magazine and eject the cartridge in the chamber by racking \the [src] a few times."))
				else
					to_chat(user, SPAN_NOTICE("To unjam it, you'd have to pull out the magazine and eject the cartridge in the chamber by pulling the trigger and racking \the [src]."))
			else
				if (fire_closed_bolt)
					to_chat(user, SPAN_NOTICE("To unjam it, pry out the cartridge in the chamber before racking \the [src]."))
				else
					to_chat(user, SPAN_NOTICE("To unjam it, pry out the cartridge in the chamber."))

	if (ammo_magazine)
		to_chat(user, "It has \a [ammo_magazine] loaded.")
	if (user.skill_check(SKILL_WEAPONS, SKILL_TRAINED))
		to_chat(user, "Has [getAmmo()] round\s remaining.")
	if (user.skill_check(SKILL_WEAPONS, SKILL_BASIC) && handle_casings != CYCLE_CASINGS) //Most guns that cycle casings don't have bolts. Please don't add one that does.
		if (user.skill_check(SKILL_WEAPONS, SKILL_EXPERIENCED))
			if (fire_closed_bolt)
				to_chat(user, "The bolt needs to be closed for this weapon to fire.")
			else
				to_chat(user, "The bolt needs to be open for this weapon to fire.")
		if (bolt_open)
			to_chat(user, "The bolt is open.")
		else
			to_chat(user, "The bolt is closed.")
	if(loc == user)
		if (user.skill_check(SKILL_WEAPONS, SKILL_BASIC))
			to_chat(user, "[src.DrawChamber()]")
		else
			user.visible_message(
				SPAN_NOTICE("\The [user] looks down the barrel of \the [src]."),
				SPAN_NOTICE("You look down the barrel of \the [src].")
				)


/obj/item/gun/projectile/proc/getAmmo()
	var/bullets = 0
	if(loaded)
		bullets += length(loaded)
	if(ammo_magazine && ammo_magazine.stored_ammo)
		bullets += length(ammo_magazine.stored_ammo)
	if(chambered && handle_casings != CYCLE_CASINGS)
		bullets += 1
	return bullets


/obj/item/gun/projectile/proc/DrawChamber()
	if (handle_casings == CYCLE_CASINGS)
		var/chambers = list()
		var/empty_chambers = 0
		while (chamber_offset > empty_chambers)
			chambers += "🌣"
			empty_chambers ++
		for (var/obj/item/ammo_casing/casing in loaded)
			if (casing.BB)
				chambers += "◉"
			else
				chambers += "◎"
		while (max_shells > length(chambers))
			chambers += "🌣"
			empty_chambers ++
		var/chamberlist = ""
		for (var/chamber in chambers)
			chamberlist += chamber
		return chamberlist
	else
		if (chambered)
			if (chambered.BB)
				return "◉"
			else
				return "◎"
		else
			return "🌣"

/* Unneeded -- so far.
//in case the weapon has firemodes and can't unload using attack_hand()
/obj/item/gun/projectile/verb/unload_gun()
	set name = "Unload Ammo"
	set category = "Object"
	set src in usr

	if(usr.stat || usr.restrained()) return

	unload_ammo(usr)
*/
