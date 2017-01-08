//This is a holder for things like the Skipjack and Nuke shuttle.
/datum/shuttle/multi_shuttle
	flags = SHUTTLE_FLAGS_NONE
	var/cloaked = 1
	var/at_origin = 1
	var/returned_home = 0
	var/move_time = 240
	var/cooldown = 20
	var/last_move = 0	//the time at which we last moved

	var/announcer
	var/arrival_message
	var/departure_message

	var/area/interim
	var/area/last_departed
	var/start_location
	var/last_location
	var/list/destinations
	var/list/destination_dock_controller_tags = list() //optional, in case the shuttle has multiple docking ports like the ERT shuttle (even though that isn't a multi_shuttle)
	var/list/destination_dock_controllers = list()
	var/list/destination_dock_targets = list()
	var/area/origin
	var/return_warning = 0
	category = /datum/shuttle/multi_shuttle

/datum/shuttle/multi_shuttle/New()
	origin = locate(origin)
	interim = locate(interim)
	for(var/destination in destinations)
		destinations[destination] = locate(destinations[destination])
	..()

/datum/shuttle/multi_shuttle/init_docking_controllers()
	..()
	for(var/destination in destinations)
		var/controller_tag = destination_dock_controller_tags[destination]
		if(!controller_tag)
			destination_dock_controllers[destination] = docking_controller
		else
			var/datum/computer/file/embedded_program/docking/C = locate(controller_tag)

			if(!istype(C))
				warning("Shuttle with docking tag [controller_tag] could not find it's controller!")
			else
				destination_dock_controllers[destination] = C

	//might as well set this up here.
	if(origin) last_departed = origin
	last_location = start_location

/datum/shuttle/multi_shuttle/current_dock_target()
	return destination_dock_targets[last_location]

/datum/shuttle/multi_shuttle/move(var/area/origin, var/area/destination)
	..()
	last_move = world.time
	if (destination == src.origin)
		returned_home = 1
	docking_controller = destination_dock_controllers[last_location]

/datum/shuttle/multi_shuttle/proc/announce_departure()

	if(cloaked || isnull(departure_message))
		return

	command_announcement.Announce(departure_message,(announcer ? announcer : "[using_map.boss_name]"))

/datum/shuttle/multi_shuttle/proc/announce_arrival()

	if(cloaked || isnull(arrival_message))
		return

	command_announcement.Announce(arrival_message,(announcer ? announcer : "[using_map.boss_name]"))


/obj/machinery/computer/shuttle_control/multi
	icon_keyboard = "syndie_key"
	icon_screen = "syndishuttle"

/obj/machinery/computer/shuttle_control/multi/attack_hand(user as mob)

	if(..(user))
		return
	src.add_fingerprint(user)

	var/datum/shuttle/multi_shuttle/MS = shuttle_controller.shuttles[shuttle_tag]
	if(!istype(MS)) return

	var/dat
	dat = "<center>[shuttle_tag] Ship Control<hr>"


	if(MS.moving_status != SHUTTLE_IDLE)
		dat += "Location: <font color='red'>Moving</font> <br>"
	else
		var/area/areacheck = get_area(src)
		dat += "Location: [areacheck.name]<br>"

	if((MS.last_move + MS.cooldown*10) > world.time)
		dat += "<font color='red'>Engines charging.</font><br>"
	else
		dat += "<font color='green'>Engines ready.</font><br>"

	dat += "<br><b><A href='?src=\ref[src];toggle_cloak=[1]'>Toggle cloaking field</A></b><br>"
	dat += "<b><A href='?src=\ref[src];move_multi=[1]'>Move ship</A></b><br>"
	dat += "<b><A href='?src=\ref[src];start=[1]'>Return to base</A></b></center>"

	//Docking
	dat += "<center><br><br>"
	if(MS.skip_docking_checks())
		dat += "Docking Status: <font color='grey'>Not in use.</font>"
	else
		var/override_en = MS.docking_controller.override_enabled
		var/docking_status = MS.docking_controller.get_docking_status()

		dat += "Docking Status: "
		switch(docking_status)
			if("undocked")
				dat += "<font color='[override_en? "red" : "grey"]'>Undocked</font>"
			if("docking")
				dat += "<font color='[override_en? "red" : "yellow"]'>Docking</font>"
			if("undocking")
				dat += "<font color='[override_en? "red" : "yellow"]'>Undocking</font>"
			if("docked")
				dat += "<font color='[override_en? "red" : "green"]'>Docked</font>"

		if(override_en) dat += " <font color='red'>(Override Enabled)</font>"

		dat += ". <A href='?src=\ref[src];refresh=[1]'>\[Refresh\]</A><br><br>"

		switch(docking_status)
			if("undocked")
				dat += "<b><A href='?src=\ref[src];dock_command=[1]'>Dock</A></b>"
			if("docked")
				dat += "<b><A href='?src=\ref[src];undock_command=[1]'>Undock</A></b>"
	dat += "</center>"

	user << browse("[dat]", "window=[shuttle_tag]shuttlecontrol;size=300x600")

//check if we're undocked, give option to force launch
/obj/machinery/computer/shuttle_control/proc/check_docking(datum/shuttle/multi_shuttle/MS)
	if(MS.skip_docking_checks() || MS.docking_controller.can_launch())
		return 1

	var/choice = alert("The shuttle is currently docked! Please undock before continuing.","Error","Cancel","Force Launch")
	if(choice == "Cancel")
		return 0

	choice = alert("Forcing a shuttle launch while docked may result in severe injury, death and/or damage to property. Are you sure you wish to continue?", "Force Launch", "Force Launch", "Cancel")
	if(choice == "Cancel")
		return 0

	return 1

/obj/machinery/computer/shuttle_control/multi/Topic(href, href_list)
	if(..())
		return 1

	usr.set_machine(src)
	src.add_fingerprint(usr)

	var/datum/shuttle/multi_shuttle/MS = shuttle_controller.shuttles[shuttle_tag]
	if(!istype(MS)) return

//	log_debug("multi_shuttle: last_departed=[MS.last_departed], origin=[MS.origin], interim=[MS.interim], travel_time=[MS.move_time]")


	if(href_list["refresh"])
		updateUsrDialog()
		return

	if (MS.moving_status != SHUTTLE_IDLE)
		to_chat(usr, "<span class='notice'>[shuttle_tag] vessel is moving.</span>")
		return

	if(href_list["dock_command"])
		MS.dock()
		return

	if(href_list["undock_command"])
		MS.undock()
		return

	if(href_list["start"])
		if(MS.at_origin)
			to_chat(usr, "<span class='warning'>You are already at your home base.</span>")
			return

		if((MS.last_move + MS.cooldown*10) > world.time)
			to_chat(usr, "<span class='warning'>The ship's drive is inoperable while the engines are charging.</span>")
			return

		if(!check_docking(MS))
			updateUsrDialog()
			return

		if(!MS.return_warning)
			to_chat(usr, "<span class='warning'>Returning to your home base will end your mission. If you are sure, press the button again.</span>")
			//TODO: Actually end the mission.
			MS.return_warning = 1
			return

		MS.long_jump(MS.last_departed,MS.origin,MS.interim,MS.move_time)
		MS.last_departed = MS.origin
		MS.last_location = MS.start_location
		MS.at_origin = 1

	if(href_list["toggle_cloak"])

		MS.cloaked = !MS.cloaked
		to_chat(usr, "<span class='warning'>Ship stealth systems have been [(MS.cloaked ? "activated. The station will not" : "deactivated. The station will")] be warned of our arrival.</span>")


	if(href_list["move_multi"])
		if((MS.last_move + MS.cooldown*10) > world.time)
			to_chat(usr, "<span class='warning'>The ship's drive is inoperable while the engines are charging.</span>")
			return

		if(!check_docking(MS))
			updateUsrDialog()
			return

		var/choice = input("Select a destination.") as null|anything in MS.destinations
		if(!choice) return

		to_chat(usr, "<span class='notice'>[shuttle_tag] main computer recieved message.</span>")

		if(MS.at_origin)
			MS.announce_arrival()
			MS.last_departed = MS.origin
			MS.at_origin = 0


			MS.long_jump(MS.last_departed, MS.destinations[choice], MS.interim, MS.move_time)
			MS.last_departed = MS.destinations[choice]
			MS.last_location = choice
			return

		else if(choice == MS.origin)

			MS.announce_departure()

		MS.short_jump(MS.last_departed, MS.destinations[choice])
		MS.last_departed = MS.destinations[choice]
		MS.last_location = choice

	updateUsrDialog()
