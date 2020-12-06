/obj/machinery/atmospherics/binary/pump/high_power
	icon = 'icons/atmos/volume_pump.dmi'
	icon_state = "map_off"
	level = 1

	name = "high power gas pump"
	desc = "A pump. Has double the power rating of the standard gas pump."

	idle_power_usage = 450	// oversized pumps means oversized idle use
	power_rating = 45000	// 45000 W ~ 60 HP
	build_icon_state = "volumepump"
	base_type = /obj/machinery/atmospherics/binary/pump/high_power/buildable

/obj/machinery/atmospherics/binary/pump/high_power/buildable
	uncreated_component_parts = null

/obj/machinery/atmospherics/binary/pump/high_power/on
	use_power = POWER_USE_IDLE
	icon_state = "map_on"

/obj/machinery/atmospherics/binary/pump/high_power/on_update_icon()
	if(!powered())
		icon_state = "off"
	else
		icon_state = "[use_power ? "on" : "off"]"

// For mapping purposes
/obj/machinery/atmospherics/binary/pump/high_power/on/max_pressure/
	target_pressure = MAX_PUMP_PRESSURE

// A possible variant for Atmospherics distribution feed.
/obj/machinery/atmospherics/binary/pump/high_power/on/distribution/Initialize()
	. = ..()
	target_pressure = round(3 * ONE_ATMOSPHERE)