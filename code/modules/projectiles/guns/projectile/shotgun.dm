/obj/item/gun/projectile/shotgun/pump
	name = "shotgun"
	desc = "A mass-produced shotgun by Mars Security Industries. The rugged ZX-870 'Bulldog' is common throughout most frontier worlds. Useful for sweeping alleys or ship corridors."
	icon = 'icons/obj/guns/shotguns.dmi'
	icon_state = "shotgun"
	item_state = "shotgun"
	max_shells = 4
	w_class = ITEM_SIZE_HUGE
	force = 10
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BACK
	caliber = CALIBER_SHOTGUN
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	load_method = SINGLE_CASING
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	handle_casings = HOLD_CASINGS
	one_hand_penalty = 8
	bulk = 6
	var/recentpump = 0 // to prevent spammage
	wielded_item_state = "shotgun-wielded"
	load_sound = 'sound/weapons/guns/interaction/shotgun_instert.ogg'

/obj/item/gun/projectile/shotgun/on_update_icon()
	..()
	if(length(loaded))
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-empty"

/obj/item/gun/projectile/shotgun/pump/consume_next_projectile()
	if(chambered)
		return chambered.BB
	return null

/obj/item/gun/projectile/shotgun/pump/attack_self(mob/living/user as mob)
	if(world.time >= recentpump + 10)
		if(!is_held_twohanded(user))
			var/fail_chance = user.skill_fail_chance(SKILL_WEAPONS, 90, SKILL_EXPERT, 0.25)
			var/drop_chance = user.skill_fail_chance(SKILL_WEAPONS, 50, SKILL_EXPERT, 0.5)

			if (!fail_chance)
				user.visible_message(
					SPAN_NOTICE("\The [user] racks \the [src] with one hand."),
					SPAN_NOTICE("You manage to rack \the [src] with one hand.")
				)
				pump(user)
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
				pump(user)

		else
			pump(user)

		recentpump = world.time

/obj/item/gun/projectile/shotgun/pump/proc/pump(mob/M as mob)
	playsound(M, 'sound/weapons/shotgunpump.ogg', 60, 1)

	if(chambered)//We have a shell in the chamber
		chambered.dropInto(loc)//Eject casing
		if(LAZYLEN(chambered.fall_sounds))
			playsound(loc, pick(chambered.fall_sounds), 50, 1)
		chambered = null

	if(length(loaded))
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		chambered = AC

	update_icon()


/obj/item/gun/projectile/shotgun/pump/use_tool(obj/item/tool, mob/user, list/click_params)
	// Circular Saw - Remove stock
	if (istype(tool, /obj/item/circular_saw))
		if (!remove_stock(tool, user))
			return TRUE
		playsound(src, 'sound/weapons/circsawhit.ogg', 50, TRUE)
		return TRUE

	// Energy Weapon - Remove stock
	if (istype(tool, /obj/item/melee/energy))
		var/obj/item/melee/energy/energy_weapon = tool
		if (!energy_weapon.active)
			to_chat(user, SPAN_WARNING("\The [tool] needs to be turned on before you can cut \the [src]'s stock."))
			return TRUE
		if (!remove_stock(tool, user))
			return TRUE
		playsound(src, 'sound/weapons/blade1.ogg', 50, TRUE)
		return TRUE

	// Plasma Cutter - Remove stock
	if (istype(tool, /obj/item/gun/energy/plasmacutter))
		var/obj/item/gun/energy/plasmacutter/plasmacutter = tool
		if (!plasmacutter.slice(user))
			return TRUE
		if (!remove_stock(tool, user))
			return TRUE
		playsound(src, 'sound/weapons/plasma_cutter.ogg', 50, TRUE)
		return TRUE

	return ..()


/obj/item/gun/projectile/shotgun/pump/proc/remove_stock(obj/item/tool, mob/user)
	// Ugly hack. /pump needs abstracting
	if (type != /obj/item/gun/projectile/shotgun/pump)
		to_chat(user, SPAN_WARNING("\The [src]'s stock cannot be removed."))
		return FALSE
	user.visible_message(
		SPAN_NOTICE("\The [user] begins to cut \the [src]'s stock with \a [tool]."),
		SPAN_NOTICE("You begin to cut \the [src]'s stock with \a [tool].")
	)
	var/do_flags = loc == user ? DO_BAR_OVER_USER : EMPTY_BITFIELD
	if (!do_after(user, 5 SECONDS, src, DO_PUBLIC_UNIQUE | do_flags) || !user.use_sanity_check(src, tool, SANITY_CHECK_TARGET_UNEQUIP))
		return FALSE
	user.unEquip(src)
	user.visible_message(
		SPAN_NOTICE("\The [user] slices \the [src]'s stock off with \a [tool]."),
		SPAN_NOTICE("You slice \the [src]'s stock off with \a [tool].")
	)
	var/obj/item/gun/projectile/shotgun/pump/sawn/new_gun = new (get_turf(src))
	transfer_fingerprints_to(new_gun)
	qdel(src)
	return TRUE


/obj/item/gun/projectile/shotgun/pump/sawn
	name = "riot shotgun"
	desc = "A mass-produced shotgun by Mars Security Industries. The rugged ZX-870 'Bulldog' is common throughout most frontier worlds. This one has had it's stock cut off..."
	icon = 'icons/obj/guns/shotguns.dmi'
	icon_state = "rshotgun"
	item_state = "rshotgun"
	max_shells = 4
	w_class = ITEM_SIZE_LARGE
	force = 10
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT|SLOT_BACK
	caliber = CALIBER_SHOTGUN
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	load_method = SINGLE_CASING
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	handle_casings = HOLD_CASINGS
	one_hand_penalty = 4
	bulk = 4
	var/recentpumpr = 0 // to prevent spammage
	wielded_item_state = "rshotgun-wielded"
	load_sound = 'sound/weapons/guns/interaction/shotgun_instert.ogg'

/obj/item/gun/projectile/shotgun/pump/sawn/attack_self(mob/living/user)
	if(world.time >= recentpump + 10)
		if(!is_held_twohanded(user))
			var/fail_chance = user.skill_fail_chance(SKILL_WEAPONS, 90, SKILL_EXPERT, 0.25)
			var/drop_chance = user.skill_fail_chance(SKILL_WEAPONS, 50, SKILL_EXPERT, 0.5)

			if (!fail_chance)
				user.visible_message(
					SPAN_NOTICE("\The [user] racks \the [src] with one hand."),
					SPAN_NOTICE("You manage to rack \the [src] with one hand.")
				)
				pump(user)
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
				pump(user)

		else
			pump(user)

		recentpumpr = world.time

/obj/item/gun/projectile/shotgun/pump/sawn/proc/pumpr(mob/living/user)
	playsound(user, 'sound/weapons/shotgunpump.ogg', 60, 1)

	if(chambered)//We have a shell in the chamber
		chambered.dropInto(loc)//Eject casing
		if(length(chambered.fall_sounds))
			playsound(loc, pick(chambered.fall_sounds), 50, 1)
		chambered = null

	if(length(loaded))
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		chambered = AC

	update_icon()


/obj/item/gun/projectile/shotgun/pump/combat
	name = "combat shotgun"
	desc = "Built for close quarters combat, the Hephaestus Industries KS-40 is widely regarded as a weapon of choice for repelling boarders."
	icon_state = "cshotgun"
	item_state = "cshotgun"
	wielded_item_state = "cshotgun-wielded"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	max_shells = 7 //match the ammo box capacity, also it can hold a round in the chamber anyways, for a total of 8.
	ammo_type = /obj/item/ammo_casing/shotgun
	one_hand_penalty = 8

/obj/item/gun/projectile/shotgun/pump/combat/on_update_icon()
	..()
	if(length(loaded) > 3)
		for(var/i = 0 to length(loaded) - 4)
			var/image/I = image(icon, "shell")
			I.pixel_x = i * 2
			overlays += I

/obj/item/gun/projectile/shotgun/doublebarrel
	name = "double-barreled shotgun"
	desc = "A classic double-barreled shotgun. In production for centuries, it has proliferated across human space, earning a sizable reputation for being simple and effective. Produced by Novaya Zemlya Arms."
	icon = 'icons/obj/guns/shotguns.dmi'
	icon_state = "dshotgun"
	item_state = "dshotgun"
	wielded_item_state = "dshotgun-wielded"
	//SPEEDLOADER because rapid unloading.
	//In principle someone could make a speedloader for it, so it makes sense.
	load_method = SINGLE_CASING|SPEEDLOADER
	handle_casings = CYCLE_CASINGS
	max_shells = 2
	w_class = ITEM_SIZE_HUGE
	force = 10
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BACK
	caliber = CALIBER_SHOTGUN
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 1)
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	one_hand_penalty = 8
	wielded_item_state = "gun_wielded"

	burst_delay = 0
	firemodes = list(
		list(mode_name="fire one barrel at a time", burst=1),
		list(mode_name="fire both barrels at once", burst=2),
		)

/obj/item/gun/projectile/shotgun/doublebarrel/pellet
	ammo_type = /obj/item/ammo_casing/shotgun/pellet

/obj/item/gun/projectile/shotgun/doublebarrel/flare
	name = "signal shotgun"
	desc = "A double-barreled shotgun meant to fire signal flash shells."
	ammo_type = /obj/item/ammo_casing/shotgun/flash

/obj/item/gun/projectile/shotgun/doublebarrel/unload_ammo(user, allow_dump)
	..(user, allow_dump=1)


/obj/item/gun/projectile/shotgun/doublebarrel/get_interactions_info()
	. = ..()
	.["Circular Saw"] = "<p>Saws off the barrel.</p>"
	.["Energy Weapon"] = "<p>Saws off the barrel. The weapon must be turned on.</p>"
	.["Plasma Cutter"] = "<p>Saws off the barrel.</p>"


/obj/item/gun/projectile/shotgun/doublebarrel/use_tool(obj/item/tool, mob/user, list/click_params)
	// Circular Saw - Shorten barrel
	if (istype(tool, /obj/item/circular_saw))
		shorten_barrel(tool, user)
		return TRUE

	// Energy Weapon - Shorten barrel
	if (istype(tool, /obj/item/melee/energy))
		var/obj/item/melee/energy/energy_weapon = tool
		if (!energy_weapon.active)
			to_chat(user, SPAN_WARNING("\The [tool] needs to be turned on before it can cut \the [src]'s barrel."))
			return TRUE
		shorten_barrel(tool, user)
		return TRUE

	// Plasma Cutter - Shorten barrel
	if (istype(tool, /obj/item/gun/energy/plasmacutter))
		var/obj/item/gun/energy/plasmacutter/plasmacutter = tool
		if (!plasmacutter.slice(user))
			return TRUE
		shorten_barrel(tool, user)
		return TRUE

	return ..()


/obj/item/gun/projectile/shotgun/doublebarrel/proc/shorten_barrel(obj/item/tool, mob/user)
	if (w_class <= 3)
		to_chat(user, SPAN_WARNING("\The [src]'s barrel is too short to cut off."))
		return
	user.visible_message(
		SPAN_NOTICE("\The [user] begins to cut off \the [src]'s barrel with \a [tool]."),
		SPAN_NOTICE("You begin to cut off \the [src]'s barrel with \the [tool].")
	)
	if (length(loaded))
		for (var/i in 1 to max_shells)
			Fire(user, user)
		user.visible_message(
			SPAN_WARNING("\The [src] goes off in \the [user]'s face!"),
			SPAN_DANGER("\The [src] goes off in your face!")
		)
		return
	var/do_flags = loc == user ? DO_BAR_OVER_USER : EMPTY_BITFIELD
	if (!do_after(user, 3 SECONDS, src, DO_PUBLIC_UNIQUE | do_flags) || !user.use_sanity_check(src, tool, SANITY_CHECK_TARGET_UNEQUIP))
		return
	user.unEquip(src)
	var/obj/item/gun/projectile/shotgun/doublebarrel/sawn/empty/new_gun = new(loc)
	transfer_fingerprints_to(new_gun)
	user.visible_message(
		SPAN_NOTICE("\The [user] shortens \the [src]'s barrel with \a [tool]."),
		SPAN_NOTICE("You shorten \the [src]'s barrel with \a [tool].")
	)
	qdel(src)
	return


/obj/item/gun/projectile/shotgun/doublebarrel/sawn
	name = "sawn-off shotgun"
	desc = "A ubiquitous weapon, commonplace in almost every settlement and slum. It is one of many basic firearms for those who want to be able to defend themselves with as little fuss as possible. Produced by Novaya Zemlya Arms."
	icon_state = "sawnshotgun"
	item_state = "sawnshotgun"
	wielded_item_state = "sawnshotgun-wielded"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	w_class = ITEM_SIZE_NORMAL
	force = 5
	one_hand_penalty = 4
	bulk = 2

/obj/item/gun/projectile/shotgun/doublebarrel/sawn/empty
	starts_loaded = FALSE
