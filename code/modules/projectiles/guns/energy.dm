/obj/item/gun/energy
	name = "energy gun"
	desc = "A basic energy-based gun."
	icon = 'icons/obj/guns/basic_energy.dmi'
	icon_state = "energy"
	fire_sound = 'sound/weapons/Taser.ogg'
	fire_sound_text = "laser blast"
	accuracy = 1
	accuracy_power = 6

	var/obj/item/cell/guncell/power_supply //What type of power cell this uses
	var/charge_cost = 25 //How much energy is needed to fire.
	var/max_shots = 10 //Determines the capacity of the weapon's power cell. Specifying a cell_type overrides this value.
	var/cell_type = null
	var/projectile_type = /obj/item/projectile/beam/practice
	var/modifystate
	var/battery_chamber_size = BATTERY_PISTOL
	var/battery_changable = FALSE
	var/battery_type = /obj/item/cell/guncell/pistol/small
	var/charge_meter = 1	//if set, the icon state will be chosen based on the current charge

	//self-recharging
	var/self_recharge = 0	//if set, the weapon will recharge itself
	var/use_external_power = 0 //if set, the weapon will look for an external power source to draw from, otherwise it recharges magically
	var/recharge_time = 4
	var/charge_tick = 0

/obj/item/gun/energy/switch_firemodes()
	. = ..()
	if(.)
		update_icon()

/obj/item/gun/energy/emp_act(severity)
	..()
	update_icon()

/obj/item/gun/energy/attackby(obj/item/W, mob/living/user)
	if(istype(W, /obj/item/cell/guncell/))
		var/obj/item/cell/guncell/B = W
		if((B.battery_chamber_size != src.battery_chamber_size) && (B.universal == FALSE))
			to_chat(usr, SPAN_WARNING("This battery don't fit for this weapon!"))
			return
		if(power_supply)
			to_chat(usr, SPAN_WARNING("[src] is already loaded."))
			return

		if(insert_item(W, user))
			power_supply = W
			update_icon()
	. = ..()

/obj/item/gun/energy/MouseDrop(atom/over_object)
	if(!battery_changable)
		to_chat(usr, SPAN_WARNING("[src] is a disposable, its batteries cannot be removed!."))
	else if(self_recharge)
		to_chat(usr, SPAN_WARNING("[src] is a self-charging gun, its batteries cannot be removed!."))
	else if((src.loc == usr) && istype(over_object, /obj/screen) && (over_object.name in list(BP_R_HAND, BP_L_HAND)) && eject_item(power_supply, usr))
		power_supply = null
		update_icon()

/obj/item/gun/energy/Initialize()
	. = ..()
	if(cell_type)
		power_supply = new cell_type(src)
	else
		power_supply = new battery_type(src)
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
		to_chat(user, "Seems like it's dead.")
		return
	if (charge_cost == 0)
		to_chat(user, "This gun seems to have an unlimited number of shots.")
	else
		var/shots_remaining = round(power_supply.charge / charge_cost)
		to_chat(user, "Has [shots_remaining] shot\s remaining.")

/obj/item/gun/energy/on_update_icon()
	..()
	if(charge_meter)
		var/ratio = 0
		if(power_supply)
			ratio = power_supply.percent()
			if(power_supply.charge < charge_cost)
				ratio = 0
			else
				ratio = clamp(round(ratio, 25), 25, 100)
		else
			ratio = 0
		//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
		// Also make sure cells adminbussed with higher-than-max charge don't break sprites

		if(modifystate)
			icon_state = "[modifystate][ratio]"
		else
			icon_state = "[initial(icon_state)][ratio]"
		update_held_icon()
