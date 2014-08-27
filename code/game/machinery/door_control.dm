#define CONTROL_POD_DOORS 0
#define CONTROL_NORMAL_DOORS 1
#define CONTROL_EMITTERS 2

/obj/machinery/door_control
	name = "remote door-control"
	desc = "It controls doors, remotely."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "doorctrl0"
	desc = "A remote control-switch for a door."
	power_channel = ENVIRON
	var/id = null
	var/range = 10
	var/normaldoorcontrol = CONTROL_POD_DOORS
	var/desiredstate = 0 // Zero is closed, 1 is open.
	var/specialfunctions = 1
	/*
	Bitflag, 	1= open
				2= idscan,
				4= bolts
				8= shock
				16= door safties

	*/

	var/exposedwires = 0
	var/wires = 3
	/*
	Bitflag,	1=checkID
				2=Network Access
	*/

	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4

/obj/machinery/door_control/attack_ai(mob/user as mob)
	if(wires & 2)
		return src.attack_hand(user)
	else
		user << "Error, no route to host."

/obj/machinery/door_control/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/door_control/attackby(obj/item/weapon/W, mob/user as mob)
	/* For later implementation
	if (istype(W, /obj/item/weapon/screwdriver))
	{
		if(wiresexposed)
			icon_state = "doorctrl0"
			wiresexposed = 0

		else
			icon_state = "doorctrl-open"
			wiresexposed = 1

		return
	}
	*/
	if(istype(W, /obj/item/device/detective_scanner))
		return
	if(istype(W, /obj/item/weapon/card/emag))
		req_access = list()
		req_one_access = list()
		playsound(src.loc, "sparks", 100, 1)
	return src.attack_hand(user)

/obj/machinery/door_control/proc/handle_door()
	for(var/obj/machinery/door/airlock/D in range(range))
		if(D.id_tag == src.id)
			if(specialfunctions & OPEN)
				if (D.density)
					spawn(0)
						D.open()
						return
				else
					spawn(0)
						D.close()
						return
			if(desiredstate == 1)
				if(specialfunctions & IDSCAN)
					D.aiDisabledIdScanner = 1
				if(specialfunctions & BOLTS)
					D.lock()
				if(specialfunctions & SHOCK)
					D.secondsElectrified = -1
				if(specialfunctions & SAFE)
					D.safe = 0
			else
				if(specialfunctions & IDSCAN)
					D.aiDisabledIdScanner = 0
				if(specialfunctions & BOLTS)
					if(!D.isWireCut(4) && D.arePowerSystemsOn())
						D.unlock()
				if(specialfunctions & SHOCK)
					D.secondsElectrified = 0
				if(specialfunctions & SAFE)
					D.safe = 1

/obj/machinery/door_control/proc/handle_pod()
	for(var/obj/machinery/door/poddoor/M in world)
		if(M.id == src.id)
			if(M.density)
				spawn(0)
					M.open()
					return
			else
				spawn(0)
					M.close()
					return

/obj/machinery/door_control/proc/handle_emitters(mob/user as mob)
	for(var/obj/machinery/power/emitter/E in range(range))
		if(E.id == src.id)
			spawn(0)
				E.activate(user)
				return

/obj/machinery/door_control/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	if(stat & (NOPOWER|BROKEN))
		return

	if(!allowed(user) && (wires & 1))
		user << "\red Access Denied"
		flick("doorctrl-denied",src)
		return

	use_power(5)
	icon_state = "doorctrl1"
	add_fingerprint(user)

	switch(normaldoorcontrol)
		if(CONTROL_NORMAL_DOORS)
			handle_door()
		if(CONTROL_POD_DOORS)
			handle_pod()
		if(CONTROL_EMITTERS)
			handle_emitters(user)

	desiredstate = !desiredstate
	spawn(15)
		if(!(stat & NOPOWER))
			icon_state = "doorctrl0"

/obj/machinery/door_control/power_change()
	..()
	if(stat & NOPOWER)
		icon_state = "doorctrl-p"
	else
		icon_state = "doorctrl0"

/obj/machinery/driver_button/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/driver_button/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/driver_button/attackby(obj/item/weapon/W, mob/user as mob)

	if(istype(W, /obj/item/device/detective_scanner))
		return
	return src.attack_hand(user)

/obj/machinery/driver_button/attack_hand(mob/user as mob)

	src.add_fingerprint(usr)
	if(stat & (NOPOWER|BROKEN))
		return
	if(active)
		return
	add_fingerprint(user)

	use_power(5)

	active = 1
	icon_state = "launcheract"

	for(var/obj/machinery/door/poddoor/M in world)
		if (M.id == src.id)
			spawn( 0 )
				M.open()
				return

	sleep(20)

	for(var/obj/machinery/mass_driver/M in world)
		if(M.id == src.id)
			M.drive()

	sleep(50)

	for(var/obj/machinery/door/poddoor/M in world)
		if (M.id == src.id)
			spawn( 0 )
				M.close()
				return

	icon_state = "launcherbtt"
	active = 0

	return
