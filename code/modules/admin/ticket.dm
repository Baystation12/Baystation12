var/list/tickets = list()
var/list/ticket_panels = list()

/datum/ticket
	var/datum/client_lite/owner
	var/datum/client_lite/assigned_admin
	var/status = TICKET_OPEN
	var/list/msgs = list()
	var/datum/client_lite/closed_by

/datum/ticket/New(var/client/owner)
	src.owner = client_repository.get_lite_client(owner)
	tickets |= src

/datum/ticket/proc/close(var/client/closed_by)
	src.status = TICKET_CLOSED
	src.closed_by = client_repository.get_lite_client(closed_by)
	to_chat(client_by_ckey(src.owner.ckey), "<span class='notice'><b>Your ticket has been closed by [closed_by].</b></span>")
	for(var/client/H in admins)
		if(R_INVESTIGATE & H.holder.rights)
			to_chat(H, "<span class='notice'><b>ADMINHELP</b>: <b>[src.owner.key_name(0)]</b>'s ticket has been closed by <b>[key_name(closed_by)]</b>.</span>")
	send2adminirc("[src.owner.ckey]'s ticket has been closed by [closed_by].")

/datum/ticket/proc/take(var/client/assigned_admin)
	src.assigned_admin = client_repository.get_lite_client(assigned_admin)
	src.status = TICKET_ASSIGNED
	var/take_msg = "<span class='notice'><b>ADMINHELP</b>: <b>[key_name(assigned_admin)]</b> has assigned themself to <b>[src.owner.key_name(0)]'s</b> ticket.</span>"
	send2adminirc("[key_name(assigned_admin)] has assigned themself to [src.owner.key_name(0)]'s ticket.")
	for(var/client/X in admins)
		if(R_INVESTIGATE & X.holder.rights)
			to_chat(X, take_msg)
	to_chat(client_by_ckey(src.owner.ckey), "<span class='notice'><b>Your ticket has been assigned to [assigned_admin], who should respond shortly. Thanks for your patience!</b></span>")

proc/get_open_ticket_by_client(var/client/owner)
	owner = client_repository.get_lite_client(owner)
	for(var/datum/ticket/ticket in tickets)
		if(ticket.owner == owner && (ticket.status == TICKET_OPEN || ticket.status == TICKET_ASSIGNED))
			return ticket // there should only be one open ticket by a client at a time, so no need to keep looking

/datum/ticket_msg
	var/datum/client_lite/msg_from
	var/datum/client_lite/msg_to
	var/msg

/datum/ticket_msg/New(var/client/msg_from, var/client/msg_to, var/msg)
	src.msg_from = client_repository.get_lite_client(msg_from)
	src.msg_to = client_repository.get_lite_client(msg_to)
	src.msg = msg

/datum/ticket_panel
	var/datum/ticket/open_ticket = null

/datum/ticket_panel/tg_ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = tg_always_state)
	ui = tgui_process.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "ticket_panel", "Ticket Manager", 600, 800, master_ui, state)
		ui.open()

/datum/ticket_panel/ui_data(mob/user)
	var/list/data = list()

	data["may_take_ticket"] = user.client.holder
	data["tickets"] = list()
	data["messages"] = list()

	for(var/id = tickets.len, id >= 1, id--)
		var/datum/ticket/ticket = tickets[id]
		if(user.client.holder || ticket.owner == client_repository.get_lite_client(user))
			var/open = 0
			var/status = "Unknown status"
			switch(ticket.status)
				if(TICKET_OPEN)
					open = 1
					status = "Open, unassigned"
				if(TICKET_ASSIGNED)
					open = 1
					status = "Assigned to [ticket.assigned_admin]"
				if(TICKET_CLOSED)
					status = "Closed by [ticket.closed_by]."
			data["tickets"] += list(list("id" = id, "owner" = ticket.owner.ckey, "open" = open, "status" = status))

	if(open_ticket)
		for(var/datum/ticket_msg/msg in open_ticket.msgs)
			var/msg_to = (msg.msg_to.ckey != NO_CLIENT_CKEY) ? msg.msg_to.ckey : "Adminhelp"
			data["messages"] += list(list("msg_from" = msg.msg_from.ckey, "msg_to" = msg_to, "msg" = msg.msg))

	return data

/datum/ticket_panel/ui_act(action, params)
	if(..())
		return

	var/datum/ticket/ticket = tickets[text2num(params["id"])]
	if(!ticket)
		return

	var/datum/client_lite/client_lite = client_repository.get_lite_client(usr)
	switch(action)
		if("view")
			open_ticket = ticket
			return 1
		if("take")
			if(isnull(ticket) || ticket.status == TICKET_CLOSED)
				return

			if(ticket.status == TICKET_ASSIGNED && (ticket.assigned_admin == client_lite || alert(usr.client, "This ticket is already assigned to [ticket.assigned_admin.key_name(0)]. Are you sure you want to take over?",  "Take over?" , "Yes" , "No") != "Yes"))
				return

			ticket.take(usr.client)
			return 1
		if("close")
			if(isnull(ticket) || ticket.status == TICKET_CLOSED)
				return

			if(ticket.status == TICKET_ASSIGNED && !(ticket.assigned_admin == client_lite || ticket.owner == usr.client) && alert(usr, "This ticket is assigned to [ticket.assigned_admin.key_name(0)]. Are you sure you want to close it?",  "Close ticket?" , "Yes" , "No") != "Yes")
				return

			ticket.close(usr.client)
			return 1


/client/verb/view_tickets()
	set name = "View Tickets"
	set category = "Admin"

	var/datum/ticket_panel/ticket_panel = src.get_ticket_panel()
	ticket_panel.tg_ui_interact(src.mob)

/client/proc/get_ticket_panel()
	. = ticket_panels[src.ckey]

	if(!.)
		. = new /datum/ticket_panel()
		ticket_panels[src.ckey] = .