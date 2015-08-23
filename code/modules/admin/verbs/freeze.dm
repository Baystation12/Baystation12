/client/proc/freeze(mob/M as mob in mob_list) //Freeze
	set category = "Admin"
	set name = "Freeze Mob"
	if(!holder)
		src << "Only mentors and above may use this command."
		return
	if(!mob)
		alert("\red Cannot freeze nonmobs.")
		return
	if(!istype(M))
		alert("\red Cannot freeze a ghost")
		return
	if (ismob(M))
		if (istype(M, /mob/living/silicon/ai))
			alert("The AI can't be frozen.  You'll have to talk to them.", null, null, null, null, null)
			return
		if (!M.paralysis)
			M << "<b><font color= red>You have been frozen by <a href='?priv_msg=\ref[usr.client]'>[key]</a></b></font>"
			M.Paralyse(5000000000)
			log_admin("\red [key_name_admin(usr)] has frozen [key_name(M)].", 1)
			message_admins("\blue [key_name_admin(usr)] froze [key_name_admin(M)].", 1)
			return
		else if (M.paralysis)
			M << "<b> <font color= red>You have been unfrozen by <a href='?priv_msg=\ref[usr.client]'>[key]</a></b></font>"
			log_admin("\blue [key_name(usr)] has unfrozen [key_name(M)].")
			message_admins("\blue [key_name_admin(usr)] has unfrozen [key_name_admin(M)].")
			M.Paralyse(0)
			M.SetParalysis(0)
			M.blinded = 0
			M.lying = 0
			M.stat = 0
			M.SetStunned(0) //should fix the issue with slowdown
			M.SetWeakened(0) //should fix the issue with slowdown
			return
		return

/client/proc/freezemecha(obj/mecha/O as obj in world)
	set category = "Admin"
	set name = "Freeze Mech"
	if(!holder)
		src << "Only administrators may use this command."
		return
	var/obj/mecha/M = O
	if(!istype(M,/obj/mecha))
		src << "\red <b>This can only be used on Mechs!</b>"
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
							message_admins("\blue [key_name_admin(usr)] froze [key_name(M.occupant)] in a [M.name]")
							log_admin("[key_name(usr)] froze [key_name(M.occupant)] in a [M.name]")
						else
							message_admins("\blue [key_name_admin(usr)] froze an empty [M.name]")
							log_admin("[key_name(usr)] froze an empty [M.name]")
					else if(M.can_move == 0)
						M.can_move = 1
						if(M.occupant)
							M.addVerb(/obj/mecha/verb/eject)
							M.occupant << "<b><font color= red>You have been unfrozen by <a href='?priv_msg=\ref[usr.client]'>[key]</a></b></font>"
							message_admins("\blue [key_name_admin(usr)] unfroze [key_name(M.occupant)] in a [M.name]")
							log_admin("[key_name(usr)] unfroze [M.occupant.name]/[M.occupant.ckey] in a [M.name]")
						else
							message_admins("\blue [key_name_admin(usr)] unfroze an empty [M.name]")
							log_admin("[key_name(usr)] unfroze an empty [M.name]")
