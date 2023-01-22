/obj/item/gun/projectile
	name = "gun"
	desc = "A gun that fires bullets."
	icon = 'icons/obj/guns/pistol.dmi'
	icon_state = "secguncomp"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	w_class = ITEM_SIZE_NORMAL
	matter = list(MATERIAL_STEEL = 1000)
	screen_shake = 2
	combustion = 1

	var/caliber = CALIBER_PISTOL		//determines which casings will fit
	var/handle_casings = EJECT_CASINGS	//determines how spent casings should be handled
	var/load_method = SINGLE_CASING|SPEEDLOADER //1 = Single shells, 2 = box or quick loader, 3 = magazine
	var/obj/item/ammo_casing/chambered = null

	//For SINGLE_CASING or SPEEDLOADER guns
	var/max_shells = 0			//the number of casings that will fit inside
	var/ammo_type = null		//the type of ammo that the gun comes preloaded with
	var/list/loaded = list()	//stored ammo
	var/starts_loaded = 1		//whether the gun starts loaded or not, can be overridden for guns crafted in-game
	var/load_sound = 'sound/weapons/guns/interaction/bullet_insert.ogg'

	//For MAGAZINE guns
	var/magazine_type = null	//the type of magazine that the gun comes preloaded with
	var/obj/item/ammo_magazine/ammo_magazine = null //stored magazine
	var/allowed_magazines		//magazine types that may be loaded. Can be a list or single path
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
		src.visible_message("<span class='danger'>\The [src] jams!</span>")
		is_jammed = 1
		var/mob/user = loc
		if(istype(user))
			if(prob(user.skill_fail_chance(SKILL_WEAPONS, 100, SKILL_PROF)))
				return null
			else
				to_chat(user, "<span class='notice'>You reflexively clear the jam on \the [src].</span>")
				is_jammed = 0
				playsound(src.loc, 'sound/weapons/flipblade.ogg', 50, 1)
	if(is_jammed)
		return null
	//get the next casing
	if(loaded.len)
		chambered = loaded[1] //load next casing.
		if(handle_casings != HOLD_CASINGS)
			loaded -= chambered
	else if(ammo_magazine && ammo_magazine.stored_ammo.len)
		chambered = ammo_magazine.stored_ammo[ammo_magazine.stored_ammo.len]
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

#define EXP_TAC_RELOAD 1 SECOND
#define PROF_TAC_RELOAD 0.5 SECONDS
#define EXP_SPD_RELOAD 0.5 SECONDS
#define PROF_SPD_RELOAD 0.25 SECONDS



//Attempts to load A into src, depending on the type of thing being loaded and the load_method
//Maybe this should be broken up into separate procs for each load method?
/obj/item/gun/projectile/proc/load_ammo(var/obj/item/A, mob/user)
	if(istype(A, /obj/item/ammo_magazine))
		. = TRUE
		var/obj/item/ammo_magazine/AM = A
		if(!(load_method & AM.mag_type) || caliber != AM.caliber)
			return //incompatible

		switch(AM.mag_type)
			if(MAGAZINE)
				if((ispath(allowed_magazines) && !istype(A, allowed_magazines)) || (islist(allowed_magazines) && !is_type_in_list(A, allowed_magazines)))
					to_chat(user, SPAN_WARNING("\The [A] won't fit into [src]."))
					return
				if(ammo_magazine)
					if(user.a_intent == I_HELP || user.a_intent == I_DISARM || !user.skill_check(SKILL_WEAPONS, SKILL_EXPERT))
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
							if(do_after(user, user.get_skill_value(SKILL_WEAPONS) == SKILL_PROF ? PROF_TAC_RELOAD : EXP_TAC_RELOAD, src, DO_DEFAULT | DO_BOTH_UNIQUE_ACT))
								ammo_magazine.update_icon()
								user.put_in_hands(ammo_magazine)
								user.visible_message(SPAN_WARNING("\The [user] reloads \the [src] with \the [AM]!"),
													 SPAN_WARNING("You tactically reload \the [src] with \the [AM]!"))
						else //Speed reloading
							if(!can_special_reload)
								to_chat(user, SPAN_WARNING("You can't speed reload with this gun!"))
								return
							if(!user.unEquip(AM, src))
								return
							//Experienced gets a 0.5 second delay, master gets a 0.25 second delay
							if(do_after(user, user.get_skill_value(SKILL_WEAPONS) == SKILL_PROF ? PROF_SPD_RELOAD : EXP_SPD_RELOAD, src, DO_DEFAULT | DO_BOTH_UNIQUE_ACT))
								ammo_magazine.update_icon()
								ammo_magazine.dropInto(user.loc)
								user.visible_message(SPAN_WARNING("\The [user] reloads \the [src] with \the [AM]!"),
													 SPAN_WARNING("You speed reload \the [src] with \the [AM]!"))
					ammo_magazine = AM
					playsound(loc, mag_insert_sound, 75, 1)
					update_icon()
					AM.update_icon()
					return
				if(!user.unEquip(AM, src))
					return
				ammo_magazine = AM
				user.visible_message("[user] inserts [AM] into [src].", "<span class='notice'>You insert [AM] into [src].</span>")
				playsound(loc, mag_insert_sound, 50, 1)
			if(SPEEDLOADER)
				if(loaded.len >= max_shells)
					to_chat(user, "<span class='warning'>[src] is full!</span>")
					return
				var/count = 0
				for(var/obj/item/ammo_casing/C in AM.stored_ammo)
					if(loaded.len >= max_shells)
						break
					if(C.caliber == caliber)
						C.forceMove(src)
						loaded += C
						AM.stored_ammo -= C //should probably go inside an ammo_magazine proc, but I guess less proc calls this way...
						count++
				if(count)
					user.visible_message("[user] reloads [src].", "<span class='notice'>You load [count] round\s into [src].</span>")
					playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
		AM.update_icon()
	else if(istype(A, /obj/item/ammo_casing))
		. = TRUE
		var/obj/item/ammo_casing/C = A
		if(!(load_method & SINGLE_CASING) || caliber != C.caliber)
			return //incompatible
		if(loaded.len >= max_shells)
			to_chat(user, "<span class='warning'>[src] is full.</span>")
			return
		if(!user.unEquip(C, src))
			return
		loaded.Insert(1, C) //add to the head of the list
		user.visible_message("[user] inserts \a [C] into [src].", "<span class='notice'>You insert \a [C] into [src].</span>")
		playsound(loc, load_sound, 50, 1)

	update_icon()

#undef EXP_TAC_RELOAD
#undef PROF_TAC_RELOAD
#undef EXP_SPD_RELOAD
#undef PROF_SPD_RELOAD

//attempts to unload src. If allow_dump is set to 0, the speedloader unloading method will be disabled
/obj/item/gun/projectile/proc/unload_ammo(mob/user, var/allow_dump=1)
	if(is_jammed)
		user.visible_message("\The [user] begins to unjam [src].", "You clear the jam and unload [src]")
		if(!do_after(user, 0.4 SECONDS, src, DO_DEFAULT | DO_BOTH_UNIQUE_ACT))
			return
		is_jammed = 0
		playsound(src.loc, 'sound/weapons/flipblade.ogg', 50, 1)
	if(ammo_magazine)
		user.put_in_hands(ammo_magazine)
		user.visible_message("[user] removes [ammo_magazine] from [src].", "<span class='notice'>You remove [ammo_magazine] from [src].</span>")
		playsound(loc, mag_remove_sound, 50, 1)
		ammo_magazine.update_icon()
		ammo_magazine = null
	else if(loaded.len)
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
			if(count)
				user.visible_message("[user] unloads [src].", "<span class='notice'>You unload [count] round\s from [src].</span>")
		else if(load_method & SINGLE_CASING)
			var/obj/item/ammo_casing/C = loaded[loaded.len]
			loaded.len--
			user.put_in_hands(C)
			user.visible_message("[user] removes \a [C] from [src].", "<span class='notice'>You remove \a [C] from [src].</span>")
	else
		to_chat(user, "<span class='warning'>[src] is empty.</span>")
	update_icon()

/obj/item/gun/projectile/attackby(var/obj/item/A as obj, mob/user as mob)
	if(!load_ammo(A, user))
		return ..()

/obj/item/gun/projectile/attack_self(mob/user as mob)
	if(firemodes.len > 1)
		..()
	else
		unload_ammo(user)

/obj/item/gun/projectile/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		unload_ammo(user, allow_dump=0)
	else
		return ..()

/obj/item/gun/projectile/afterattack(atom/A, mob/living/user)
	..()
	if(auto_eject && ammo_magazine && ammo_magazine.stored_ammo && !ammo_magazine.stored_ammo.len)
		ammo_magazine.dropInto(user.loc)
		user.visible_message(
			"[ammo_magazine] falls out and clatters on the floor!",
			"<span class='notice'>[ammo_magazine] falls out and clatters on the floor!</span>"
			)
		if(auto_eject_sound)
			playsound(user, auto_eject_sound, 40, 1)
		ammo_magazine.update_icon()
		ammo_magazine = null
		update_icon() //make sure to do this after unsetting ammo_magazine

/obj/item/gun/projectile/examine(mob/user)
	. = ..()
	if(is_jammed && user.skill_check(SKILL_WEAPONS, SKILL_BASIC))
		to_chat(user, "<span class='warning'>It looks jammed.</span>")
	if(ammo_magazine)
		to_chat(user, "It has \a [ammo_magazine] loaded.")
	if(user.skill_check(SKILL_WEAPONS, SKILL_ADEPT))
		to_chat(user, "Has [getAmmo()] round\s remaining.")

/obj/item/gun/projectile/proc/getAmmo()
	var/bullets = 0
	if(loaded)
		bullets += loaded.len
	if(ammo_magazine && ammo_magazine.stored_ammo)
		bullets += ammo_magazine.stored_ammo.len
	if(chambered)
		bullets += 1
	return bullets

/* Unneeded -- so far.
//in case the weapon has firemodes and can't unload using attack_hand()
/obj/item/gun/projectile/verb/unload_gun()
	set name = "Unload Ammo"
	set category = "Object"
	set src in usr

	if(usr.stat || usr.restrained()) return

	unload_ammo(usr)
*/
