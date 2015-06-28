
/client/verb/who()
	set name = "Who"
	set category = "OOC"

	var/msg = "<b>Current Players:</b>\n"

	var/list/Lines = list()

	if(holder && (R_ADMIN & holder.rights || R_MOD & holder.rights))
		for(var/client/C in clients)
			var/entry = "\t[C.key]"
			if(C.holder && C.holder.fakekey)
				entry += " <i>(as [C.holder.fakekey])</i>"
			entry += " - Playing as [C.mob.real_name]"
			switch(C.mob.stat)
				if(UNCONSCIOUS)
					entry += " - <font color='darkgray'><b>Unconscious</b></font>"
				if(DEAD)
					if(isobserver(C.mob))
						var/mob/dead/observer/O = C.mob
						if(O.started_as_observer)
							entry += " - <font color='gray'>Observing</font>"
						else
							entry += " - <font color='black'><b>DEAD</b></font>"
					else
						entry += " - <font color='black'><b>DEAD</b></font>"
			if(is_special_character(C.mob))
				entry += " - <b><font color='red'>Antagonist</font></b>"
			entry += " (<A HREF='?_src_=holder;adminmoreinfo=\ref[C.mob]'>?</A>)"
			Lines += entry
	else
		for(var/client/C in clients)
			if(C.holder && C.holder.fakekey)
				Lines += C.holder.fakekey
			else
				Lines += C.key

	for(var/line in sortList(Lines))
		msg += "[line]\n"

	msg += "<b>Total Players: [length(Lines)]</b>"
	src << msg

/client/verb/staffwho()
	set category = "Admin"
	set name = "Staffwho"

	var/msg = ""
	var/modmsg = ""
	var/devmsg = ""
	var/auditmsg = ""
	var/num_mods_online = 0
	var/num_admins_online = 0
	var/num_devs_online = 0
	var/num_auditor_online = 0
	if(holder)
		for(var/client/C in admins)
			if(R_ADMIN & C.holder.rights || (!R_MENTOR & C.holder.rights && !R_DEV & C.holder.rights && !R_AUDITOR))	//Used to determine who shows up in admin rows

				if(C.holder.fakekey && (!R_ADMIN & holder.rights && !R_MENTOR & holder.rights && !R_AUDITOR))		//Mentors can't see stealthmins
					continue

				msg += "\t[C] is a [C.holder.rank]"

				if(C.holder.fakekey)
					msg += " <i>(as [C.holder.fakekey])</i>"

				if(isobserver(C.mob))
					msg += " - Observing"
				else if(istype(C.mob,/mob/new_player))
					msg += " - Lobby"
				else
					msg += " - Playing"

				if(C.is_afk())
					msg += " (AFK)"
				msg += "\n"

				num_admins_online++

			else if(R_MENTOR & C.holder.rights)
				modmsg += "\t[C] is a [C.holder.rank]"

				if(isobserver(C.mob))
					modmsg += " - Observing"
				else if(istype(C.mob,/mob/new_player))
					modmsg += " - Lobby"
				else
					modmsg += " - Playing"

				if(C.is_afk())
					modmsg += " (AFK)"
				modmsg += "\n"
				num_mods_online++

			else if(R_DEV & C.holder.rights)
				devmsg += "\t[C] is a [C.holder.rank]"

				if(isobserver(C.mob))
					devmsg += " - Observing"
				else if(istype(C.mob,/mob/new_player))
					devmsg += " - Lobby"
				else
					devmsg += " - Playing"

				if(C.is_afk())
					devmsg += " (AFK)"
				devmsg += "\n"
				num_devs_online++

			else if(R_AUDITOR & C.holder.rights)
				auditmsg += "\t[C] is a [C.holder.rank]"

				if(isobserver(C.mob))
					auditmsg += " - Observing"
				else if(istype(C.mob,/mob/new_player))
					auditmsg += " - Lobby"
				else
					auditmsg += " - Playing"

				if(C.is_afk())
					auditmsg += " (AFK)"
				auditmsg += "\n"
				num_auditor_online++
	else
		for(var/client/C in admins)
			if(R_ADMIN & C.holder.rights)
				if(!C.holder.fakekey)
					msg += "\t[C] is a [C.holder.rank]\n"
					num_admins_online++
			else if (R_MENTOR & C.holder.rights)
				modmsg += "\t[C] is a [C.holder.rank]\n"
				num_mods_online++
			else if (R_DEV & C.holder.rights)
				devmsg += "\t[C] is a [C.holder.rank]\n"
				num_devs_online++
			else if (R_AUDITOR & C.holder.rights)
				auditmsg += "\t[C] is a [C.holder.rank]\n"
				num_auditor_online++
	msg = "<b>Current Admins ([num_admins_online]):</b>\n" + msg + "\n<b> Current Moderators & Mentors([num_mods_online]):</b>\n" + modmsg + "\n<b> Current Developers([num_devs_online]):</b>\n" + devmsg + "\n<b> Current Auditors([num_auditor_online]):</b>\n" + auditmsg
	src << msg


/client/verb/VIPwho()
	set category = "OOC"
	set name = "Event Who"

	var/msg = ""
	var/num_VIP_online = 0
	if(holder)
		for(var/client/C in vips)
			if(C.vipholder)
				msg += "\t[C] is a [C.vipholder.rank]"
				if(isobserver(C.mob))
					msg += " - Observing"
				else if(istype(C.mob,/mob/new_player))
					msg += " - Lobby"
				else
					msg += " - Playing"

				if(C.is_afk())
					msg += " (AFK)"
				msg += "\n"

				num_VIP_online++
	else
		for(var/client/C in vips)
			if(C.vipholder)
				msg += "\t[C] is a [C.vipholder.rank]\n"
			else
				msg += "\t[C] is a [C.vipholder.rank]\n"

			num_VIP_online++

	msg = "<b>Current Event Personnel ([num_VIP_online]):</b>\n" + msg
	if(num_VIP_online == 0)
		msg += "No Event Personnel Online"
	else
		msg += ""
	src << msg
