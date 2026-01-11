
#define SENSORS_STRENGTH_COEFFICIENT 7

/obj/machinery/shipsensors
	name = "sensors suite"
	desc = "Long range gravity scanner with various other sensors, used to detect irregularities in surrounding space. Can only run in vacuum to protect delicate quantum BS elements."
	icon = 'icons/obj/machines/shipsensors.dmi'
	icon_state = "sensors"
	anchored = TRUE
	density = TRUE
	construct_state = /singleton/machine_construction/default/panel_closed
	health_max = 200
	var/critical_heat = 50 // sparks and takes damage when active & above this heat
	var/heat_reduction = 1.5 // mitigates this much heat per tick
	var/sensor_strength //used for detecting ships via contacts
	var/heat = 0
	var/range = 1
	idle_power_usage = 5000
	base_type = /obj/machinery/shipsensors
	maximum_component_parts = list(/obj/item/stock_parts = 10) // Circuit, 5 manipulators, 3 subspace shit and 1 tesla coil


/obj/machinery/shipsensors/upgraded
	uncreated_component_parts = list(/obj/item/stock_parts/manipulator/nano = 2)


/obj/machinery/shipsensors/RefreshParts()
	..()
	sensor_strength = clamp(total_component_rating_of_type(/obj/item/stock_parts/manipulator), 0, 5) * SENSORS_STRENGTH_COEFFICIENT

/obj/machinery/shipsensors/proc/in_vacuum()
	var/turf/T=get_turf(src)
	if (istype(T))
		var/datum/gas_mixture/environment = T.return_air()
		if (environment && environment.return_pressure() > MINIMUM_PRESSURE_DIFFERENCE_TO_SUSPEND)
			return 0
	return 1


/obj/machinery/shipsensors/on_update_icon()
	ClearOverlays()
	if (panel_open)
		AddOverlays("[icon_state]_panel")
	if (use_power)
		AddOverlays(emissive_appearance(icon, "[icon_state]_lights_working"))
		AddOverlays("[icon_state]_lights_working")
	if (health_dead())
		icon_state = "sensors_broken"
	. = ..()


/obj/machinery/shipsensors/proc/toggle()
	if (!use_power && (health_dead() || !in_vacuum()))
		return // No turning on if broken or misplaced.
	if (!use_power) //need some juice to kickstart
		use_power_oneoff(idle_power_usage*5)
	update_use_power(!use_power)
	power_change()
	queue_icon_update()


/obj/machinery/shipsensors/Process()
	..()
	if (use_power) //can't run in non-vacuum
		if (!in_vacuum())
			toggle()
		if (heat > critical_heat)
			src.visible_message(SPAN_DANGER("\The [src] violently spews out sparks!"))
			var/datum/effect/spark_spread/s = new /datum/effect/spark_spread
			s.set_up(3, 1, src)
			s.start()

			damage_health(rand(10, 50), DAMAGE_BURN)
			toggle()
		heat += idle_power_usage/15000

	if (heat > 0)
		heat = max(0, heat - heat_reduction)


/obj/machinery/shipsensors/power_change()
	. = ..()
	if (use_power && !powered())
		toggle()


/obj/machinery/shipsensors/proc/set_range(nrange)
	range = nrange
	change_power_consumption(1500 * (range**2), POWER_USE_IDLE) //Exponential increase, also affects speed of overheating


/obj/machinery/shipsensors/emp_act(severity)
	if (use_power)
		toggle()
	..()


/obj/machinery/shipsensors/on_death()
	if (use_power)
		toggle()
	..()


/obj/machinery/shipsensors/RefreshParts()
	..()
	heat_reduction = round(total_component_rating_of_type(/obj/item/stock_parts/manipulator) / 3)


/obj/item/stock_parts/circuitboard/shipsensors
	name = "circuit board (broad-band sensor suite)"
	board_type = "machine"
	icon_state = "mcontroller"
	build_path = /obj/machinery/shipsensors
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 5, TECH_BLUESPACE = 3)
	req_components = list(
		/obj/item/stock_parts/subspace/ansible = 1,
		/obj/item/stock_parts/subspace/filter = 1,
		/obj/item/stock_parts/subspace/treatment = 1,
		/obj/item/stock_parts/manipulator = 3
	)

#undef SENSORS_STRENGTH_COEFFICIENT
