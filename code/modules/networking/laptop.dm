/obj/item/weapon/laptop
	name = "Laptop"
	icon = 'laptop.dmi'
	icon_state = "laptop_0"
	var/datum/os/OS
	var/on = 0
	var/mob/console_user
	var/address
	var/obj/machinery/router/R
	var/obj/machinery/router/connected_to
	var/router_loc

/obj/item/weapon/laptop/New()
	..()
	address = 0
	OS = new(src)
	processing_objects.Add(src) // Do this
//	spawn while(1)
//		sleep(10) / You don't want to do this like this.
//		process()

/obj/item/weapon/laptop/proc/get_routers()
	. = list()
	for(var/obj/machinery/router/R in range(20,src.loc))
		. += R
	return .

/obj/item/weapon/laptop/proc/receive_packet(var/obj/machinery/sender, var/datum/function/P)
	if(P.name == "response")
		OS.receive_message(P.arg1)
	else if(P.name == "MSG")
		OS.receive_message(P.arg1)
	else if(P.name == "who")
		var/datum/function/R = new()
		R.name = "response"
		R.arg1 = ""
		for(var/obj/machinery/router/Ro in get_routers())
			R.arg1 += "[ip2text(Ro.address)]\tRouter\n"
		R.source_id = address
		R.destination_id = P.source_id
		receive_packet(src, R)
	else
		..()

/obj/item/weapon/laptop/proc/updateicon()
	icon_state = "laptop_[on]"
	if(on && (!address || prob(10)))
		updateip()

/obj/item/weapon/laptop/proc/updateip()
	var/list/obj/machinery/router/routers = list()
	for(var/obj/machinery/router/R in world)
		routers |= R
	if(connected_to)//Clear the old IP
		connected_to.connected[router_loc] = null
	address = 0 //Generate a new IP
	while(!address) //Search to see if it exists
		address = rand(1,routers.len) << 8
		address += rand(2,255)
		for(var/obj/machinery/router/R in routers)
			if(R.address_range == (address >> 8) && R.connected[address%256])
				address = 0
				break
	for(var/obj/machinery/router/R in routers) //Claim dat IP!
		if(R.address_range == (address >> 8))
			connected_to = R
			router_loc = address%256
			R.connected[address%256] = src
			break
//		OS.

/obj/item/weapon/laptop/attack_self(mob/user as mob)
	on = !on
	updateicon()
	if(!on)
		user.hide_console()
	else
		user.display_console(src)
	return
		// DO MORE SHIT HERE

/obj/item/weapon/laptop/process()
//	world << "LAPTOP TICK"
	if(console_user)
		if(!(console_user in range(1,src)) || winget(console_user, "console", "is-visible") == "false")
			console_user.hide_console()
	if(OS)
		for(var/mob/A in OS.owner)
			if(!(A in range(1,src)) || winget(A.client, "console", "is-visible") == "false")
				A.hide_console()
				OS.owner -= A
	if(!console_user && on)
		on = !on
		update_icon()

/obj/item/weapon/laptop/verb/reboot()
	set name = "Reboot"
	set src in view(1)
	OS.reboot()