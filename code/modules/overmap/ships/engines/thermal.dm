//Thermal nozzle engine
/datum/ship_engine/thermal
	name = "thermal engine"
	var/obj/machinery/atmospherics/unary/engine/nozzle

/datum/ship_engine/thermal/New(var/obj/machinery/_holder)
	..()
	nozzle = _holder

/datum/ship_engine/thermal/Destroy()
	nozzle = null
	. = ..()

/datum/ship_engine/thermal/get_status()
	return nozzle.get_status()

/datum/ship_engine/thermal/get_thrust()
	return nozzle.get_thrust()

/datum/ship_engine/thermal/burn()
	return nozzle.burn()

/datum/ship_engine/thermal/set_thrust_limit(var/new_limit)
	nozzle.thrust_limit = new_limit

/datum/ship_engine/thermal/get_thrust_limit()
	return nozzle.thrust_limit

/datum/ship_engine/thermal/is_on()
	return nozzle.is_on()

/datum/ship_engine/thermal/toggle()
	nozzle.on = !nozzle.on

/datum/ship_engine/thermal/can_burn()
	return nozzle.is_on() && nozzle.check_fuel()

//Actual thermal nozzle engine object

/obj/machinery/atmospherics/unary/engine
	name = "engine nozzle"
	desc = "Simple thermal nozzle, uses heated gast to propell the ship."
	icon = 'icons/obj/ship_engine.dmi'
	icon_state = "nozzle"
	use_power = 0
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 7500			//7500 W ~ 10 HP
	opacity = 1
	density = 1
	var/on = 1
	var/datum/ship_engine/thermal/controller
	var/thrust_limit = 1	//Value between 1 and 0 to limit the resulting thrust
	var/moles_per_burn = 10

/obj/machinery/atmospherics/unary/engine/Initialize()
	. = ..()
	controller = new(src)

/obj/machinery/atmospherics/unary/engine/Destroy()
	QDEL_NULL(controller)
	. = ..()

/obj/machinery/atmospherics/unary/engine/proc/get_status()
	. = list()
	.+= "Location: [get_area(src)]."
	if(!powered())
		.+= "Insufficient power to operate."
	if(!check_fuel())
		.+= "Insufficient fuel for a burn."

	.+= "Propellant total mass: [round(air_contents.get_mass(),0.01)] kg."
	.+= "Propellant used per burn: [round(air_contents.specific_mass() * moles_per_burn * thrust_limit,0.01)] kg."
	.+= "Propellant pressure: [round(air_contents.return_pressure()/1000,0.1)] MPa."
	. = jointext(.,"<br>")

/obj/machinery/atmospherics/unary/engine/proc/is_on()
	return on && powered()

/obj/machinery/atmospherics/unary/engine/proc/check_fuel()
	return air_contents.total_moles > moles_per_burn * thrust_limit

/obj/machinery/atmospherics/unary/engine/proc/get_thrust()
	if(!is_on() || !check_fuel())
		return 0
	var/used_part = moles_per_burn/air_contents.get_total_moles() * thrust_limit
	. = calculate_thrust(air_contents, used_part)
	return

/obj/machinery/atmospherics/unary/engine/proc/burn()
	if (!is_on())
		return 0
	if(!check_fuel())
		audible_message(src,"<span class='warning'>[src] coughs once and goes silent!</span>")
		on = !on
		return 0
	var/exhaust_dir = reverse_direction(dir)
	var/datum/gas_mixture/removed = air_contents.remove(moles_per_burn * thrust_limit)
	. = calculate_thrust(removed)
	var/turf/T = get_step(src,exhaust_dir)
	if(T)
		T.assume_air(removed)
		new/obj/effect/engine_exhaust(T,exhaust_dir,air_contents.temperature)

/obj/machinery/atmospherics/unary/engine/proc/calculate_thrust(datum/gas_mixture/propellant, used_part = 1)
	return round(sqrt(propellant.get_mass() * used_part * air_contents.return_pressure()/100),0.1)

//Exhaust effect
/obj/effect/engine_exhaust
	name = "engine exhaust"
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	light_color = "#ED9200"
	anchored = 1

/obj/effect/engine_exhaust/New(var/turf/nloc, var/ndir, var/temp)
	..(nloc)
	if(temp > PHORON_MINIMUM_BURN_TEMPERATURE)
		icon_state = "exhaust"
		set_light(5, 2)
	set_dir(ndir)
	nloc.hotspot_expose(temp,125)
	playsound(loc, 'sound/effects/spray.ogg', 50, 1, -1)
	spawn(20)
		qdel(src)