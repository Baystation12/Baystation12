var/list/tickets = list()
var/list/ticket_panels = list()

/datum/ticket
	var/datum/client_lite/owner
	var/list/assigned_admins = list()
	var/status = TICKET_OPEN
	var/list/msgs = list()
	var/datum/client_lite/closed_by
	var/id
	var/opened_time

/datum/ticket/New(var/datum/client_lite/owner)
	src.owner = owner
	tickets |= src
	id = tickets.len
	opened_time = world.time

/datum/ticket/proc/close(var/datum/client_lite/closed_by)
	if(status == TICKET_CLOSED)
		return

	if(status == TICKET_ASSIGNED && !(closed_by.ckey in assigned_admin_ckeys() || owner.ckey == closed_by.ckey) && alert(client_by_ckey(closed_by.ckey), "You are not assigned to this ticket. Are you sure you want to close it?",  "Close ticket?" , "Yes" , "No") != "Yes")
		return

	src.status = TICKET_CLOSED
	src.closed_by = closed_by

	to_chat(client_by_ckey(src.owner.ckey), "<span class='notice'><b>Your ticket has been closed by [closed_by.ckey].</b></span>")
	message_staff("<span class='notice'><b>[src.owner.key_name(0)]</b>'s ticket has been closed by <b>[closed_by.key_name(0)]</b>.</span>")
	send2adminirc("[src.owner.key_name(0)]'s ticket has been closed by [closed_by.key_name(0)].")

	update_ticket_panels()

	return 1

/datum/ticket/proc/take(var/datum/client_lite/assigned_admin)
	if(status == TICKET_CLOSED)
		return

	if(status == TICKET_ASSIGNED && (assigned_admin.ckey in assigned_admin_ckeys() || alert(client_by_ckey(assigned_admin.ckey), "This ticket is already assigned. Do you want to add yourself to the ticket?",  "Join ticket?" , "Yes" , "No") != "Yes"))
		return

	if(assigned_admin.ckey == owner.ckey)
		return

	assigned_admins |= assigned_admin
	src.status = TICKET_ASSIGNED

	message_staff("<span class='notice'><b>[assigned_admin.key_name(0)]</b> has assigned themself to <b>[src.owner.key_name(0)]'s</b> ticket.</span>")
	send2adminirc("[assigned_admin.key_name(0)] has assigned themself to [src.owner.key_name(0)]'s ticket.")
	to_chat(client_by_ckey(src.owner.ckey), "<span class='notice'><b>[assigned_admin.ckey] has added themself to your ticket and should respond shortly. Thanks for your patience!</b></span>")

	update_ticket_panels()

	return 1

/datum/ticket/proc/assigned_admin_ckeys()
	. = list()

	for(var/datum/client_lite/assigned_admin in assigned_admins)
		. |= assigned_admin.ckey

proc/get_open_ticket_by_client(var/datum/client_lite/owner)
	for(var/datum/ticket/ticket in tickets)
		if(ticket.owner.ckey == owner.ckey && (ticket.status == TICKET_OPEN || ticket.status == TICKET_ASSIGNED))
			return ticket // there should only be one open ticket by a client at a time, so no need to keep looking

/datum/ticket/proc/is_active()
	if(status != TICKET_ASSIGNED)
		return 0

	for(var/datum/client_lite/admin in assigned_admins)
		var/client/admin_client = client_by_ckey(admin.ckey)
		if(admin_client && !admin_client.is_afk())
			return 1

	return 0

/datum/ticket_msg
	var/msg_from
	var/msg_to
	var/msg
	var/time_stamp

/datum/ticket_msg/New(var/msg_from, var/msg_to, var/msg)
	src.msg_from = msg_from
	src.msg_to = msg_to
	src.msg = msg
	src.time_stamp = time_stamp()

/datum/ticket_panel
	var/datum/ticket/open_ticket = null

/datum/ticket_panel/proc/get_dat(var/client/C)
	var/dat = "<html><body><center><b>Ticket Manager</b><br />"
	dat += "<a href='byond://?src=\ref[src];action=exit'>Exit</a></center>"

	var/ticket_dat = ""
	for(var/id = tickets.len, id >= 1, id--)
		var/datum/ticket/ticket = tickets[id]
		if(C.holder || ticket.owner.ckey == C.ckey)
			var/open = 0
			var/status = "Unknown status"
			switch(ticket.status)
				if(TICKET_OPEN)
					open = 1
					status = "Opened [round((world.time - ticket.opened_time) / (1 MINUTE))] minute\s ago, unassigned"
				if(TICKET_ASSIGNED)
					open = 2
					status = "Assigned to [english_list(ticket.assigned_admin_ckeys(), "no one")]"
				if(TICKET_CLOSED)
					status = "Closed by [ticket.closed_by.ckey]"
			ticket_dat += "<li>"
			if(open_ticket && open_ticket == ticket)
				ticket_dat += "<i>"
			ticket_dat += "Ticket #[id] - [ticket.owner.ckey] - [status]<br /><a href='byond://?src=\ref[src];action=view;ticket=\ref[ticket]'>VIEW</a>"
			if(open)
				ticket_dat += " - <a href='byond://?src=\ref[src];action=pm;ticket=\ref[ticket]'>PM</a>"
				if(C.holder)
					ticket_dat += " - <a href='byond://?src=\ref[src];action=take;ticket=\ref[ticket]'>[(open == 1) ? "TAKE" : "JOIN"]</a>"
				ticket_dat += " - <a href='byond://?src=\ref[src];action=close;ticket=\ref[ticket]'>CLOSE</a>"
			if(open_ticket && open_ticket == ticket)
				ticket_dat += "</i>"
			ticket_dat += "</li>"

	if(ticket_dat)
		dat += "<p>Available tickets:</p><ul>[ticket_dat]</ul>"

		if(open_ticket)
			dat += "<p>Messages for ticket #[open_ticket.id]:</p>"

			var/msg_dat = ""
			for(var/datum/ticket_msg/msg in open_ticket.msgs)
				var/msg_to = msg.msg_to ? msg.msg_to : "Adminhelp"
				msg_dat += "<li>\[[msg.time_stamp]\] [msg.msg_from] -> [msg_to]: [msg.msg]</li>"

			if(msg_dat)
				dat += "<ul>[msg_dat]</ul>"
			else
				dat += "<p>No messages to display.</p>"
	else
		dat += "<p>No tickets to display.</p>"
	dat += "</body></html>"

	return dat

/datum/ticket_panel/Topic(href, href_list)
	..()

	if(href_list["action"] == "exit")
		show_browser(usr, null, "window=ticketpanel")
		ticket_panels -= usr.client

	var/datum/ticket/ticket = locate(href_list["ticket"])
	if(!ticket)
		return

	switch(href_list["action"])
		if("view")
			open_ticket = ticket
			show_browser(usr, src.get_dat(usr.client), "window=ticketpanel;size=600x800;can_close=0")
		if("take")
			ticket.take(client_repository.get_lite_client(usr.client))
		if("close")
			ticket.close(client_repository.get_lite_client(usr.client))
		if("pm")
			if(usr.client.holder && ticket.owner.ckey != usr.ckey)
				usr.client.cmd_admin_pm(client_by_ckey(ticket.owner.ckey), ticket = ticket)
			else if(ticket.status == TICKET_ASSIGNED)
				// manually check that the target client exists here as to not spam the usr for each logged out admin on the ticket
				var/admin_found = 0
				for(var/datum/client_lite/admin in ticket.assigned_admins)
					var/client/admin_client = client_by_ckey(admin.ckey)
					if(admin_client)
						admin_found = 1
						usr.client.cmd_admin_pm(admin_client, ticket = ticket)
						break
				if(!admin_found)
					to_chat(usr, "<span class='warning'>Error: Private-Message: Client not found. They may have lost connection, so please be patient!</span>")
			else
				usr.client.adminhelp()

/client/verb/view_tickets()
	set name = "View Tickets"
	set category = "Admin"

	var/datum/ticket_panel/ticket_panel = new /datum/ticket_panel()
	ticket_panels[src] = ticket_panel

	var/dat = ticket_panel.get_dat(src)
	show_browser(src, dat, "window=ticketpanel;size=600x800;can_close=0")

proc/update_ticket_panels()
	for(var/client/C in ticket_panels)
		var/datum/ticket_panel/ticket_panel = ticket_panels[C]
		show_browser(C, ticket_panel.get_dat(C), "window=ticketpanel;size=600x800;can_close=0")