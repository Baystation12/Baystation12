/obj/item/modular_computer/proc/power_failure(malfunction = 0)
	if(enabled) // Shut down the computer
		visible_message("<span class='danger'>\The [src]'s screen flickers briefly and then goes dark.</span>", range = 1)
		var/datum/extension/interactive/ntos/os = get_extension(src, /datum/extension/interactive/ntos)
		if(os)
			os.event_powerfailure()
		shutdown_computer(0)

/// Tries to use power from battery. Passing false as a parameter results in this proc returning whether battery is functional or not.
/obj/item/modular_computer/proc/battery_power(power_usage = FALSE)
	apc_powered = FALSE
	if(!battery_module || !battery_module.check_functionality() || battery_module.battery.charge <= 0)
		return FALSE
	if(battery_module.battery.use(power_usage * CELLRATE) || ((power_usage == 0) && battery_module.battery.charge))
		return TRUE
	return FALSE

/// Tries to use power from APC, if present.
/obj/item/modular_computer/proc/apc_power(power_usage = 0)
	apc_powered = TRUE
	// Tesla link was originally limited to machinery only, but this probably works too, and the benefit of being able to power all devices from an APC outweights
	// the possible minor performance loss.
	if(!tesla_link || !tesla_link.check_functionality())
		return FALSE
	var/area/A = get_area(src)
	if(!istype(A) || !A.powered(EQUIP))
		return FALSE

	// At this point, we know that APC can power us for this tick. Check if we also need to charge our battery, and then actually use the power.
	if(battery_module && (battery_module.battery.charge < battery_module.battery.maxcharge))
		power_usage += tesla_link.passive_charging_rate
		battery_module.battery.give(tesla_link.passive_charging_rate * CELLRATE)

	A.use_power_oneoff(power_usage, EQUIP)
	return TRUE

/// Tries to use power in general (Abstraction)
/obj/item/modular_computer/proc/computer_use_power(power_usage = 0)
	// First tries to charge from an APC, if APC is unavailable switches to battery power. If neither works the computer fails.
	if(apc_power(power_usage))
		return TRUE
	if(battery_power(power_usage))
		return TRUE
	return FALSE

/// Handles power-related things, such as battery interaction, recharging, shutdown when it's discharged
/obj/item/modular_computer/proc/handle_power()
	var/power_usage = screen_on ? base_active_power_usage : base_idle_power_usage
	if(enabled)
		for(var/obj/item/stock_parts/computer/H in get_all_components())
			if(H.enabled)
				power_usage += H.power_usage
		last_power_usage = power_usage

	if(computer_use_power(power_usage))
		return
	power_failure()