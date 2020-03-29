/obj/machinery/exonet/broadcaster/relay
	name = "EXONET Relay"
	desc = "A very complex relay capable of transmitting and relaying large amounts of distance across space. Looks fragile."
	active_power_usage = 20000 //20kW

/obj/machinery/exonet/broadcaster/relay/on_update_icon()
	if(operable())
		icon_state = "bus"
	else
		icon_state = "bus_off"