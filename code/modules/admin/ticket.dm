#define CLOSE_REASON_OTHER "other"

var/list/tickets = list()
var/list/ticket_panels = list()
GLOBAL_LIST_INIT(ticket_close_reasons, list("ticket is fully resolved", "ticket has been rejected", "ticket is no longer relevant"))

/datum/ticket
	var/owner
	var/list/assigned_admins = list()
	var/status = TICKET_OPEN
	var/list/msgs = list()
	var/closed_by
	var/id
	var/opened_time
	var/close_reason

/datum/ticket/New(var/owner)
	src.owner = owner
	tickets |= src
	id = tickets.len
	opened_time = world.time

/datum/ticket/proc/close(var/client/closed_by)
	if(!closed_by)
		return

	if(status == TICKET_CLOSED)
		return

	if(status == TICKET_ASSIGNED && !((closed_by.ckey in assigned_admins) || owner == closed_by.ckey) && alert(closed_by, "You are not assigned to this ticket. Are you sure you want to close it?",  "Close ticket?" , "Yes" , "No") != "Yes")
		return

	if(status == TICKET_ASSIGNED && !closed_by.holder) // non-admins can only close a ticket if no admin has taken it
		return

	close_reason = input(closed_by, "Please provide a close reason:", "Close ticket") in (GLOB.ticket_close_reasons | CLOSE_REASON_OTHER)
	if(close_reason == CLOSE_REASON_OTHER)
		close_reason = sanitize(input(closed_by, "Enter a custom close reason:", "Close ticket") as text)

	if(!close_reason)
		close_reason = "ticket closed for no reason"

	src.status = TICKET_CLOSED
	src.closed_by = closed_by.ckey

	to_chat(client_by_ckey(src.owner), "<span class='notice'><b>Your ticket has been closed by [closed_by] with the reason: [close_reason].</b></span>")
	message_staff("<span class='notice'><b>[src.owner]</b>'s ticket has been closed by <b>[key_name(closed_by)]</b> with the reason: <b>[close_reason]</b>.</span>")
	send2adminirc("[src.owner]'s ticket has been closed by [key_name(closed_by)] with the reason: [close_reason].")

	update_ticket_panels()

	return 1

/datum/ticket/proc/take(var/client/assigned_admin)
	if(!assigned_admin)
		return

	if(status == TICKET_CLOSED)
		return

	if(assigned_admin.ckey == owner)
		return

	if(status == TICKET_ASSIGNED && ((assigned_admin.ckey in assigned_admins) || alert(assigned_admin, "This ticket is already assigned. Do you want to add yourself to the ticket?",  "Join ticket?" , "Yes" , "No") != "Yes"))
		return

	assigned_admins |= assigned_admin.ckey
	src.status = TICKET_ASSIGNED

	message_staff("<span class='notice'><b>[key_name(assigned_admin)]</b> has assigned themself to <b>[src.owner]'s</b> ticket.</span>")
	send2adminirc("[key_name(assigned_admin)] has assigned themself to [src.owner]'s ticket.")
	to_chat(client_by_ckey(src.owner), "<span class='notice'><b>[assigned_admin] has added themself to your ticket and should respond shortly. Thanks for your patience!</b></span>")

	update_ticket_panels()

	return 1

proc/get_open_ticket_by_ckey(var/owner)
	for(var/datum/ticket/ticket in tickets)
		if(ticket.owner == owner && (ticket.status == TICKET_OPEN || ticket.status == TICKET_ASSIGNED))
			return ticket // there should only be one open ticket by a client at a time, so no need to keep looking

/datum/ticket/proc/is_active()
	if(status != TICKET_ASSIGNED)
		return 0

	for(var/admin in assigned_admins)
		var/client/admin_client = client_by_ckey(admin)
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
	var/datum/browser/ticket_panel_window

/datum/ticket_panel/proc/get_dat()
	var/client/C = ticket_panel_window.user.client
	if(!C)
		return

	var/list/dat = list()

	var/list/ticket_dat = list()
	for(var/id = tickets.len, id >= 1, id--)
		var/datum/ticket/ticket = tickets[id]
		if(C.holder || ticket.owner == C.ckey)
			var/client/owner_client = client_by_ckey(ticket.owner)
			var/open = 0
			var/status = "Unknown status"
			var/color = "#6aa84f"
			switch(ticket.status)
				if(TICKET_OPEN)
					open = 1
					status = "Opened [round((world.time - ticket.opened_time) / (1 MINUTE))] minute\s ago, unassigned"
				if(TICKET_ASSIGNED)
					open = 2
					status = "Assigned to [english_list(ticket.assigned_admins, "no one")]"
					color = "#ffffff"
				if(TICKET_CLOSED)
					status = "Closed by [ticket.closed_by], reason: [ticket.close_reason]."
					color = "#cc2222"
			ticket_dat += "<li style='padding-bottom:10px;color:[color]'>"
			if(open_ticket && open_ticket == ticket)
				ticket_dat += "<i>"
			ticket_dat += "Ticket #[id] - [ticket.owner] [owner_client ? "" : "(DC)"] - [status]<br /><a href='byond://?src=\ref[src];action=view;ticket=\ref[ticket]'>VIEW</a>"
			if(open)
				ticket_dat += " - <a href='byond://?src=\ref[src];action=pm;ticket=\ref[ticket]'>PM</a>"
				if(C.holder)
					ticket_dat += " - <a href='byond://?src=\ref[src];action=take;ticket=\ref[ticket]'>[(open == 1) ? "TAKE" : "JOIN"]</a>"
				if(ticket.status != TICKET_CLOSED && (C.holder || ticket.status == TICKET_OPEN))
					ticket_dat += " - <a href='byond://?src=\ref[src];action=close;ticket=\ref[ticket]'>CLOSE</a>"
			if(C.holder)
				var/ref_mob = ""
				if(owner_client)
					ref_mob = "\ref[owner_client.mob]"
				ticket_dat += " - <A HREF='?_src_=holder;adminmoreinfo=[ref_mob]'>?</A> - <A HREF='?_src_=holder;adminplayeropts=[ref_mob]'>PP</A> - <A HREF='?_src_=vars;Vars=[ref_mob]'>VV</A> - <A HREF='?_src_=holder;subtlemessage=[ref_mob]'>SM</A>[owner_client ? "- [admin_jump_link(owner_client, src)]" : ""]"
			if(open_ticket && open_ticket == ticket)
				ticket_dat += "</i>"
			ticket_dat += "</li>"

	if(ticket_dat.len)
		dat += "<br /><div style='width:50%;float:left;'><p><b>Available tickets:</b></p><ul>[jointext(ticket_dat, null)]</ul></div>"

		if(open_ticket)
			dat += "<div style='width:50%;float:left;'><p><b>\[<a href='byond://?src=\ref[src];action=unview;'>X</a>\] Messages for ticket #[open_ticket.id]:</b></p>"

			var/list/msg_dat = list()
			for(var/datum/ticket_msg/msg in open_ticket.msgs)
				var/msg_to = msg.msg_to ? msg.msg_to : "Adminhelp"
				msg_dat += "<li>\[[msg.time_stamp]\] [msg.msg_from] -> [msg_to]: [C.holder ? generate_ahelp_key_words(C.mob, msg.msg) : msg.msg]</li>"

			if(msg_dat.len)
				dat += "<ul>[jointext(msg_dat, null)]</ul></div>"
			else
				dat += "<p>No messages to display.</p></div>"
	else
		dat += "<p>No tickets to display.</p>"
	dat += "</body></html>"

	return jointext(dat, null)

/datum/ticket_panel/Topic(href, href_list)
	..()

	if(href_list["close"])
		ticket_panels -= usr.client

	switch(href_list["action"])
		if("unview")
			open_ticket = null
			ticket_panel_window.set_content(get_dat())
			ticket_panel_window.update()

	var/datum/ticket/ticket = locate(href_list["ticket"])
	if(!ticket)
		return

	switch(href_list["action"])
		if("view")
			open_ticket = ticket
			ticket_panel_window.set_content(get_dat())
			ticket_panel_window.update()
		if("take")
			ticket.take(usr.client)
		if("close")
			ticket.close(usr.client)
		if("pm")
			if(usr.client.holder && ticket.owner != usr.ckey)
				usr.client.cmd_admin_pm(client_by_ckey(ticket.owner), ticket = ticket)
			else if(ticket.status == TICKET_ASSIGNED)
				// manually check that the target client exists here as to not spam the usr for each logged out admin on the ticket
				var/admin_found = 0
				for(var/admin in ticket.assigned_admins)
					var/client/admin_client = client_by_ckey(admin)
					if(admin_client)
						admin_found = 1
						usr.client.cmd_admin_pm(admin_client, ticket = ticket)
						break
				if(!admin_found)
					to_chat(usr, "<span class='warning'>Error: Private-Message: Client not found. They may have lost connection, so please be patient!</span>")
			else
				usr.client.adminhelp(input(usr,"", "adminhelp \"text\"") as text)

/client/verb/view_tickets()
	set name = "View Tickets"
	set category = "Admin"

	var/datum/ticket_panel/ticket_panel = new()
	ticket_panels[src] = ticket_panel
	ticket_panel.ticket_panel_window = new(src.mob, "ticketpanel", "Ticket Manager", 1024, 768, ticket_panel)

	ticket_panel.ticket_panel_window.set_content(ticket_panel.get_dat())
	ticket_panel.ticket_panel_window.open()

/proc/update_ticket_panels()
	for(var/client/C in ticket_panels)
		var/datum/ticket_panel/ticket_panel = ticket_panels[C]
		if(C.mob != ticket_panel.ticket_panel_window.user)
			C.view_tickets()
		else
			ticket_panel.ticket_panel_window.set_content(ticket_panel.get_dat())
			ticket_panel.ticket_panel_window.update()

#undef CLOSE_REASON_OTHER