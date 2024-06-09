/obj/item/gun/magnetic
	name = "improvised coilgun"
	desc = "A coilgun hastily thrown together out of a basic frame and advanced power storage components. Is it safe for it to be duct-taped together like that?"
	icon = 'icons/obj/guns/coilgun.dmi'
	icon_state = "coilgun"
	item_state = "coilgun"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_MAGNET = 4)
	one_hand_penalty = 5
	fire_delay = 20
	w_class = ITEM_SIZE_LARGE
	bulk = GUN_BULK_RIFLE
	combustion = 1

	var/obj/item/cell/cell                              // Currently installed powercell.
	var/obj/item/stock_parts/capacitor/capacitor        // Installed capacitor. Higher rating == faster charge between shots.
	var/removable_components = TRUE                            // Whether or not the gun can be dismantled.
	var/gun_unreliable = 15                                    // Percentage chance of detonating in your hands.

	var/obj/item/loaded                                        // Currently loaded object, for retrieval/unloading.
	var/load_type = /obj/item/stack/material/rods                       // Type of stack to load with.
	var/load_sheet_max = 1									   // Maximum number of "sheets" you can load from a stack.
	var/projectile_type = /obj/item/projectile/bullet/magnetic // Actual fire type, since this isn't throw_at rod launcher.

	var/power_cost = 950                                       // Cost per fire, should consume almost an entire basic cell.
	var/power_per_tick                                         // Capacitor charge per process(). Updated based on capacitor rating.
	serial = EMPTY_BITFIELD

/obj/item/gun/magnetic/preloaded
	cell = /obj/item/cell/high
	capacitor = /obj/item/stock_parts/capacitor/adv

/obj/item/gun/magnetic/Initialize()
	START_PROCESSING(SSobj, src)

	if (ispath(cell))
		cell = new cell(src)
	if (ispath(capacitor))
		capacitor = new capacitor(src)
		capacitor.charge = capacitor.max_charge
	if (ispath(loaded))
		loaded = new loaded (src, load_sheet_max)

	if(capacitor)
		power_per_tick = (power_cost*0.15) * capacitor.rating
	update_icon()
	. = ..()

/obj/item/gun/magnetic/Destroy()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(cell)
	QDEL_NULL(loaded)
	QDEL_NULL(capacitor)
	. = ..()

/obj/item/gun/magnetic/get_cell()
	return cell

/obj/item/gun/magnetic/Process()
	if(capacitor)
		if(cell)
			if(capacitor.charge < capacitor.max_charge && cell.checked_use(power_per_tick))
				capacitor.charge(power_per_tick)
		else
			if(capacitor)
				capacitor.use(capacitor.charge * 0.05)
	update_icon()

/obj/item/gun/magnetic/on_update_icon()
	..()
	var/list/overlays_to_add = list()
	if(removable_components)
		if(cell)
			overlays_to_add += image(icon, "[icon_state]_cell")
		if(capacitor)
			overlays_to_add += image(icon, "[icon_state]_capacitor")
	if(!cell || !capacitor)
		overlays_to_add += image(icon, "[icon_state]_red")
	else if(capacitor.charge < power_cost)
		overlays_to_add += image(icon, "[icon_state]_amber")
	else
		overlays_to_add += image(icon, "[icon_state]_green")
	if(loaded)
		overlays_to_add += image(icon, "[icon_state]_loaded")
		var/obj/item/magnetic_ammo/mag = loaded
		if(istype(mag))
			if(mag.remaining)
				overlays_to_add += image(icon, "[icon_state]_ammo")

	AddOverlays(overlays_to_add)

/obj/item/gun/magnetic/proc/show_ammo(mob/user)
	if(loaded)
		to_chat(user, SPAN_NOTICE("It has \a [loaded] loaded."))

/obj/item/gun/magnetic/examine(mob/user)
	. = ..()
	if(cell)
		to_chat(user, SPAN_NOTICE("The installed [cell.name] has a charge level of [round((cell.charge/cell.maxcharge)*100)]%."))
	if(capacitor)
		to_chat(user, SPAN_NOTICE("The installed [capacitor.name] has a charge level of [round((capacitor.charge/capacitor.max_charge)*100)]%."))
	if(!cell || !capacitor)
		to_chat(user, SPAN_NOTICE("The capacitor charge indicator is blinking [SPAN_COLOR("[COLOR_RED]", "red")]. Maybe you should check the cell or capacitor."))
	else
		if(capacitor.charge < power_cost)
			to_chat(user, SPAN_NOTICE("The capacitor charge indicator is [SPAN_COLOR("[COLOR_ORANGE]", "amber")]."))
		else
			to_chat(user, SPAN_NOTICE("The capacitor charge indicator is [SPAN_COLOR("[COLOR_GREEN]", "green")]."))


/obj/item/gun/magnetic/use_tool(obj/item/tool, mob/user, list/click_params)
	// Capacitor - Install capacitor
	if (istype(tool, /obj/item/stock_parts/capacitor))
		if (!removable_components)
			USE_FEEDBACK_FAILURE("\The [src]'s components can't be swapped out.")
			return TRUE
		if (capacitor)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [capacitor] installed.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		capacitor = tool
		power_per_tick = (power_cost * 0.15) * capacitor.rating
		update_icon()
		playsound(src, 'sound/machines/click.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] slots \a [tool] into \a [src]."),
			SPAN_NOTICE("You slot \the [tool] into \the [src].")
		)
		return TRUE

	// Cell - Install cell
	if (istype(tool, /obj/item/cell))
		if (!removable_components)
			USE_FEEDBACK_FAILURE("\The [src]'s components can't be swapped out.")
			return TRUE
		if (cell)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [cell] installed.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		cell = tool
		update_icon()
		playsound(src, 'sound/machines/click.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] slots \a [tool] into \a [src]."),
			SPAN_NOTICE("You slot \the [tool] into \the [src].")
		)
		return TRUE

	// Screwdriver - Remove capacitor
	if (isScrewdriver(tool))
		if (!removable_components)
			USE_FEEDBACK_FAILURE("\The [src]'s components can't be swapped out.")
			return TRUE
		if (!capacitor)
			USE_FEEDBACK_FAILURE("\The [src] has no capacitor to remove.")
			return TRUE
		user.put_in_hands(capacitor)
		playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] detaches \a [capacitor] from \a [src] with \a [tool]."),
			SPAN_NOTICE("You detach \the [capacitor] from \the [src] with \the [tool].")
		)
		capacitor = null
		power_per_tick = 0
		update_icon()
		return TRUE

	// Attempt to load ammo
	if (istype(tool, load_type))
		// This is not strictly necessary for the magnetic gun but something using
		// specific ammo types may exist down the track.
		if (isstack(tool))
			var/obj/item/stack/ammo = tool
			var/ammo_count = 0
			var/obj/item/stack/loaded_ammo = loaded
			if (!istype(loaded_ammo))
				if (loaded)
					USE_FEEDBACK_FAILURE("\The [src] already has \a [loaded] loaded.")
					return TRUE
				ammo_count = min(load_sheet_max, ammo.amount)
				loaded = new load_type(src, ammo_count)
				loaded_ammo = loaded
			else
				if (loaded_ammo.type != ammo.type)
					USE_FEEDBACK_FAILURE("\The [src] is currently loaded with [loaded_ammo.get_stack_name()]. \The [ammo.get_stack_name()] is not cannot be mixed with this.")
					return TRUE
				ammo_count = min(load_sheet_max - loaded_ammo.amount, ammo.amount)
				loaded_ammo.amount += ammo_count
			if (!ammo_count)
				USE_FEEDBACK_FAILURE("\The [src] is already fully loaded.")
				return TRUE
			ammo.use(ammo_count)
			user.visible_message(
				SPAN_NOTICE("\The [user] loads \a [src] with [ammo.get_vague_name(ammo_count > 1)]."),
				SPAN_NOTICE("You load \the [src] with [ammo.get_exact_name(ammo_count)].")
			)
			if (load_sheet_max > 1)
				to_chat(user, SPAN_INFO("\The [src] now has [loaded_ammo.get_exact_name()] out of [load_sheet_max] loaded."))
		else
			if (loaded)
				USE_FEEDBACK_FAILURE("\The [src] already has \a [loaded] loaded.")
				return TRUE
			if (!user.unEquip(tool, src))
				FEEDBACK_UNEQUIP_FAILURE(user, tool)
				return TRUE
			if (istype(tool, /obj/item/magnetic_ammo))
				var/obj/item/magnetic_ammo/mag = tool
				if (load_type != mag.basetype)
					USE_FEEDBACK_FAILURE("\The [mag] doesn't fit in \the [src].")
					return TRUE
				projectile_type = mag.projectile_type
			loaded = tool
		playsound(src, 'sound/weapons/flipblade.ogg', 50, TRUE)
		update_icon()
		return TRUE

	return ..()


/obj/item/gun/magnetic/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		var/obj/item/removing

		if(loaded)
			removing = loaded
			loaded = null
		else if(cell && removable_components)
			removing = cell
			cell = null

		if(removing)
			user.put_in_hands(removing)
			user.visible_message(SPAN_NOTICE("\The [user] removes \the [removing] from \the [src]."))
			playsound(loc, 'sound/machines/click.ogg', 10, 1)
			update_icon()
			return
	. = ..()

/obj/item/gun/magnetic/proc/check_ammo()
	return loaded

/obj/item/gun/magnetic/proc/use_ammo()
	qdel(loaded)
	loaded = null

/obj/item/gun/magnetic/consume_next_projectile()

	if(!check_ammo() || !capacitor || capacitor.charge < power_cost)
		return

	use_ammo()
	capacitor.use(power_cost)
	update_icon()

	if(gun_unreliable && prob(gun_unreliable))
		spawn(3) // So that it will still fire - considered modifying Fire() to return a value but burst fire makes that annoying.
			visible_message(SPAN_DANGER("\The [src] explodes with the force of the shot!"))
			explosion(get_turf(src), 2, EX_ACT_LIGHT)
			qdel(src)

	return new projectile_type(src)
