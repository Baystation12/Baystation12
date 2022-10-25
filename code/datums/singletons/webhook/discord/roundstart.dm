/singleton/webhook/discord/roundstart
	config_key = "discord_roundstart"


/singleton/webhook/discord/roundstart/CreateBody()
	return ..(list(
		"embeds" = list(list(
			"title" = "Round Starting",
			"description" = "A new round has started[config.server ? " on byond://[config.server]" : ""].",
			"color" = 0x8bbbd5
		))
	))


/hook/roundstart/proc/WebhookNotify()
	SSwebhooks.Send(/singleton/webhook/discord/roundstart)
	return TRUE
