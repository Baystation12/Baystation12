/singleton/webhook/discord/lobby
	config_key = "discord_lobby"


/singleton/webhook/discord/lobby/CreateBody()
	return ..(list(
		"embeds" = list(list(
			"title" = "Server Ready",
			"description" = "A new round is ready to start[config.server ? " on byond://[config.server]" : ""].",
			"color" = 0x8bbbd5
		))
	))


/hook/lobby/proc/WebhookNotify()
	SSwebhooks.Send(/singleton/webhook/discord/lobby)
	return TRUE
