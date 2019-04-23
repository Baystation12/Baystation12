/datum/ship_engine/ion
	name = "ion thruster"
	var/obj/machinery/engine/ion/thruster
	
/datum/ship_engine/ion/New(var/obj/machinery/_holder)
	..()
	thruster = _holder
	
/datum/ship_engine/ion/Destroy()
	thruster = null
	. = ..()

/datum/ship_engine/ion/get_status()
	return thruster.get_status()

/datum/ship_engine/ion/get_thrust()
	return thruster.get_thrust()

/datum/ship_engine/ion/burn()
	return thruster.burn()

/datum/ship_engine/ion/set_thrust_limit(var/new_limit)
	thruster.thrust_limit = new_limit

/datum/ship_engine/ion/get_thrust_limit()
	return thruster.thrust_limit

/datum/ship_engine/ion/is_on()
	return thruster.on && thruster.powered()

/datum/ship_engine/ion/toggle()
	thruster.on = !thruster.on

/datum/ship_engine/ion/can_burn()
	return thruster.on && thruster.powered()

/obj/machinery/engine/ion
	name = "ion propulsion device"
	desc = "An advanced ion propulsion device, using energy and minutes amount of gas to generate thrust."
	icon = 'icons/obj/ship_engine.dmi'
	icon_state = "nozzle"
	power_channel = ENVIRON
	idle_power_usage = 100
	var/datum/ship_engine/ion/controller
	var/thrust_limit = 1
	var/on = 1
	var/burn_cost = 750
	var/generated_thrust = 2.5
	
/obj/machinery/engine/ion/Initialize()
	. = ..()
	controller = new(src)

/obj/machinery/engine/ion/Destroy()
	QDEL_NULL(controller)
	. = ..()
	
/obj/machinery/engine/ion/proc/get_status()
	. = list()
	.+= "Location: [get_area(src)]."
	if(!powered())
		.+= "Insufficient power to operate."
	
	. = jointext(.,"<br>")
	
/obj/machinery/engine/ion/proc/burn()
	if(!on && !powered())
		return 0
	use_power_oneoff(burn_cost)
	. = thrust_limit * generated_thrust
	
/obj/machinery/engine/ion/proc/get_thrust()
	return thrust_limit * generated_thrust * on
	
/obj/item/weapon/circuitboard/engine/ion
	name = T_BOARD("ion propulsion device")
	icon_state = "mcontroller"
	build_path = /obj/machinery/engine/ion
	origin_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 2)
	req_components = list(
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/capacitor = 2)