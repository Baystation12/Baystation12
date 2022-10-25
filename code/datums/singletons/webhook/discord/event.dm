/singleton/webhook/discord/event
	config_key = "discord_custom_event"


/singleton/webhook/discord/event/CreateBody(event_text)
	return ..(list(
		"embeds" = list(list(
			"title" = "An event is beginning.",
			"description" = event_text || "undefined",
			"color" = 0x8bbbd5
		))
	))
