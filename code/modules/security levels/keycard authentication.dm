/obj/machinery/keycard_auth
	name = "Keycard Authentication Device"
	desc = "This device is used to trigger functions which require more than one ID card to authenticate."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "auth_off"
	var/active = 0 //This gets set to 1 on all devices except the one where the initial request was made.
	var/event = ""
	var/screen = 1
	var/confirmed = 0 //This variable is set by the device that confirms the request.
	var/confirm_delay = 3 SECONDS
	var/busy = 0 //Busy when waiting for authentication or an event request has been sent from this device.
	var/obj/machinery/keycard_auth/event_source
	var/mob/event_triggered_by
	var/mob/event_confirmed_by
	//1 = select event
	//2 = authenticate
	anchored = TRUE
	idle_power_usage = 2
	active_power_usage = 6
	power_channel = ENVIRON

/obj/machinery/keycard_auth/attack_ai(mob/user as mob)
	to_chat(user, "<span class='warning'>A firewall prevents you from interfacing with this device!</span>")
	return

/obj/machinery/keycard_auth/attackby(obj/item/W as obj, mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		to_chat(user, "This device is not powered.")
		return
	if(istype(W,/obj/item/card/id))
		var/obj/item/card/id/ID = W
		if(access_keycard_auth in ID.access)
			if(active == 1)
				//This is not the device that made the initial request. It is the device confirming the request.
				if(event_source && event_source.event_triggered_by != usr)
					event_source.confirmed = 1
					event_source.event_confirmed_by = usr
				else
					to_chat(user, "<span class='warning'>Unable to confirm, DNA matches that of origin.</span>")
			else if(screen == 2)
				event_triggered_by = usr
				broadcast_request() //This is the device making the initial event request. It needs to broadcast to other devices

//icon_state gets set everwhere besides here, that needs to be fixed sometime
/obj/machinery/keycard_auth/on_update_icon()
	if(stat &NOPOWER)
		icon_state = "auth_off"

/obj/machinery/keycard_auth/interface_interact(mob/user)
	if(busy)
		to_chat(user, "This device is busy.")
		return TRUE
	interact(user)
	return TRUE

/obj/machinery/keycard_auth/interact(mob/user)
	user.set_machine(src)

	var/dat = "<h1>Keycard Authentication Device</h1>"

	dat += "This device is used to trigger some high security events. It requires the simultaneous swipe of two high-level ID cards."
	dat += "<br><hr><br>"

	if(screen == 1)
		dat += "Select an event to trigger:<ul>"

		var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
		if(security_state.current_security_level == security_state.severe_security_level)
			dat += "<li>Cannot modify the alert level at this time: [security_state.severe_security_level.name] engaged.</li>"
		else
			if(security_state.current_security_level == security_state.high_security_level)
				dat += "<li><A href='?src=\ref[src];triggerevent=Revert alert'>Disengage [security_state.high_security_level.name]</A></li>"
			else
				dat += "<li><A href='?src=\ref[src];triggerevent=Red alert'>Engage [security_state.high_security_level.name]</A></li>"

		if(!config.ert_admin_call_only)
			dat += "<li><A href='?src=\ref[src];triggerevent=Emergency Response Team'>Emergency Response Team</A></li>"

		dat += "<li><A href='?src=\ref[src];triggerevent=Grant Emergency Maintenance Access'>Grant Emergency Maintenance Access</A></li>"
		dat += "<li><A href='?src=\ref[src];triggerevent=Revoke Emergency Maintenance Access'>Revoke Emergency Maintenance Access</A></li>"
		dat += "<li><A href='?src=\ref[src];triggerevent=Grant Nuclear Authorization Code'>Grant Nuclear Authorization Code</A></li>"
		dat += "</ul>"
		show_browser(user, dat, "window=keycard_auth;size=500x250")
	if(screen == 2)
		dat += "Please swipe your card to authorize the following event: <b>[event]</b>"
		dat += "<p><A href='?src=\ref[src];reset=1'>Back</A>"
		show_browser(user, dat, "window=keycard_auth;size=500x250")
	return

/obj/machinery/keycard_auth/CanUseTopic(var/mob/user, href_list)
	if(busy)
		to_chat(user, "This device is busy.")
		return STATUS_CLOSE
	if(!user.IsAdvancedToolUser())
		to_chat(user, FEEDBACK_YOU_LACK_DEXTERITY)
		return min(..(), STATUS_UPDATE)
	return ..()

/obj/machinery/keycard_auth/OnTopic(user, href_list)
	if(href_list["triggerevent"])
		event = href_list["triggerevent"]
		screen = 2
		. = TOPIC_REFRESH
	if(href_list["reset"])
		reset()
		. = TOPIC_REFRESH

	if(. == TOPIC_REFRESH)
		attack_hand(user)

/obj/machinery/keycard_auth/proc/reset()
	active = 0
	event = ""
	screen = 1
	confirmed = 0
	event_source = null
	icon_state = "auth_off"
	event_triggered_by = null
	event_confirmed_by = null

/obj/machinery/keycard_auth/proc/broadcast_request()
	icon_state = "auth_on"
	for(var/obj/machinery/keycard_auth/KA in world)
		if(KA == src) continue
		KA.reset()
		spawn()
			KA.receive_request(src)

	sleep(confirm_delay)
	if(confirmed)
		confirmed = 0
		trigger_event(event)
		log_and_message_admins("triggered and [key_name(event_confirmed_by)] confirmed event [event]", event_triggered_by || usr)
	reset()

/obj/machinery/keycard_auth/proc/receive_request(var/obj/machinery/keycard_auth/source)
	if(stat & (BROKEN|NOPOWER))
		return
	event_source = source
	busy = 1
	active = 1
	icon_state = "auth_on"

	sleep(confirm_delay)

	event_source = null
	icon_state = "auth_off"
	active = 0
	busy = 0

/obj/machinery/keycard_auth/proc/trigger_event()
	switch(event)
		if("Red alert")
			var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
			security_state.stored_security_level = security_state.current_security_level
			security_state.set_security_level(security_state.high_security_level)
			SSstatistics.add_field("alert_keycard_auth_red",1)
		if("Revert alert")
			var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
			security_state.set_security_level(security_state.stored_security_level)
			SSstatistics.add_field("alert_keycard_revert_red",1)
		if("Grant Emergency Maintenance Access")
			GLOB.using_map.make_maint_all_access()
			SSstatistics.add_field("alert_keycard_auth_maintGrant",1)
		if("Revoke Emergency Maintenance Access")
			GLOB.using_map.revoke_maint_all_access()
			SSstatistics.add_field("alert_keycard_auth_maintRevoke",1)
		if("Emergency Response Team")
			if(is_ert_blocked())
				to_chat(usr, "<span class='warning'>All emergency response teams are dispatched and can not be called at this time.</span>")
				return

			trigger_armed_response_team(1)
			SSstatistics.add_field("alert_keycard_auth_ert",1)
		if("Grant Nuclear Authorization Code")
			var/obj/machinery/nuclearbomb/nuke = locate(/obj/machinery/nuclearbomb/station) in world
			if(nuke)
				to_chat(usr, "The nuclear authorization code is [nuke.r_code]")
			else
				to_chat(usr, "No self destruct terminal found.")
			SSstatistics.add_field("alert_keycard_auth_nukecode",1)

/obj/machinery/keycard_auth/proc/is_ert_blocked()
	if(config.ert_admin_call_only) return 1
	return SSticker.mode && SSticker.mode.ert_disabled

var/global/maint_all_access = 0