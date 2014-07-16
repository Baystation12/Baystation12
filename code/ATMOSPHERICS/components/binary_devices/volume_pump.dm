/obj/machinery/atmospherics/binary/pump/high_power
	icon = 'icons/atmos/volume_pump.dmi'
	icon_state = "map_off"
	level = 1

	name = "high power gas pump"
	desc = "A pump. Has double the power rating of the standard gas pump."

	active_power_usage = 15000	//This also doubles as a measure of how powerful the pump is, in Watts. 15000 W ~ 20 HP

/obj/machinery/atmospherics/binary/pump/high_power/on
	on = 1
	icon_state = "map_on"

/obj/machinery/atmospherics/binary/pump/high_power/update_icon()
	if(!powered())
		icon_state = "off"
	else
		icon_state = "[on ? "on" : "off"]"
