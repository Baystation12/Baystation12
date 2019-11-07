/obj/item/weapon/gun/magnetic
	name = "improvised coilgun"
	desc = "A coilgun hastily thrown together out of a basic frame and advanced power storage components. Is it safe for it to be duct-taped together like that?"
	icon = 'icons/obj/guns/coilgun.dmi'
	icon_state = "coilgun"
	item_state = "coilgun"
	one_hand_penalty = 5
	fire_delay = 20
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4, TECH_ESOTERIC = 2, TECH_MAGNET = 4)
	w_class = ITEM_SIZE_LARGE
	bulk = GUN_BULK_RIFLE
	combustion = 1

	var/obj/item/weapon/cell/cell                              // Currently installed powercell.
	var/obj/item/weapon/stock_parts/capacitor/capacitor        // Installed capacitor. Higher rating == faster charge between shots.
	var/removable_components = TRUE                            // Whether or not the gun can be dismantled.
	var/gun_unreliable = 15                                    // Percentage chance of detonating in your hands.

	var/obj/item/loaded                                        // Currently loaded object, for retrieval/unloading.
	var/load_type = /obj/item/stack/material/rods                       // Type of stack to load with.
	var/load_sheet_max = 1									   // Maximum number of "sheets" you can load from a stack.
	var/projectile_type = /obj/item/projectile/bullet/magnetic // Actual fire type, since this isn't throw_at rod launcher.

	var/power_cost = 950                                       // Cost per fire, should consume almost an entire basic cell.
	var/power_per_tick                                         // Capacitor charge per process(). Updated based on capacitor rating.

/obj/item/weapon/gun/magnetic/Initialize()
	START_PROCESSING(SSobj, src)
	if(capacitor)
		power_per_tick = (power_cost*0.15) * capacitor.rating
	update_icon()
	. = ..()

/obj/item/weapon/gun/magnetic/Destroy()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(cell)
	QDEL_NULL(loaded)
	QDEL_NULL(capacitor)
	. = ..()

/obj/item/weapon/gun/magnetic/get_cell()
	return cell

/obj/item/weapon/gun/magnetic/Process()
	if(capacitor)
		if(cell)
			if(capacitor.charge < capacitor.max_charge && cell.checked_use(power_per_tick))
				capacitor.charge(power_per_tick)
		else
			if(capacitor)
				capacitor.use(capacitor.charge * 0.05)
	update_icon()

/obj/item/weapon/gun/magnetic/on_update_icon()
	. = ..()
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
		var/obj/item/weapon/magnetic_ammo/mag = loaded
		if(istype(mag))
			if(mag.remaining)
				overlays_to_add += image(icon, "[icon_state]_ammo")

	overlays += overlays_to_add

/obj/item/weapon/gun/magnetic/proc/show_ammo(var/mob/user)
	if(loaded)
		to_chat(user, "<span class='notice'>It has \a [loaded] loaded.</span>")

/obj/item/weapon/gun/magnetic/examine(mob/user)
	. = ..()
	if(cell)
		to_chat(user, "<span class='notice'>The installed [cell.name] has a charge level of [round((cell.charge/cell.maxcharge)*100)]%.</span>")
	if(capacitor)
		to_chat(user, "<span class='notice'>The installed [capacitor.name] has a charge level of [round((capacitor.charge/capacitor.max_charge)*100)]%.</span>")
	if(!cell || !capacitor)
		to_chat(user, "<span class='notice'>The capacitor charge indicator is blinking <font color ='[COLOR_RED]'>red</font>. Maybe you should check the cell or capacitor.</span>")
	else
		if(capacitor.charge < power_cost)
			to_chat(user, "<span class='notice'>The capacitor charge indicator is <font color ='[COLOR_ORANGE]'>amber</font>.</span>")
		else
			to_chat(user, "<span class='notice'>The capacitor charge indicator is <font color ='[COLOR_GREEN]'>green</font>.</span>")

/obj/item/weapon/gun/magnetic/attackby(var/obj/item/thing, var/mob/user)

	if(removable_components)
		if(istype(thing, /obj/item/weapon/cell))
			if(cell)
				to_chat(user, "<span class='warning'>\The [src] already has \a [cell] installed.</span>")
				return
			if(!user.unEquip(thing, src))
				return
			cell = thing
			playsound(loc, 'sound/machines/click.ogg', 10, 1)
			user.visible_message("<span class='notice'>\The [user] slots \the [cell] into \the [src].</span>")
			update_icon()
			return

		if(isScrewdriver(thing))
			if(!capacitor)
				to_chat(user, "<span class='warning'>\The [src] has no capacitor installed.</span>")
				return
			user.put_in_hands(capacitor)
			user.visible_message("<span class='notice'>\The [user] unscrews \the [capacitor] from \the [src].</span>")
			playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
			capacitor = null
			update_icon()
			return

		if(istype(thing, /obj/item/weapon/stock_parts/capacitor))
			if(capacitor)
				to_chat(user, "<span class='warning'>\The [src] already has \a [capacitor] installed.</span>")
				return
			if(!user.unEquip(thing, src))
				return
			capacitor = thing
			playsound(loc, 'sound/machines/click.ogg', 10, 1)
			power_per_tick = (power_cost*0.15) * capacitor.rating
			user.visible_message("<span class='notice'>\The [user] slots \the [capacitor] into \the [src].</span>")
			update_icon()
			return

	if(istype(thing, load_type))

		// This is not strictly necessary for the magnetic gun but something using
		// specific ammo types may exist down the track.
		var/obj/item/stack/ammo = thing
		if(!istype(ammo))
			if(loaded)
				to_chat(user, "<span class='warning'>\The [src] already has \a [loaded] loaded.</span>")
				return
			var/obj/item/weapon/magnetic_ammo/mag = thing
			if(istype(mag))
				if(!(load_type == mag.basetype))
					to_chat(user, "<span class='warning'>\The [src] doesn't seem to accept \a [mag].</span>")
					return
				projectile_type = mag.projectile_type
			if(!user.unEquip(thing, src))
				return

			loaded = thing
		else if(load_sheet_max > 1)
			var ammo_count = 0
			var/obj/item/stack/loaded_ammo = loaded
			if(!istype(loaded_ammo))
				ammo_count = min(load_sheet_max,ammo.amount)
				loaded = new load_type(src, ammo_count)
			else
				ammo_count = min(load_sheet_max-loaded_ammo.amount,ammo.amount)
				loaded_ammo.amount += ammo_count
			if(ammo_count <= 0)
				// This will also display when someone tries to insert a stack of 0, but that shouldn't ever happen anyway.
				to_chat(user, "<span class='warning'>\The [src] is already fully loaded.</span>")
				return
			ammo.use(ammo_count)
		else
			if(loaded)
				to_chat(user, "<span class='warning'>\The [src] already has \a [loaded] loaded.</span>")
				return
			loaded = new load_type(src, 1)
			ammo.use(1)

		user.visible_message("<span class='notice'>\The [user] loads \the [src] with \the [loaded].</span>")
		playsound(loc, 'sound/weapons/flipblade.ogg', 50, 1)
		update_icon()
		return
	. = ..()

/obj/item/weapon/gun/magnetic/attack_hand(var/mob/user)
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
			user.visible_message("<span class='notice'>\The [user] removes \the [removing] from \the [src].</span>")
			playsound(loc, 'sound/machines/click.ogg', 10, 1)
			update_icon()
			return
	. = ..()

/obj/item/weapon/gun/magnetic/proc/check_ammo()
	return loaded

/obj/item/weapon/gun/magnetic/proc/use_ammo()
	qdel(loaded)
	loaded = null

/obj/item/weapon/gun/magnetic/consume_next_projectile()

	if(!check_ammo() || !capacitor || capacitor.charge < power_cost)
		return

	use_ammo()
	capacitor.use(power_cost)
	update_icon()

	if(gun_unreliable && prob(gun_unreliable))
		spawn(3) // So that it will still fire - considered modifying Fire() to return a value but burst fire makes that annoying.
			visible_message("<span class='danger'>\The [src] explodes with the force of the shot!</span>")
			explosion(get_turf(src), -1, 0, 2)
			qdel(src)

	return new projectile_type(src)