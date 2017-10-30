#define waypoint_sector(waypoint) map_sectors["[waypoint.z]"]

/datum/shuttle/autodock/overmap
	warmup_time = 10

	var/range = 0	//how many overmap tiles can shuttle go, for picking destinations and returning.
	var/obj/shuttle/overmap/fuel_port/fuel_port //the fuel port of the shuttle

	category = /datum/shuttle/autodock/overmap

/datum/shuttle/autodock/overmap/New(var/_name, var/obj/effect/shuttle_landmark/start_waypoint)
	..(_name, start_waypoint)

	for(var/area/A in shuttle_area)
		for(var/obj/shuttle/overmap/fuel_port/fuel_port_in_area in A)
			fuel_port_in_area.parent_shuttle = src
			fuel_port = fuel_port_in_area

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

/datum/shuttle/autodock/overmap/proc/try_consume_fuel() //returns 1 if sucessful, returns 0 if insufficient fuel
	if(!fuel_port)
		return 1 //shuttles without fuel ports can ALWAYS launch
	else
		if(fuel_port.contents.len)
			var/obj/item/weapon/tank/fuel_tank = fuel_port.contents[1]
			if(istype(fuel_tank))
				if(fuel_tank.air_contents.gas["phoron"] >= 4)
					fuel_tank.air_contents.gas["phoron"] -= 4
					fuel_tank.air_contents.update_values()
					return 1 //fuel consumed, launch sucessful!
				else
					return 0 //insufficient fuel
			else
				return 0 //something weird happened
		else
			return 0 //can't launch if your fuel tank is missing...

/obj/shuttle/overmap/fuel_port
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

/obj/shuttle/overmap/fuel_port/New()
	src.contents.Add(new/obj/item/weapon/tank/phoron)

/obj/shuttle/overmap/fuel_port/attack_hand(mob/user as mob)
	if(!opened)
		to_chat(user, "<spawn class='notice'>The door is secured tightly. You'll need a crowbar to open it.")
		return
	else if(contents.len > 0)
		user.put_in_hands(contents[1])
	update_icon()

/obj/shuttle/overmap/fuel_port/update_icon()
	if(opened)
		if(contents.len > 0)
			icon_state = icon_full
		else
			icon_state = icon_empty
	else
		icon_state = icon_closed

/obj/shuttle/overmap/fuel_port/attackby(obj/item/weapon/W as obj, mob/user as mob)
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