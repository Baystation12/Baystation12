/obj/machinery/computer/drone_control
	name = "Maintenance Drone Control"
	desc = "Used to monitor the drone population and the assembler that services them."
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "power_key"
	icon_screen = "power"
	req_access = list(access_engine_equip)
	machine_name = "drone control console"
	machine_desc = "Used to monitor the status of the ship's maintenance drones. Also allows for simple pings to draw attention to areas in need of repairs."

	//Used when pinging drones.
	var/drone_call_area = "Engineering"
	//Used to enable or disable drone fabrication.
	var/obj/machinery/drone_fabricator/dronefab

/obj/machinery/computer/drone_control/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/computer/drone_control/interact(mob/user)
	user.set_machine(src)
	var/dat
	dat += "<B>Maintenance Units</B><BR>"

	for(var/mob/living/silicon/robot/drone/D in world)
		if(D.z != src.z)
			continue
		dat += "<BR>[D.real_name] ([D.stat == 2 ? SPAN_COLOR("red", "INACTIVE") : SPAN_COLOR("green", "ACTIVE")])"
		dat += "<span style='font-size: 9'><BR>Cell charge: [D.cell.charge]/[D.cell.maxcharge]."
		dat += "<BR>Currently located in: [get_area(D)]."
		dat += "<BR><A href='?src=\ref[src];resync=\ref[D]'>Resync</A> | <A href='?src=\ref[src];shutdown=\ref[D]'>Shutdown</A></span>"

	dat += "<BR><BR><B>Request drone presence in area:</B> <A href='?src=\ref[src];setarea=1'>[drone_call_area]</A> (<A href='?src=\ref[src];ping=1'>Send ping</A>)"

	dat += "<BR><BR><B>Drone fabricator</B>: "
	dat += "[dronefab ? "<A href='?src=\ref[src];toggle_fab=1'>[(dronefab.produce_drones && dronefab.is_powered()) ? "ACTIVE" : "INACTIVE"]</A>" : "[SPAN_COLOR("red", "<b>FABRICATOR NOT DETECTED.</b>")] (<A href='?src=\ref[src];search_fab=1'>search</a>)"]"
	show_browser(user, dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return


/obj/machinery/computer/drone_control/Topic(href, href_list)
	if((. = ..()))
		return

	if(!allowed(usr))
		to_chat(usr, SPAN_DANGER("Access denied."))
		return

	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)

	if (href_list["setarea"])

		//Probably should consider using another list, but this one will do.
		var/t_area = input("Select the area to ping.", "Set Target Area", null) as null|anything in GLOB.tagger_locations

		if(!t_area)
			return

		drone_call_area = t_area
		to_chat(usr, SPAN_NOTICE("You set the area selector to [drone_call_area]."))

	else if (href_list["ping"])

		to_chat(usr, SPAN_NOTICE("You issue a maintenance request for all active drones, highlighting [drone_call_area]."))
		for(var/mob/living/silicon/robot/drone/D in world)
			if(D.client && D.stat == 0)
				to_chat(D, "-- Maintenance drone presence requested in: [drone_call_area].")

	else if (href_list["resync"])

		var/mob/living/silicon/robot/drone/D = locate(href_list["resync"])

		if(D.stat != 2)
			to_chat(usr, SPAN_DANGER("You issue a law synchronization directive for the drone."))
			D.law_resync()

	else if (href_list["shutdown"])

		var/mob/living/silicon/robot/drone/D = locate(href_list["shutdown"])

		if(D.stat != 2)
			to_chat(usr, SPAN_DANGER("You issue a kill command for the unfortunate drone."))
			message_admins("[key_name_admin(usr)] issued kill order for drone [key_name_admin(D)] from control console.")
			log_game("[key_name(usr)] issued kill order for [key_name(src)] from control console.")
			D.shut_down()

	else if (href_list["search_fab"])
		if(dronefab)
			return

		for(var/obj/machinery/drone_fabricator/fab in oview(3,src))

			if(!fab.is_powered())
				continue

			dronefab = fab
			to_chat(usr, SPAN_NOTICE("Drone fabricator located."))
			return

		to_chat(usr, SPAN_DANGER("Unable to locate drone fabricator."))

	else if (href_list["toggle_fab"])

		if(!dronefab)
			return

		if(get_dist(src,dronefab) > 3)
			dronefab = null
			to_chat(usr, SPAN_DANGER("Unable to locate drone fabricator."))
			return

		dronefab.produce_drones = !dronefab.produce_drones
		to_chat(usr, SPAN_NOTICE("You [dronefab.produce_drones ? "enable" : "disable"] drone production in the nearby fabricator."))

	src.updateUsrDialog()
