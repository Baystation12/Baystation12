/obj/item/modular_computer/proc/power_failure(var/malfunction = 0)
	if(enabled) // Shut down the computer
		visible_message("<span class='danger'>\The [src]'s screen flickers briefly and then goes dark.</span>", range = 1)
		if(active_program)
			active_program.event_powerfailure(0)
		for(var/datum/computer_file/program/PRG in idle_threads)
			PRG.event_powerfailure(1)
		shutdown_computer(0)

// Tries to use power from battery. Passing 0 as parameter results in this proc returning whether battery is functional or not.
/obj/item/modular_computer/proc/battery_power(var/power_usage = 0)
	apc_powered = FALSE
	if(!battery_module || !battery_module.check_functionality() || battery_module.battery.charge <= 0)
		return FALSE
	if(battery_module.battery.use(power_usage * CELLRATE) || ((power_usage == 0) && battery_module.battery.charge))
		return TRUE
	return FALSE

// Tries to use power from APC, if present.
/obj/item/modular_computer/proc/apc_power(var/power_usage = 0)
	apc_powered = TRUE
	// Tesla link was originally limited to machinery only, but this probably works too, and the benefit of being able to power all devices from an APC outweights
	// the possible minor performance loss.
	if(!tesla_link || !tesla_link.check_functionality())
		return FALSE
	var/area/A = get_area(src)
	if(!istype(A) || !A.powered(EQUIP))
		return FALSE

	// At this point, we know that APC can power us for this tick. Check if we also need to charge our battery, and then actually use the power.
	if(battery_module && (battery_module.battery.charge < battery_module.battery.maxcharge) && (power_usage > 0))
		power_usage += tesla_link.passive_charging_rate
		battery_module.battery.give(tesla_link.passive_charging_rate * CELLRATE)

	A.use_power(power_usage, EQUIP)
	return TRUE

// Handles power-related things, such as battery interaction, recharging, shutdown when it's discharged
/obj/item/modular_computer/proc/handle_power()
	var/power_usage = screen_on ? base_active_power_usage : base_idle_power_usage
	for(var/obj/item/weapon/computer_hardware/H in get_all_components())
		if(H.enabled)
			power_usage += H.power_usage
	last_power_usage = power_usage

	// First tries to charge from an APC, if APC is unavailable switches to battery power. If neither works the computer fails.
	if(apc_power(power_usage))
		return
	if(battery_power(power_usage))
		return
	power_failure()