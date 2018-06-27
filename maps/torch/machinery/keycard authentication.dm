/obj/machinery/keycard_auth/torch

/obj/machinery/keycard_auth/torch/attack_hand(mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		to_chat(user, "This device is not powered.")
		return
	if(!user.IsAdvancedToolUser())
		return 0
	if(busy)
		to_chat(user, "This device is busy.")
		return

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
		dat += "<li><A href='?src=\ref[src];triggerevent=Bolt All Saferooms'>Bolt All Saferooms</A></li>"
		dat += "<li><A href='?src=\ref[src];triggerevent=Unbolt All Saferooms'>Unbolt All Saferooms</A></li>"
		dat += "</ul>"
		user << browse(dat, "window=keycard_auth;size=500x250")
	if(screen == 2)
		dat += "Please swipe your card to authorize the following event: <b>[event]</b>"
		dat += "<p><A href='?src=\ref[src];reset=1'>Back</A>"
		user << browse(dat, "window=keycard_auth;size=500x250")
	return

/obj/machinery/keycard_auth/torch/trigger_event()
	switch(event)
		if("Red alert")
			var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
			security_state.stored_security_level = security_state.current_security_level
			security_state.set_security_level(security_state.high_security_level)
			feedback_inc("alert_keycard_auth_red",1)
		if("Revert alert")
			var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
			security_state.set_security_level(security_state.stored_security_level)
			feedback_inc("alert_keycard_revert_red",1)
		if("Grant Emergency Maintenance Access")
			GLOB.using_map.make_maint_all_access()
			feedback_inc("alert_keycard_auth_maintGrant",1)
		if("Revoke Emergency Maintenance Access")
			GLOB.using_map.revoke_maint_all_access()
			feedback_inc("alert_keycard_auth_maintRevoke",1)
		if("Emergency Response Team")
			if(is_ert_blocked())
				to_chat(usr, "<span class='warning'>All emergency response teams are dispatched and can not be called at this time.</span>")
				return

			trigger_armed_response_team(1)
			feedback_inc("alert_keycard_auth_ert",1)
		if("Grant Nuclear Authorization Code")
			var/obj/machinery/nuclearbomb/nuke = locate(/obj/machinery/nuclearbomb/station) in world
			if(nuke)
				to_chat(usr, "The nuclear authorization code is [nuke.r_code]")
			else
				to_chat(usr, "No self destruct terminal found.")
			feedback_inc("alert_keycard_auth_nukecode",1)
		if("Bolt All Saferooms")
			GLOB.using_map.bolt_saferooms()
			feedback_inc("bolted_saferoom",1)
		if("Unbolt All Saferooms")
			GLOB.using_map.unbolt_saferooms()
			feedback_inc("unbolted_saferoom",1)
