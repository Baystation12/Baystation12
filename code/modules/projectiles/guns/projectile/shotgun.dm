/obj/item/gun/projectile/shotgun
	abstract_type = /obj/item/gun/projectile/shotgun
	name = "master shotgun object"
	desc = "You should not see this."

	fire_sound = 'sound/weapons/gunshot/shotgun.ogg'
	racksound = 'sound/weapons/guns/interaction/shotgunpump.ogg'
	load_sound = 'sound/weapons/guns/interaction/shotgun_insert.ogg'

	force = 10
	rackdelay = 10

	w_class = ITEM_SIZE_HUGE
	handle_casings = HOLD_CASINGS
	caliber = CALIBER_SHOTGUN
	load_method = SINGLE_CASING
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	bulk = GUN_BULK_HEAVY_RIFLE


/obj/item/gun/projectile/shotgun/pump
	name = "shotgun"
	desc = "A mass-produced shotgun by Mars Security Industries. The rugged MSI-870 'Crawford' is a common sight across much of \
			settled space. Useful for sweeping alleys or ship corridors."

	icon = 'icons/obj/guns/shotguns.dmi'
	icon_state = "shotgun"
	item_state = "shotgun"
	wielded_item_state = "shotgun-wielded"

	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	hold_open = FALSE

	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	one_hand_penalty = 8
	max_shells = 4


/obj/item/gun/projectile/shotgun/on_update_icon()
	..()
	if(length(loaded))
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-empty"


/obj/item/gun/projectile/shotgun/pump/on_update_icon()
	..()
	if(!bolt_open)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-empty"


/obj/item/gun/projectile/shotgun/pump/consume_next_projectile()
	if(chambered)
		return chambered.BB
	return null


/obj/item/gun/projectile/shotgun/pump/use_tool(obj/item/tool, mob/user, list/click_params)
	if (istype(tool, /obj/item/ammo_magazine/shotholder))
		var/obj/item/ammo_magazine/shotholder/SH = tool
		if (!length(SH.stored_ammo))
			return TRUE
		if (user.a_intent != I_HURT)
			return TRUE
		var/obj/item/ammo_casing/C = SH.stored_ammo[length(SH.stored_ammo)]
		SH.stored_ammo-=C
		load_ammo(C, user)

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
	desc = "A mass-produced shotgun by Mars Security Industries. The rugged MSI-870 is a common sight across much of settled space. \
			MSI sells its own 'riot' configuration as the 870 'Bateman'."

	icon = 'icons/obj/guns/shotguns.dmi'
	icon_state = "rshotgun"
	item_state = "rshotgun"
	wielded_item_state = "rshotgun-wielded"

	w_class = ITEM_SIZE_LARGE
	slot_flags = SLOT_BELT|SLOT_BACK
	bulk = GUN_BULK_LIGHT_RIFLE

	force = 5
	max_shells = 4
	one_hand_penalty = 4
	accuracy = -1


/obj/item/gun/projectile/shotgun/pump/combat
	name = "combat shotgun"
	desc = "Built for close quarters combat, the Hephaestus Industries KS-40 is widely regarded as a weapon of choice for \
			repelling boarders."
	icon_state = "cshotgun"
	item_state = "cshotgun"
	wielded_item_state = "cshotgun-wielded"

	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)

	ammo_type = /obj/item/ammo_casing/shotgun
	one_hand_penalty = 8
	max_shells = 7 // Match the ammo box capacity, also it can hold a round in the chamber anyways, for a total of 8.
	rackdelay = 5 // Faster to cycle.


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
	desc = "A classic double-barreled shotgun. In production for centuries, it has proliferated across human space, \
			earning a sizable reputation for being simple and effective. This one is produced by Novaya Zemlya Arms."

	icon = 'icons/obj/guns/shotguns.dmi'
	icon_state = "dshotgun"
	item_state = "dshotgun"
	wielded_item_state = "dshotgun-wielded"
	wielded_item_state = "gun_wielded"

	load_method = SINGLE_CASING|SPEEDLOADER //SPEEDLOADER because rapid unloading.
	handle_casings = CYCLE_CASINGS
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 1)
	allow_dump = TRUE

	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	one_hand_penalty = 8
	max_shells = 2
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
	desc = "A ubiquitous weapon, commonplace in almost every settlement and slum. It is one of many basic firearms \
			for those who want to be able to defend themselves with as little fuss as possible. \
			This one is produced by Novaya Zemlya Arms."
	icon_state = "sawnshotgun"
	item_state = "sawnshotgun"
	wielded_item_state = "sawnshotgun-wielded"

	slot_flags = SLOT_BELT|SLOT_HOLSTER
	w_class = ITEM_SIZE_NORMAL
	bulk = GUN_BULK_LIGHT_RIFLE - 2

	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	force = 5
	one_hand_penalty = 4
	accuracy = -1


/obj/item/gun/projectile/shotgun/doublebarrel/sawn/empty
	starts_loaded = FALSE


/obj/item/gun/projectile/shotgun/flare
	name = "flare launcher"
	desc = "A single shot polymer flare gun, the XI-54 'Sirius' is a reliable way to launch flares away from yourself."

	icon = 'icons/obj/guns/flaregun.dmi'
	icon_state = "flaregun"
	item_state = "flaregun"

	fire_sound = 'sound/weapons/empty.ogg'
	load_sound = 'sound/weapons/guns/interaction/shotgun_insert.ogg'
	fire_sound = 'sound/weapons/gunshot/shotgun.ogg'
	fire_sound_text = "a satisfying 'thump'"

	matter = list(MATERIAL_STEEL = 1500, MATERIAL_PLASTIC = 2000)
	handle_casings = CYCLE_CASINGS
	load_method = SINGLE_CASING|SPEEDLOADER
	slot_flags = SLOT_BELT | SLOT_HOLSTER
	w_class = ITEM_SIZE_SMALL
	obj_flags = 0

	max_shells = 1


/obj/item/gun/projectile/shotgun/flare/loaded
	ammo_type = /obj/item/ammo_casing/shotgun/flash


/obj/item/gun/projectile/shotgun/flare/examine(mob/user, distance)
	. = ..()
	if(distance <= 2 && length(loaded))
		to_chat(user, "\A [loaded[1]] is chambered.")


/obj/item/gun/projectile/shotgun/flare/special_check()
	if(!length(loaded))
		return
	var/obj/item/ammo_casing/casing = loaded[1]
	if(istype(casing) && istype(casing.BB) && !istype(casing, /obj/item/ammo_casing/shotgun/flash))
		var/damage = casing.BB.get_structure_damage()
		if(istype(casing.BB, /obj/item/projectile/bullet/pellet))
			var/obj/item/projectile/bullet/pellet/PP = casing.BB
			damage = PP.damage*PP.pellets
		if(damage > 5)
			var/mob/living/carbon/C = loc
			if(istype(C))
				C.visible_message(
					SPAN_DANGER("[src] explodes in [C]'s hands!"),
					SPAN_DANGER("[src] explodes in your face!")
				)
				C.drop_from_inventory(src)
				for(var/zone in list(BP_L_HAND, BP_R_HAND))
					C.apply_damage(rand(10,20), def_zone=zone)
			else
				visible_message(SPAN_DANGER("[src] explodes!"))
			explosion(get_turf(src), 1, EX_ACT_LIGHT)
			qdel(src)
			return FALSE
	return ..()
