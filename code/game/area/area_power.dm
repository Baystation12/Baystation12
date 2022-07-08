/*
#define EQUIP 1
#define LIGHT 2
#define ENVIRON 3
*/

/area
	var/list/machinery_list

/area/proc/powered(var/chan)		// return true if the area has power to given channel
	if(!requires_power)
		return 1
	if(always_unpowered)
		return 0
	switch(chan)
		if(EQUIP)
			return power_equip
		if(LIGHT)
			return power_light
		if(ENVIRON)
			return power_environ
		if(LOCAL)
			return FALSE // if you're running on local power, don't come begging for help here.

	return 0

/// Called whenever the area's power or power usage state should change.
/area/proc/power_change()
	for(var/obj/machinery/M in machinery_list)	// for each machine in the area
		M.power_change()			// reverify power status (to update icons etc.)
	if (fire || eject || party)
		update_icon()

/// Returns Integer. The total amount of power usage queued for the area from both `used_*` and `oneoff_*` for the given power channel, or all channels if `TOTAL` is passed instead.
/area/proc/usage(var/chan)
	switch(chan)
		if(LIGHT)
			return used_light + oneoff_light
		if(EQUIP)
			return used_equip + oneoff_equip
		if(ENVIRON)
			return used_environ + oneoff_environ
		if(TOTAL)
			return .(LIGHT) + .(EQUIP) + .(ENVIRON)

/// Sets all `oneoff_*` vars to `0`. Helper for APCs. Called every machinery process tick.
/area/proc/clear_usage()
	oneoff_equip = 0
	oneoff_light = 0
	oneoff_environ = 0

/**
 * Adds the given amount of power to the `used_*` var for the given power channel, effectively increasing continuous power usage.
 *
 * **Generally, you probably do not want to use this directly. See `power_use_change()` and `use_power_oneoff()` instead.**
 *
 * **Parameters**:
 * - `amount` Integer. The amount of power to add to the given channel. Use negative numbers to subtract instead.
 * - `chan` Integer (`EQUIP`, `LIGHT`, or `ENVIRON`). The power channel to add the power to.
 */
/area/proc/use_power(var/amount, var/chan)
	switch(chan)
		if(EQUIP)
			used_equip += amount
		if(LIGHT)
			used_light += amount
		if(ENVIRON)
			used_environ += amount

/**
 * Updates the area's continuous power use (See the `used_*` vars) for the given channel.
 * This is used by machines to properly update the area of power use changes.
 *
 * **If calling this from a `/obj/machine`, you should probably use `REPORT_POWER_CONSUMPTION_CHANGE()` instead.**
 *
 * **Parameters**:
 * - `old_amount` Integer. The amount of power being used before the change.
 * - `new_amount` Integer. The amount of power being used after the change.
 * - `chan` Integer (`ENVIRON`, `EQUIP`, or `LIGHT`). The channel to update.
 */
/area/proc/power_use_change(old_amount, new_amount, chan)
	use_power(new_amount - old_amount, chan)

/**
 * Adds the given amount of power to the `oneoff_*` var for the given power channel. This results in a single spike in power usage that is reset on the next power tick.
 * Use this for a one-time power draw from the area, typically for non-machines.
 *
 * **Parameters**:
 * - `amount` Integer. The amount of power to add to the given channel. Use negative numbers to subtract instead.
 * - `chan` Integer (`EQUIP`, `LIGHT`, or `ENVIRON`). The power channel to add the power to.
 */
/area/proc/use_power_oneoff(var/amount, var/chan)
	switch(chan)
		if(EQUIP)
			oneoff_equip += amount
		if(LIGHT)
			oneoff_light += amount
		if(ENVIRON)
			oneoff_environ += amount

/// Recomputes the continued power usage; can be used for testing or error recovery, but is not called under normal conditions.
/area/proc/retally_power()
	used_equip = 0
	used_light = 0
	used_environ = 0
	for(var/obj/machinery/M in src)
		switch(M.power_channel)
			if(EQUIP)
				used_equip += M.get_power_usage()
			if(LIGHT)
				used_light += M.get_power_usage()
			if(ENVIRON)
				used_environ += M.get_power_usage()
