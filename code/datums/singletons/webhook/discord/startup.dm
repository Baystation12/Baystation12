/singleton/webhook/discord/startup
	config_key = "discord_startup"


/singleton/webhook/discord/startup/CreateBody()
	return ..(list(
		"embeds" = list(list(
			"title" = "Server Starting",
			"description" = "Server starting up[config.server ? " on byond://[config.server]" : ""].",
			"color" = 0x8bbbd5
		))
	))


/hook/startup/proc/WebhookNotify()
	SSwebhooks.Send(/singleton/webhook/discord/startup)
	return TRUE
