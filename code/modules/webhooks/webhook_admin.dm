/decl/webhook/ban
	id = WEBHOOK_BAN


/decl/webhook/ban/get_message(var/list/data)
	. = ..()

	.["content"] = "[data["admin"]];[data["player"]];[data["time"]];[data["reason"]]"


/decl/webhook/notes
	id = WEBHOOK_NOTES


/decl/webhook/notes/get_message(var/list/data)
	. = ..()

	.["content"] = "**[data["admin"]]** -> **[data["player"]]**: [data["info"]]"
