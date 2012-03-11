var/global/first_free_address_range = 1
/obj/machinery/router/var/address_range
/obj/machinery/router/var/list/connected[255]
/obj/machinery/router/var/mob/console_user
/obj/machinery/router/var/datum/os/OS


/obj/machinery/router
	networking = 1
	icon = 'computer.dmi'
	icon_state = "console"
	name = "router"
	density = 1
	anchored = 1
	security = 2


/obj/machinery/router/New()
	var/area/A = get_area(src)
	src.name = "[A.name] Router"
	if(!www)
		www = new /datum/www(null)
	address_range = first_free_address_range
	address = address_range << 8
	address |= 1
	first_free_address_range += 1
//	processing_items.Add(src) // Do this
	OS = new(src)
	// find things that aren't connected currently
	for(var/obj/machinery/M in orange(15,src)) if(M.networking && !M.address)
		connect(M)
	..()


/obj/machinery/router/Del()
	for(var/obj/machinery/M in connected)
		disconnect(M)
	..()


/obj/machinery/router/process()
	if(console_user)
		if(!(console_user in range(1,src)) || winget(console_user, "console", "is-visible") == "false")
			console_user.hide_console()
	if(OS)
		for(var/mob/A in OS.owner)
			if(!A)
				OS.owner -= A
				continue
			if(!(A in range(1,src)) || winget(A.client, "console", "is-visible") == "false")
				A.hide_console()


/obj/machinery/router/proc/connect(var/obj/machinery/M)
	if(M.address) return
	var/i = 1
	while(M.address ? connected[M.address % 256] : 1)
		i+=1
		if(i > 100)
			M.address = 0
			world << "\red ERROR WHILE ALLOCATING MACHINERY IP."
			return
		// shift the address range to the left by 3 bytes
		M.address = address_range << 8
		M.address |= rand(2, 255)
	connected[M.address % 256] = M
	return


/obj/machinery/router/proc/disconnect(var/obj/machinery/M)
	if(!M.address) return

	connected[M.address % 256] = null
	M.address = 0


/obj/machinery/router/call_function(var/datum/function/F)
	if(uppertext(F.arg1) == net_pass)
		//world << "AUTHED"
		if(F.name == "who")
			var/tp = /obj
			if(F.arg2 == "apc")
				tp = /obj/machinery/power/apc
			else if(F.arg2 == "airlock")
				tp = /obj/machinery/door/airlock
			else if(F.arg2 == "status_display")
				tp = /obj/machinery/status_display
			else if(F.arg2 == "alarm")
				tp = /obj/machinery/alarm
			else if(F.arg2 == "router")
				tp = /obj/machinery/router
			else if(F.arg2 == "disposal")
				tp = /obj/machinery/disposal
			else if(F.arg2 == "laptop")
				tp = /obj/item/weapon/laptop
			var/datum/function/R = new()
			R.name = "response"
			R.arg1 = ""
			var/list/passes = list()
			for(var/obj/M in connected) if(istype(M,tp))
				if(istype(M,/obj/item/weapon/laptop))
					if(M:OS:name != "ThinkThank")
						R.arg1 += "[ip2text(M:address)]\t[M:OS:name]\n"
					else
						R.arg1 += "[ip2text(M:address)]\t[M.name]\n"
				if(istype(M,/obj/machinery/))
					var/area/A = get_area(M.loc)
					if(M:security == 1 && !passes[A.name])
						passes[A.name] = M:net_pass
					else if(M:security == 2)
						R.arg1 += "[ip2text(M:address)]\t[M.name][M:net_tag ? "([M:net_tag])" : ""]\[[M:net_pass]]\n"
					else
						R.arg1 += "[ip2text(M:address)]\t[M.name][M:net_tag ? "([M:net_tag])" : ""]\n"
			for(var/obj/machinery/router/Ro in world) if(istype(Ro,tp))
				R.arg1 += "[ip2text(Ro.address)]\tRouter\n"
			R.arg1 += "Area Passwords\n"
			for(var/A in passes)
				var/pass = passes[A]
				R.arg1 += "[A]:[pass]\n"
			R.source_id = address
			R.destination_id = F.source_id
			receive_packet(src, R)
		if(F.name == "response")
			OS.receive_message(F.arg1)
	else if(F.name == "who")
		var/tp = /obj
		if(F.arg1 == "apc")
			tp = /obj/machinery/power/apc
		else if(F.arg1 == "airlock")
			tp = /obj/machinery/door/airlock
		else if(F.arg1 == "status_display")
			tp = /obj/machinery/status_display
		else if(F.arg1 == "alarm")
			tp = /obj/machinery/alarm
		else if(F.arg1 == "router")
			tp = /obj/machinery/router
		else if(F.arg1 == "disposal")
			tp = /obj/machinery/disposal
		else if(F.arg1 == "laptop")
			tp = /obj/item/weapon/laptop
		var/datum/function/R = new()
		R.name = "response"
		R.arg1 = ""
		for(var/obj/M in connected) if(istype(M,tp))
			if(istype(M,/obj/item/weapon/laptop))
				if(M:OS:name != "ThinkThank")
					R.arg1 += "[ip2text(M:address)]\t[M:OS:name]\n"
				else
					R.arg1 += "[ip2text(M:address)]\t[M.name]\n"
			else if(M:net_tag)
				R.arg1 += "[ip2text(M:address)]\t[M.name]([M:net_tag])\n"
			else
				R.arg1 += "[ip2text(M:address)]\t[M.name]\n"
		for(var/obj/machinery/router/Ro in world) if(istype(Ro,tp))
			R.arg1 += "[ip2text(Ro.address)]\tRouter\n"
		R.source_id = address
		R.destination_id = F.source_id
		receive_packet(src, R)
	else if(F.name == "response")
		OS.receive_message(F.arg1)
	else
		..()


/obj/machinery/router/receive_packet(var/obj/machinery/sender, var/datum/function/P)
	if(P.destination_id == src.address)
		call_function(P)
		return

	// shift 3 bytes to the right to get the address range
	var/router = P.destination_id >> 8
	// if the destination is connected to this router, send to the destination
	if(router == src.address_range)
		for(var/obj/M in connected) if(M:address == P.destination_id)
			M:receive_packet(src, P)
	// otherwise, send to the router connected to the destination
	else
		for(var/obj/machinery/router/R in world) if(R.address_range == router)
			R.receive_packet(src, P)


/obj/machinery/computer/console/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

obj/machinery/router/attack_hand(mob/user as mob)
	user.display_console(src)