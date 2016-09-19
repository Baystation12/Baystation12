/obj/machinery/space_battle/missile_sensor
	name = "missile sensor"
	desc = "Used to fire and guide missile systems."
	icon = 'icons/obj/ship_battles.dmi'
	icon_state = "sensor"
	var/sensor_id = null // For dishes
	use_power = 2
	idle_power_usage = 100
	active_power_usage = 600
	density = 1
	anchored = 1

	var/needs_dish = 0
	var/obj/machinery/space_battle/missile_sensor/dish/dish

	initialize()
		..()
		reconnect()
		var/area/ship_battle/A = get_area(src)
		if(A && istype(A))
			req_access = list(A.team*10 - SPACE_ENGINEERING)


	Destroy()
		sensor_id = null
		if(dish)
			dish.linked_sensor = null
			dish = null
		return ..()

	attack_hand(var/mob/user)
		src.visible_message("<span class='notice'>\The [user] begins inspecting \the [src]..</span>")
		if(do_after(user, 50))
			var/efficiency = get_efficiency(1,0,0)
			user << "<span class='[efficiency < 50 ? "warning" : "notice"]'>\The [src] has an efficiency of: [efficiency]%</span>"
			user << "<span class='notice'>\The [src] ID tag is set to: \"[id_tag]\"</span>"
			if(use_power == 1)
				user << "<span class='warning'>\The [src] is disabled!</span>"
			if(!istype(src, /obj/machinery/space_battle/missile_sensor/hub))
				user << "<span class='notice'>\The [src] External Dish ID is set to: \"[sensor_id]\" \
				<b><A href='?src=\ref[src];change_sensor_id=[1]'>\[Change\]</A></b></span>"
				var/sensing = can_sense()
				if(sensing == 1) user << "<span class='notice'>\The [src] is working properly!</span>"
				else user << "<span class='warning'>\The [src] produces an error when tested, \"[sensing]\"</span>"

	Topic(href, href_list)
		if(Adjacent(usr) && !usr.stat)
			if(href_list["change_sensor_id"])
				var/mob/living/carbon/human/H = usr
				if(!istype(H))
					usr << "<span class='warning'>Only humans can do this!</span>"
					return
				if(!allowed(H))
					usr << "<span class='warning'>You don't have access to do that!</span>"
					return
				var/inp = input(usr, "What would you like to change \the [src]'s ID to?")
				if(inp)
					if(length(inp) < 25)
						src.visible_message("<span class='notice'>\The [usr] begins modifying \the [src]'s external sensor id..</span>")
						if(do_after(usr, 50))
							sensor_id = inp
							reconnect()
							usr << "<span class='notice'>You set \the [src]'s sensor identification to, \"[sensor_id]\"</span>"
					else
						usr << "<span class='warning'>That is too long!</span>"
		..()

	proc/can_sense()
		if(stat & (BROKEN))
			return "Broken"
		if(stat & NOPOWER)
			return "Insufficient Power"
		if(use_power == 1)
			return "Disabled"
		if(needs_dish)
			if(!dish)
				reconnect()
				if(!dish)
					return "Wireless Connection Severed: No connected dish."
			else if(!dish.can_sense())
				return "Wireless Connection Severed: Dish status - [dish.can_sense()]"
		return 1

	examine(var/mob/user)
		..()
		if(use_power == 1)
			usr << "<span class='warning'>It's disabled!</span>"

	emp_act(var/severity = 0)
		if(severity)
			if(prob(100/severity))
				toggle_active()
		..()

	reconnect()
		dish = null
		if(needs_dish)
			for(var/obj/machinery/space_battle/missile_sensor/dish/D in world)
				if(D.sensor_id == src.sensor_id && src.z == D.z)
					dish = D
					D.linked_sensor = src
					break

	proc/toggle_active()
		if(use_power == 1)
			use_power = 2
			linked.em_signature += 1
		else
			use_power = 1
			linked.em_signature -= 1

	attackby(var/obj/item/O, var/mob/user)
		if(!stat & (BROKEN|NOPOWER))
			if(istype(O, /obj/item/stack/cable_coil))
				user.visible_message("<span class='notice'>[user] [use_power > 1 ? "disables" : "enables"] \the [src]!</span>", "<span class='notice'>You [use_power > 1 ? "disable" : "enable"] \the [src]!")
				toggle_active()
				return
			if(istype(O, /obj/item/weapon/wrench))
				anchored = !anchored
				user.visible_message("<span class='notice'>\The [user] [anchored ? "" : "un"]anchors \the [src]!</span>")
		..()

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
	var/obj/machinery/space_battle/missile_sensor/ship_sensor/target_finder

/obj/machinery/space_battle/missile_sensor/tracking/proc/find_targets()
	return target_finder.find_targets()

/obj/machinery/space_battle/missile_sensor/tracking/reconnect()
	for(var/obj/machinery/space_battle/missile_sensor/ship_sensor/T in world)
		if(T.z == src.z && id_tag && T.id_tag == src.id_tag)
			target_finder = T
	..()

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
	can_be_destroyed = 0

	var/obj/machinery/space_battle/missile_sensor/guidance/guidance
	var/obj/machinery/space_battle/missile_sensor/tracking/tracking
	var/obj/machinery/space_battle/missile_sensor/scanning/scanning
	var/obj/machinery/space_battle/missile_sensor/thermal/thermal
	var/obj/machinery/space_battle/missile_sensor/microwave/microwave
	var/obj/machinery/space_battle/missile_sensor/xray/xray
	var/obj/machinery/space_battle/missile_sensor/advguidance/advguidance
	var/obj/machinery/space_battle/missile_sensor/eccm
	var/obj/machinery/space_battle/missile_sensor/ship_sensor/sensor

	var/list/radars = list()

/obj/machinery/space_battle/missile_sensor/hub/Destroy()
	guidance = null
	tracking = null
	scanning = null
	thermal = null
	microwave = null
	xray = null
	eccm = null
	return ..()

/obj/machinery/space_battle/missile_sensor/hub/reconnect()
	spawn(3)
	if(linked)
		linked.reconnect()
	for(var/obj/machinery/space_battle/missile_computer/F in world)
		if(F.id_tag == src.id_tag && F.z == src.z)
			F.sensor = src
			linked = F
	for(var/obj/machinery/space_battle/missile_sensor/M in world)
		if(M.id_tag == src.id_tag && M.z == src.z)
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
			if(istype(M, /obj/machinery/space_battle/missile_sensor/eccm) && !eccm)
				eccm = M
			if(istype(M, /obj/machinery/space_battle/missile_sensor/radar))
				radars.Add(M)
			if(istype(M, /obj/machinery/space_battle/missile_sensor/ship_sensor) && !sensor)
				sensor = M
	rename()
	return

/obj/machinery/space_battle/missile_sensor/hub/rename()
	var/id_num
	if(linked)
		id_num = linked.id_num
	if(!id_num) return
	name = "[initial(name)]([id_num])"
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
	for(var/obj/machinery/space_battle/missile_sensor/radar/R in radars)
		R.name = "[initial(R.name)]([id_num])"
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

/obj/machinery/space_battle/missile_sensor/hub/proc/has_eccm()
	if(can_sense())
		if(eccm)
			return eccm.can_sense()
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
	return radars

/obj/machinery/space_battle/missile_sensor/hub/proc/get_firing_targets()
	if(sensor)
		return sensor.find_targets()
	return 0
/****************
*Overmap Sensors*
****************/

/obj/machinery/space_battle/missile_sensor/ship_sensor
	name = "ship sensor"
	desc = "A ship sensor."
	component_type = /obj/item/weapon/component/sensor
	needs_dish = 1

/obj/machinery/space_battle/missile_sensor/ship_sensor/proc/find_targets()
	if(!can_sense()) return 0
	if(component && istype(component, /obj/item/weapon/component/sensor))
		var/obj/item/weapon/component/sensor/S = component
		return S.find_targets()
	else return 0

/obj/machinery/space_battle/missile_sensor/ship_sensor/gravity // Allows the eye to move
	name = "gravity sensor"
	desc = "Searches for ships within the specified range."
	needs_dish = 1
	icon_state = "tracker"
	component_type = /obj/item/weapon/component/sensor/gravity

/obj/machinery/space_battle/missile_sensor/ship_sensor/em // Allows the eye to move
	name = "em sensor"
	desc = "Searches for active weaponry or shields."
	needs_dish = 1
	icon_state = "tracker"
	component_type = /obj/item/weapon/component/sensor/em

/obj/machinery/space_battle/missile_sensor/ship_sensor/thermal // Allows the eye to move
	name = "thermal sensor"
	desc = "Searches for thermal signatures."
	needs_dish = 1
	icon_state = "tracker"
	component_type = /obj/item/weapon/component/sensor/thermal



