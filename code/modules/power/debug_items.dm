/obj/machinery/power/debug_items/
	icon = 'icons/obj/power.dmi'
	icon_state = "tracker"
	anchored = 1
	density = 1
	var/show_extended_information = 1	// Set to 0 to disable extra information on examining (for example, when used on admin events)

/obj/machinery/power/debug_items/examine(var/mob/user)
	..()
	if(show_extended_information)
		show_info(user)

/obj/machinery/power/debug_items/proc/show_info(var/mob/user)
	if(!powernet)
		user << "This device is not connected to a powernet"
		return

	user << "Connected to powernet: [powernet]"
	user << "Available power: [num2text(powernet.avail, 20)] W"
	user << "Load: [num2text(powernet.viewload, 20)] W"
	user << "Has alert: [powernet.problem ? "YES" : "NO"]"
	user << "Cables: [powernet.cables.len]"
	user << "Nodes: [powernet.nodes.len]"


// An infinite power generator. Adds energy to connected cable.
/obj/machinery/power/debug_items/infinite_generator
	name = "Fractal Energy Reactor"
	desc = "An experimental power generator"
	var/power_generation_rate = 1000000

/obj/machinery/power/debug_items/infinite_generator/process()
	add_avail(power_generation_rate)

/obj/machinery/power/debug_items/infinite_generator/show_info(var/mob/user)
	..()
	user << "Generator is providing [num2text(power_generation_rate, 20)] W"


// A cable powersink, without the explosion/network alarms normal powersink causes.
/obj/machinery/power/debug_items/infinite_cable_powersink
	name = "Null Point Core"
	desc = "An experimental device that disperses energy, used for grid testing purposes."
	var/power_usage_rate = 0
	var/last_used = 0

/obj/machinery/power/debug_items/infinite_cable_powersink/process()
	last_used = draw_power(power_usage_rate)

/obj/machinery/power/debug_items/infinite_cable_powersink/show_info(var/mob/user)
	..()
	user << "Power sink is demanding [num2text(power_usage_rate, 20)] W"
	user << "[num2text(last_used, 20)] W was actually used last tick"


/obj/machinery/power/debug_items/infinite_apc_powersink
	name = "APC Dummy Load"
	desc = "A dummy load that connects to an APC, used for load testing purposes."
	use_power = 2
	active_power_usage = 0

/obj/machinery/power/debug_items/infinite_apc_powersink/show_info(var/mob/user)
	..()
	user << "Dummy load is using [num2text(active_power_usage, 20)] W"
	user << "Powered: [powered() ? "YES" : "NO"]"