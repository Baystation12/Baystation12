//allows right clicking mobs to send an admin PM to their client, forwards the selected mob's client to cmd_admin_pm
/client/proc/cmd_admin_pm_context(mob/M as mob in SSmobs.mob_list)
	set category = null
	set name = "Admin PM Mob"
	if(!holder)
		to_chat(src, "<span class='warning'>Error: Admin-PM-Context: Only administrators may use this command.</span>")
		return
	if( !ismob(M) || !M.client )	return
	cmd_admin_pm(M.client,null)
	feedback_add_details("admin_verb","APMM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

//shows a list of clients we could send PMs to, then forwards our choice to cmd_admin_pm
/client/proc/cmd_admin_pm_panel()
	set category = "Admin"
	set name = "Admin PM"
	if(!holder)
		to_chat(src, "<span class='warning'>Error: Admin-PM-Panel: Only administrators may use this command.</span>")
		return
	var/list/client/targets[0]
	for(var/client/T)
		if(T.mob)
			if(isnewplayer(T.mob))
				targets["(New Player) - [T]"] = T
			else if(isghost(T.mob))
				targets["[T.mob.name](Ghost) - [T]"] = T
			else
				targets["[T.mob.real_name](as [T.mob.name]) - [T]"] = T
		else
			targets["(No Mob) - [T]"] = T
	var/list/sorted = sortList(targets)
	var/target = input(src,"To whom shall we send a message?","Admin PM",null) in sorted|null
	cmd_admin_pm(targets[target],null)
	feedback_add_details("admin_verb","APM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


//takes input from cmd_admin_pm_context, cmd_admin_pm_panel or /client/Topic and sends them a PM.
//Fetching a message if needed. src is the sender and C is the target client

/client/proc/cmd_admin_pm(var/client/C, var/msg = null, var/datum/ticket/ticket = null)
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, "<span class='warning'>Error: Private-Message: You are unable to use PM-s (muted).</span>")
		return

	if(!istype(C,/client))
		if(holder)	to_chat(src, "<span class='warning'>Error: Private-Message: Client not found.</span>")
		else		to_chat(src, "<span class='warning'>Error: Private-Message: Client not found. They may have lost connection, so please be patient!</span>")
		return

	var/recieve_pm_type = "Player"
	if(holder)
		//mod PMs are maroon
		//PMs sent from admins and mods display their rank
		if(holder)
			recieve_pm_type = holder.rank

	else if(C && !C.holder)
		to_chat(src, "<span class='warning'>Error: Admin-PM: Non-admin to non-admin PM communication is forbidden.</span>")
		return

	msg = sanitize(msg)

	//get message text, limit it's length.and clean/escape html
	if(!msg)
		msg = input(src,"Message:", "Private message to [key_name(C, 0, holder ? 1 : 0)]") as text|null

		if(!msg)	return
		if(!C)
			if(holder)	to_chat(src, "<span class='warning'>Error: Private-Message: Client not found.</span>")
			else		to_chat(src, "<span class='warning'>Error: Private-Message: Client not found. They may have lost connection, so try using an adminhelp!</span>")
			return

		msg = sanitize(msg)

	var/datum/client_lite/receiver_lite = client_repository.get_lite_client(C)
	var/datum/client_lite/sender_lite = client_repository.get_lite_client(src)

	// searches for an open ticket, in case an outdated link was clicked
	// I'm paranoid about the problems that could be caused by accidentally finding the wrong ticket, which is why this is strict
	if(isnull(ticket))
		if(holder)
			ticket = get_open_ticket_by_client(receiver_lite) // it's more likely an admin clicked a different PM link, so check admin -> player with ticket first
			if(isnull(ticket) && C.holder)
				ticket = get_open_ticket_by_client(sender_lite) // if still no dice, try an admin with ticket -> admin
		else
			ticket = get_open_ticket_by_client(sender_lite) // lastly, check player with ticket -> admin


	if(isnull(ticket)) // finally, accept that no ticket exists
		if(holder && sender_lite.ckey != receiver_lite.ckey)
			ticket = new /datum/ticket(receiver_lite)
			ticket.take(sender_lite)
		else
			to_chat(src, "<span class='notice'>You do not have an open ticket. Please use the adminhelp verb to open a ticket.</span>")
			return
	else if(ticket.status != TICKET_ASSIGNED && sender_lite.ckey == ticket.owner.ckey)
		to_chat(src, "<span class='notice'>Your ticket is not open for conversation. Please wait for an administrator to receive your adminhelp.</span>")
		return

	// if the sender is an admin and they're not assigned to the ticket, ask them if they want to take/join it, unless the admin is responding to their own ticket
	if(holder && !(sender_lite.ckey in ticket.assigned_admin_ckeys()))
		if(sender_lite.ckey != ticket.owner.ckey && !ticket.take(sender_lite))
			return

	var/recieve_message

	if(holder && !C.holder)
		recieve_message = "<span class='pm'><span class='howto'><b>-- Click the [recieve_pm_type]'s name to reply --</b></span></span>\n"
		if(C.adminhelped)
			to_chat(C, recieve_message)
			C.adminhelped = 0

		//AdminPM popup for ApocStation and anybody else who wants to use it. Set it with POPUP_ADMIN_PM in config.txt ~Carn
		if(config.popup_admin_pm)
			spawn(0)	//so we don't hold the caller proc up
				var/sender = src
				var/sendername = key
				var/reply = sanitize(input(C, msg,"[recieve_pm_type] PM from [sendername]", "") as text|null)		//show message and await a reply
				if(C && reply)
					if(sender)
						C.cmd_admin_pm(sender,reply)										//sender is still about, let's reply to them
					else
						adminhelp(reply)													//sender has left, adminhelp instead
				return

	var/sender_message = "<span class='pm'><span class='out'>" + create_text_tag("pm_out_alt", "PM", src) + " to <span class='name'>[get_options_bar(C, holder ? 1 : 0, holder ? 1 : 0, 1)]</span>"
	if(holder)
		sender_message += " (<a href='?_src_=holder;take_ticket=\ref[ticket]'>[(ticket.status == TICKET_OPEN) ? "TAKE" : "JOIN"]</a>) (<a href='?src=\ref[usr];close_ticket=\ref[ticket]'>CLOSE</a>)"
		sender_message += ": <span class='message'>[generate_ahelp_key_words(mob, msg)]</span>"
	else
		sender_message += ": <span class='message'>[msg]</span>"
	sender_message += "</span></span>"
	to_chat(src, sender_message)

	var/receiver_message = "<span class='pm'><span class='in'>" + create_text_tag("pm_in", "", C) + " <b>\[[recieve_pm_type] PM\]</b> <span class='name'>[get_options_bar(src, C.holder ? 1 : 0, C.holder ? 1 : 0, 1)]</span>"
	if(C.holder)
		receiver_message += " (<a href='?_src_=holder;take_ticket=\ref[ticket]'>[(ticket.status == TICKET_OPEN) ? "TAKE" : "JOIN"]</a>) (<a href='?src=\ref[usr];close_ticket=\ref[ticket]'>CLOSE</a>)"
		receiver_message += ": <span class='message'>[generate_ahelp_key_words(C.mob, msg)]</span>"
	else
		receiver_message += ": <span class='message'>[msg]</span>"
	receiver_message += "</span></span>"
	to_chat(C, receiver_message)

	//play the recieving admin the adminhelp sound (if they have them enabled)
	//non-admins shouldn't be able to disable this
	if(C.get_preference_value(/datum/client_preference/staff/play_adminhelp_ping) == GLOB.PREF_HEAR)
		sound_to(C, 'sound/effects/adminhelp.ogg')

	log_admin("PM: [key_name(src)]->[key_name(C)]: [msg]")
	adminmsg2adminirc(src, C, html_decode(msg))

	ticket.msgs += new /datum/ticket_msg(src.ckey, C.ckey, msg)
	update_ticket_panels()

	//we don't use message_admins here because the sender/receiver might get it too
	for(var/client/X in GLOB.admins)
		//check client/X is an admin and isn't the sender or recipient
		if(X == C || X == src)
			continue
		if(X.key != key && X.key != C.key && (X.holder.rights & R_ADMIN|R_MOD|R_MENTOR))
			to_chat(X, "<span class='pm'><span class='other'>" + create_text_tag("pm_other", "PM:", X) + " <span class='name'>[key_name(src, X, 0, ticket)]</span> to <span class='name'>[key_name(C, X, 0, ticket)]</span> (<a href='?_src_=holder;take_ticket=\ref[ticket]'>[(ticket.status == TICKET_OPEN) ? "TAKE" : "JOIN"]</a>) (<a href='?src=\ref[usr];close_ticket=\ref[ticket]'>CLOSE</a>): <span class='message'>[msg]</span></span></span>")

/client/proc/cmd_admin_irc_pm(sender)
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, "<span class='warning'>Error: Private-Message: You are unable to use PM-s (muted).</span>")
		return

	var/msg = input(src,"Message:", "Reply private message to [sender] on IRC / 400 character limit") as text|null

	if(!msg)
		return

	// Handled on Bot32's end, unsure about other bots
//	if(length(msg) > 400) // TODO: if message length is over 400, divide it up into seperate messages, the message length restriction is based on IRC limitations.  Probably easier to do this on the bots ends.
//		to_chat(src, "<span class='warning'>Your message was not sent because it was more then 400 characters find your message below for ease of copy/pasting</span>")
//		to_chat(src, "<span class='notice'>[msg]</span>")
//		return

	log_admin("PM: [key_name(src)]->IRC-[sender]: [msg]")
	adminmsg2adminirc(src, sender, html_decode(msg))
	admin_pm_repository.store_pm(src, "IRC-[sender]", msg)

	to_chat(src, "<span class='pm'><span class='out'>" + create_text_tag("pm_out_alt", "PM", src) + " to <span class='name'>[sender]</span>: <span class='message'>[msg]</span></span></span>")
	for(var/client/X in GLOB.admins)
		if(X == src)
			continue
		if(X.holder.rights & R_ADMIN|R_MOD)
			to_chat(X, "<span class='pm'><span class='other'>" + create_text_tag("pm_other", "PM:", X) + " <span class='name'>[key_name(src, X, 0)]</span> to <span class='name'>[sender]</span>: <span class='message'>[msg]</span></span></span>")
