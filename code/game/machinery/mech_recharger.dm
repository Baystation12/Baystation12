/obj/machinery/mech_recharger
	name = "mech recharger"
	desc = "A mech recharger, built into the floor."
	icon = 'icons/mecha/mech_bay.dmi'
	icon_state = "recharge_floor"
	density = 0
	plane = ABOVE_TURF_PLANE
	layer = ABOVE_TILE_LAYER
	anchored = 1
	idle_power_usage = 200	// Some electronics, passive drain.
	active_power_usage = 60 KILOWATTS // When charging
	use_power = 1
