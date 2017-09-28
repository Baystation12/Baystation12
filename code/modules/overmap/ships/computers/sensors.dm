/obj/machinery/power/shipsensors
	name = "sensors suite"
	desc = "Long range gravity scanner with various other sensors, used to detect irregularities in surrounding space. Can only run in vacuum to protect delicate quantum BS elements."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "sensors"
	use_power = 0
	var/max_health = 200
	var/health = 200
	var/range = 1
	var/enabled = FALSE
	var/base_power_usage = 15000
	var/power_usage_multiplier = 1.65	// Results in approx. 500kW @ 7 tiles range

/obj/machinery/power/shipsensors/New()
	..()
	uid = gl_uid++

/obj/machinery/power/shipsensors/attackby(obj/item/weapon/W, mob/user)
	var/damage = max_health - health
	if(damage && istype(W, /obj/item/weapon/weldingtool))

		var/obj/item/weapon/weldingtool/WT = W

		if(!WT.isOn())
			return

		if(WT.remove_fuel(0,user))
			to_chat(user, "<span class='notice'>You start repairing the damage to [src].</span>")
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			if(do_after(user, max(5, damage / 5), src) && WT && WT.isOn())
				to_chat(user, "<span class='notice'>You finish repairing the damage to [src].</span>")
				take_damage(-damage)
		else
			to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
			return
		return
	..()

/obj/machinery/power/shipsensors/proc/in_vacuum()
	var/turf/T=get_turf(src)
	if(istype(T))
		var/datum/gas_mixture/environment = T.return_air()
		if(environment && environment.return_pressure() > MINIMUM_PRESSURE_DIFFERENCE_TO_SUSPEND)
			return 0
	return 1

/obj/machinery/power/shipsensors/update_icon()
	var/obj/effect/overmap/ship/linked = map_sectors["[z]"]
	if(enabled && linked)
		icon_state = "sensors"
		linked.set_light(range + 1, range * 2)
	else
		icon_state = "sensors_off"
		linked.set_light(0)

/obj/machinery/power/shipsensors/examine(mob/user)
	. = ..()
	if(health == 0)
		to_chat(user, "\The [src] is wrecked.")
	if(health < max_health * 0.25)
		to_chat(user, "\The [src] looks like it's about to break!")
	else if(health < max_health * 0.5)
		to_chat(user, "\The [src] looks seriously damaged!")
	else if(health < max_health * 0.75)
		to_chat(user, "\The [src] shows signs of damage!")

/obj/machinery/power/shipsensors/bullet_act(var/obj/item/projectile/Proj)
	take_damage(Proj.get_structure_damage())
	..()

/obj/machinery/power/shipsensors/proc/toggle()
	if(!enabled && ((health <= 0) || !has_power()))
		return
	enabled = !enabled
	update_icon()

/obj/machinery/power/shipsensors/process()
	..()
	if(!enabled)
		return
	if(!in_vacuum() || !has_power())
		toggle()
		return
	powernet.draw_power(power_usage())

/obj/machinery/power/shipsensors/proc/power_usage()
	return base_power_usage * (power_usage_multiplier ** range)

/obj/machinery/power/shipsensors/proc/has_power()
	return powernet && (powernet.last_surplus() >= power_usage())

/obj/machinery/power/shipsensors/power_change()
	return

/obj/machinery/power/shipsensors/emp_act(severity)
	if(!enabled)
		return
	take_damage(20/severity)
	toggle()

/obj/machinery/power/shipsensors/proc/take_damage(value)
	health = min(max(health - value, 0),max_health)
	if(enabled && health == 0)
		toggle()