var/image/adminoverlay = image('icons/effects/effects.dmi',icon_state="adminoverlay")

/client/proc/freeze(mob/living/M as mob in mob_list)
	set category = "Special Verbs"
	set name = "Freeze"
	if(!holder)
		src << "Only administrators may use this command."
		return
	if(!M)
		return
	if(!istype(M))
		alert("Cannot freeze a ghost")
		return
	if(M.client)
		if(!M.admin_freeze)
			M.admin_freeze = 1
			if(istype(M, /mob/living/carbon/slime))
				M.canmove = 0
			else
				M.SetWeakened(200)
			spawn(50)
				M.overlays += adminoverlay
			M << "<b><font color= red>You have been frozen by <a href='?priv_msg=\ref[usr.client]'>[key]</a></b></font>"
			log_and_message_admins("\blue [key_name_admin(usr)] froze [key_name(M)]")
		else
			M.admin_freeze = 0
			if(istype(M, /mob/living/carbon/slime))
				M.canmove = 1
			else
				M.SetWeakened(0)
			M.overlays -= adminoverlay
			M << "<b> <font color= red>You have been unfrozen by <a href='?priv_msg=\ref[usr.client]'>[key]</a></b></font>"
			log_and_message_admins("\blue [key_name_admin(usr)] unfroze [key_name(M)]")

/client/proc/freezemecha(obj/mecha/O as obj in world)
	set category = "Special Verbs"
	set name = "Freeze Mech"
	if(!holder)
		src << "Only administrators may use this command."
		return
	if(!istype(O,/obj/mecha))
		src << "\red <b>This can only be used on Mechs!</b>"
		return

	if(O.can_move)
		O.can_move = 0
		spawn(50)
			O.overlays += adminoverlay
		if(O.occupant)
			O.removeVerb(/obj/mecha/verb/eject)
			O.occupant << "<b><font color= red>You have been frozen by <a href='?priv_msg=\ref[usr.client]'>[key]</a></b></font>"
			log_and_message_admins("\blue [key_name_admin(usr)] froze [key_name(O.occupant)] in a [O.name]")
		else
			log_and_message_admins("\blue [key_name_admin(usr)] froze an empty [O.name]")
	else
		O.can_move = 1
		O.overlays -= adminoverlay
		if(O.occupant)
			O.addVerb(/obj/mecha/verb/eject)
			O.occupant << "<b><font color= red>You have been unfrozen by <a href='?priv_msg=\ref[usr.client]'>[key]</a></b></font>"
			log_and_message_admins("\blue [key_name_admin(usr)] unfroze [key_name(O.occupant)] in a [O.name]")
		else
			log_and_message_admins("\blue [key_name_admin(usr)] unfroze an empty [O.name]")
