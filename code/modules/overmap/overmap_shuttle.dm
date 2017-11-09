#define waypoint_sector(waypoint) map_sectors["[waypoint.z]"]

/datum/shuttle/autodock/overmap
	warmup_time = 10

	var/range = 0	//how many overmap tiles can shuttle go, for picking destinations and returning.
	var/fuel_consumption = 0 //Amount of moles of gas consumed per trip; If zero, then shuttle is magic and does not need fuel
	var/list/obj/structure/fuel_port/fuel_ports //the fuel ports of the shuttle (but usually just one)

	category = /datum/shuttle/autodock/overmap

/datum/shuttle/autodock/overmap/New(var/_name, var/obj/effect/shuttle_landmark/start_waypoint)
	..(_name, start_waypoint)
	refresh_fuel_ports_list()

/datum/shuttle/autodock/overmap/proc/refresh_fuel_ports_list() //loop through all
	fuel_ports = list()
	for(var/area/A in shuttle_area)
		for(var/obj/structure/fuel_port/fuel_port_in_area in A)
			fuel_port_in_area.parent_shuttle = src
			fuel_ports += fuel_port_in_area

<<<<<<< HEAD
/datum/shuttle/autodock/overmap/fuel_check()
	if(src.try_consume_fuel()) //insufficient fuel
=======
<<<<<<< HEAD
/datum/shuttle/autodock/overmap/fuel_check()
	if(src.try_consume_fuel()) //insufficient fuel
=======
/datum/shuttle/autodock/overmap/proc/fuel_check()
	var/datum/shuttle/autodock/overmap/this_shuttle = src
	if(!this_shuttle.try_consume_fuel()) //insufficient fuel
>>>>>>> f4426d73dbabaec5b7e0c2a7b56b75bce0b1a926
>>>>>>> origin/30-10-2017-shuttlefueltanks
		for(var/area/A in shuttle_area)
			for(var/mob/living/M in A)
				M.show_message("<spawn class='warning'>You hear the shuttle engines sputter... perhaps it doesn't have enough fuel?", AUDIBLE_MESSAGE,
				"<spawn class='warning'>The shuttle shakes but fails to take off.", VISIBLE_MESSAGE)
				return 0 //failure!
	return 1 //sucess, continue with launch

/datum/shuttle/autodock/overmap/proc/can_go()
	if(!next_location)
		return FALSE
	if(moving_status == SHUTTLE_INTRANSIT)
		return FALSE //already going somewhere, current_location may be an intransit location instead of in a sector
	return get_dist(waypoint_sector(current_location), waypoint_sector(next_location)) <= range

/datum/shuttle/autodock/overmap/can_launch()
	return ..() && can_go()

/datum/shuttle/autodock/overmap/can_force()
	return ..() && can_go()

/datum/shuttle/autodock/overmap/proc/set_destination(var/obj/effect/shuttle_landmark/A)
	if(A != current_location)
		next_location = A
		move_time = initial(move_time) * (1 + get_dist(waypoint_sector(current_location),waypoint_sector(next_location)))

/datum/shuttle/autodock/overmap/proc/get_possible_destinations()
	var/list/res = list()
	for (var/obj/effect/overmap/S in range(waypoint_sector(current_location), range))
		for(var/obj/effect/shuttle_landmark/LZ in S.get_waypoints(src.name))
			if(LZ.is_valid(src))
				res["[S.name] - [LZ.name]"] = LZ
	return res

/datum/shuttle/autodock/overmap/proc/get_location_name()
	if(moving_status == SHUTTLE_INTRANSIT)
		return "In transit"
	return "[waypoint_sector(current_location)] - [current_location]"

/datum/shuttle/autodock/overmap/proc/get_destination_name()
	if(!next_location)
		return "None"
	return "[waypoint_sector(next_location)] - [next_location]"

/datum/shuttle/autodock/overmap/proc/try_consume_fuel() //returns 1 if sucessful, returns 0 if error (like insufficient fuel)
	if(!fuel_consumption)
		return 1 //shuttles with zero fuel consumption are magic and can always launch
	else
		if(fuel_ports.len)
			var/list/obj/item/weapon/tank/fuel_tanks = list()
			for(var/obj/structure/FP in fuel_ports) //loop through fuel ports and assemble list of all fuel tanks
				if(FP.contents.len)
					var/obj/item/weapon/tank/FT = FP.contents[1]
					if(istype(FT))
						fuel_tanks += FT
			if(!fuel_tanks.len)
				return 0 //can't launch if you have no fuel TANKS in the ports
			var/total_flammable_gas_moles = 0
			for(var/obj/item/weapon/tank/FT in fuel_tanks)
				total_flammable_gas_moles += FT.air_contents.get_by_flag(XGM_GAS_FUEL)
			if(total_flammable_gas_moles >= fuel_consumption) //launch is possible, so start consuming that fuel
				var/fuel_to_consume = fuel_consumption
				for(var/obj/item/weapon/tank/FT in fuel_tanks) //loop through tanks, consume their fuel one by one
					if(FT.air_contents.get_by_flag(XGM_GAS_FUEL) >= fuel_to_consume)
						FT.air_contents.remove_by_flag(XGM_GAS_FUEL, fuel_to_consume)
						return 1 //ALL REQUIRED FUEL HAS BEEN CONSUMED, GO FOR LAUNCH!
					else //this tank doesn't have enough to launch shuttle by itself, so remove all its fuel, then continue loop
						fuel_to_consume -= FT.air_contents.get_by_flag(XGM_GAS_FUEL)
						FT.air_contents.remove_by_flag(XGM_GAS_FUEL, FT.air_contents.get_by_flag(XGM_GAS_FUEL))
			else
				return 0 //can't launch if you have insufficient fuel
		else
			return 0 //can't launch if you have no fuel PORTS at all

/obj/structure/fuel_port
	name = "fuel port"
	desc = "The fuel input port of the shuttle. Holds one phoron tank. Use a crowbar to open and close it."
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "fuel_port"
	density = 0
	anchored = 1
	var/icon_closed = "fuel_port"
	var/icon_empty = "fuel_port_empty"
	var/icon_full = "fuel_port_full"
	var/opened = 0
	var/parent_shuttle

/obj/structure/fuel_port/New()
	src.contents.Add(new/obj/item/weapon/tank/phoron)

/obj/structure/fuel_port/attack_hand(mob/user as mob)
	if(!opened)
		to_chat(user, "<spawn class='notice'>The door is secured tightly. You'll need a crowbar to open it.")
		return
	else if(contents.len > 0)
		user.put_in_hands(contents[1])
	update_icon()

/obj/structure/fuel_port/update_icon()
	if(opened)
		if(contents.len > 0)
			icon_state = icon_full
		else
			icon_state = icon_empty
	else
		icon_state = icon_closed

/obj/structure/fuel_port/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/crowbar))
		if(opened)
			to_chat(user, "<spawn class='notice'>You tightly shut \the [src] door.")
			playsound(src.loc, 'sound/effects/locker_close.ogg', 25, 0, -3)
			opened = 0
		else
			to_chat(user, "<spawn class='notice'>You open up \the [src] door.")
			playsound(src.loc, 'sound/effects/locker_open.ogg', 15, 1, -3)
			opened = 1
	else if(istype(W,/obj/item/weapon/tank))
		if(!opened)
			to_chat(user, "<spawn class='warning'>\The [src] door is still closed!")
			return
		if(contents.len == 0)
			user.drop_from_inventory(W)
			W.forceMove(src)
	update_icon()