/datum/computer_hardware/
	var/name = "Hardware"
	var/desc = "Unknown Hardware"
	// Following two variables reference the machine that holds this hardware
	// It is necessary to have two variables as we have modular_computer machine and item.
	var/obj/machinery/modular_computer/holder = null
	var/obj/item/modular_computer/holder2 = null
	var/power_usage = 0 // If the hardware uses extra power, change this.
	var/enabled = 1		// If the hardware is turned off set this to 0.
	var/critical = 1	// Prevent disabling for important component, like the HDD.

/datum/computer_hardware/New(var/obj/L)
	if(istype(L, /obj/machinery/modular_computer))
		holder = L
		return
	if(istype(L, /obj/item/modular_computer))
		holder2 = L
		return

	CRASH("Inapropriate type passed to computer_hardware/New()!")
	qdel(src)

/datum/computer_hardware/Destroy()
	holder = null
	holder2 = null
	..()