//This file was auto-corrected by findeclaration.exe on 29/05/2012 15:03:05
#define STATE_DEFAULT 1
#define STATE_INJECTOR  2
#define STATE_REACTOR 3


/obj/machinery/computer/am_reactor
	name = "Antimatter Reactor Console"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "comm_computer"
	req_access = list(ACCESS_ENGINE)
	var/reactor_id = 0
	var/authenticated = 0
	var/obj/machinery/power/am_reactor/reactor/connected_E = null
	var/obj/machinery/power/am_reactor/injector/connected_I = null
	var/state = STATE_DEFAULT

/obj/machinery/computer/am_reactor/New()
	..()
	spawn( 24 )
		for(var/obj/machinery/power/am_reactor/reactor/E in world)
			if(E.reactor_id == src.reactor_id)
				src.connected_E = E
		for(var/obj/machinery/power/am_reactor/injector/I in world)
			if(I.reactor_id == src.reactor_id)
				src.connected_I = I
	return

/obj/machinery/computer/am_reactor/Topic(href, href_list)
	if(..())
		return
	usr.machine = src

	if(!href_list["operation"])
		return
	switch(href_list["operation"])
		// main interface
		if("activate")
			src.connected_E.reactor_process()
		if("reactor")
			src.state = STATE_REACTOR
		if("injector")
			src.state = STATE_INJECTOR
		if("main")
			src.state = STATE_DEFAULT
		if("login")
			var/mob/M = usr
			var/obj/item/weapon/card/id/I = M.get_active_hand()
			if (I && istype(I))
				if(src.check_access(I))
					authenticated = 1
		if("deactivate")
			src.connected_E.stopping = 1
		if("logout")
			authenticated = 0

	src.updateUsrDialog()

/obj/machinery/computer/am_reactor/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/am_reactor/attack_paw(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/am_reactor/attack_hand(var/mob/user as mob)
	if(..())
		return
	user.machine = src
	var/dat = "<head><title>Reactor Computer</title></head><body>"
	switch(src.state)
		if(STATE_DEFAULT)
			if (src.authenticated)
				dat += "<BR>\[ <A HREF='?src=\ref[src];operation=logout'>Log Out</A> \]<br>"
				dat += "<BR>\[ <A HREF='?src=\ref[src];operation=reactor'>Reactor Menu</A> \]"
				dat += "<BR>\[ <A HREF='?src=\ref[src];operation=injector'>Injector Menu</A> \]"
			else
				dat += "<BR>\[ <A HREF='?src=\ref[src];operation=login'>Log In</A> \]"
		if(STATE_INJECTOR)
			if(src.connected_I.injecting)
				dat += "<BR>\[ Injecting \]<br>"
			else
				dat += "<BR>\[ Injecting not in progress \]<br>"
		if(STATE_REACTOR)
			if(src.connected_E.stopping)
				dat += "<BR>\[ STOPPING \]"
			else if(src.connected_E.operating && !src.connected_E.stopping)
				dat += "<BR>\[ <A HREF='?src=\ref[src];operation=deactivate'>Emergency Stop</A> \]"
			else
				dat += "<BR>\[ <A HREF='?src=\ref[src];operation=activate'>Activate Reactor</A> \]"
			dat += "<BR>Contents:<br>[src.connected_E.H_fuel]kg of Hydrogen<br>[src.connected_E.antiH_fuel]kg of Anti-Hydrogen<br>"

	dat += "<BR>\[ [(src.state != STATE_DEFAULT) ? "<A HREF='?src=\ref[src];operation=main'>Main Menu</A> | " : ""]<A HREF='?src=\ref[user];mach_close=communications'>Close</A> \]"
	user << browse(dat, "window=communications;size=400x500")
	onclose(user, "communications")

