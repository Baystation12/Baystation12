/obj/machinery/exonet/modem
	name = "EXONET Modem"
	desc = "A very complex modem capable of transmitting information to PLEXUS, the space internet. Looks fragile."
	active_power_usage = 20000 //20kW

/obj/machinery/exonet/modem/on_update_icon()
	if(operable())
		icon_state = "bus"
	else
		icon_state = "bus_off"