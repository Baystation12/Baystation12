/obj/item/device/assembly/gps
	name = "relay positioning device"
	desc = "Triangulates the approximate co-ordinates using a nearby satellite network."
	icon_state = "locator"
	item_state = "locator"
	w_class = 2

	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_PROCESS_SEND | WIRE_DIRECT_SEND | WIRE_MISC_CONNECTION

	var/list/sent_types = list("x", "y", "z", "xy", "xyz")
	var/sent_type = "x"

/obj/item/device/assembly/gps/attack_self(var/mob/user as mob)
	process_activation()
	..()

/obj/item/device/assembly/gps/activate()
	var/turf/T = get_turf(src)
	if(T)
		T.visible_message("<span class='notice'> \icon[src] [src] flashes <i>[T.x].[rand(0,9)]:[T.y].[rand(0,9)]:[T.z].[rand(0,9)]</i></span>.")
		if(holder)
			switch(sent_type)
				if("x")
					send_data(list(T.x))
				if("y")
					send_data(list(T.y))
				if("z")
					send_data(list(T.z))
				if("xy")
					send_data(list(T.x, T.y))
				if("xyz")
					send_data(list(T.x, T.y, T.z))
		return 1
	return 0

/obj/item/device/assembly/gps/get_data()
	var/list/data = list()
	data.Add("Sending Coordinates", sent_type)
	return data


/obj/item/device/assembly/gps/Topic(href, href_list)
	if(href_list["option"])
		switch(href_list["option"])
			if("Sending Coordinates")
				var/index = sent_types.Find(sent_type)
				if(!index || index == sent_types.len) sent_type = sent_types[1]
				else
					sent_type = sent_types[(index+1)]
				usr << "<span class='notice'>You set \the [src]'s sent data to: \"[sent_type]\"</span>"
	..()


