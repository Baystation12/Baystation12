/obj/item/weapon/computer_hardware/tesla_link
	name = "tesla link"
	desc = "An advanced tesla link that wirelessly recharges connected device from nearby area power controller."
	critical = 0
	enabled = 0 // Starts turned off
	icon_state = "teslalink"
	hardware_size = 2		// Can't be installed into tablets
	var/obj/machinery/modular_computer/holder

/obj/item/weapon/computer_hardware/tesla_link/New(var/obj/L)
	if(istype(L, /obj/machinery/modular_computer))
		holder = L
		return
	..(L)

/obj/item/weapon/computer_hardware/tesla_link/Destroy()
	if(holder && (holder.tesla_link == src))
		holder.tesla_link = null
	..()