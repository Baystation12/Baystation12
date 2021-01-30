/decl/webhook/roundstart
	id = WEBHOOK_ROUNDSTART

// Data expects a "url" field pointing to the current hosted server and port to connect on.
/decl/webhook/roundstart/get_message(var/list/data)
	. = ..()
	var/desc = "A new round is starting in 3 minutes"
//	if(data && data["url"])
//		desc += " on Tor4. \n <[world.url]>"

	.["embeds"] = list(list(
		"title" = "Round starting.",
		"description" = desc,
		"color" = COLOR_WEBHOOK_DEFAULT
	))
