/datum/computer_hardware/
	var/name = "Hardware"
	var/desc = "Unknown Hardware"
	var/obj/machinery/modular_computer/holder = null
	var/power_usage = 0 // If the hardware uses extra power, change this.
	var/enabled = 1		// If the hardware is turned off set this to 0.
	var/critical = 1	// Prevent disabling for important component, like the HDD.

/datum/computer_hardware/New(var/obj/machinery/modular_computer/L)
	holder = L
	..()