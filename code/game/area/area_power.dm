/**
 * Whether or not the area has power to the given power channel.
 *
 * Parameters:
 * - `chan` - Int (One of `EQUIP`, `LIGHT`, `ENVIRON`, or `LOCAL`). The power channel to check.
 *
 * Returns boolean. `TRUE` if powered, `FALSE` otherwise.
 */
/area/proc/powered(chan)
	if(!requires_power)
		return TRUE
	if(always_unpowered)
		return FALSE
	switch(chan)
		if(EQUIP)
			return power_equip
		if(LIGHT)
			return power_light
		if(ENVIRON)
			return power_environ

	return FALSE


/**
 * Propagates power updates to machinery in the area. Called when the power status changes. Generally, you shouldn't
 *   need to call this manually.
 */
/area/proc/power_change()
	for(var/obj/machinery/M in src)	// for each machine in the area
		M.power_change()			// reverify power status (to update icons etc.)
	if (fire || eject || party)
		update_icon()


/**
 * Determines the current power usage of the area for the given channel.
 *
 * Parameters:
 * - `chan` - Int (One of `EQUIP`, `LIGHT`, `ENVIRON`, or `TOTAL`). The power channel to check. `TOTAL` will return the
 *     total power usage of all channels.
 *
 * Returns int. The power usage in watts.
 */
/area/proc/usage(chan)
	switch(chan)
		if(LIGHT)
			return used_light + oneoff_light
		if(EQUIP)
			return used_equip + oneoff_equip
		if(ENVIRON)
			return used_environ + oneoff_environ
		if(TOTAL)
			return .(LIGHT) + .(EQUIP) + .(ENVIRON)
	return 0


/**
 * Helper for APCs; will generally be called every tick.
 */
/area/proc/clear_usage()
	oneoff_equip = 0
	oneoff_light = 0
	oneoff_environ = 0


/**
 * Modifies the area's `used_*` variables, adding the given amount for the given power channel. Not a proc you want to
 *   use directly unless you know what you are doing; see `use_power_oneoff()` instead.
 *
 * Parameters:
 * - `amount` - Int. The amount of power to add. Use negative values to subtract instead.
 * - `chan` - Int (One of `EQUIP`, `LIGHT`, `ENVIRON`). The power channel to modify.
 */
/area/proc/use_power(amount, chan)
	switch(chan)
		if(EQUIP)
			used_equip += amount
		if(LIGHT)
			used_light += amount
		if(ENVIRON)
			used_environ += amount


/**
 * This is used by machines to properly update the area of power changes. Directly calls `use_power()` with the
 *   difference between old and new amounts.
 *
 * Parameters:
 * - `old_amount` - Int. The amount of power previously being used.
 * - `new_amount` - Int. The amount of power being used now.
 * - `chan` - Int (One of `EQUIP`, `LIGHT`, `ENVIRON`). The power channel to modify. Passed directly to `use_power()`.
 */
/area/proc/power_use_change(old_amount, new_amount, chan)
	use_power(new_amount - old_amount, chan)


/**
 * Use this for a one-time power draw from the area, typically for non-machines, or machinery with a single power hit
 *   for a given action.
 *
 * Parameters:
 * - `amount` - Int. The amount of power to use.
 * - `chan` - Int (One of `EQUIP`, `LIGHT`, `ENVIRON`). The power channel to use power from.
 */
/area/proc/use_power_oneoff(amount, chan)
	switch(chan)
		if(EQUIP)
			oneoff_equip += amount
		if(LIGHT)
			oneoff_light += amount
		if(ENVIRON)
			oneoff_environ += amount


/**
 * This recomputes the continued power usage; can be used for testing or error recovery, but is not called every tick.
 */
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
