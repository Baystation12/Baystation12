/decl/webhook/custom_event
	id = WEBHOOK_CUSTOM_EVENT

// Data expects a "text" field containing the new custom event text.
/decl/webhook/custom_event/get_message(var/list/data)
	. = ..()
	.["embeds"] = list(list(
		"title" = "A custom event is beginning.",
		"description" = (data && data["text"]) || "undefined",
		"color" = COLOR_WEBHOOK_DEFAULT
	))
