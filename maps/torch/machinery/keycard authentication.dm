/obj/machinery/keycard_auth/torch/interact(mob/user)
	user.set_machine(src)

	var/list/dat = list()

	dat += "<h1>Keycard Authentication Device</h1>"

	dat += "This device is used to trigger some high security events. It requires the simultaneous swipe of two high-level ID cards."
	dat += "<br><hr><br>"

	if(screen == 1)
		dat += "Select an event to trigger:<br>"

		var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
		if(security_state.current_security_level == security_state.severe_security_level)
			dat += "Cannot modify the alert level at this time: [security_state.severe_security_level.name] engaged.<br>"
		else
			if(security_state.current_security_level == security_state.high_security_level)
				dat += "<A href='?src=\ref[src];triggerevent=Revert alert'>Disengage [security_state.high_security_level.name]</A><br>"
			else
				dat += "<A href='?src=\ref[src];triggerevent=Red alert'>Engage [security_state.high_security_level.name]</A><br>"

		if(!config.ert_admin_call_only)
			dat += "<A href='?src=\ref[src];triggerevent=Emergency Response Team'>Emergency Response Team</A><br>"

		dat += "<A href='?src=\ref[src];triggerevent=Grant Emergency Maintenance Access'>Grant Emergency Maintenance Access</A><br>"
		dat += "<A href='?src=\ref[src];triggerevent=Revoke Emergency Maintenance Access'>Revoke Emergency Maintenance Access</A><br>"
		dat += "<A href='?src=\ref[src];triggerevent=Grant Nuclear Authorization Code'>Grant Nuclear Authorization Code</A><br>"
		dat += "<a href='?src=\ref[src];triggerevent=Evacuate'>Initiate Evacuation Procedures</a><br>"
	if(screen == 2)
		dat += "Please swipe your card to authorize the following event: <b>[event]</b>"
		dat += "<p><A href='?src=\ref[src];reset=1'>Back</A>"

	var/datum/browser/popup = new(user, "kad_window", "Keycard Authentication Device", 500, 250)
	popup.set_content(JOINTEXT(dat))
	popup.open()
	return

/obj/machinery/keycard_auth/torch/trigger_event()
	switch(event)
		if("Red alert")
			var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
			security_state.stored_security_level = security_state.current_security_level
			security_state.set_security_level(security_state.high_security_level)
		if("Revert alert")
			var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
			security_state.set_security_level(security_state.stored_security_level)
		if("Grant Emergency Maintenance Access")
			GLOB.using_map.make_maint_all_access()
		if("Revoke Emergency Maintenance Access")
			GLOB.using_map.revoke_maint_all_access()
		if("Emergency Response Team")
			if(is_ert_blocked())
				to_chat(usr, "<span class='warning'>All emergency response teams are dispatched and can not be called at this time.</span>")
				return

			trigger_armed_response_team(1)
		if("Grant Nuclear Authorization Code")
			var/obj/machinery/nuclearbomb/nuke = locate(/obj/machinery/nuclearbomb/station) in world
			if(nuke)
				to_chat(usr, "The nuclear authorization code is [nuke.r_code]")
			else
				to_chat(usr, "No self destruct terminal found.")
		if("Bolt All Saferooms")
			GLOB.using_map.bolt_saferooms()
		if("Unbolt All Saferooms")
			GLOB.using_map.unbolt_saferooms()
		if("Evacuate")
			if(!evacuation_controller)
				to_chat(usr, "<span class='danger'>Unable to initiate evacuation!</span>")
				return
			for (var/datum/evacuation_option/EO in evacuation_controller.available_evac_options())
				if(EO.abandon_ship)
					evacuation_controller.handle_evac_option(EO.option_target, usr)
					return
