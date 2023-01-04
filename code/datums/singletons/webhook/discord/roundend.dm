/singleton/webhook/discord/roundend
	config_key = "discord_round_end"


/singleton/webhook/discord/roundend/CreateBody(list/statistics)
	var/content = "A round of **[SSticker.mode?.name || "Unknown"]** has ended."
	if (islist(statistics))
		var/survivors = statistics["surviving_total"] || 0
		content += "\nThere [survivors == 1 ? "was 1 survivor" : "were [survivors] survivors"]"
		var/observers = statistics["ghosts"] || 0
		if (observers)
			content += " and [observers == 1 ? "1 observer" : "[observers] observers"]"
	return ..(list(
		"embeds" = list(list(
			"title" = "Round [game_id] is ending.",
			"description" = "[content].",
			"color" = 0x8bbbd5
		))
	))
