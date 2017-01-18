/datum/shuttle/autodock/ferry/emergency
	category = /datum/shuttle/autodock/ferry/emergency
	move_time = 10 MINUTES
	var/datum/evacuation_controller/pods/shuttle/emergency_controller

/datum/shuttle/autodock/ferry/emergency/New()
	. = ..()
	emergency_controller = evacuation_controller
	if(!istype(emergency_controller))
		CRASH("Escape shuttle created without the appropriate controller type.")
		return
	if(emergency_controller.shuttle)
		CRASH("An emergency shuttle has already been created.")
		return
	emergency_controller.shuttle = src

/datum/shuttle/autodock/ferry/emergency/arrived()
	. = ..()

	if(!emergency_controller.has_evacuated())
		emergency_controller.finish_preparing_evac()

	if (istype(in_use, /obj/machinery/computer/shuttle_control/emergency))
		var/obj/machinery/computer/shuttle_control/emergency/C = in_use
		C.reset_authorization()

/datum/shuttle/autodock/ferry/emergency/long_jump(var/destination, var/interim, var/travel_time, var/direction)
	..(destination, interim, emergency_controller.get_long_jump_time(), direction)

/datum/shuttle/autodock/ferry/emergency/move(var/atom/destination)
	if(current_location == landmark_station)
		emergency_controller.shuttle_leaving() // This is a hell of a line. v
		priority_announcement.Announce(replacetext(replacetext((emergency_controller.emergency_evacuation ? using_map.emergency_shuttle_leaving_dock : using_map.shuttle_leaving_dock), "%dock_name%", "[using_map.dock_name]"),  "%ETA%", "[round(emergency_controller.get_eta()/60,1)] minute\s"))
	else if(destination == landmark_offsite && emergency_controller.has_evacuated())
		emergency_controller.shuttle_evacuated()
	..(destination)

/datum/shuttle/autodock/ferry/emergency/can_launch(var/user)
	if (istype(user, /obj/machinery/computer/shuttle_control/emergency))
		var/obj/machinery/computer/shuttle_control/emergency/C = user
		if (!C.has_authorization())
			return 0
	return ..()

/datum/shuttle/autodock/ferry/emergency/can_force(var/user)
	if (istype(user, /obj/machinery/computer/shuttle_control/emergency))
		var/obj/machinery/computer/shuttle_control/emergency/C = user

		//initiating or cancelling a launch ALWAYS requires authorization, but if we are already set to launch anyways than forcing does not.
		//this is so that people can force launch if the docking controller cannot safely undock without needing X heads to swipe.
		if (!(process_state == WAIT_LAUNCH || C.has_authorization()))
			return 0
	return ..()

/datum/shuttle/autodock/ferry/emergency/can_cancel(var/user)
	if(emergency_controller.has_evacuated())
		return 0
	if (istype(user, /obj/machinery/computer/shuttle_control/emergency))
		var/obj/machinery/computer/shuttle_control/emergency/C = user
		if (!C.has_authorization())
			return 0
	return ..()

/datum/shuttle/autodock/ferry/emergency/launch(var/user)
	if (!can_launch(user)) return

	if (istype(user, /obj/machinery/computer/shuttle_control/emergency))	//if we were given a command by an emergency shuttle console
		if (emergency_controller.autopilot)
			emergency_controller.autopilot = 0
			to_world("<span class='notice'><b>Alert: The shuttle autopilot has been overridden. Launch sequence initiated!</b></span>")

	if(usr)
		log_admin("[key_name(usr)] has overridden the shuttle autopilot and activated launch sequence")
		message_admins("[key_name_admin(usr)] has overridden the shuttle autopilot and activated launch sequence")

	..(user)

/datum/shuttle/autodock/ferry/emergency/force_launch(var/user)
	if (!can_force(user)) return

	if (istype(user, /obj/machinery/computer/shuttle_control/emergency))	//if we were given a command by an emergency shuttle console
		if (emergency_controller.autopilot)
			emergency_controller.autopilot = 0
			to_world("<span class='notice'><b>Alert: The shuttle autopilot has been overridden. Bluespace drive engaged!</b></span>")

	if(usr)
		log_admin("[key_name(usr)] has overridden the shuttle autopilot and forced immediate launch")
		message_admins("[key_name_admin(usr)] has overridden the shuttle autopilot and forced immediate launch")

	..(user)

/datum/shuttle/autodock/ferry/emergency/cancel_launch(var/user)

	if (!can_cancel(user)) return

	if(!emergency_controller.shuttle_preparing())

		if (istype(user, /obj/machinery/computer/shuttle_control/emergency))	//if we were given a command by an emergency shuttle console
			if (emergency_controller.autopilot)
				emergency_controller.autopilot = 0
				to_world("<span class='notice'><b>Alert: The shuttle autopilot has been overridden. Launch sequence aborted!</b></span>")

		if(usr)
			log_admin("[key_name(usr)] has overridden the shuttle autopilot and cancelled launch sequence")
			message_admins("[key_name_admin(usr)] has overridden the shuttle autopilot and cancelled launch sequence")

	..(user)

/obj/machinery/computer/shuttle_control/emergency
	shuttle_tag = "Escape"
	var/debug = 0
	var/req_authorizations = 2
	var/list/authorized = list()

/obj/machinery/computer/shuttle_control/emergency/proc/has_authorization()
	return (authorized.len >= req_authorizations || emagged)

/obj/machinery/computer/shuttle_control/emergency/proc/reset_authorization()
	//no need to reset emagged status. If they really want to go back to the station they can.
	authorized = initial(authorized)

//returns 1 if the ID was accepted and a new authorization was added, 0 otherwise
/obj/machinery/computer/shuttle_control/emergency/proc/read_authorization(var/obj/item/ident)
	if (!ident || !istype(ident))
		return 0
	if (authorized.len >= req_authorizations)
		return 0 //don't need any more

	if (!evacuation_controller.emergency_evacuation && security_level < SEC_LEVEL_RED)
		src.visible_message("\The [src] buzzes. It does not appear to be accepting any commands.")
		return 0

	var/list/access
	var/auth_name
	var/dna_hash

	var/obj/item/weapon/card/id/ID = ident.GetIdCard()

	if(!ID)
		return

	access = ID.access
	auth_name = "[ID.registered_name] ([ID.assignment])"
	dna_hash = ID.dna_hash

	if (!access || !istype(access))
		return 0	//not an ID

	if (dna_hash in authorized)
		src.visible_message("\The [src] buzzes. That ID has already been scanned.")
		return 0

	if (!(access_heads in access))
		src.visible_message("\The [src] buzzes, rejecting [ident].")
		return 0

	src.visible_message("\The [src] beeps as it scans [ident].")
	authorized[dna_hash] = auth_name
	if (req_authorizations - authorized.len)
		to_world("<span class='notice'><b>Alert: [req_authorizations - authorized.len] authorization\s needed to override the shuttle autopilot.</b></span>")

	if(usr)
		log_admin("[key_name(usr)] has inserted [ID] into the shuttle control computer - [req_authorizations - authorized.len] authorisation\s needed")
		message_admins("[key_name_admin(usr)] has inserted [ID] into the shuttle control computer - [req_authorizations - authorized.len] authorisation\s needed")

	return 1

/obj/machinery/computer/shuttle_control/emergency/emag_act(var/remaining_charges, var/mob/user)
	if (!emagged)
		to_chat(user, "<span class='notice'>You short out \the [src]'s authorization protocols.</span>")
		emagged = 1
		return 1

/obj/machinery/computer/shuttle_control/emergency/attackby(obj/item/weapon/W as obj, mob/user as mob)
	read_authorization(W)
	..()

/obj/machinery/computer/shuttle_control/emergency/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	var/datum/shuttle/autodock/ferry/emergency/shuttle = shuttle_controller.shuttles[shuttle_tag]
	if (!istype(shuttle))
		return

	var/shuttle_state
	switch(shuttle.moving_status)
		if(SHUTTLE_IDLE) shuttle_state = "idle"
		if(SHUTTLE_WARMUP) shuttle_state = "warmup"
		if(SHUTTLE_INTRANSIT) shuttle_state = "in_transit"

	var/shuttle_status
	switch (shuttle.process_state)
		if(IDLE_STATE)
			if (shuttle.in_use)
				shuttle_status = "Busy."
			else if (!shuttle.location)
				shuttle_status = "Standing-by at [using_map.station_name]."
			else
				shuttle_status = "Standing-by at [using_map.dock_name]."
		if(WAIT_LAUNCH, FORCE_LAUNCH)
			shuttle_status = "Shuttle has recieved command and will depart shortly."
		if(WAIT_ARRIVE)
			shuttle_status = "Proceeding to destination."
		if(WAIT_FINISH)
			shuttle_status = "Arriving at destination now."

	//build a list of authorizations
	var/list/auth_list[req_authorizations]

	if (!emagged)
		var/i = 1
		for (var/dna_hash in authorized)
			auth_list[i++] = list("auth_name"=authorized[dna_hash], "auth_hash"=dna_hash)

		while (i <= req_authorizations)	//fill up the rest of the list with blank entries
			auth_list[i++] = list("auth_name"="", "auth_hash"=null)
	else
		for (var/i = 1; i <= req_authorizations; i++)
			auth_list[i] = list("auth_name"="<font color=\"red\">ERROR</font>", "auth_hash"=null)

	var/has_auth = has_authorization()

	data = list(
		"shuttle_status" = shuttle_status,
		"shuttle_state" = shuttle_state,
		"has_docking" = shuttle.docking_controller? 1 : 0,
		"docking_status" = shuttle.docking_controller? shuttle.docking_controller.get_docking_status() : null,
		"docking_override" = shuttle.docking_controller? shuttle.docking_controller.override_enabled : null,
		"can_launch" = shuttle.can_launch(src),
		"can_cancel" = shuttle.can_cancel(src),
		"can_force" = shuttle.can_force(src),
		"auth_list" = auth_list,
		"has_auth" = has_auth,
		"user" = debug? user : null,
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "escape_shuttle_control_console.tmpl", "Shuttle Control", 470, 420)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/shuttle_control/emergency/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["removeid"])
		var/dna_hash = href_list["removeid"]
		authorized -= dna_hash

	if(!emagged && href_list["scanid"])
		//They selected an empty entry. Try to scan their id.
		if (ishuman(usr))
			var/mob/living/carbon/human/H = usr
			if (!read_authorization(H.get_active_hand()))	//try to read what's in their hand first
				read_authorization(H.wear_id)
