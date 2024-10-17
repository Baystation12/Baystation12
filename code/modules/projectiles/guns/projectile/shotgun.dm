/obj/item/gun/projectile/shotgun
	abstract_type = /obj/item/gun/projectile/shotgun
	name = "master shotgun object"
	desc = "You should not see this."
	fire_sound = 'sound/weapons/gunshot/shotgun.ogg'

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

/obj/item/gun/projectile/shotgun/pump/on_update_icon()
	..()
	if(chambered)
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
			var/fail_chance = user.skill_fail_chance(SKILL_WEAPONS, 90, SKILL_EXPERIENCED, 0.25)
			var/drop_chance = user.skill_fail_chance(SKILL_WEAPONS, 50, SKILL_EXPERIENCED, 0.5)

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
	if (type != /obj/item/gun/projectile/shotgun/pump)
		return ..() // ugly hack for now, /pump needs abstracting

	// Circular saw, energy sword, plasma cutter - Saw off stock
	if (is_type_in_list(tool, list(/obj/item/circular_saw, /obj/item/melee/energy, /obj/item/gun/energy/plasmacutter)))
		if (!user.canUnEquip(src))
			FEEDBACK_UNEQUIP_FAILURE(user, src)
			return TRUE
		if (istype(tool, /obj/item/melee/energy))
			var/obj/item/melee/energy/energy = tool
			if (!energy.active)
				USE_FEEDBACK_FAILURE("\The [tool] needs to be active to cut \the [src]'s stock.")
				return TRUE
		if (istype(tool, /obj/item/gun/energy/plasmacutter))
			var/obj/item/gun/energy/plasmacutter/plasmacutter = tool
			if (!plasmacutter.slice(user))
				return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] starts sawing \a [src]'s stock off with \a [tool]."),
			SPAN_NOTICE("You start sawing \the [src]'s stock off with \the [tool].")
		)
		if (!user.do_skilled(5 SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_PUBLIC_UNIQUE) || !user.use_sanity_check(src, tool, SANITY_CHECK_TARGET_UNEQUIP))
			return TRUE
		user.unEquip(src)
		var/obj/item/gun/projectile/shotgun/pump/sawn/sawn = new (get_turf(src))
		transfer_fingerprints_to(sawn)
		sawn.add_fingerprint(user, tool = tool)
		user.visible_message(
			SPAN_NOTICE("\The [user] saws \a [src]'s stock off with \a [tool]."),
			SPAN_NOTICE("You saw \the [src]'s stock off with \the [tool].")
		)
		qdel_self()
		return TRUE

	return ..()

/obj/item/gun/projectile/shotgun/pump/DrawChamber()
	var/chamberlist = ""
	if (chambered)
		if (chambered.BB)
			chamberlist += "◉|"
		else
			chamberlist += "◎|"
	else
		chamberlist += "🌣|"
	if (length(loaded) > 0)
		var/obj/item/ammo_casing/casinglist = loaded
		if (casinglist[1].BB)
			chamberlist += "◉"
		else
			chamberlist += "◎"
	else
		chamberlist += "🌣"
	return chamberlist

/obj/item/gun/projectile/shotgun/pump/empty
	starts_loaded = FALSE

/obj/item/gun/projectile/shotgun/pump/sawn
	name = "riot shotgun"
	desc = "A mass-produced shotgun by Mars Security Industries. The rugged ZX-870 'Bulldog' is common throughout most frontier worlds. This one has had its stock cut off..."
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
	wielded_item_state = "rshotgun-wielded"
	load_sound = 'sound/weapons/guns/interaction/shotgun_instert.ogg'


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
			AddOverlays(I)

/obj/item/gun/projectile/shotgun/pump/combat/empty
	starts_loaded = FALSE

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


//this is largely hacky and bad :(	-Pete
/obj/item/gun/projectile/shotgun/doublebarrel/use_tool(obj/item/tool, mob/user, list/click_params)
	// Circular saw, energy sword, plasmacutter - Shorten barrel
	if (is_type_in_list(tool, list(/obj/item/circular_saw, /obj/item/melee/energy, /obj/item/gun/energy/plasmacutter)))
		if (w_class <= 3)
			USE_FEEDBACK_FAILURE("\The [src]'s barrel can't be shortened any further.")
			return TRUE
		if (!user.canUnEquip(src))
			FEEDBACK_UNEQUIP_FAILURE(user, src)
			return TRUE
		if (istype(tool, /obj/item/melee/energy))
			var/obj/item/melee/energy/energy = tool
			if (!energy.active)
				USE_FEEDBACK_FAILURE("\The [tool] needs to be active to cut \the [src]'s barrel.")
				return TRUE
		if (istype(tool, /obj/item/gun/energy/plasmacutter))
			var/obj/item/gun/energy/plasmacutter/plasmacutter = tool
			if (!plasmacutter.slice(user))
				return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] starts shortening \a [src]'s barrel with \a [tool]."),
			SPAN_NOTICE("You start shortening \the [src]'s barrel with \the [tool].")
		)
		if (length(loaded))
			for (var/i in 1 to max_shells)
				Fire(user, user)
			visible_message(
				SPAN_DANGER("\The [src] goes off!"),
				SPAN_DANGER("You hear a gunshot!")
			)
			return TRUE
		if (!user.do_skilled(3 SECONDS, SKILL_CONSTRUCTION, src) || !user.use_sanity_check(src, tool, SANITY_CHECK_TARGET_UNEQUIP))
			return TRUE
		if (istype(tool, /obj/item/melee/energy))
			var/obj/item/melee/energy/energy = tool
			if (!energy.active)
				USE_FEEDBACK_FAILURE("\The [tool] needs to be active to cut \the [src]'s barrel.")
				return TRUE
		if (istype(tool, /obj/item/gun/energy/plasmacutter))
			var/obj/item/gun/energy/plasmacutter/plasmacutter = tool
			if (!plasmacutter.slice(user))
				return TRUE
		user.unEquip(src)
		var/obj/item/gun/projectile/shotgun/doublebarrel/sawn/empty/new_gun = new(get_turf(src))
		transfer_fingerprints_to(new_gun)
		new_gun.add_fingerprint(user, tool = tool)
		user.visible_message(
			SPAN_NOTICE("\The [user] shortens \a [src]'s barrel with \a [tool]."),
			SPAN_NOTICE("You shorten \the [src]'s barrel with \the [tool].")
		)
		qdel_self()
		return TRUE

	return ..()


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

/obj/item/gun/projectile/shotgun/magshot
	name = "auto shotgun"
	desc = "A remnant of a bygone era, the NZ CSG-242 was formerly standard issue for Confederate Naval Forces for ship defense during hostile boarding actions. With a change in doctrine after the losses at Gaia, and with more focus on a multi-role weapons platform, the weapon is slowly being phased out of service."
	icon = 'icons/obj/guns/magshot.dmi'
	icon_state = "magshot"
	item_state = "magshot"
	wielded_item_state = "magshot-wielded"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/shotgunmag
	allowed_magazines = list(/obj/item/ammo_magazine/shotgunmag)
	w_class = ITEM_SIZE_HUGE
	force = 10
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BACK
	caliber = CALIBER_SHOTGUN
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 1)
	auto_eject = TRUE
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	fire_sound = 'sound/weapons/gunshot/shotgun.ogg'
	one_hand_penalty = 8
	bulk = GUN_BULK_RIFLE
	burst_delay = 2
	accuracy = -1
	jam_chance = 0.5
	safety_icon = "safety"

	firemodes = list(
		list(mode_name="semi-auto",     burst=1, fire_delay=2, move_delay=3, one_hand_penalty=7, burst_accuracy=null, dispersion=1.5),
		list(mode_name="3 shell burst", burst=3, fire_delay=1.5, move_delay=6, one_hand_penalty=9, burst_accuracy=list(-1,-1, -2), dispersion=list(2, 2, 4)),
		list(mode_name="full auto",		can_autofire=TRUE, burst=1, fire_delay=1, move_delay=6, one_hand_penalty=15, burst_accuracy = list(-1,-2,-2,-3,-3,-3,-4,-4), dispersion = list(2, 4, 4, 6, 6, 8))
		)

/obj/item/gun/projectile/shotgun/magshot/on_update_icon()
	..()

	if(ammo_magazine)
		icon_state = initial(icon_state)
		wielded_item_state = initial(wielded_item_state)

		if(LAZYLEN(ammo_magazine.stored_ammo) == ammo_magazine.max_ammo)
			AddOverlays(image(icon, "ammo100"))
		else if(LAZYLEN(ammo_magazine.stored_ammo) <= 0.75 * ammo_magazine.max_ammo)
			AddOverlays(image(icon, "ammo75"))
		else if(LAZYLEN(ammo_magazine.stored_ammo) <= 0.5 * ammo_magazine.max_ammo)
			AddOverlays(image(icon, "ammo50"))
		else
			AddOverlays(image(icon, "ammo25"))

	else
		icon_state = "[initial(icon_state)]-empty"
		wielded_item_state = "[initial(wielded_item_state)]-empty"
