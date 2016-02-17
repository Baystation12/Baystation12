/obj/item/device/assembly/target_finder
	name = "scanning device"
	desc = "A scanning device used for targetting."
	icon_state = "targetting"
	matter = list(DEFAULT_WALL_MATERIAL = 800, "glass" = 200, "waste" = 50)
	var/data_mode = 0
	var/range = 2

	wires = WIRE_MISC_CONNECTION | WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_PROCESS_SEND | WIRE_DIRECT_SEND | WIRE_MISC_SPECIAL
	wire_num = 7

/obj/item/device/assembly/target_finder/holder_click(target, mob/user, proximity_flag, click_parameters)
	add_debug_log("Processing holder_click \[[src]\]")
	if(istype(target, /mob/living))
		misc_special(target, user)
	return 0

/obj/item/device/assembly/target_finder/misc_special(mob/target, mob/user)
	add_debug_log("Running mob reference \[[src] to [target] \]")
	if(!istype(target)) return 0
	else if(get_dist(src, target) > range)
		add_debug_log("Range check failure! \[[src]\]")
		return 0
	else if(active_wires & WIRE_MISC_SPECIAL)
		for(var/obj/item/device/assembly/O in get_holder_linked_devices())
			if(!data_mode)
				O.misc_special(target, user)
			else
				send_direct_pulse(O)
		return 1
	else
		add_debug_log("Wire failure! \[[src]\]")
		return 0

/obj/item/device/assembly/target_finder/activate()
	var/mob/living/carbon/target
	for(var/mob/living/carbon/C in view(range+1))
		if(get_dist(C, src) < get_dist(target, src))
			target = C
	if(target)
		misc_special(target, null)

/obj/item/device/assembly/target_finder/get_data(var/mob/user, var/ui_key)
	var/list/data = list()
//	var/list/devices = get_holder_linked_devices()
//	for(var/i=1;i<=devices.len;i++)
//		if(istype(devices[i], /obj/item/device/assembly))
//			var/obj/item/device/assembly/A = devices[i]
//			data["connected_device[i]"] = "[i] : [A.name]"
	data.Add("Data Send Method", "[data_mode ? "Pulse" : "Data"]", "Range", range)
	return data

/obj/item/device/assembly.target_finder/Topic(href, href_list)
	if(href_list["option"])
		switch(href_list["option"])
			if("Data Send Method")
				data_mode = !data_mode
			if("Range")
				range++
				if(range >= 7)
					range = 1
				usr << "<span class='notice'>You set \the [src]'s range to [range]!</span>"
	..()






