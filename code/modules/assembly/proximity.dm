/obj/item/device/assembly/prox_sensor
	name = "proximity sensor"
	desc = "Used for scanning and alerting when someone enters a certain proximity."
	icon_state = "prox"
	matter = list(DEFAULT_WALL_MATERIAL = 800, "glass" = 200, "waste" = 50)

	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_PROCESS_SEND | WIRE_DIRECT_SEND
	wire_num = 5

	var/scanning = 0
	var/timing = 0
	var/time = 10

	var/range = 2
	var/send_type = 0

	proc
		toggle_scan()
		sense()


/obj/item/device/assembly/prox_sensor/activate()
	timing = !timing
	update_icon()
	return ..()

/obj/item/device/assembly/prox_sensor/HasProximity(atom/movable/AM as mob|obj)
	if (istype(AM, /obj/effect/beam))	return
	if (AM.move_speed < 12)	sense(AM)
	return


/obj/item/device/assembly/prox_sensor/sense(var/atom/movable/AM)
	if(active_wires & WIRE_DIRECT_RECEIVE && scanning)
		var/turf/mainloc = get_turf(src)
		if(send_type || (AM && !istype(AM, /mob/living)))
			receive_direct_pulse()
		else
			for(var/obj/item/device/assembly/A in get_connected_devices())
				A.misc_special(AM)
		if(!holder)
			mainloc.visible_message("\icon[src] *beep* *beep*", "*beep* *beep*")
		return

/obj/item/device/assembly/prox_sensor/process()
	if(scanning)
		var/turf/mainloc = get_turf(src)
		for(var/mob/living/A in range(range,mainloc))
			if (A.move_speed < 12)
				sense(A)
	if(timing)
		time--
	if(timing && time <= 0)
		timing = 0
		toggle_scan()
		time = 10
	return


/obj/item/device/assembly/prox_sensor/dropped()
	spawn(0)
		sense()
		return
	return


/obj/item/device/assembly/prox_sensor/toggle_scan()
	scanning = !scanning
	return

/obj/item/device/assembly/prox_sensor/Move()
	..()
	sense()
	return

/*
	interact(mob/user as mob)//TODO: Change this to the wires thingy
		var/second = time % 60
		var/minute = (time - second) / 60
		var/dat = text("<TT><B>Proximity Sensor</B>\n[] []:[]\n<A href='?src=\ref[];tp=-30'>-</A> <A href='?src=\ref[];tp=-1'>-</A> <A href='?src=\ref[];tp=1'>+</A> <A href='?src=\ref[];tp=30'>+</A>\n</TT>", (timing ? text("<A href='?src=\ref[];time=0'>Arming</A>", src) : text("<A href='?src=\ref[];time=1'>Not Arming</A>", src)), minute, second, src, src, src, src)
		dat += text("<BR>Range: <A href='?src=\ref[];range=-1'>-</A> [] <A href='?src=\ref[];range=1'>+</A>", src, range, src)
		dat += "<BR><A href='?src=\ref[src];scanning=1'>[scanning?"Armed":"Unarmed"]</A> (Movement sensor active when armed!)"
		dat += "<BR><BR><A href='?src=\ref[src];refresh=1'>Refresh</A>"
		dat += "<BR><BR><A href='?src=\ref[src];close=1'>Close</A>"
		user << browse(dat, "window=prox")
		onclose(user, "prox")
		return
*/
/obj/item/device/assembly/prox_sensor/get_data()
	return list("Scanning", scanning, "Range", range, "Time", time, "Armed", timing, "Send Type", (send_type ? "Pulse" : "Target communication"))


/obj/item/device/assembly/prox_sensor/Topic(href, href_list)
	if(!usr.canmove || usr.stat || usr.restrained() || !in_range(loc, usr))
		usr << browse(null, "window=prox")
		onclose(usr, "prox")
		return

	if(href_list["option"])
		switch(href_list["option"])
			if("Scanning")
				toggle_scan()
			if("Time")
				var/inp = text2num(input(usr, "What would you like to set the time to?", "Proximity Sensor"))
				if(inp && isnum(inp))
					time = min(max(round(inp), 0), 600)
			if("Range")
				var/inp = text2num(input(usr, "What would you like to set the time to?", "Proximity Sensor"))
				if(inp && isnum(inp))
					range = min(max(inp, 1), 6)
			if("Armed")
				if(scanning)
					timing = !timing
					if(timing)
						processing_objects.Add(src)
					else
						processing_objects.Remove(src)
				else
					usr << "<span class='notice'>The proximity sensor is not scanning!</span>"
			if("Send Type")
				send_type = !send_type
	..()
