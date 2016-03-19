/obj/item/device/assembly/target_control
	name = "target scanner"
	desc = "Used for scanning targets."
	icon_state = "prox"
	matter = list(DEFAULT_WALL_MATERIAL = 800, "glass" = 200, "waste" = 50)

	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_PROCESS_SEND | WIRE_DIRECT_SEND | WIRE_MISC_SPECIAL | WIRE_MISC_CONNECTION
	wire_num = 7

	var/list/modes = list("Name", "Gender")
	var/mode = "Name"

/obj/item/device/assembly/target_control/misc_special(var/mob/living/L)
	switch(mode)
		if("Name")
			send_data(list(L.name))
		if("Gender")
			send_data(list(L.gender))
	return 1
/obj/item/device/assembly/target_control/get_data()
	return list("Mode", mode)

/obj/item/device/assembly/target_control/Topic(href, href_list)
	if(href_list["option"])
		switch(href_list["option"])
			if("Mode")
				var/i = modes.Find(mode)
				i++
				if(i > modes.len) i = 1
				mode = modes[i]
	..()