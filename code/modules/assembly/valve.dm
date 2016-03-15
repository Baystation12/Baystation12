/obj/item/device/assembly/valve
	name = "valve control"
	desc = "A device that can be placed on valves in order to control them."
	icon_state = "timer"
	matter = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 50, "waste" = 10)

	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_MISC_CONNECTION
	wire_num = 4

	var/list/actions = list("Close", "Open", "Toggle")
	var/trigger = "Open"
	var/obj/machinery/atmospherics/valve/target

/obj/item/device/assembly/valve/anchored(var/anchor = 0)
	if(anchor)
		target = locate(/obj/machinery/atmospherics/pipe) in get_turf(src)
	else
		target = null
	return 1

/obj/item/device/assembly/valve/get_data()
	return list("Trigger Action", action)

/obj/item/device/assembly/valve/Topic(href, href_list)
	if(href_list["option"])
		switch(href_list["option"])
			if("Trigger Action")
				var/index = actions.Find(action)
				if(index >= actions.len || !index) index = 1
				else index++
				action = actions[index]
	..()

/obj/item/device/assembly/valve/activate()
	if(target)
		switch(trigger)
			if("Open")
				target.open()
			if("Close")
				target.close()
			if("Toggle")
				if(target.open) target.close()
				else target.open()
		return 1
	return 0

