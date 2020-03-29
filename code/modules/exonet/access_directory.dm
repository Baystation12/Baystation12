/obj/machinery/exonet/access_directory
	name = "EXONET Relay"
	desc = "A very complex machine that manages the security for an EXONET system. Looks fragile."
	active_power_usage = 4 KILOWATTS

/obj/machinery/exonet/access_directory/on_update_icon()
	if(operable())
		icon_state = "bus"
	else
		icon_state = "bus_off"
