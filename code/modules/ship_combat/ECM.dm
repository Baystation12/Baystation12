/obj/machinery/space_battle/ecm
	name = "Electronic Counter Measures"
	desc = "A fire control computer."

	icon = 'icons/obj/ship_battles.dmi'
	icon_state = "ecm"
	density = 1
	anchored = 1
	var/radius = 3
	var/strength = 1
	var/obj/machinery/space_battle/missile_sensor/dish/dish
	var/sensor_id = null

	component_type = /obj/item/weapon/component/ecm

	idle_power_usage = 500
	active_power_usage = 500
	use_power = 2

	New()
		..()
		var/obj/item/weapon/component/ecm/comp = component
		idle_power_usage = comp.idle_power_usage
		reconnect()

	reconnect()
		for(var/obj/machinery/space_battle/missile_sensor/dish/D in world)
			if(D.sensor_id == sensor_id)
				dish = D
		return ..()

	proc/update_power_usage()
		active_power_usage = round(idle_power_usage ** (1+radius*0.05) * strength * get_efficiency(-1,1))
		..()

	attack_hand(var/mob/user)
		ui_interact(user)
		return

	proc/can_block(var/range = 3)
		if(range > radius || stat & (BROKEN|NOPOWER))
//			world << "ecm failure: range too great or broken"
			return 0
		else if(!dish || !dish.can_sense())
//			world << "ecm failure: [dish.can_sense()]"
			return 0
		return 1

/obj/machinery/space_battle/ecm/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = list()
	data["radius"] = radius
	data["power"] = round(idle_power_usage ** (1+radius*0.05) * strength * get_efficiency(-1,1))
	data["working"] = can_block(1)
	data["strength"] = strength
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "ecm.tmpl", "Electronic Counter Measures", 800, 500, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/space_battle/ecm/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["radius"])
		var/nradius = input(usr, "Enter a new range(0-[MAX_ECM_RANGE])", "ECM") as num
		if(isnum(nradius))
			radius = min(12, max(0, nradius))
		else
			usr << "<span class='warning'>That is invalid!</span>"
	if(href_list["strength"])
		var/nstrength = input(usr, "Enter a new strength(0-3)", "ECM") as num
		if(isnum(nstrength))
			radius = min(3, max(0, nstrength))
		else
			usr << "<span class='warning'>That is invalid!</span>"
	update_power_usage()
	return 1

/obj/machinery/space_battle/ecm/advanced
	component_type = /obj/item/weapon/component/ecm/ionic

/obj/machinery/space_battle/missile_sensor/eccm
	name = "electronic counter counter measures"
	desc = "Distrupts enemy ECM"
	needs_dish = 1
	var/strength = 1
	idle_power_usage = 200
	active_power_usage = 10000

	attack_hand(var/mob/user)
		if(!stat & (BROKEN|NOPOWER))
			strength++
			if(strength > 3) strength = 1
			user << "<span class='notice'>\The [src]'s strength is now: [strength]</span>"
			active_power_usage = initial(active_power_usage) * strength
		else return ..()

	can_sense()
		if(stat & (BROKEN))
			return "Broken"
		if(stat & NOPOWER)
			return "Insufficient Power"
		if(use_power == 1)
			return "Disabled"
		return ..() == 1 ? strength : 0
