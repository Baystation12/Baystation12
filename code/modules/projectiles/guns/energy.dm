/obj/item/gun/energy
	name = "energy gun"
	desc = "A basic energy-based gun."
	icon = 'icons/obj/guns/basic_energy.dmi'
	icon_state = "energy"
	fire_sound = 'sound/weapons/Taser.ogg'
	fire_sound_text = "laser blast"
	accuracy = 1

	var/obj/item/cell/power_supply //What type of power cell this uses
	var/charge_cost = 20 //How much energy is needed to fire.
	var/max_shots = 10 //Determines the capacity of the weapon's power cell. Specifying a cell_type overrides this value.
	var/cell_type = null
	var/projectile_type = /obj/item/projectile/beam/practice
	var/modifystate
	var/charge_meter = 1	//if set, the icon state will be chosen based on the current charge

	//self-recharging
	var/self_recharge = 0	//if set, the weapon will recharge itself
	var/use_external_power = 0 //if set, the weapon will look for an external power source to draw from, otherwise it recharges magically
	var/recharge_time = 4
	var/charge_tick = 0

	var/no_reloadable = 0

	var/hatch_open = 0 //determines if you can insert a cell in/detach a cell

	var/reload_time = 5 SECONDS

	var/mag_insert_sound = 'sound/weapons/guns/interaction/energy_magin.ogg'
	var/mag_remove_sound = 'sound/weapons/guns/interaction/pistol_magout.ogg'

/obj/item/gun/energy/switch_firemodes()
	. = ..()
	if(.)
		update_icon()

/obj/item/gun/energy/emp_act(severity)
	..()
	update_icon()

/obj/item/gun/energy/Initialize()
	. = ..()
	if(cell_type)
		power_supply = new cell_type(src)
	else
		power_supply = new /obj/item/cell/device/variable(src, max_shots*charge_cost)
	if(self_recharge)
		START_PROCESSING(SSobj, src)
	update_icon()

/obj/item/gun/energy/Destroy()
	if(self_recharge)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/gun/energy/get_cell()
	return power_supply

/obj/item/gun/energy/Process()
	if(self_recharge) //Every [recharge_time] ticks, recharge a shot for the cyborg
		charge_tick++
		if(charge_tick < recharge_time) return 0
		charge_tick = 0

		if(!power_supply || power_supply.charge >= power_supply.maxcharge)
			return 0 // check if we actually need to recharge

		if(use_external_power)
			var/obj/item/cell/external = get_external_power_supply()
			if(!external || !external.use(charge_cost)) //Take power from the borg...
				return 0

		power_supply.give(charge_cost) //... to recharge the shot
		update_icon()
	return 1

/obj/item/gun/energy/special_check(var/mob/user)

	if(!..())
		return

	if(hatch_open)
		to_chat(user, "<span class='warning'>[src] has its cell cover still open!</span>")
		return 0
	return 1

//To load a new power cell into the energy gun, if item A is a cell type and the gun is not self-recharging
/obj/item/gun/energy/proc/load_ammo(var/obj/item/cell/AM, mob/user)
	if(self_recharge)
		return
	//only let's you load in power cells
	if(istype(AM))
		. = TRUE
		if(hatch_open)
			if(power_supply)
				to_chat(user, SPAN_WARNING("[src] already has a power cell loaded.")) //already a power cell here
				return

			if(!user.IsHolding(src))
				to_chat(user, SPAN_WARNING("You must hold \the [src] in your hands to load it."))
				return

			if(AM.maxcharge <= (max_shots*charge_cost))
				user.visible_message("[user] begins to reconfigure the wires and insert the cell into [src].", SPAN_NOTICE("You begin to reconfigure the wires and insert the cell into [src]."))

				if(!do_after(user, reload_time, src))
					user.visible_message("[usr] stops reconfiguring the wires in [src].", SPAN_WARNING("You stop reconfiguring the wires in [src]."))
					return

				if(!user.IsHolding(AM))
					to_chat(user, SPAN_WARNING("You must hold \the [AM] in your hands to load it."))
					return

				if(!user.unequip_item(AM, src))
					return

				power_supply = AM
				user.visible_message("[user] inserts [AM] into [src].", SPAN_NOTICE("You insert [AM] and hot wire it into [src]."))
				playsound(loc, mag_insert_sound, 50, 1)
			else
				to_chat(user, SPAN_WARNING("The cell size is too big for the [src]. It must be [max_shots*charge_cost] Wh or smaller."))
				return
		else
			to_chat(user, SPAN_WARNING("The cell cover is closed. Use a screwdriver to open it."))
			return
		update_icon()

//To unload the existing power cell, if the cell cover is open and the gun is not self recharging
/obj/item/gun/energy/proc/unload_ammo(mob/user)
	if(self_recharge)
		return
	if(no_reloadable)
		return
	if(hatch_open)
		if(power_supply)
			user.put_in_hands(power_supply)
			user.visible_message("[user] removes [power_supply] from [src].", "<span class='notice'>You disconnect the wires and remove [power_supply] from [src].</span>")
			playsound(loc, mag_remove_sound, 50, 1)
			power_supply.update_icon()
			power_supply = null
			if(modifystate)
				icon_state = "[modifystate][0]"
			else
				icon_state = "[initial(icon_state)][0]"
			update_icon()
		else
			to_chat(user, SPAN_WARNING("[src] is empty."))
	else
		user.visible_message(SPAN_WARNING("The cell cover is closed. Use a screwdriver to open it."))
		return

//to trigger loading cell
/obj/item/gun/energy/attackby(var/obj/item/A as obj, mob/user as mob)
	if(isScrewdriver(A) && (no_reloadable))
		to_chat(user, SPAN_WARNING("[src] has a non-removable cell."))
		return ..()
	if(isScrewdriver(A) && (!self_recharge))
		if(!hatch_open)
			hatch_open = 1
			playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			user.visible_message("[user] opens the cell cover of [src].", "<span class='notice'>You open the cell cover of [src].</span>")
			return
		else
			hatch_open = 0
			playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			user.visible_message("[user] closes the cell cover of [src].", "<span class='notice'>You close the cell cover of [src].</span>")
			return
	if(!load_ammo(A, user))
		return ..()

//to trigger unloading the cell
/obj/item/gun/energy/attack_self(mob/user as mob)
	if(firemodes.len > 1)
		..()
	else
		unload_ammo(user)

/obj/item/gun/energy/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		unload_ammo(user)
	else
		return ..()


/obj/item/gun/energy/consume_next_projectile()
	if(!power_supply) return null
	if(!ispath(projectile_type)) return null
	if(!power_supply.checked_use(charge_cost)) return null
	return new projectile_type(src)

/obj/item/gun/energy/proc/get_external_power_supply()
	if(isrobot(loc) || istype(loc, /obj/item/rig_module) || istype(loc, /obj/item/mech_equipment))
		return loc.get_cell()

/obj/item/gun/energy/examine(mob/user)
	. = ..(user)
	if(!power_supply)
		to_chat(user, "There is no power cell loaded.")
	if (charge_cost == 0)
		to_chat(user, "This gun seems to have an unlimited number of shots.")
	else
		var/shots_remaining = round(power_supply.charge / charge_cost)
		to_chat(user, "Has [shots_remaining] shot\s remaining.")
	if(!hatch_open)
		to_chat(user, "The cell cover is closed.")
	if(hatch_open)
		to_chat(user, "The cell cover is open.")
	return

/obj/item/gun/energy/on_update_icon()
	..()
	if(charge_meter && power_supply)
		var/ratio = power_supply.percent()

		//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
		// Also make sure cells adminbussed with higher-than-max charge don't break sprites
		if(power_supply.charge < charge_cost)
			ratio = 0
		else
			ratio = clamp(round(ratio, 25), 25, 100)

		if(modifystate)
			icon_state = "[modifystate][ratio]"
		else
			icon_state = "[initial(icon_state)][ratio]"
		update_held_icon()
