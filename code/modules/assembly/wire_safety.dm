/obj/item/device/assembly/wire_safety
	name = "wired device"
	desc = "A weird device covered in a tangle of wiress"
	icon_state = "wire_safety"
	matter = list(DEFAULT_WALL_MATERIAL = 200, "waste" = 10)

	wires = WIRE_PROCESS_ACTIVATE | WIRE_PROCESS_SEND | WIRE_DIRECT_SEND
	wire_num = 3

	var/list/protected_index = list()
	var/protected_wire = "NULL"
	var/pulse = 0

	var/list/choice_wires = list("Direct Receive" = 1, "Direct Send" = 2, "Radio Receive" = 4,\
						  	     "Radio Send" = 8, "Receive Signal" = 16, "Send Signal" = 32,\
								 "Activation" = 64, "Power Receive" = 128, "Power Send" = 256,\
								 "Secondary Activation", 512, "Target Communication", 1024,\
								 "Data Connection" = 2048, "Internal Ticker" = 4096,\
								 "Safety" = 8192, "Maintenance" = 16384, "Clear" = 0)

	has_safety(index)
		if(index == protected_index)
			return 1
		return 0

	holder_wire_safety(var/obj/item/device/assembly/A, var/index = 0, var/pulsed = 0)
		var/cp = 90
		var/pp = 40
		if(pulse)
			cp = 0
			pp = 75
		cp /= (connects_to.len * protected_index.len)
		cp /= (connects_to.len * protected_index.len)
		if(index && index == protected_index)
			if(holder.get_index(A) in connects_to)
				if(pulsed && prob(pp))
					process_activation()
				else if(!pulsed && prob(cp))
					process_activation()

	get_data()
		return list("Pulse Protection", pulse)

	get_buttons()
		return list("Wire Protection")

	get_nonset_data()
		var/cp = 90
		var/pp = 40
		if(pulse)
			cp = 0
			pp = 75
		cp /= (connects_to.len * protected_index.len)
		cp /= (connects_to.len * protected_index.len)
		return list("Cut Detection Percentage:", cp, "Pulse Detection Percentage:", pp)

	Topic(href, href_list)
		if(href_list["option"])
			switch(href_list["option"])
				if("Wire Protection")
					open_window(usr)
				if("Pulse Protection")
					pulse = !pulse
		if(href_list["index"])
			protected_index |= href_list["index"]
		..()
	//Access window, but for wires.
	proc/open_window(var/mob/user as mob)
		var/t1 = ""
		for(var/W in choice_wires)
			if(!protected_index.len || !(choice_wires[W] in protected_index))
				t1 += "<a href='?src=\ref[src];index=[(choice_wires[W])]'>[W]</a><br>"
			else
				t1 += "<a style='color: red' href='?src=\ref[src];index=[(choice_wires[W])]'>[W]</a><br>"
		t1 += text("<p><a href='?src=\ref[];close=1'>Close</a></p>\n", src)
		user << browse(t1, "window=wires")
		onclose(user, "wiring")
