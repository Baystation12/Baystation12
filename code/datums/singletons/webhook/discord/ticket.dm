/singleton/webhook/discord/ticket
	config_key = "discord_ticket"

	/// If a ticket number is higher than this, update it and indicate that the ticket is new.
	var/static/highest_ticket = 0


/singleton/webhook/discord/ticket/CreateBody(number, user_ckey, staff_ckey, active_staff, message)
	var/content = "№[number] (**[user_ckey]**)"
	if (number > highest_ticket)
		content = "**New Ticket** with [active_staff] active staff:\n[content]"
		highest_ticket = number
	if (!content)
		content = "[content] closed by **[staff_ckey || user_ckey || "timeout"]**."
	else if (staff_ckey)
		content = "[content] **[staff_ckey || user_ckey]**: [message]"
	return ..(list("content" = content))


/hook/ticket/proc/WebhookNotify(number, user_ckey, staff_ckey, active_staff, message)
	SSwebhooks.Send(/singleton/webhook/discord/roundstart, number, user_ckey, staff_ckey, active_staff, message)
	return TRUE
