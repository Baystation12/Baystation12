
/datum/ship_engine/repulsor
	name = "repulsor ship engine"
	var/obj/machinery/repulsor_engine/nozzle

/datum/ship_engine/repulsor/New(var/obj/machinery/_holder)
	..()
	nozzle = _holder

/datum/ship_engine/repulsor/Destroy()
	nozzle = null
	. = ..()

/datum/ship_engine/repulsor/get_status()
	return nozzle.get_status()

/datum/ship_engine/repulsor/get_thrust()
	return nozzle.get_thrust()

/datum/ship_engine/repulsor/burn()
	return nozzle.burn()

/datum/ship_engine/repulsor/set_thrust_limit(var/new_limit)
	nozzle.thrust_limit = new_limit
	nozzle.active_power_usage = nozzle.full_power_drain * new_limit

/datum/ship_engine/repulsor/get_thrust_limit()
	return nozzle.thrust_limit

/datum/ship_engine/repulsor/is_on()
	return nozzle.is_on()

/datum/ship_engine/repulsor/toggle()
	nozzle.on = !nozzle.on

/datum/ship_engine/repulsor/can_burn()
	return nozzle.is_on() && nozzle.check_fuel()


/obj/machinery/repulsor_engine
	name = "repulsor engine"
	desc = "A sophisticated gravitic drive that allows great speed and maneuvrability."
	icon = 'repulsor.dmi'
	icon_state = "off"
	anchored = 1
	use_power = 1
	var/last_burn = 0
	idle_power_usage = 100		//internal circuitry, friction losses and stuff
	active_power_usage = 10000
	var/full_power_drain = 10000
	opacity = 1
	density = 1
	var/thrust_limit = 1	//Value between 1 and 0 to limit the resulting thrust
	var/on = 1
	var/datum/ship_engine/repulsor/controller

/obj/machinery/repulsor_engine/Initialize()
	. = ..()
	controller = new(src)

/obj/machinery/repulsor_engine/Destroy()
	QDEL_NULL(controller)
	. = ..()

/obj/machinery/repulsor_engine/process()
	if(use_power == 2)
		if(world.time > last_burn + 30)
			use_power = 1
			icon_state = "off"

/obj/machinery/repulsor_engine/proc/get_status()
	. = list()
	.+= "Location: [get_area(src)]."
	if(!powered())
		.+= "Insufficient power to operate."
	if(!check_fuel())
		.+= "Insufficient fuel for a burn."

	. += "Plasma flow pressure: [check_fuel() ? "Good" : "Insufficient"]"
	. += "Thrust limit: [100 * thrust_limit]%"
	. += "Thrust power drain: [use_power == 1 ? idle_power_usage : active_power_usage]W"
	. = jointext(.,"<br>")

/obj/machinery/repulsor_engine/proc/is_on()
	return on && powered()

/obj/machinery/repulsor_engine/proc/check_fuel()
	//later on we'll add plasma conduits which these draw small amounts of fuel for
	return 1

/obj/machinery/repulsor_engine/proc/get_thrust()
	if(!is_on() || !check_fuel())
		return 0
	return thrust_limit

/obj/machinery/repulsor_engine/proc/burn()
	if (!is_on())
		return 0
	if(!check_fuel())
		audible_message(src,"<span class='warning'>[src] coughs once and goes silent!</span>")
		on = !on
		return 0
	var/exhaust_dir = reverse_direction(dir)

	. = thrust_limit

	//use some power
	use_power = 2
	last_burn = world.time

	//push anything away
	var/list/victims = list()
	var/turf/start_turf = get_step(src, exhaust_dir)

	//check if there is anything to knock away
	for(var/atom/movable/A in start_turf)
		if(A.anchored)
			continue
		victims.Add(A)

	if(victims.len)
		//get the turf to "throw" to
		var/turf/throw_turf = start_turf
		var/dist = 10
		//do while because i can
		do
			start_turf = get_step(start_turf, exhaust_dir)
			dist--
		while(dist > 0)
		//punch it!
		for(var/atom/movable/A in victims)
			A.throw_at(throw_turf, rand(3, 10), 1, src)

	icon_state = "animated"
