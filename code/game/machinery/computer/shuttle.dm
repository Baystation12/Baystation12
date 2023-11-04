/obj/machinery/computer/shuttle
	name = "Shuttle"
	desc = "For shuttle control."
	icon_keyboard = "tech_key"
	icon_screen = "shuttle"
	light_color = "#00ffff"
	construct_state = null
	var/auth_need = 3.0
	var/list/authorized = list(  )


/obj/machinery/computer/shuttle/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(inoperable() || evacuation_controller.has_evacuated())
		return ..()

	var/datum/evacuation_controller/shuttle/evac_control = evacuation_controller
	if(!istype(evac_control))
		to_chat(user, SPAN_DANGER("This console should not in use on this map. Please report this to a developer."))
		return TRUE

	if (isid(W) || istype(W, /obj/item/modular_computer))
		if (istype(W, /obj/item/modular_computer))
			W = W.GetIdCard()
		if (!W:access) //no access
			to_chat(user, "The access level of [W:registered_name]\'s card is not high enough. ")
			return TRUE

		var/list/cardaccess = W:access
		if(!istype(cardaccess, /list) || !length(cardaccess)) //no access
			to_chat(user, "The access level of [W:registered_name]\'s card is not high enough. ")
			return TRUE

		if(!(access_bridge in W:access)) //doesn't have this access
			to_chat(user, "The access level of [W:registered_name]\'s card is not high enough. ")
			return TRUE

		var/choice = alert(user, text("Would you like to (un)authorize a shortened launch time? [] authorization\s are still needed. Use abort to cancel all authorizations.", src.auth_need - length(src.authorized)), "Shuttle Launch", "Authorize", "Repeal", "Abort")
		if(evacuation_controller.is_prepared() && user.get_active_hand() != W)
			return TRUE
		switch(choice)
			if("Authorize")
				authorized -= W:registered_name
				authorized += W:registered_name
				if (auth_need - length(authorized) > 0)
					message_admins("[key_name_admin(user)] has authorized early shuttle launch")
					log_game("[user.ckey] has authorized early shuttle launch")
					to_world(SPAN_NOTICE("<b>Alert: [auth_need - length(authorized)] authorizations needed until shuttle is launched early</b>"))
				else
					message_admins("[key_name_admin(user)] has launched the shuttle")
					log_game("[user.ckey] has launched the shuttle early")
					to_world(SPAN_NOTICE("<b>Alert: Shuttle launch time shortened to 10 seconds!</b>"))
					evacuation_controller.set_launch_time(world.time+100)
					//src.authorized = null
					qdel(authorized)
					authorized = list(  )

			if("Repeal")
				authorized -= W:registered_name
				to_world(SPAN_NOTICE("<b>Alert: [auth_need - length(authorized)] authorizations needed until shuttle is launched early</b>"))

			if("Abort")
				to_world(SPAN_NOTICE("<b>All authorizations to shortening time for shuttle launch have been revoked!</b>"))
				authorized.Cut()
				authorized = list(  )
		return TRUE

	if (istype(W, /obj/item/card/emag) && !emagged)
		var/choice = alert(user, "Would you like to launch the shuttle?","Shuttle control", "Launch", "Cancel")

		if(!emagged && !evacuation_controller.is_prepared() && user.get_active_hand() == W)
			switch(choice)
				if("Launch")
					to_world(SPAN_NOTICE("<b>Alert: Shuttle launch time shortened to 10 seconds!</b>"))
					evacuation_controller.set_launch_time(world.time+100)
					emagged = TRUE
				if("Cancel")
					return TRUE
		return TRUE

	return ..()
