/obj/machinery/space_battle/missile_sensor
	name = "missile sensor"
	desc = "Used to fire and guide missile systems."
	icon = 'icons/obj/ship_battles.dmi'
	icon_state = "sensor"
	var/sensor_id = null // For dishes
	var/can_sense = 1
	idle_power_usage = 400
	density = 1
	anchored = 1

	var/needs_dish = 0
	var/obj/machinery/space_battle/missile_sensor/dish/dish

	New()
		..()
		reconnect()

	Destroy()
		sensor_id = null
		if(dish)
			dish.linked_sensor = null
			dish = null
		return ..()

	proc/can_sense()
		if(stat & (BROKEN))
			return "Broken"
		if(stat & NOPOWER)
			return "Insufficient Power"
		if(!can_sense)
			return "Disabled"
		if(needs_dish)
			if(!dish)
				return "Wireless Connection Severed: Dish not responding."
			else if(!dish.can_sense())
				return "Wireless Connection Severed: Dish status - [dish.can_sense()]"
		return 1

	examine(var/mob/user)
		..()
		if(!can_sense)
			usr << "<span class='warning'>It's disabled!</span>"

	emp_act()
		can_sense = 0
		..()

	reconnect()
		spawn(2)
		if(needs_dish)
			for(var/obj/machinery/space_battle/missile_sensor/dish/D in world)
				if(D.sensor_id == src.sensor_id && src.sensor_id)
					if(!D.linked_sensor)
						dish = D
						D.linked_sensor = src
						break

	attackby(var/obj/item/O, var/mob/user)
		..()
		if(istype(O, /obj/item/weapon/wrench))
			user.visible_message("<span class='notice'>[user] [can_sense ? "disables" : "enables"] \the [src]!</span>", "<span class='notice'>You [can_sense ? "disable" : "enable"] \the [src]!")
			can_sense = !can_sense

/obj/machinery/space_battle/missile_sensor/dish
	name = "radar dish"
	desc = "A large, metal disc for relaying information through the depths of space."
	idle_power_usage = 250
	icon_state = "dish"
	needs_dish = 0
	density = 0
	has_circuit = 0

	var/obj/machinery/space_battle/missile_sensor/linked_sensor

	reconnect()
		return 0

	Destroy()
		if(linked_sensor)
			linked_sensor.dish = null
			linked_sensor = null
		return ..()

/obj/machinery/space_battle/missile_sensor/guidance // Without it, missiles fire at the enemy ship randomly.
	name = "missile guidance system"
	desc = "Guides missiles to their desired location."
	icon_state = "guidance"
	needs_dish = 1

/obj/machinery/space_battle/missile_sensor/tracking // Allows the eye to move
	name = "ship tracking system"
	desc = "Allows the enemy ship to be easily tracked."
	needs_dish = 1
	icon_state = "tracker"

/obj/machinery/space_battle/missile_sensor/scanning // Allows the eye nightvision & see_turf
	name = "ship radar"
	desc = "Allows the enemy ship to be properly located."
	needs_dish = 1
	icon_state = "scanner"

/obj/machinery/space_battle/missile_sensor/thermal // Allows the eye see_mob
	name = "thermal sensor"
	desc = "Shows thermal signatures."
	needs_dish = 1
	icon_state = "thermal"

/obj/machinery/space_battle/missile_sensor/microwave
	name = "microwave sensor"
	desc = "Shows small items."
	needs_dish = 1
	icon_state = "microwave"

/obj/machinery/space_battle/missile_sensor/xray
	name = "xray device"
	desc = "Allows internal view of enemy ship"
	needs_dish = 1
	icon_state = "xray"

/obj/machinery/space_battle/missile_sensor/radar
	name = "radar system"
	desc = "Reduces firing cost"
	needs_dish = 1
	icon_state = "radar"

/obj/machinery/space_battle/missile_sensor/advguidance
	name = "advanced guidance"
	desc = "Allows fire arcing and guided missiles."
	needs_dish = 1
	icon_state = "advguidance"

/obj/machinery/space_battle/missile_sensor/hub
	name = "sensor hub"
	desc = "A hub filled with cable inputs."
	icon_state = "hub"

	var/obj/machinery/space_battle/missile_sensor/guidance/guidance
	var/obj/machinery/space_battle/missile_sensor/tracking/tracking
	var/obj/machinery/space_battle/missile_sensor/scanning/scanning
	var/obj/machinery/space_battle/missile_sensor/thermal/thermal
	var/obj/machinery/space_battle/missile_sensor/microwave/microwave
	var/obj/machinery/space_battle/missile_sensor/xray/xray
	var/obj/machinery/space_battle/missile_sensor/advguidance/advguidance

	var/list/radars = list()

/obj/machinery/space_battle/missile_sensor/hub/Destroy()
	guidance = null
	tracking = null
	scanning = null
	thermal = null
	microwave = null
	xray = null
	return ..()

/obj/machinery/space_battle/missile_sensor/hub/reconnect()
	spawn(3)
	for(var/obj/machinery/space_battle/missile_sensor/M in world)
		if(M.id_tag == src.id_tag)
			if(istype(M, /obj/machinery/space_battle/missile_sensor/guidance) && !guidance)
				guidance = M
			if(istype(M, /obj/machinery/space_battle/missile_sensor/tracking) && !tracking)
				tracking = M
			if(istype(M, /obj/machinery/space_battle/missile_sensor/scanning) && !scanning)
				scanning = M
			if(istype(M, /obj/machinery/space_battle/missile_sensor/thermal) && !thermal)
				thermal = M
			if(istype(M, /obj/machinery/space_battle/missile_sensor/microwave) && !microwave)
				microwave = M
			if(istype(M, /obj/machinery/space_battle/missile_sensor/xray) && !xray)
				xray = M
			if(istype(M, /obj/machinery/space_battle/missile_sensor/advguidance) && !advguidance)
				advguidance = M
			if(istype(M, /obj/machinery/space_battle/missile_sensor/radar))
				radars.Add(M)
	return

/obj/machinery/space_battle/missile_sensor/hub/proc/set_names(var/id_num)
	reconnect()
	if(guidance)
		guidance.name = "[initial(guidance.name)]([id_num])"
	if(tracking)
		tracking.name = "[initial(tracking.name)]([id_num])"
	if(scanning)
		scanning.name = "[initial(scanning.name)]([id_num])"
	if(thermal)
		thermal.name = "[initial(thermal.name)]([id_num])"
	if(microwave)
		microwave.name = "[initial(microwave.name)]([id_num])"
	if(xray)
		xray.name = "[initial(xray.name)]([id_num])"
	if(advguidance)
		advguidance.name = "[initial(advguidance.name)]([id_num])"
	return

/obj/machinery/space_battle/missile_sensor/hub/proc/has_guidance()
	if(can_sense())
		if(guidance)
			return guidance.can_sense()
		return "Unconnected!"
	return 0

/obj/machinery/space_battle/missile_sensor/hub/proc/has_advguidance()
	if(can_sense())
		if(advguidance)
			return advguidance.can_sense()
		return "Unconnected!"
	return 0

/obj/machinery/space_battle/missile_sensor/hub/proc/has_tracking()
	if(can_sense())
		if(tracking)
			return tracking.can_sense()
		return "Unconnected!"
	return 0

/obj/machinery/space_battle/missile_sensor/hub/proc/has_scanning()
	if(can_sense())
		if(scanning)
			return scanning.can_sense()
		return "Unconnected!"
	return 0

/obj/machinery/space_battle/missile_sensor/hub/proc/has_thermal()
	if(can_sense())
		if(thermal)
			return thermal.can_sense()
		return "Unconnected"
	return 0

/obj/machinery/space_battle/missile_sensor/hub/proc/has_microwave()
	if(can_sense())
		if(microwave)
			return microwave.can_sense()
		return "Unconnected"
	return 0

/obj/machinery/space_battle/missile_sensor/hub/proc/has_xray()
	if(xray && can_sense())
		if(has_scanning() && has_thermal() && has_microwave())
			return xray.can_sense()
		else
			return "Prerequisites nonfunctional."
	return 0

/obj/machinery/space_battle/missile_sensor/hub/proc/has_radars()
	if(!can_sense()) return 0
	var/count = 0
	for(var/obj/machinery/space_battle/missile_sensor/radar/M in radars)
		if(M.can_sense())
			count++
	return count



