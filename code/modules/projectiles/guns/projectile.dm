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

	var/caliber = CALIBER_PISTOL		//determines which casings will fit
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
	var/allowed_magazines		//magazine types that may be loaded. Can be a list or single path
	var/banned_magazines 		//magazine types that may NOT be loaded. Can be a list or single path
	var/auto_eject = 0			//if the magazine should automatically eject itself when empty.
	var/auto_eject_sound = null
	var/mag_insert_sound = 'sound/weapons/guns/interaction/pistol_magin.ogg'
	var/mag_remove_sound = 'sound/weapons/guns/interaction/pistol_magout.ogg'
	var/can_special_reload = TRUE //Whether or not we can tactical/speed reload

	var/is_jammed = 0           //Whether this gun is jammed
	var/jam_chance = 0          //Chance it jams on fire
	var/bolt_open = FALSE
	var/fire_closed_bolt = TRUE //Whether or not the weapon fires from a closed bolt. Closed bolt means an extra round in the chamber.
	var/hold_open = TRUE //Whether or not this weapon automatically holds its bolt open when emptied.
	var/recentrack = 0 // to prevent spammage
	var/rackdelay = 5
	var/racksound = 'sound/weapons/flipblade.ogg'
	var/selectorsound = 'sound/weapons/flipblade.ogg'
	var/allow_dump = FALSE //Whether a gun with multiple chambers can dump all its rounds at once (e.g a revolver)
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
		close_bolt(manual = FALSE)
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
		process_chambered(manual = FALSE)
	else if (chambered)
		if (chambered.BB)
			chambered.expend()
			if (handle_casings != HOLD_CASINGS)
				process_chambered(manual = FALSE)

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
	if(ismob(loc))
		var/mob/user = loc
		if (istype(src, /obj/item/gun/projectile/boltloader))
			return
		else if (!prob(user.skill_fail_chance(SKILL_WEAPONS, 90, SKILL_MASTER, 0.25)))
			if (handle_casings != CYCLE_CASINGS)
				if (is_held_twohanded(user) || user.skill_check(SKILL_WEAPONS, SKILL_MASTER) || (bolt_open && hold_open)) //don't risk automatically dropping the gun on the floor
					process_chambered(manual = TRUE) //tap, rack, bang
	..()

/obj/item/gun/projectile/proc/open_bolt(manual)
	var/obj/item/ammo_casing/ejected = null
	if (chambered && !bolt_open && !is_jammed)
		if (!prob(jam_chance)) //"double feed" aka failure to extract malfunction
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
	if (hold_open)
		if (prob(jam_chance)) //"out of battery" aka failure to feed malfunction
			return
		if (ammo_magazine && !length(ammo_magazine.stored_ammo) && !manual) //bolt hold open on empty
			return
	if (bolt_open && !prob(jam_chance)) //"stovepipe" aka failure to feed malfunction
		if (!chambered)
			if (ammo_magazine && length(ammo_magazine.stored_ammo)) //attempt to load next casing
				chambered = ammo_magazine.stored_ammo[length(ammo_magazine.stored_ammo)]
				ammo_magazine.stored_ammo -= chambered
			if (length(loaded))
				chambered = loaded[1]
				loaded -= chambered
		else if (((load_method != MAGAZINE) && length(loaded)))
			is_jammed = TRUE
			return
		else if ((ammo_magazine && length(ammo_magazine.stored_ammo)))
			is_jammed = TRUE
			return
	bolt_open = FALSE
	update_icon()
	return TRUE

/obj/item/gun/projectile/proc/process_chambered(manual) //manual should be TRUE if the operator is running the action by hand, FALSE otherwise

	switch(handle_casings)
		if (CYCLE_CASINGS) //cycle the casing back to the end.
			chamber_offset = 0
			var/obj/item/ammo_casing/cartridge
			var/obj/item/ammo_casing/new_round
			for (var/entry in loaded) //clean up
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
			if (cartridge)
				cartridge.expend()
			if (manual)
				to_chat(loc, SPAN_NOTICE("You cycle \the [src]'s chambers. \The [new_round] is now next to fire."))
		else //eject casing onto ground.
			if (!chambered && !manual) //chamber is empty and the action isn't being run manually, so gun can't cycle on its own
				return
			if (!manual)
				open_bolt(manual)
				close_bolt(manual)
			else
				if (ismob(loc))
					var/mob/user = loc //if we have an operator, we should probably start thinking about whether they're using one or two hands
					if (hold_open && (handle_casings == EJECT_CASINGS) && bolt_open) //hit the bolt release, you can do it one-handed and fast
						to_chat(user, SPAN_NOTICE("You hit the bolt release on \the [src]."))
						close_bolt(manual = FALSE)
					else if (world.time >= recentrack + rackdelay)
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
							close_bolt(handle_casings != EJECT_CASINGS)
						recentrack = world.time
						playsound(src.loc, racksound, 60, 1)

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
		if(user)
			user.visible_message(
				"[ammo_magazine] falls out and clatters on the floor!",
				SPAN_NOTICE("[ammo_magazine] falls out and clatters on the floor!")
				)
			if(auto_eject_sound)
				playsound(user, auto_eject_sound, 40, 1)
		ammo_magazine.update_icon()
		ammo_magazine = null
		update_icon() //make sure to do this after unsetting ammo_magazine
		return 1
	return

//Attempts to load A into src, depending on the type of thing being loaded and the load_method
//Maybe this should be broken up into separate procs for each load method?
/obj/item/gun/projectile/proc/load_ammo(obj/item/A, mob/user)
	if(istype(A, /obj/item/ammo_magazine))
		. = TRUE
		var/obj/item/ammo_magazine/AM = A
		if (((istext(caliber) && caliber != AM.caliber) || (islist(caliber) && !is_type_in_list(AM.caliber, caliber))))
			return //incompatible
		else if (load_method == SINGLE_CASING && AM.mag_type == SPEEDLOADER && world.time >= recentload)
			if (length(AM.stored_ammo))
				var/C = AM.stored_ammo[1]
				if (length(loaded) >= max_shells)
					to_chat(user, SPAN_WARNING("[src] is full!"))
					return
				if (!user.unEquip(C, src))
					return
				loaded.Insert(1, C) //add to the head of the list
				AM.stored_ammo -= C
				user.visible_message("[user] inserts \a [C] into [src].", SPAN_NOTICE("You insert \a [C] into [src]."))
				playsound(loc, load_sound, 50, 1)
				recentload = world.time + 0.5 SECONDS
			AM.update_icon()
			update_icon()
			return
		else if (!(load_method & AM.mag_type))
			return //incompatible

		switch(AM.mag_type)
			if(MAGAZINE)
				if((ispath(allowed_magazines) && !istype(A, allowed_magazines)) || (islist(allowed_magazines) && !is_type_in_list(A, allowed_magazines)) || (ispath(banned_magazines) && istype(A, banned_magazines)) || (islist(banned_magazines) && is_type_in_list(A, banned_magazines)))
					to_chat(user, SPAN_WARNING("\The [A] won't fit into [src]."))
					return
				if(ammo_magazine)
					if(user.a_intent == I_HELP || user.a_intent == I_DISARM || !user.skill_check(SKILL_WEAPONS, SKILL_EXPERIENCED))
						to_chat(user, SPAN_WARNING("[src] already has a magazine loaded."))//already a magazine here
						return
					else
						if(user.a_intent == I_GRAB) //Tactical reloading
							if(!can_special_reload)
								to_chat(user, SPAN_WARNING("You can't tactically reload this gun!"))
								return
							if(!user.unEquip(AM, src))
								return
							//Experienced gets a 1 second delay, master gets a 0.5 second delay
							if(do_after(user, user.get_skill_value(SKILL_WEAPONS) == SKILL_MASTER ? PROF_TAC_RELOAD : EXP_TAC_RELOAD, src, DO_DEFAULT | DO_BOTH_UNIQUE_ACT))
								if(jam_chance && (!(ammo_magazine.type == magazine_type)))
									jam_chance -= 3.7
								ammo_magazine.update_icon()
								user.put_in_hands(ammo_magazine)
								user.visible_message(
									SPAN_WARNING("\The [user] reloads \the [src] with \the [AM]!"),
									SPAN_WARNING("You tactically reload \the [src] with \the [AM]!")
								)
						else //Speed reloading
							if(!can_special_reload)
								to_chat(user, SPAN_WARNING("You can't speed reload with this gun!"))
								return
							if(!user.unEquip(AM, src))
								return
							//Experienced gets a 0.5 second delay, master gets a 0.25 second delay
							if(do_after(user, user.get_skill_value(SKILL_WEAPONS) == SKILL_MASTER ? PROF_SPD_RELOAD : EXP_SPD_RELOAD, src, DO_DEFAULT | DO_BOTH_UNIQUE_ACT))
								if(jam_chance && istype(ammo_magazine, magazine_type))
									jam_chance -= 3
								ammo_magazine.update_icon()
								ammo_magazine.dropInto(user.loc)
								user.visible_message(
									SPAN_WARNING("\The [user] reloads \the [src] with \the [AM]!"),
									SPAN_WARNING("You speed reload \the [src] with \the [AM]!")
								)
					ammo_magazine = AM
					playsound(loc, mag_insert_sound, 75, 1)
					update_icon()
					AM.update_icon()
					if(!istype(AM, magazine_type))
						jam_chance += 3
					return
				ammo_magazine = AM
				if(!user.unEquip(AM, src))
					ammo_magazine = null
					return
				user.visible_message("[user] inserts [AM] into [src].", SPAN_NOTICE("You insert [AM] into [src]."))
				playsound(loc, mag_insert_sound, 50, 1)
				if(!istype(AM, magazine_type))
					jam_chance += 3
			if(SPEEDLOADER)
				if(length(loaded) >= max_shells)
					to_chat(user, SPAN_WARNING("[src] is full!"))
					return
				var/count = 0
				for(var/obj/item/ammo_casing/C in AM.stored_ammo)
					if(length(loaded) >= max_shells)
						break
					if(C.caliber == caliber)
						C.forceMove(src)
						loaded += C
						AM.stored_ammo -= C //should probably go inside an ammo_magazine proc, but I guess less proc calls this way...
						count++
				if(count)
					user.visible_message("[user] reloads [src].", SPAN_NOTICE("You load [count] round\s into [src]."))
					playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
		AM.update_icon()
	else if(istype(A, /obj/item/ammo_casing))
		. = TRUE
		var/obj/item/ammo_casing/C = A
		if(!(load_method & SINGLE_CASING) || caliber != C.caliber)
			return //incompatible
		if(length(loaded) >= max_shells)
			to_chat(user, SPAN_WARNING("[src] is full."))
			return
		if(!user.unEquip(C, src))
			return
		loaded.Insert(1, C) //add to the head of the list
		user.visible_message("[user] inserts \a [C] into [src].", SPAN_NOTICE("You insert \a [C] into [src]."))
		playsound(loc, load_sound, 50, 1)

	update_icon()

#undef EXP_TAC_RELOAD
#undef PROF_TAC_RELOAD
#undef EXP_SPD_RELOAD
#undef PROF_SPD_RELOAD

//attempts to unload src. If allow_dump is set to 0, the speedloader unloading method will be disabled
/obj/item/gun/projectile/proc/unload_ammo(mob/user)
	if(is_jammed) //pressure on the jam makes it harder to remove the magazine
		user.visible_message("\The [user] struggles to unload [src].", "You struggle to unload [src]")
		if(!do_after(user, round((50/(user.get_skill_value(SKILL_WEAPONS))), 1), src, DO_DEFAULT | DO_BOTH_UNIQUE_ACT | DO_SHOW_PROGRESS))
			return
	is_jammed = FALSE
	if(ammo_magazine)
		if(jam_chance && !istype(ammo_magazine, magazine_type))
			jam_chance -= 3
		user.put_in_hands(ammo_magazine)
		user.visible_message("[user] removes [ammo_magazine] from [src].", SPAN_NOTICE("You remove [ammo_magazine] from [src]."))
		playsound(loc, mag_remove_sound, 50, 1)
		ammo_magazine.update_icon()
		ammo_magazine = null
	else if(length(loaded))
		//presumably, if it can be speed-loaded, it can be speed-unloaded.
		if(allow_dump && (load_method & SPEEDLOADER))
			var/count = 0
			var/turf/T = get_turf(user)
			if(T)
				for(var/obj/item/ammo_casing/C in loaded)
					if(LAZYLEN(C.fall_sounds))
						playsound(loc, pick(C.fall_sounds), 50, 1)
					C.forceMove(T)
					count++
				loaded.Cut()
			chambered = null
			if(count)
				user.visible_message("[user] unloads [src].", SPAN_NOTICE("You unload [count] round\s from [src]."))
		else if(load_method & SINGLE_CASING)
			var/obj/item/ammo_casing/C = loaded[length(loaded)]
			LIST_DEC(loaded)
			user.put_in_hands(C)
			user.visible_message("[user] removes \a [C] from [src].", SPAN_NOTICE("You remove \a [C] from [src]."))
	else
		to_chat(user, SPAN_WARNING("[src] is empty."))
	update_icon()


/obj/item/gun/projectile/use_tool(obj/item/tool, mob/user, list/click_params)
	// Anything - Attempt to load ammo
	if (load_ammo(tool, user))
		return TRUE

	// Pry out a round from the chamber
	if (handle_casings != CYCLE_CASINGS && bolt_open && chambered) //check weapon type and condition
		if (tool.sharp && (tool.w_class < 3)) //check tool
			if (is_jammed)
				user.visible_message(SPAN_WARNING("\The [user] tries to pry something out of \the [src]."), SPAN_WARNING("You stick \the [tool] in the action of \the [src], trying to pry out the [chambered]."))
				if (!do_after(user, round((50/(user.get_skill_value(SKILL_WEAPONS))), 1), src, DO_DEFAULT | DO_BOTH_UNIQUE_ACT | DO_SHOW_PROGRESS | DO_USER_SAME_HAND) || !user.use_sanity_check(src, tool))
					return
			to_chat(user, SPAN_NOTICE("You pry \the [chambered] from \the [src]."))
			chambered.dropInto(get_turf(loc))
			if (length(chambered.fall_sounds))
				playsound(loc, pick(chambered.fall_sounds), 50, 1)
			chambered = null

	return ..()


/obj/item/gun/projectile/attack_self(mob/user as mob)
	process_chambered(manual = TRUE)

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
			if (handle_casings == EJECT_CASINGS)
				to_chat(user, SPAN_WARNING("To unjam it, you'd have to empty the weapon and reload it."))
			else if (load_method & MAGAZINE)
				if (fire_closed_bolt)
					to_chat(user, SPAN_WARNING("To unjam it, you'd have to pull out the magazine and eject the cartridge in the chamber by racking the weapon a few times."))
				else
					to_chat(user, SPAN_WARNING("To unjam it, you'd have to pull out the magazine and eject the cartridge in the chamber by pulling the trigger and racking the weapon."))
			else
				if (fire_closed_bolt)
					to_chat(user, SPAN_WARNING("To unjam it, you'd have to take out a round and pry out the cartridge in the chamber with a sharp object before racking the weapon."))
				else
					to_chat(user, SPAN_WARNING("To unjam it, you'd have to take out a round and pry out the cartridge in the chamber with a sharp object."))


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
