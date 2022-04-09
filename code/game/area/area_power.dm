/*
#define EQUIP 1
#define LIGHT 2
#define ENVIRON 3
*/

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

// called when power status changes
/area/proc/power_change()
	for(var/obj/machinery/M in src)	// for each machine in the area
		M.power_change()			// reverify power status (to update icons etc.)
	if (fire || eject || party)
		update_icon()

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

// Helper for APCs; will generally be called every tick.
/area/proc/clear_usage()
	oneoff_equip = 0
	oneoff_light = 0
	oneoff_environ = 0

// Not a proc you want to use directly unless you know what you are doing; see use_power_oneoff below instead.
/area/proc/use_power(var/amount, var/chan)
	switch(chan)
		if(EQUIP)
			used_equip += amount
		if(LIGHT)
			used_light += amount
		if(ENVIRON)
			used_environ += amount

// This is used by machines to properly update the area of power changes.
/area/proc/power_use_change(old_amount, new_amount, chan)
	use_power(new_amount - old_amount, chan)

// Use this for a one-time power draw from the area, typically for non-machines.
/area/proc/use_power_oneoff(var/amount, var/chan)
	switch(chan)
		if(EQUIP)
			oneoff_equip += amount
		if(LIGHT)
			oneoff_light += amount
		if(ENVIRON)
			oneoff_environ += amount

// This recomputes the continued power usage; can be used for testing or error recovery, but is not called every tick.
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