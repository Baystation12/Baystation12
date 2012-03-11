/** Networking will use RPCs to send packets. These RPCs can also be
	used by computer terminals to process user input.
	http://baystation12.net/forums/index.php/topic,1529.msg23274.html#msg23274
**/

/datum/function
	var
		name = "None"
		arg1 = null
		arg2 = null
		arg3 = null
		arg4 = null
		arg5 = null

		source_id = 0
		destination_id = 0

	proc/get_args()
		var/list/rval = list()
		if(arg1 == null) return rval
		rval += arg1
		if(arg2 == null) return rval
		rval += arg2
		if(arg3 == null) return rval
		rval += arg3
		if(arg4 == null) return rval
		rval += arg4
		if(arg5 == null) return rval
		rval += arg5

var/global/const/PROCESS_RPCS = 2
/obj/machinery/var/networking = 0 // set to 1 if this object should be sent messages
								  // set to 2 if the received RPCs should be directly called
/obj/machinery/var/security = 0 // set 1 for a low security 6 char password or 2 for a 12 high security password.
/obj/machinery/var/net_pass = null
/obj/machinery/var/address = 0
/obj/machinery/var/net_tag

var/list/area_net_pass = list()

proc/setup_pass()
	for(var/obj/machinery/M in world)
		if(M.networking)
			var/area/A = get_area(M.loc)
			if(M.security == 1)
				if(area_net_pass[A.name])
					M.net_pass = area_net_pass[A.name]
				else
					net_genpass(A.name)
					M.net_pass = area_net_pass[A.name]
			else if(M.security == 2)
				M.net_pass = net_genpass()

proc/net_genpass(var/N)
	var/pass
	var/k
	var/list/chars = list("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z")
	var/list/nums = list("0","1","2","3","4","5","6","7","8","9")
	var/count = 0
	while(!pass)
		count++
		if(rand(0,1))
			k += pick(nums)
		else
			k += pick(chars)
		if(count == 12)
			pass = k
			break
	if(N)
		area_net_pass[N] = copytext(pass,1,7)
	return pass

proc/setupnetwork() //  use this if you need create something at the start of the server
	world << "\red \b Setting up Networking systems."
	setup_pass()

/obj/machinery/proc/call_function(datum/function/F)
	if(F.name == "location")
		var/datum/function/R = new()
		R.name = "response"
		R.arg1 = "[src] at [src.loc:loc:name]\n"
		R.source_id = address
		R.destination_id = F.source_id
		send_packet(src,F.source_id,R)

/obj/machinery/proc/receive_packet(var/obj/machinery/sender, var/datum/function/P)
	if(networking == PROCESS_RPCS)
		call_function(P)

// computers can have a console interaction
/obj/machinery/computer/var/mob/console_user
/obj/machinery/computer/var/datum/os/operating_system

/obj/machinery/computer/proc/display_console(mob/user)
	if(winget(user, "console", "is-visible") == "true" || user.console_device)
		if(user.console_device)
			if(user.console_device == src)
				return
			if(user.console_device:console_user == src)
				user.console_device:console_user = null
			user.console_device:OS.owner -= user
			user.comp = null
			user.console_device = null
		user << output(null, "console_output")
		winshow(user, "console", 0)
	winshow(user, "console", 1)
	console_user = user
	if(!operating_system)
		operating_system = new(src)
	user.comp = operating_system
	operating_system.owner += user
	operating_system.Boot()

/obj/machinery/computer/process()
	if(console_user)
		if(!(console_user in range(1,src)) || winget(console_user, "console", "is-visible") == "false")
			console_user.hide_console()
	if(operating_system)
		for(var/mob/A in operating_system.owner)
			if(!(A in range(1,src)) || winget(A.client, "console", "is-visible") == "false")
				A.hide_console()
				operating_system.owner -= A
mob/proc/display_console(var/obj/device)
	if(winget(src, "console", "is-visible") == "true" || console_device)
		if(console_device)
			if(console_device == device)
				return
			if(console_device:console_user == src)
				console_device:console_user = null
			console_device:OS.owner -= src
			comp = null
			console_device = null
		src << output(null, "console_output")
		winshow(src, "console", 0)
	winshow(src, "console", 1)
	device:console_user = src
	src.comp = device:OS
	src.console_device = device
	device:OS.owner += src
	if(!device:OS.boot)
		device:OS.ip = device:address
	device:OS.Boot()

mob/proc/hide_console()
	if(winget(src, "console", "is-visible") == "true" || console_device)
		if(console_device)
			if(console_device:console_user == src)
				console_device:console_user = null
			console_device:OS.owner -= src
			comp = null
			console_device = null
		src << output(null, "console_output")
		winshow(src, "console", 0)
mob/verb/closeconsoleV()
	hide_console()
proc/send_packet(var/obj/device, var/dest_address, var/datum/function/F)
	// for laptops, try to find a connection
	if(istype(device,/obj/item/weapon/laptop))
		if(!device:R || !(device:R in device:get_routers()) )
			if(device:R)
				device:R.disconnect(device)
				device:R = null
				device:OS.ip = 0

			device:address = 0
			for(var/obj/machinery/router/R in device:get_routers())
				device:R = R
				R.connect(device)
				device:OS.ip = device:address
				break

	// first, find out what router belongs to the device, if any at all
	var/address = device:address

	if(!address)
		return "Not connected to network."

	// get the router bit from the address
	var/router = address >> 8

	for(var/obj/machinery/router/R in world)
		if(R.address_range == router)
			F.source_id = address
			F.destination_id = dest_address
			spawn R.receive_packet(device,F)
			return "Packet successfully transmitted to router"

	return "Not connected to network."

proc/text2ip(var/txt)
	var/list/parts = list()
	var/current_part = ""
	for(var/i = 1, i<=length(txt), i++)
		var/char = copytext(txt,i,i+1)
		if(char == ".")
			parts += current_part
			current_part = ""
		else if("0" <= char && char <= "9")
			current_part += char
		else
			return -1
	if(current_part != "")
		parts += current_part
		current_part = ""
	if(parts.len != 4)
		return -1
	if(parts[1] != "197")
		return -1
	if(parts[2] != "8")
		return -1
	var/rval = 0
	rval += text2num(parts[3]) * 256
	rval += text2num(parts[4])
	return rval

proc/ip2text(var/ip)
	ASSERT(isnum(ip))
	var/x3 = ip >> 8
	var/x4 = ip & 255
	return "197.8.[x3].[x4]"