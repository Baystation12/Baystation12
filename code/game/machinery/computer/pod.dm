//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/pod
	name = "Pod Launch Control"
	desc = "A controll for launching pods. Some people prefer firing Mechas."
	icon_state = "computer_generic"
	var/id = 1.0
	var/obj/machinery/mass_driver/connected = null
	var/timing = 0.0
	var/time = 30.0
	var/title = "Mass Driver Controls"


/obj/machinery/computer/pod/New()
	..()
	spawn( 5 )
		for(var/obj/machinery/mass_driver/M in world)
			if(M.id == id)
				connected = M
			else
		return
	return


/obj/machinery/computer/pod/proc/alarm()
	if(stat & (NOPOWER|BROKEN))
		return

	if(!( connected ))
		viewers(null, null) << "Cannot locate mass driver connector. Cancelling firing sequence!"
		return

	for(var/obj/machinery/door/poddoor/M in world)
		if(M.id == id)
			M.open()
			return
	sleep(20)

	for(var/obj/machinery/mass_driver/M in world)
		if(M.id == id)
			M.power = connected.power
			M.drive()

	sleep(50)
	for(var/obj/machinery/door/poddoor/M in world)
		if(M.id == id)
			M.close()
			return
	return


/obj/machinery/computer/pod/attackby(I as obj, user as mob)
	if(istype(I, /obj/item/weapon/screwdriver))
		playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			if(stat & BROKEN)
				user << "\blue The broken glass falls out."
				var/obj/structure/computerframe/A = new /obj/structure/computerframe( loc )
				new /obj/item/weapon/shard( loc )

				//generate appropriate circuitboard. Accounts for /pod/old computer types
				var/obj/item/weapon/circuitboard/pod/M = null
				if(istype(src, /obj/machinery/computer/pod/old))
					M = new /obj/item/weapon/circuitboard/olddoor( A )
					if(istype(src, /obj/machinery/computer/pod/old/syndicate))
						M = new /obj/item/weapon/circuitboard/syndicatedoor( A )
					if(istype(src, /obj/machinery/computer/pod/old/swf))
						M = new /obj/item/weapon/circuitboard/swfdoor( A )
				else //it's not an old computer. Generate standard pod circuitboard.
					M = new /obj/item/weapon/circuitboard/pod( A )

				for (var/obj/C in src)
					C.loc = loc
				M.id = id
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = 1
				del(src)
			else
				user << "\blue You disconnect the monitor."
				var/obj/structure/computerframe/A = new /obj/structure/computerframe( loc )

				//generate appropriate circuitboard. Accounts for /pod/old computer types
				var/obj/item/weapon/circuitboard/pod/M = null
				if(istype(src, /obj/machinery/computer/pod/old))
					M = new /obj/item/weapon/circuitboard/olddoor( A )
					if(istype(src, /obj/machinery/computer/pod/old/syndicate))
						M = new /obj/item/weapon/circuitboard/syndicatedoor( A )
					if(istype(src, /obj/machinery/computer/pod/old/swf))
						M = new /obj/item/weapon/circuitboard/swfdoor( A )
				else //it's not an old computer. Generate standard pod circuitboard.
					M = new /obj/item/weapon/circuitboard/pod( A )

				for (var/obj/C in src)
					C.loc = loc
				M.id = id
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = 1
				del(src)
	else
		attack_hand(user)
	return


/obj/machinery/computer/pod/attack_ai(var/mob/user as mob)
	return attack_hand(user)


/obj/machinery/computer/pod/attack_paw(var/mob/user as mob)
	return attack_hand(user)


/obj/machinery/computer/pod/attack_hand(var/mob/user as mob)
	if(..())
		return

	var/dat = "<HTML><BODY><TT><B>[title]</B>"
	user.machine = src
	if(connected)
		var/d2
		if(timing)	//door controls do not need timers.
			d2 = "<A href='?src=\ref[src];time=0'>Stop Time Launch</A>"
		else
			d2 = "<A href='?src=\ref[src];time=1'>Initiate Time Launch</A>"
		var/second = time % 60
		var/minute = (time - second) / 60
		dat += "<HR>\nTimer System: [d2]\nTime Left: [minute ? "[minute]:" : null][second] <A href='?src=\ref[src];tp=-30'>-</A> <A href='?src=\ref[src];tp=-1'>-</A> <A href='?src=\ref[src];tp=1'>+</A> <A href='?src=\ref[src];tp=30'>+</A>"
		var/temp = ""
		var/list/L = list( 0.25, 0.5, 1, 2, 4, 8, 16 )
		for(var/t in L)
			if(t == connected.power)
				temp += "[t] "
			else
				temp += "<A href = '?src=\ref[src];power=[t]'>[t]</A> "
		dat += "<HR>\nPower Level: [temp]<BR>\n<A href = '?src=\ref[src];alarm=1'>Firing Sequence</A><BR>\n<A href = '?src=\ref[src];drive=1'>Test Fire Driver</A><BR>\n<A href = '?src=\ref[src];door=1'>Toggle Outer Door</A><BR>"
	else
		dat += "<BR>\n<A href = '?src=\ref[src];door=1'>Toggle Outer Door</A><BR>"
	dat += "<BR><BR><A href='?src=\ref[user];mach_close=computer'>Close</A></TT></BODY></HTML>"
	user << browse(dat, "window=computer;size=400x500")
	add_fingerprint(usr)
	onclose(user, "computer")
	return


/obj/machinery/computer/pod/process()
	..()
	if(timing)
		if(time > 0)
			time = round(time) - 1
		else
			alarm()
			time = 0
			timing = 0
		updateDialog()
	return


/obj/machinery/computer/pod/Topic(href, href_list)
	if(..())
		return
	if((usr.contents.Find(src) || (in_range(src, usr) && istype(loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.machine = src
		if(href_list["power"])
			var/t = text2num(href_list["power"])
			t = min(max(0.25, t), 16)
			if(connected)
				connected.power = t
		if(href_list["alarm"])
			alarm()
		if(href_list["time"])
			timing = text2num(href_list["time"])
		if(href_list["tp"])
			var/tp = text2num(href_list["tp"])
			time += tp
			time = min(max(round(time), 0), 120)
		if(href_list["door"])
			for(var/obj/machinery/door/poddoor/M in world)
				if(M.id == id)
					if(M.density)
						M.open()
					else
						M.close()
		updateUsrDialog()
	return



/obj/machinery/computer/pod/old
	icon_state = "old"
	name = "DoorMex Control Computer"
	title = "Door Controls"



/obj/machinery/computer/pod/old/syndicate
	name = "ProComp Executive IIc"
	desc = "The Syndicate operate on a tight budget. Operates external airlocks."
	title = "External Airlock Controls"



/obj/machinery/computer/pod/old/swf
	name = "Magix System IV"
	desc = "An arcane artifact that holds much magic. Running E-Knock 2.2: Sorceror's Edition"
