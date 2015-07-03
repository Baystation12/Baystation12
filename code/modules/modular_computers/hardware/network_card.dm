/datum/computer_hardware/network_card/
	name = "NTNet Network Card"
	desc = "A basic network card for usage with standard NTNet frequencies."
	power_usage = 50
	critical = 0
	var/identification_string = "" // Identification string, technically nickname seen in the network. Can be set by user.
	var/long_range = 0
	var/ethernet = 0 // Hard-wired, therefore always on, ignores NTNet wireless checks.

/datum/computer_hardware/network_card/advanced
	desc = "An advanced network card for usage with standard NTNet frequencies. It's transmitter is strong enough to connect even off-station."
	long_range = 1
	power_usage = 100 // Better range but higher power usage.

/datum/computer_hardware/network_card/wired
	desc = "An advanced network card for usage with NTNet. This one uses wired connection."
	ethernet = 1
	power_usage = 100 // Better range but higher power usage.

/datum/computer_hardware/network_card/Destroy()
	if(holder && (holder.network_card == src))
		holder.network_card = null
	holder = null
	..()

// 0 - No signal, 1 - Low signal, 2 - High signal. 3 - Wired Connection
/datum/computer_hardware/network_card/proc/get_signal(var/specific_action = 0)
	if(!holder) // Hardware is not installed in anything. No signal. How did this even get called?
		return 0

	if(!enabled)
		return 0

	if(ethernet) // Computer is connected via wired connection.
		return 3

	if(!ntnet_global || !ntnet_global.check_function(specific_action)) // NTNet is down and we are not connected via wired connection. No signal.
		return 0

	if(holder.z in config.station_levels) // Computer is on station, High signal
		return 2

	if(long_range) // Computer is not on station, but it has upgraded network card. Low signal.
		return 1

	return 0 // Computer is not on station and does not have upgraded network card. No signal.