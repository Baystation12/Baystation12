#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/security
	name = T_BOARD("security camera monitor")
	build_path = /obj/machinery/computer/security
	req_access = list(access_security)
	var/list/network
	var/locked = 1
	var/emagged = 0
	
/obj/item/weapon/circuitboard/security/New()
	..()
	network = station_networks

/obj/item/weapon/circuitboard/security/engineering
	name = T_BOARD("engineering camera monitor")
	build_path = /obj/machinery/computer/security/engineering
	req_access = list()
	
/obj/item/weapon/circuitboard/security/engineering/New()
	..()
	network = engineering_networks

/obj/item/weapon/circuitboard/security/mining
	name = T_BOARD("mining camera monitor")
	build_path = /obj/machinery/computer/security/mining
	network = list("MINE")
	req_access = list()

/obj/item/weapon/circuitboard/security/construct(var/obj/machinery/computer/security/C)
	if (..(C))
		C.network = network

/obj/item/weapon/circuitboard/security/deconstruct(var/obj/machinery/computer/security/C)
	if (..(C))
		network = C.network

/obj/item/weapon/circuitboard/security/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I,/obj/item/weapon/card/emag))
		if(emagged)
			user << "Circuit lock is already removed."
			return
		user << "\blue You override the circuit lock and open controls."
		emagged = 1
		locked = 0
	else if(istype(I,/obj/item/weapon/card/id))
		if(emagged)
			user << "\red Circuit lock does not respond."
			return
		if(check_access(I))
			locked = !locked
			user << "\blue You [locked ? "" : "un"]lock the circuit controls."
		else
			user << "\red Access denied."
	else if(istype(I,/obj/item/device/multitool))
		if(locked)
			user << "\red Circuit controls are locked."
			return
		var/existing_networks = list2text(network,",")
		var/input = sanitize(input(usr, "Which networks would you like to connect this camera console circuit to? Seperate networks with a comma. No Spaces!\nFor example: SS13,Security,Secret ", "Multitool-Circuitboard interface", existing_networks))
		if(!input)
			usr << "No input found please hang up and try your call again."
			return
		var/list/tempnetwork = text2list(input, ",")
		tempnetwork = difflist(tempnetwork,restricted_camera_networks,1)
		if(tempnetwork.len < 1)
			usr << "No network found please hang up and try your call again."
			return
		network = tempnetwork
	return
