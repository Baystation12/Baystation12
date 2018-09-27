
/datum/ship_engine/fusion
	name = "fusion thruster"
	var/obj/machinery/fusion_thruster/nozzle

/datum/ship_engine/fusion/New(var/obj/machinery/_holder)
	..()
	nozzle = _holder

/datum/ship_engine/fusion/Destroy()
	nozzle = null
	. = ..()

/datum/ship_engine/fusion/get_status()
	return nozzle.get_status()

/datum/ship_engine/fusion/get_thrust()
	return nozzle.get_thrust()

/datum/ship_engine/fusion/burn()
	return nozzle.burn()

/datum/ship_engine/fusion/set_thrust_limit(var/new_limit)
	nozzle.thrust_limit = new_limit
	nozzle.active_power_usage = nozzle.full_power_drain * new_limit

/datum/ship_engine/fusion/get_thrust_limit()
	return nozzle.thrust_limit

/datum/ship_engine/fusion/is_on()
	return nozzle.is_on()

/datum/ship_engine/fusion/toggle()
	nozzle.on = !nozzle.on

/datum/ship_engine/fusion/can_burn()
	return nozzle.is_on() && nozzle.check_fuel()


/obj/machinery/fusion_thruster
	name = "fusion thruster"
	desc = "Simple thermal nozzle, uses heated gas to propel the ship."
	icon = 'fusion_thruster.dmi'
	icon_state = "nozzle0"
	anchored = 1
	use_power = 1
	var/last_burn = 0
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	active_power_usage = 5000
	var/full_power_drain = 5000
	opacity = 1
	density = 1
	var/thrust_limit = 1	//Value between 1 and 0 to limit the resulting thrust
	var/on = 1
	var/datum/ship_engine/fusion/controller
	var/obj/item/fusion_fuel/held_fuel
	var/fuel_consumption_rate = 1

//spawn with fuel
/obj/machinery/fusion_thruster/fueled
	icon_state = "nozzle1"

/obj/machinery/fusion_thruster/fueled/New()
	. = ..()
	held_fuel = new(src)

/obj/machinery/fusion_thruster/Initialize()
	. = ..()
	controller = new(src)

/obj/machinery/fusion_thruster/Destroy()
	QDEL_NULL(controller)
	. = ..()

/obj/machinery/fusion_thruster/process()
	if(use_power == 2)
		if(world.time > last_burn + 30)
			use_power = 1

/obj/machinery/fusion_thruster/proc/can_use(var/mob/M)
	if(M.stat || M.restrained() || M.lying || !istype(M, /mob/living) || get_dist(M, src) > 1)
		return 0
	return 1

/obj/machinery/fusion_thruster/attack_hand(var/mob/user)
	if(can_use(user))
		if(held_fuel)
			src.visible_message("<span class='info'>[src] ejects it's spent [held_fuel].</span>")
			held_fuel.loc = src.loc
			held_fuel = null
			icon_state = "nozzle0"
		else
			to_chat(user, "<span class='notice'>[src] does not contain a deuterium fuel packet!</span>")

/obj/machinery/fusion_thruster/attackby(var/obj/I, var/mob/user)
	if(can_use(user))
		if(istype(I, /obj/item/fusion_fuel))
			user.drop_item()
			I.loc = src
			held_fuel = I
			icon_state = "nozzle1"
			to_chat(user, "<span class='info'>You insert [I] into [src].</span>")

/obj/machinery/fusion_thruster/proc/get_status()
	. = list()
	.+= "Location: [get_area(src)]."
	if(!powered())
		.+= "Insufficient power to operate."
	if(!check_fuel())
		.+= "Insufficient fuel for a burn."

	. += "Deuterium fuel status: [check_fuel()]u"
	. += "Thrust limit: [100 * thrust_limit]%"
	. += "Thrust power drain: [use_power == 1 ? idle_power_usage : active_power_usage]W"
	. = jointext(.,"<br>")

/obj/machinery/fusion_thruster/proc/is_on()
	return on && powered()

/obj/machinery/fusion_thruster/proc/check_fuel()
	if(held_fuel)
		return held_fuel.fuel_left
	return 0

/obj/machinery/fusion_thruster/proc/get_thrust()
	if(!is_on() || !check_fuel())
		return 0
	return thrust_limit

/obj/machinery/fusion_thruster/proc/burn()
	if (!is_on())
		return 0
	if(!check_fuel())
		audible_message(src,"<span class='warning'>[src] coughs once and goes silent!</span>")
		on = !on
		return 0

	. = thrust_limit

	//use some fuel
	held_fuel.fuel_left = max(held_fuel.fuel_left - fuel_consumption_rate * thrust_limit, 0)

	//put out some superheated exhaust
	var/exhaust_dir = reverse_direction(dir)
	var/turf/T = get_step(src,exhaust_dir)
	if(T)
		new/obj/effect/engine_exhaust(T,exhaust_dir, 1000)




/obj/machinery/thruster_loader
	name = "thruster fuel loader"
	desc = "An automated loading device for a fusion thruster to insert and remove deuterium fuel packets."
	icon = 'fusion_thruster.dmi'
	icon_state = "loader"
	anchored = 1

/obj/machinery/thruster_loader/proc/can_use(var/mob/M)
	if(M.stat || M.restrained() || M.lying || !istype(M, /mob/living) || get_dist(M, src) > 1)
		return 0
	return 1

/obj/machinery/thruster_loader/attack_hand(var/mob/user)
	if(can_use(user))
		var/obj/machinery/fusion_thruster/thruster = locate() in get_step(src, src.dir)
		if(thruster)
			var/obj/item/fusion_fuel/old_fuel = thruster.held_fuel
			if(old_fuel)
				src.visible_message("<span class='info'>[src] ejects the spent [old_fuel].</span>")
				old_fuel.loc = src.loc
				thruster.held_fuel = null
				thruster.icon_state = "nozzle0"
			else
				to_chat(user, "<span class='notice'>[src] can not detect a deuterium fuel packet!</span>")
		else
			to_chat(user, "<span class='notice'>No thruster detected by [src], check that it is located to the [dir2text(src.dir)].</span>")

/obj/machinery/thruster_loader/attackby(var/obj/I, var/mob/user)
	if(can_use(user))
		var/obj/machinery/fusion_thruster/thruster = locate() in get_step(src, src.dir)
		if(thruster)
			if(istype(I, /obj/item/fusion_fuel))
				user.drop_item()
				I.loc = thruster
				thruster.held_fuel = I
				thruster.icon_state = "nozzle1"
				to_chat(user, "<span class='info'>You insert [I] into [src] and it's loaded into the thruster.</span>")
		else
			to_chat(user, "<span class='notice'>No thruster detected by [src], check that it is located to the [dir2text(src.dir)].</span>")
