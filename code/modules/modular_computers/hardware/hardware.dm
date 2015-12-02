/obj/item/weapon/computer_hardware/
	name = "Hardware"
	desc = "Unknown Hardware"
	icon = 'icons/obj/modular_components.dmi'
	// Following two variables reference the machine that holds this hardware
	// It is necessary to have two variables as we have modular_computer machine and item.
	var/obj/item/modular_computer/holder2 = null
	var/power_usage = 0 	// If the hardware uses extra power, change this.
	var/enabled = 1			// If the hardware is turned off set this to 0.
	var/critical = 1		// Prevent disabling for important component, like the HDD.
	var/hardware_size = 1	// Limits which devices can contain this component. 1: Tablets/Laptops/Consoles, 2: Laptops/Consoles, 3: Consoles only

/obj/item/weapon/computer_hardware/New(var/obj/L)
	if(istype(L, /obj/machinery/modular_computer))
		var/obj/machinery/modular_computer/C = L
		if(C.cpu)
			holder2 = C.cpu
			return
	if(istype(L, /obj/item/modular_computer))
		holder2 = L
		return

/obj/item/weapon/computer_hardware/Destroy()
	holder2 = null
	..()