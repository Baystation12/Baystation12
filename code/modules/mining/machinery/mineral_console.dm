/obj/machinery/computer/mining
	name = "ore processing console"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "console"
	req_access = list(access_cargo)
	circuit = /obj/item/weapon/circuitboard/mineral_processing
	var/obj/machinery/mineral/connected

/obj/machinery/computer/mining/attack_hand(var/mob/user)
	if(!connected)
		to_chat(user, "<span class='warning'>\The [src] is not connected to a processing machine. <a href='?src=\ref[src];scan_for_machine=1'>Scan</a></span>")
		return
	var/datum/browser/popup = new(user, "mining-[name]", "[src] Control Panel")
	popup.set_content(jointext(connected.get_console_data(), "<br>"))
	popup.open()

/obj/machinery/computer/mining/Topic(href, href_list)
	if((. = ..()))
		return
	if(href_list["scan_for_machine"])
		for(var/c in GLOB.alldirs)
			var/turf/T = get_step(loc, c)
			if(T)
				var/obj/machinery/mineral/M = locate(/obj/machinery/mineral) in T
				if(M && ispath(M.console) && istype(src, M.console))
					M.console = src
					connected = M
					break
		return TRUE

/obj/machinery/computer/mining/Destroy()
	if(connected)
		if(connected.console == src)
			connected.console = initial(connected.console)
		connected = null
	. = ..()
