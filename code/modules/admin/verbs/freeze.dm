/client/proc/freeze(mob/living/M as mob in mob_list)
	set category = "Admin"
	set name = "Freeze"
	if(!holder)
		src << "Only administrators may use this command."
		return
	if(!mob)
		return
	if(!istype(M))
		alert("Cannot freeze a ghost")
		return
	if(usr)
		if (usr.client)
			if(usr.client.holder)
				if(!M.paralysis)
					M.AdjustParalysis(2147483647)

					M << "<b><font color= red>You have been frozen by <a href='?priv_msg=\ref[usr.client]'>[key]</a></b></font>"
					message_admins("\blue [key_name_admin(usr)] froze [M.name]/[M.ckey]")
					log_admin("[key_name(usr)] froze [M.name]/[M.ckey]")


				else if (M.paralysis)
					M.AdjustParalysis(-2147483647)
					M.blinded = 0
					M.lying = 0
					M.stat = 0

					M << "<b> <font color= red>You have been unfrozen by <a href='?priv_msg=\ref[usr.client]'>[key]</a></b></font>"
					message_admins("\blue [key_name_admin(usr)] unfroze [M.name]/[M.ckey]")
					log_admin("[key_name(usr)] unfroze [M.name]/[M.ckey]")


/client/proc/freezemecha(obj/mecha/O as obj in world)
	set category = "Admin"
	set name = "Freeze mech"
	if(!holder)
		src << "Only administrators may use this command."
		return
	var/obj/mecha/M = O
	if(!istype(M,/obj/mecha))
		src << "\red <b>This can only be used on mechs!</b>"
		return
	else
		if(usr)
			if (usr.client)
				if(usr.client.holder)
					if(M.can_move == 1)
						M.can_move = 0
						if(M.occupant)
							M.removeVerb(/obj/mecha/verb/eject)
							M.occupant << "<b><font color= red>You have been frozen by <a href='?priv_msg=\ref[usr.client]'>[key]</a></b></font>"
							message_admins("\blue [key_name_admin(usr)] froze [M.occupant.name]/[M.occupant.ckey] in a [M.name]")
							log_admin("[key_name(usr)] froze [M.occupant.name]/[M.occupant.ckey] in a [M.name]")
						else
							message_admins("\blue [key_name_admin(usr)] froze an empty [M.name]")
							log_admin("[key_name(usr)] froze an empty [M.name]")
					else if(M.can_move == 0)
						M.can_move = 1
						if(M.occupant)
							M.addVerb(/obj/mecha/verb/eject)
							M.occupant << "<b><font color= red>You have been unfrozen by <a href='?priv_msg=\ref[usr.client]'>[key]</a></b></font>"
							message_admins("\blue [key_name_admin(usr)] unfroze [M.occupant.name]/[M.occupant.ckey] in a [M.name]")
							log_admin("[key_name(usr)] unfroze [M.occupant.name]/[M.occupant.ckey] in a [M.name]")
						else
							message_admins("\blue [key_name_admin(usr)] unfroze an empty [M.name]")
							log_admin("[key_name(usr)] unfroze an empty [M.name]")

