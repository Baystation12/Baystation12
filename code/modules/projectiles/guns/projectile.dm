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
	combustion = 1

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
	var/auto_eject = 0			//if the magazine should automatically eject itself when empty.
	var/auto_eject_sound = null
	var/mag_insert_sound = 'sound/weapons/guns/interaction/pistol_magin.ogg'
	var/mag_remove_sound = 'sound/weapons/guns/interaction/pistol_magout.ogg'
	var/can_special_reload = TRUE //Whether or not we can tactical/speed reload

	var/is_jammed = 0           //Whether this gun is jammed
	var/jam_chance = 0          //Chance it jams on fire
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
	if(!is_jammed && prob(jam_chance))
		src.visible_message(SPAN_DANGER("\The [src] jams!"))
		is_jammed = 1
		var/mob/user = loc
		if(istype(user))
			if(prob(user.skill_fail_chance(SKILL_WEAPONS, 100, SKILL_MASTER)))
				return null
			else
				to_chat(user, SPAN_NOTICE("You reflexively clear the jam on \the [src]."))
				is_jammed = 0
				playsound(src.loc, 'sound/weapons/flipblade.ogg', 50, 1)
	if(is_jammed)
		return null
	//get the next casing
	if(length(loaded))
		chambered = loaded[1] //load next casing.
		if(handle_casings != HOLD_CASINGS)
			loaded -= chambered
	else if(ammo_magazine && length(ammo_magazine.stored_ammo))
		chambered = ammo_magazine.stored_ammo[length(ammo_magazine.stored_ammo)]
		if(handle_casings != HOLD_CASINGS)
			ammo_magazine.stored_ammo -= chambered

	if (chambered)
		return chambered.BB
	return null

/obj/item/gun/projectile/handle_post_fire()
	..()
	if(chambered)
		chambered.expend()
		process_chambered()

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
	..()
	process_chambered()

/obj/item/gun/projectile/proc/process_chambered()
	if (!chambered) return

	switch(handle_casings)
		if(EJECT_CASINGS) //eject casing onto ground.
			chambered.dropInto(loc)
			chambered.throw_at(get_ranged_target_turf(get_turf(src),turn(loc.dir,270),1), rand(0,1), 5)
			if(LAZYLEN(chambered.fall_sounds))
				playsound(loc, pick(chambered.fall_sounds), 50, 1)
		if(CYCLE_CASINGS) //cycle the casing back to the end.
			if(ammo_magazine)
				ammo_magazine.stored_ammo += chambered
			else
				loaded += chambered

	if(handle_casings != HOLD_CASINGS)
		chambered = null

	update_icon()

#define EXP_TAC_RELOAD 1 SECOND
#define PROF_TAC_RELOAD 0.5 SECONDS
#define EXP_SPD_RELOAD 0.5 SECONDS
#define PROF_SPD_RELOAD 0.25 SECONDS



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
	// Magazines
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

				// Tactical/speed reload checks
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
						if (I_GRAB) // Tactical Reloading
							prof_reload_time = PROF_TAC_RELOAD
							exp_reload_time = EXP_TAC_RELOAD

						if (I_HURT) // Speed Reloading
							prof_reload_time = PROF_SPD_RELOAD
							exp_reload_time = EXP_SPD_RELOAD
							drop_magazine = TRUE

					var/do_after_time = user.get_skill_value(SKILL_WEAPONS) == SKILL_MASTER ? prof_reload_time : exp_reload_time
					if (!do_after(user, do_after_time, src, DO_DEFAULT | DO_BOTH_UNIQUE_ACT))
						return TRUE
					if (!user.use_sanity_check(src, ammo))
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

					if (!istype(ammo_magazine, magazine_type))
						jam_chance = initial(jam_chance) + 10
					else
						jam_chance = initial(jam_chance)

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
				if (!istype(ammo_magazine, magazine_type))
					jam_chance = initial(jam_chance) + 10
				else
					jam_chance = initial(jam_chance)
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

	// Casings
	if (istype(ammo, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/casing = ammo
		if (!GET_FLAGS(load_method, SINGLE_CASING))
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
/obj/item/gun/projectile/proc/unload_ammo(mob/user, allow_dump = TRUE)
	// Clear jams
	if (is_jammed)
		if (!do_after(user, 0.4 SECONDS, src, DO_DEFAULT | DO_BOTH_UNIQUE_ACT) || !user.use_sanity_check(src))
			return
		user.visible_message(
			SPAN_NOTICE("\The [user] unjams \a [src]."),
			SPAN_NOTICE("You unjam \the [src].")
		)
		is_jammed = FALSE
		update_icon()
		playsound(src, 'sound/weapons/flipblade.ogg', 50, TRUE)
		return

	// Eject magazine
	if (ammo_magazine)
		jam_chance = initial(jam_chance)
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

	// Dump everything on the floor
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
		update_icon()
		return

	// Unload single casings
	if (GET_FLAGS(load_method, SINGLE_CASING))
		var/obj/item/ammo_casing/casing = pop(loaded)
		user.put_in_hands(casing)
		user.visible_message(
			SPAN_NOTICE("\The [user] removes \a [casing] from \a [src]."),
			SPAN_NOTICE("You remove \a [casing] from \the [src].")
		)
		update_icon()
		return


/obj/item/gun/projectile/use_tool(obj/item/tool, mob/user, list/click_params)
	// Anything - Attempt to load ammo
	if (load_ammo(tool, user))
		return TRUE

	return ..()


/obj/item/gun/projectile/attack_self(mob/user as mob)
	if(length(firemodes) > 1)
		..()
	else
		unload_ammo(user)

/obj/item/gun/projectile/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		unload_ammo(user, FALSE)
	else
		return ..()

/obj/item/gun/projectile/afterattack(atom/A, mob/living/user)
	..()
	if(auto_eject && ammo_magazine && ammo_magazine.stored_ammo && !length(ammo_magazine.stored_ammo))
		ammo_magazine.dropInto(user.loc)
		user.visible_message(
			"[ammo_magazine] falls out and clatters on the floor!",
			SPAN_NOTICE("[ammo_magazine] falls out and clatters on the floor!")
			)
		if(auto_eject_sound)
			playsound(user, auto_eject_sound, 40, 1)
		ammo_magazine.update_icon()
		ammo_magazine = null
	update_icon() //make sure to do this after unsetting ammo_magazine

/obj/item/gun/projectile/examine(mob/user)
	. = ..()
	if(is_jammed && user.skill_check(SKILL_WEAPONS, SKILL_BASIC))
		to_chat(user, SPAN_WARNING("It looks jammed."))
	if(ammo_magazine)
		to_chat(user, "It has \a [ammo_magazine] loaded.")
	if(user.skill_check(SKILL_WEAPONS, SKILL_TRAINED))
		to_chat(user, "Has [getAmmo()] round\s remaining.")
	if (user.skill_check(SKILL_WEAPONS, SKILL_EXPERIENCED))
		to_chat(user, "[src.DrawChamber()]")

/obj/item/gun/projectile/proc/getAmmo()
	var/bullets = 0
	if(loaded)
		bullets += length(loaded)
	if(ammo_magazine && ammo_magazine.stored_ammo)
		bullets += length(ammo_magazine.stored_ammo)
	if(chambered)
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

/* Unneeded -- so far.
//in case the weapon has firemodes and can't unload using attack_hand()
/obj/item/gun/projectile/verb/unload_gun()
	set name = "Unload Ammo"
	set category = "Object"
	set src in usr

	if(usr.stat || usr.restrained()) return

	unload_ammo(usr)
*/
