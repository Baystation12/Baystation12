//This file contain all pipe based proc. No many, no more!

/obj/machinery/atmospherics/pipe/drain_power()
	return -1


/obj/machinery/atmospherics/pipe/New()
	..()
	//so pipes under walls are hidden
	icon = null
	alpha = 255
	if(istype(get_turf(src), /turf/simulated/wall) || istype(get_turf(src), /turf/simulated/shuttle/wall) || istype(get_turf(src), /turf/unsimulated/wall))
		level = 1


/obj/machinery/atmospherics/pipe/proc/pipeline_expansion()
	return nodes


/obj/machinery/atmospherics/pipe/proc/check_pressure(pressure)
	var/datum/gas_mixture/environment = loc.return_air()

	var/pressure_difference = pressure - environment.return_pressure()

	if(pressure_difference > maximum_pressure)
		burst()

	else if(pressure_difference > fatigue_pressure)
		//TODO: leak to turf, doing pfshhhhh
		if(prob(5))
			burst()

	else return 1

/*
obj/machinery/atmospherics/pipe/initialize()
	..()
	if(!get_nodes_amount())
		qdel(src)
		return 0

	var/turf/T = get_turf(src)
	if(istype(T))
		hide(T.intact)

	update_icon()
	return 1
*/

/obj/machinery/atmospherics/pipe/return_air()
	if(!parent)
		parent = new /datum/pipeline()
		parent.build_pipeline(src)

	return parent.air


/obj/machinery/atmospherics/pipe/build_network()
	if(!parent)
		parent = new /datum/pipeline()
		parent.build_pipeline(src)

	return parent.return_network()


/obj/machinery/atmospherics/pipe/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(!parent)
		parent = new /datum/pipeline()
		parent.build_pipeline(src)

	return parent.network_expand(new_network, reference)


/obj/machinery/atmospherics/pipe/return_network(obj/machinery/atmospherics/reference)
	if(!parent)
		parent = new /datum/pipeline()
		parent.build_pipeline(src)

	return parent.return_network(reference)


/obj/machinery/atmospherics/pipe/process()
	if(!parent)
		..()
	else
		. = PROCESS_KILL


/obj/machinery/atmospherics/pipe/Destroy()
	qdel(parent)
	if(air_temporary)
		loc.assume_air(air_temporary)

	..()


/obj/machinery/atmospherics/pipe/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if (istype(src, /obj/machinery/atmospherics/pipe/tank))
		return ..()
	if (istype(src, /obj/machinery/atmospherics/pipe/vent))
		return ..()

	if(istype(W,/obj/item/device/pipe_painter))
		return 0

	if (!istype(W, /obj/item/weapon/wrench))
		return ..()
	var/turf/T = src.loc
	if (level==1 && isturf(T) && T.intact)
		user << "\red You must remove the plating first."
		return 1
	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()
	if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
		user << "<span class='warning'>You cannot unwrench [src], it is too exerted due to internal pressure.</span>"
		add_fingerprint(user)
		return 1
	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
	user << "\blue You begin to unfasten \the [src]..."
	if (do_after(user, 40))
		user.visible_message( \
			"[user] unfastens \the [src].", \
			"\blue You have unfastened \the [src].", \
			"You hear ratchet.")
		new /obj/item/pipe(loc, make_from=src)
		for (var/obj/machinery/meter/meter in T)
			if (meter.target == src)
				new /obj/item/pipe_meter(T)
				qdel(meter)
		qdel(src)


/obj/machinery/atmospherics/pipe/color_cache_name(var/obj/machinery/atmospherics/node)
	if(istype(src, /obj/machinery/atmospherics/pipe/tank))
		return ..()

	if(istype(node, /obj/machinery/atmospherics/pipe/manifold) || istype(node, /obj/machinery/atmospherics/pipe/manifold4w))
		if(pipe_color == node.pipe_color)
			return node.pipe_color
		else
			return null
	else if(istype(node, /obj/machinery/atmospherics/pipe/simple))
		return node.pipe_color
	else
		return pipe_color


/obj/machinery/atmospherics/pipe/hide(var/i)
	if(level == 1 && istype(loc, /turf/simulated))
		invisibility = i ? 101 : 0
	update_icon()


/obj/machinery/atmospherics/pipe/proc/burst()
	src.visible_message("\red \bold [src] bursts!");
	playsound(src.loc, 'sound/effects/bang.ogg', 25, 1)
	var/datum/effect/effect/system/smoke_spread/smoke = new
	smoke.set_up(1,0, src.loc, 0)
	smoke.start()
	qdel(src)


/obj/machinery/atmospherics/pipe/tank/New()
	icon_state = "air"
	..()


/obj/machinery/atmospherics/pipe/tank/hide()
	update_icon()


/obj/machinery/atmospherics/pipe/tank/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(istype(W, /obj/item/device/pipe_painter))
		return

	if(istype(W, /obj/item/device/analyzer) && in_range(user, src))
		for (var/mob/O in viewers(user, null))
			O << "\red [user] has used the analyzer on \icon[icon]"

		var/pressure = parent.air.return_pressure()
		var/total_moles = parent.air.total_moles

		user << "\blue Results of analysis of \icon[icon]"
		if (total_moles>0)
			user << "\blue Pressure: [round(pressure,0.1)] kPa"
			for(var/g in parent.air.gas)
				user << "\blue [gas_data.name[g]]: [round((parent.air.gas[g] / total_moles) * 100)]%"
			user << "\blue Temperature: [round(parent.air.temperature-T0C)]&deg;C"
		else
			user << "\blue Tank is empty!"


/obj/machinery/atmospherics/pipe/tank/air/New()
	air_temporary = new
	air_temporary.volume = volume
	air_temporary.temperature = T20C

	air_temporary.adjust_multi("oxygen",  (start_pressure*O2STANDARD)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature), \
	                           "nitrogen",(start_pressure*N2STANDARD)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature))

	..()
	icon_state = "air"


/obj/machinery/atmospherics/pipe/tank/oxygen/New()
	air_temporary = new
	air_temporary.volume = volume
	air_temporary.temperature = T20C

	air_temporary.adjust_gas("oxygen", (start_pressure)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature))

	..()
	icon_state = "o2"


/obj/machinery/atmospherics/pipe/tank/nitrogen/New()
	air_temporary = new
	air_temporary.volume = volume
	air_temporary.temperature = T20C

	air_temporary.adjust_gas("nitrogen", (start_pressure)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature))

	..()
	icon_state = "n2"


/obj/machinery/atmospherics/pipe/tank/carbon_dioxide/New()
	air_temporary = new
	air_temporary.volume = volume
	air_temporary.temperature = T20C

	air_temporary.adjust_gas("carbon_dioxide", (start_pressure)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature))

	..()
	icon_state = "co2"


/obj/machinery/atmospherics/pipe/tank/phoron/New()
	air_temporary = new
	air_temporary.volume = volume
	air_temporary.temperature = T20C

	air_temporary.adjust_gas("phoron", (start_pressure)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature))

	..()
	icon_state = "phoron"


/obj/machinery/atmospherics/pipe/tank/nitrous_oxide/New()
	air_temporary = new
	air_temporary.volume = volume
	air_temporary.temperature = T0C

	air_temporary.adjust_gas("sleeping_agent", (start_pressure)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature))

	..()
	icon_state = "n2o"


/obj/machinery/atmospherics/pipe/vent/process()
	if(!parent)
		if(build_killswitch <= 0)
			. = PROCESS_KILL
		else
			build_killswitch--
		..()
		return
	else
		parent.mingle_with_turf(loc, volume)


/obj/machinery/atmospherics/pipe/vent/update_icon()
	if(nodes[1])
		icon_state = "intact"

		set_dir(get_dir(src, nodes[1]))

	else
		icon_state = "exposed"


/obj/machinery/atmospherics/pipe/vent/hide(var/i) //to make the little pipe section invisible, the icon changes.
	if(nodes[1])
		icon_state = "[i == 1 && istype(loc, /turf/simulated) ? "h" : "" ]intact"
		set_dir(get_dir(src, nodes[1]))
	else
		icon_state = "exposed"


/obj/machinery/atmospherics/pipe/passive_vent/process()
	if(parent && !welded)
		var/datum/gas_mixture/environment = loc.return_air()
		var/datum/gas_mixture/internal = parent.air

		var/env_pressure = environment.return_pressure()
		var/int_pressure = internal.return_pressure()
		var/pressure_delta = int_pressure - env_pressure

		if(pressure_delta > 0.005)// && (internal.temperature > 0))
			pump_gas_passive(src, internal, environment)//, transfer_moles)

		else if(pressure_delta < -0.005)// && (environment.temperature > 0))
			pump_gas_passive(src, environment, internal)//, transfer_moles)


/obj/machinery/atmospherics/pipe/passive_vent/update_icon(var/safety = 0)
	if(!check_icon_cache())
		return

	overlays.Cut()

	var/vent_icon = "vent"

	var/turf/T = get_turf(src)
	if(!istype(T))
		return

	if(T.intact && level == 1)
		vent_icon += "h"

	if(welded)
		vent_icon += "weld"

	vent_icon += "off"

	overlays += icon_manager.get_atmos_icon("device", , , vent_icon)


/obj/machinery/atmospherics/pipe/passive_vent/update_underlays()
	if(..())
		underlays.Cut()


/obj/machinery/atmospherics/pipe/passive_vent/hide()
	update_icon()
	update_underlays()


/obj/machinery/atmospherics/pipe/universal/update_icon(var/safety = 0)
	if(!check_icon_cache())
		return

	alpha = 255

	overlays.Cut()
	overlays += icon_manager.get_atmos_icon("pipe", , pipe_color, "universal")
	underlays.Cut()

	for(var/obj/machinery/atmospherics/node in nodes)
		if(node) //maybe not needed, but better oversafe than undersafe
			universal_underlays(node)


/obj/machinery/atmospherics/pipe/universal/update_underlays()
	update_icon()


obj/machinery/atmospherics/pipe/simple/heat_exchanging/New()
	..()
	initialize_directions_he = initialize_directions	// The auto-detection from /pipe is good enough for a simple HE pipe
// BubbleWrap END
	color = "#404040" //we don't make use of the fancy overlay system for colours, use this to set the default.

obj/machinery/atmospherics/pipe/simple/heat_exchanging/initialize()
	normalize_dir()
	var/node1_dir
	var/node2_dir
	for(var/direction in cardinal)
		if(initialize_directions.Find(direction))
			if (!node1_dir)
				node1_dir = direction
			else if (!node2_dir)
				node2_dir = direction
	for(var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/target in get_step(src,node1_dir))
		if(target.initialize_directions.Find(get_dir(target,src)))
			connect(src,target)
			break
	for(var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/target in get_step(src,node2_dir))
		if(target.initialize_directions.Find(get_dir(target,src)))
			connect(src, target)
			break
	if(!get_nodes_amount())
		qdel(src)
		return
	update_icon()
	return

obj/machinery/atmospherics/pipe/simple/heat_exchanging/process()
	if(!parent)
		..()
	else
		var/datum/gas_mixture/pipe_air = return_air()
		if(istype(loc, /turf/simulated/))
			var/environment_temperature = 0
			if(loc:blocks_air)
				environment_temperature = loc:temperature
			else
				var/datum/gas_mixture/environment = loc.return_air()
				environment_temperature = environment.temperature
			if(abs(environment_temperature-pipe_air.temperature) > minimum_temperature_difference)
				parent.temperature_interact(loc, volume, thermal_conductivity)
		else if(istype(loc, /turf/space/))
			parent.radiate_heat_to_space(surface, 1)
		if(buckled_mob)
			var/hc = pipe_air.heat_capacity()
			var/avg_temp = (pipe_air.temperature * hc + buckled_mob.bodytemperature * 3500) / (hc + 3500)
			pipe_air.temperature = avg_temp
			buckled_mob.bodytemperature = avg_temp
			var/heat_limit = 1000
			var/mob/living/carbon/human/H = buckled_mob
			if(istype(H) && H.species)
				heat_limit = H.species.heat_level_3
			if(pipe_air.temperature > heat_limit + 1)
				buckled_mob.apply_damage(4 * log(pipe_air.temperature - heat_limit), BURN, "chest", used_weapon = "Excessive Heat")
		//fancy radiation glowing
		if(pipe_air.temperature && (icon_temperature > 500 || pipe_air.temperature > 500)) //start glowing at 500K
			if(abs(pipe_air.temperature - icon_temperature) > 10)
				icon_temperature = pipe_air.temperature
				var/h_r = heat2color_r(icon_temperature)
				var/h_g = heat2color_g(icon_temperature)
				var/h_b = heat2color_b(icon_temperature)
				if(icon_temperature < 2000) //scale up overlay until 2000K
					var/scale = (icon_temperature - 500) / 1500
					h_r = 64 + (h_r - 64)*scale
					h_g = 64 + (h_g - 64)*scale
					h_b = 64 + (h_b - 64)*scale
				animate(src, color = rgb(h_r, h_g, h_b), time = 20, easing = SINE_EASING)


obj/machinery/atmospherics/pipe/simple/heat_exchanging/initialize()
	var/dir_A = dir
	var/dir_HE = turn(dir,180)
	for(var/obj/machinery/atmospherics/target in get_step(src,dir_A))
		if(target.initialize_directions.Find(get_dir(target,src)))
			connect(src, target)
			break
	for(var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/target in get_step(src,dir_HE))
		if(target.initialize_directions.Find(get_dir(target,src)))
			connect(src, target)
			break
	if(!get_nodes_amount())
		qdel(src)
		return
	update_icon()
	return