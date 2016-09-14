/obj/item/device/assembly/timer
	name = "timer"
	desc = "Used to time things. Works well with contraptions which have a count down. Tick tock."
	icon_state = "timer"
	matter = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 50, "waste" = 10)

	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_PROCESS_SEND | WIRE_DIRECT_SEND | WIRE_MISC_CONNECTION | WIRE_ASSEMBLY_PROCESS | WIRE_MISC_ACTIVATE
	wire_num = 8

	var/timing = 0
	var/time = 10
	var/time_to_set = 10

	proc
		timer_end()

/obj/item/device/assembly/timer/get_data()
	var/list/data = list()
	data.Add("Time", time, "Time to Set", time_to_set)
	return data

/obj/item/device/assembly/timer/New()
	..()
	processing_objects.Add(src)

/obj/item/device/assembly/timer/Destroy()
	processing_objects.Remove(src)
	..()

/obj/item/device/assembly/timer/activate()
	timing = 1
	update_icon()
	return 1

/obj/item/device/assembly/timer/timer_end()
	if(holder)
		misc_activate()
	else
		visible_message("\icon[src] *beep* *beep*", "*beep* *beep*")
	spawn(10)
		time = time_to_set
	timing = 0
	return

/obj/item/device/assembly/timer/misc_activate()
	if(active_wires & WIRE_MISC_ACTIVATE)
		send_pulse_to_connected()
		return 1
	return 0


/obj/item/device/assembly/timer/process()
	if(active_wires & WIRE_ASSEMBLY_PROCESS)
		if(timing && (time > 0))
			time--
			add_debug_log("\[[src] : [time]\]")
		if(timing && time <= 0)
			timing = 0
			timer_end()
	else
		timing = 0
		timer_end()
		return



/*	interact(mob/user as mob)//TODO: Have this use the wires
		if(!secured)
			user.show_message("\red The [name] is unsecured!")
			return 0
		var/second = time % 60
		var/minute = (time - second) / 60
		var/dat = text("<TT><B>Timing Unit</B>\n[] []:[]\n<A href='?src=\ref[];tp=-30'>-</A> <A href='?src=\ref[];tp=-1'>-</A> <A href='?src=\ref[];tp=1'>+</A> <A href='?src=\ref[];tp=30'>+</A>\n</TT>", (timing ? text("<A href='?src=\ref[];time=0'>Timing</A>", src) : text("<A href='?src=\ref[];time=1'>Not Timing</A>", src)), minute, second, src, src, src, src)
		dat += "<BR><BR><A href='?src=\ref[src];refresh=1'>Refresh</A>"
		dat += "<BR><BR><A href='?src=\ref[src];close=1'>Close</A>"
		user << browse(dat, "window=timer")
		onclose(user, "timer")
		return
*/

/obj/item/device/assembly/timer/Topic(href, href_list)
	if(href_list["option"])
		switch(href_list["option"])
			if("Time")
				var/inp = input(usr, "What would you like to set the time to?", "[src.interface_name]")
				inp = text2num(inp)
				if(inp)
					inp = max(1, inp)
					time = min(300, inp) // 5 mins max.
			if("Time to Set")
				var/num = input(usr, "What would you like to set the default time to?", "Repeater")
				if(num)
					time_to_set = min(120, num)
					time_to_set = max(0, num)
	..()

/obj/item/device/assembly/timer/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/stack/cable_coil))
		if(istype(src, /obj/item/device/assembly/timer/repeater))
			user << "<span class='notice'>\The [src] is already modified!</span>"
			return
		var/obj/item/stack/cable_coil/cable = W
		if(!cable.amount >= 10)
			user << "<span class='notice'>You need atleast ten units of cable to do this!</span>"
			return
		user << "<span class='notice'>You start wiring up \the [src]!</span>"
		spawn(50)
			if(user in view(2))
				cable.use(10)
				user.visible_message("<span class='warning'>\The [user] modifies \the [src]!</span>", "<span class='notice'>You add some wiring to \the [src], allowing it to trigger devices when tripped!</span>")
				var/obj/item/device/assembly/timer/repeater/repeater = new()
				repeater.forceMove(get_turf(src))
				qdel(src)
				return
	..()
