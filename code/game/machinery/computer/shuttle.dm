/obj/machinery/computer/shuttle
	name = "Shuttle"
	desc = "For shuttle control."
	icon_keyboard = "tech_key"
	icon_screen = "shuttle"
	light_color = "#00ffff"
	construct_state = null
	var/auth_need = 3.0
	var/list/authorized = list(  )


/obj/machinery/computer/shuttle/attackby(var/obj/item/card/W as obj, var/mob/user as mob)
	if(stat & (BROKEN|NOPOWER))	return

	var/datum/evacuation_controller/shuttle/evac_control = evacuation_controller
	if(!istype(evac_control))
		to_chat(user, "<span class='danger'>This console should not in use on this map. Please report this to a developer.</span>")
		return

	if ((!( istype(W, /obj/item/card) ) || evacuation_controller.has_evacuated() || !( user )))
		return

	if (istype(W, /obj/item/card/id)||istype(W, /obj/item/modular_computer))
		if (istype(W, /obj/item/modular_computer))
			W = W.GetIdCard()
		if (!W:access) //no access
			to_chat(user, "The access level of [W:registered_name]\'s card is not high enough. ")
			return

		var/list/cardaccess = W:access
		if(!istype(cardaccess, /list) || !cardaccess.len) //no access
			to_chat(user, "The access level of [W:registered_name]\'s card is not high enough. ")
			return

		if(!(access_bridge in W:access)) //doesn't have this access
			to_chat(user, "The access level of [W:registered_name]\'s card is not high enough. ")
			return 0

		var/choice = alert(user, text("Would you like to (un)authorize a shortened launch time? [] authorization\s are still needed. Use abort to cancel all authorizations.", src.auth_need - src.authorized.len), "Shuttle Launch", "Authorize", "Repeal", "Abort")
		if(evacuation_controller.is_prepared() && user.get_active_hand() != W)
			return 0
		switch(choice)
			if("Authorize")
				src.authorized -= W:registered_name
				src.authorized += W:registered_name
				if (src.auth_need - src.authorized.len > 0)
					message_admins("[key_name_admin(user)] has authorized early shuttle launch")
					log_game("[user.ckey] has authorized early shuttle launch")
					to_world(text("<span class='notice'><b>Alert: [] authorizations needed until shuttle is launched early</b></span>", src.auth_need - src.authorized.len))
				else
					message_admins("[key_name_admin(user)] has launched the shuttle")
					log_game("[user.ckey] has launched the shuttle early")
					to_world("<span class='notice'><b>Alert: Shuttle launch time shortened to 10 seconds!</b></span>")
					evacuation_controller.set_launch_time(world.time+100)
					//src.authorized = null
					qdel(src.authorized)
					src.authorized = list(  )

			if("Repeal")
				src.authorized -= W:registered_name
				to_world(text("<span class='notice'><b>Alert: [] authorizations needed until shuttle is launched early</b></span>", src.auth_need - src.authorized.len))

			if("Abort")
				to_world("<span class='notice'><b>All authorizations to shortening time for shuttle launch have been revoked!</b></span>")
				src.authorized.len = 0
				src.authorized = list(  )

	else if (istype(W, /obj/item/card/emag) && !emagged)
		var/choice = alert(user, "Would you like to launch the shuttle?","Shuttle control", "Launch", "Cancel")

		if(!emagged && !evacuation_controller.is_prepared() && user.get_active_hand() == W)
			switch(choice)
				if("Launch")
					to_world("<span class='notice'><b>Alert: Shuttle launch time shortened to 10 seconds!</b></span>")
					evacuation_controller.set_launch_time(world.time+100)
					emagged = TRUE
				if("Cancel")
					return
	return
